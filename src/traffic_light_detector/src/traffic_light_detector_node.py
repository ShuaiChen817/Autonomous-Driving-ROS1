#!/usr/bin/env python3


import rospy
from sensor_msgs.msg import Image
from traffic_light_detector.msg import TrafficLightStatus
from cv_bridge import CvBridge

import torch
import numpy as np
import cv2
import sys
import time
import threading

# 替换为你本地 yolov5 路径
sys.path.append("/home/hao/my_workspace/yolov5")

from models.common import DetectMultiBackend
from utils.datasets import letterbox
from utils.general import non_max_suppression, scale_coords
from utils.torch_utils import select_device


class TrafficLightDetector:
    def __init__(self):
        rospy.init_node('traffic_light_detector_node')

        self.model_path = rospy.get_param("~model_path")
        self.camera_topic = rospy.get_param("~camera_topic")
        self.conf_threshold = rospy.get_param("~confidence", 0.4)

        self.bridge = CvBridge()
        self.device = select_device('')
        self.model = DetectMultiBackend(self.model_path, device=self.device)
        self.model.eval()

        self.status_pub = rospy.Publisher("/traffic_light_status", TrafficLightStatus, queue_size=1)
        rospy.Subscriber(self.camera_topic, Image, self.image_callback)

        self.prev_color = "unknown"
        self.stable_color = "unknown"
        self.stable_count = 0
        self.required_stable_frames = 2

        self.last_infer_time = rospy.Time.now()
        self.infer_interval = 0.1  # 秒

        self.latest_frame = None
        self.lock = threading.Lock()
        threading.Thread(target=self.viewer_thread, daemon=True).start()

        rospy.loginfo("Traffic light detector initialized.")
        rospy.spin()

    def image_callback(self, msg):
        now = rospy.Time.now()
        if (now - self.last_infer_time).to_sec() < self.infer_interval:
            return
        self.last_infer_time = now

        start_time = time.time()

        try:
            img0 = self.bridge.imgmsg_to_cv2(msg, "bgr8")
        except Exception as e:
            rospy.logerr("cv_bridge error: %s", e)
            return

        img = letterbox(img0, new_shape=640)[0]
        img = img.transpose((2, 0, 1))[::-1]
        img = np.ascontiguousarray(img)
        img = torch.from_numpy(img).to(self.device).float() / 255.0
        img = img.unsqueeze(0)

        pred = self.model(img, augment=False)
        pred = non_max_suppression(pred, self.conf_threshold, 0.45)

        color_detected = "unknown"
        confidence = 0.0

        img_h, img_w = img0.shape[:2]
        center_x = img_w / 2
        center_y = img_h / 2

        min_distance = float('inf')
        target_box = None
        target_conf = 0.0

        for det in pred:
            if det is not None and len(det):
                det[:, :4] = scale_coords(img.shape[2:], det[:, :4], img0.shape).round()
                for *xyxy, conf, cls in det:
                    label = int(cls.item())
                    label_name = self.model.names[label].lower()
                    if label_name == "traffic light":
                        x1, y1, x2, y2 = map(int, xyxy)
                        box_cx = (x1 + x2) / 2
                        box_cy = (y1 + y2) / 2
                        dist = abs(box_cy - center_y)
                        if dist < min_distance:
                            min_distance = dist
                            target_box = (x1, y1, x2, y2)
                            target_conf = conf.item()

        draw_img = img0.copy()

        if target_box:
            x1, y1, x2, y2 = map(int, target_box)
            cv2.rectangle(draw_img, (x1, y1), (x2, y2), (0, 255, 0), 2)
            tl_crop = img0[y1:y2, x1:x2]
            color_detected = self.detect_light_color_combined(tl_crop)
            confidence = target_conf
            cv2.putText(draw_img, color_detected, (x1, y1 - 10),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.7, (255, 255, 0), 2)

        with self.lock:
            self.latest_frame = draw_img

        if color_detected == self.prev_color:
            self.stable_count += 1
        else:
            self.stable_count = 1
            self.prev_color = color_detected

        if self.stable_count >= self.required_stable_frames:
            self.stable_color = color_detected
        else:
            self.stable_color = "unknown"

        msg_out = TrafficLightStatus()
        msg_out.color = self.stable_color
        msg_out.confidence = confidence
        self.status_pub.publish(msg_out)

        duration = (time.time() - start_time) * 1000
        rospy.loginfo(f"[YOLO] Detected: {self.stable_color}, Confidence: {confidence:.2f}, Took {duration:.1f} ms")

    def detect_light_color_combined(self, img):
        hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
        v = hsv[:, :, 2]

        h = v.shape[0]
        if h < 6:
            return "unknown"

        top = v[0:h // 3, :]
        mid = v[h // 3:2 * h // 3, :]
        bot = v[2 * h // 3:, :]

        top_mean = np.mean(top)
        mid_mean = np.mean(mid)
        bot_mean = np.mean(bot)

        yellow_mask = cv2.inRange(hsv, (20, 80, 100), (35, 255, 255))
        yellow_ratio = np.sum(yellow_mask) / 255 / yellow_mask.size

        rospy.loginfo(f"[BRIGHTNESS] top={top_mean:.1f}, mid={mid_mean:.1f}, bot={bot_mean:.1f}, yellow_ratio={yellow_ratio:.2f}")

        max_brightness = max(top_mean, mid_mean, bot_mean)

        if max_brightness < 100:
            return "unknown"

        if yellow_ratio > 0.08 and mid_mean >= top_mean and mid_mean >= bot_mean:
            return "yellow"
        elif top_mean > mid_mean and top_mean > bot_mean:
            return "red"
        elif bot_mean > mid_mean and bot_mean > top_mean:
            return "green"
        else:
            return "unknown"

    def viewer_thread(self):
        while not rospy.is_shutdown():
            if self.latest_frame is not None:
                with self.lock:
                    img = self.latest_frame.copy()
                cv2.imshow("Traffic Light Detection", img)
                cv2.waitKey(1)
            time.sleep(0.03)


if __name__ == '__main__':
    try:
        TrafficLightDetector()
    except rospy.ROSInterruptException:
        pass




