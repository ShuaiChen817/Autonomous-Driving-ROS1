#!/usr/bin/env python3


import rospy
from sensor_msgs.msg import Image
from traffic_light_distance.msg import TrafficLightDistance
from cv_bridge import CvBridge

import torch
import numpy as np
import cv2
import sys
import time

# 替换为你的 YOLOv5 路径
sys.path.append("/home/hao/my_workspace/yolov5")

from models.common import DetectMultiBackend
from utils.datasets import letterbox
from utils.general import non_max_suppression, scale_coords
from utils.torch_utils import select_device


class TrafficLightDistanceEstimator:
    def __init__(self):
        rospy.init_node("traffic_light_distance_node")

        self.model_path = rospy.get_param("~model_path")
        self.rgb_topic = rospy.get_param("~rgb_topic")
        self.depth_topic = rospy.get_param("~depth_topic")
        self.conf_threshold = rospy.get_param("~confidence", 0.4)

        self.bridge = CvBridge()
        self.device = select_device('')
        self.model = DetectMultiBackend(self.model_path, device=self.device)
        self.model.eval()

        self.latest_depth = None
        rospy.Subscriber(self.depth_topic, Image, self.depth_callback)
        rospy.Subscriber(self.rgb_topic, Image, self.rgb_callback)

        self.pub = rospy.Publisher("/traffic_light_distance", TrafficLightDistance, queue_size=1)

        self.last_infer_time = rospy.Time.now()
        self.infer_interval = 0.1  # 每秒推理一次

        rospy.loginfo("Traffic Light Distance Estimator initialized.")
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
        candidates = []

        for det in pred:
            if det is not None and len(det):
                det[:, :4] = scale_coords(img_tensor.shape[2:], det[:, :4], rgb.shape).round()
                for *xyxy, conf, cls in det:
                    label = self.model.names[int(cls)].lower()
                    if label in ["traffic light", "red_light", "green_light", "yellow_light"]:
                        x1, y1, x2, y2 = map(int, xyxy)
                        bx = int((x1 + x2) / 2)
                        by = int((y1 + y2) / 2)

                        dx = int(bx * self.latest_depth.shape[1] / rgb.shape[1])
                        dy = int(by * self.latest_depth.shape[0] / rgb.shape[0])
                        raw_depth = self.latest_depth[dy, dx] / 1000.0 if 0 <= dx < self.latest_depth.shape[1] and 0 <= dy < self.latest_depth.shape[0] else np.nan
                        distance_text = f"{raw_depth:.2f} m" if not np.isnan(raw_depth) and 0 < raw_depth < 100 else "N/A"

                        cv2.rectangle(rgb_draw, (x1, y1), (x2, y2), (0, 255, 0), 2)
                        label_text = f"{label} {conf.item():.2f} | {distance_text}"
                        cv2.putText(
                            rgb_draw,
                            label_text,
                            (x1, y1 - 10),
                            cv2.FONT_HERSHEY_SIMPLEX,
                            0.5,
                            (0, 255, 0),
                            2,
                            lineType=cv2.LINE_AA
                        )

                        candidates.append({
                            "x": bx,
                            "y": by,
                            "conf": conf.item(),
                            "distance": float(raw_depth) if not np.isnan(raw_depth) and 0 < raw_depth < 100 else -1.0
                        })

        target = None
        if len(candidates) == 1:
            target = candidates[0]
        elif len(candidates) > 1:
            target = min(candidates, key=lambda c: abs(c["y"] - cy))

        if target:
            msg_out = TrafficLightDistance()
            msg_out.confidence = target["conf"]
            msg_out.distance = target["distance"]
            self.pub.publish(msg_out)

            duration_ms = (time.time() - start_time) * 1000
            rospy.loginfo(f"Conf: {target['conf']:.2f}, Distance: {target['distance']:.2f} m, Time: {duration_ms:.1f} ms")
        else:
            msg_out = TrafficLightDistance()
            msg_out.confidence = 0.0
            msg_out.distance = -1.0
            self.pub.publish(msg_out)
            rospy.loginfo("No traffic light detected. Distance: -1.00 m")

        cv2.imshow("YOLO Detection", rgb_draw)
        cv2.waitKey(1)


if __name__ == "__main__":
    try:
        TrafficLightDistanceEstimator()
    except rospy.ROSInterruptException:
        pass