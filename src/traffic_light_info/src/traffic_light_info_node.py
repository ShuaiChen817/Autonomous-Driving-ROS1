#!/usr/bin/env python3

import rospy
from sensor_msgs.msg import Image
from traffic_light_info.msg import TrafficLightInfo  # 你自定义的 msg
from cv_bridge import CvBridge

import torch
import numpy as np
import cv2
import sys
import time
import threading

# 加载 YOLOv5 模块路径
sys.path.append("/home/bygpu/intro2ros/yolo/yolov5")

from models.common import DetectMultiBackend
from utils.datasets import letterbox
from utils.general import non_max_suppression, scale_coords
from utils.torch_utils import select_device


class TrafficLightAnalyzer:
    def __init__(self):
        rospy.init_node("traffic_light_analyzer_node")

        self.model_path = rospy.get_param("~model_path")
        self.rgb_topic = rospy.get_param("~rgb_topic")
        self.depth_topic = rospy.get_param("~depth_topic")
        self.conf_threshold = rospy.get_param("~confidence", 0.4)

        self.bridge = CvBridge()
        self.device = select_device('')
        self.model = DetectMultiBackend(self.model_path, device=self.device)
        self.model.eval()

        self.latest_depth = None
        self.lock = threading.Lock()

        rospy.Subscriber(self.depth_topic, Image, self.depth_callback)
        rospy.Subscriber(self.rgb_topic, Image, self.rgb_callback)

        self.pub = rospy.Publisher("/traffic_light_info", TrafficLightInfo, queue_size=1)

        self.last_infer_time = rospy.Time.now()
        self.infer_interval = 0.1

        self.prev_color = "unknown"
        self.stable_color = "unknown"
        self.stable_count = 0
        self.required_stable_frames = 2

        self.latest_frame = None
        threading.Thread(target=self.viewer_thread, daemon=True).start()

        rospy.loginfo("Traffic Light Analyzer (red only) initialized.")
        rospy.spin()

    def depth_callback(self, msg):
        try:
            self.latest_depth = self.bridge.imgmsg_to_cv2(msg, desired_encoding="passthrough")
        except Exception as e:
            rospy.logerr("Depth image conversion error: %s", e)

    def rgb_callback(self, msg):
        now = rospy.Time.now()
        if (now - self.last_infer_time).to_sec() < self.infer_interval:
            return
        self.last_infer_time = now

        if self.latest_depth is None:
            rospy.logwarn_throttle(5, "Waiting for depth image...")
            return

        try:
            rgb = self.bridge.imgmsg_to_cv2(msg, "bgr8")
        except Exception as e:
            rospy.logerr("RGB image conversion error: %s", e)
            return

        start_time = time.time()

        rgb_draw = rgb.copy()
        img = letterbox(rgb, new_shape=640)[0]
        img = img.transpose((2, 0, 1))[::-1]
        img = np.ascontiguousarray(img)
        img_tensor = torch.from_numpy(img).to(self.device).float() / 255.0
        img_tensor = img_tensor.unsqueeze(0)

        pred = self.model(img_tensor, augment=False)
        pred = non_max_suppression(pred, self.conf_threshold, 0.45)

        h, w = rgb.shape[:2]
        cy = h / 2

        target = None
        confidence = 0.0
        distance = -1.0
        color = "unknown"

        for det in pred:
            if det is not None and len(det):
                det[:, :4] = scale_coords(img_tensor.shape[2:], det[:, :4], rgb.shape).round()
                candidates = []
                for *xyxy, conf, cls in det:
                    label = self.model.names[int(cls)].lower()
                    if label == "traffic light":
                        x1, y1, x2, y2 = map(int, xyxy)
                        bx = int((x1 + x2) / 2)
                        by = int((y1 + y2) / 2)
                        dx = int(bx * self.latest_depth.shape[1] / w)
                        dy = int(by * self.latest_depth.shape[0] / h)

                        raw_depth = self.latest_depth[dy, dx] / 1000.0 if 0 <= dx < self.latest_depth.shape[1] and 0 <= dy < self.latest_depth.shape[0] else np.nan
                        distance_value = float(raw_depth) if not np.isnan(raw_depth) and 0 < raw_depth < 100 else -1.0
                        candidates.append({
                            "box": (x1, y1, x2, y2),
                            "cx": bx,
                            "cy": by,
                            "conf": conf.item(),
                            "distance": distance_value
                        })

                if len(candidates) > 0:
                    target = min(candidates, key=lambda c: abs(c["cy"] - cy))

        if target:
            x1, y1, x2, y2 = target["box"]
            confidence = target["conf"]
            distance = target["distance"]
            crop = rgb[y1:y2, x1:x2]
            color = self.detect_red_only(crop)

            cv2.rectangle(rgb_draw, (x1, y1), (x2, y2), (0, 0, 255), 2)
            label_text = f"{color}, {distance:.2f} m"
            cv2.putText(rgb_draw, label_text, (x1, y1 - 10),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 255), 2)

        with self.lock:
            self.latest_frame = rgb_draw

        # 稳定判断
        if color == self.prev_color:
            self.stable_count += 1
        else:
            self.stable_count = 1
            self.prev_color = color

        stable_color = color if self.stable_count >= self.required_stable_frames else "unknown"

        msg_out = TrafficLightInfo()
        msg_out.color = stable_color
        msg_out.distance = distance
        self.pub.publish(msg_out)

        duration_ms = (time.time() - start_time) * 1000
        rospy.loginfo(f"[RedLight] Color: {stable_color}, Distance: {distance:.2f} m, Took: {duration_ms:.1f} ms")

    def detect_red_only(self, img):
        hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
        h, s, v = cv2.split(hsv)
        height = v.shape[0]
        if height < 6:
            return "unknown"

        # 只看上 1/3 区域
        top_h = h[0:height // 3, :]
        top_s = s[0:height // 3, :]
        top_v = v[0:height // 3, :]

        # 红色 H 通道范围：0~10 和 160~180（两个区间）
        lower_red1 = cv2.inRange(top_h, 0, 10)
        lower_red2 = cv2.inRange(top_h, 160, 180)
        red_mask = cv2.bitwise_or(lower_red1, lower_red2)

        # 结合饱和度和亮度做筛选
        brightness_mask = top_v > 100
        saturation_mask = top_s > 80
        final_mask = cv2.bitwise_and(red_mask, brightness_mask.astype(np.uint8))
        final_mask = cv2.bitwise_and(final_mask, saturation_mask.astype(np.uint8))

        red_ratio = np.sum(final_mask > 0) / final_mask.size

        # Debug log（可选）
        rospy.loginfo_throttle(2, f"[RedDetect] red_ratio={red_ratio:.2f}")

        return "red" if red_ratio > 0.02 else "unknown"

    
    
    def viewer_thread(self):
        while not rospy.is_shutdown():
            if self.latest_frame is not None:
                with self.lock:
                    img = self.latest_frame.copy()
                cv2.imshow("Red Light Detection", img)
                cv2.waitKey(1)
            time.sleep(0.03)


if __name__ == "__main__":
    try:
        TrafficLightAnalyzer()
    except rospy.ROSInterruptException:
        pass
