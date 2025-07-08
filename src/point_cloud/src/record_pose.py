#!/usr/bin/env python3
import rospy
from geometry_msgs.msg import PoseStamped
import csv
import os

# 保存路径（可自定义）
output_file = os.path.expanduser("~/car_pose_log.csv")

class PoseRecorder:
    def __init__(self):
        self.file = open(output_file, 'w')
        self.writer = csv.writer(self.file)
        self.writer.writerow(['time', 'x', 'y', 'z'])  # 写表头
        self.sub = rospy.Subscriber('/Unity_ROS_message_Rx/OurCar/CoM/pose', PoseStamped, self.callback)
        self.last_time = rospy.Time.now()

    def callback(self, msg):
        now = rospy.Time.now()
        if (now - self.last_time).to_sec() >= 1.0:
            x = msg.pose.position.x
            y = msg.pose.position.y
            z = msg.pose.position.z
            t = msg.header.stamp.to_sec()
            self.writer.writerow([t, x, y, z])
            rospy.loginfo(f"Recorded: t={t}, x={x}, y={y}, z={z}")
            self.last_time = now

    def shutdown(self):
        self.file.close()
        rospy.loginfo("Pose recording stopped and file closed.")

if __name__ == '__main__':
    rospy.init_node('pose_recorder_node')
    recorder = PoseRecorder()
    rospy.on_shutdown(recorder.shutdown)
    rospy.spin()