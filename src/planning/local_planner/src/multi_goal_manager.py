#!/usr/bin/env python3
import rospy
from geometry_msgs.msg import PoseStamped
import math

class MultiGoalPublisher:
    def __init__(self):
        self.goal_pub = rospy.Publisher('/move_base_simple/goal', PoseStamped, queue_size=1)
        rospy.Subscriber('/Unity_ROS_message_Rx/OurCar/CoM/pose', PoseStamped, self.pose_callback)

        # 目标点列表（x, y）
        self.goals = [
            (-62, -7),
            (-55, 1.0),
            (-45.0, 2.0),
            (-24.0, 3.0),
            (-13.0, 3.0),
            (10, 3.0),
            (-52.5, 120.0),
            (-42.0, 121.5),
            (-18.0, 121.5),
            (-6.5, 122.5),
            (-3.5, 132.0),
            (-3.5, 140.0),
            (-3.5, 200.0),
            (-1.0, 226.0),
            (-26.0, 232.0),
            (-42.0, 226.0),
            (-49.0, 208.0),
            (-53.0, 186.0),
            (-53.0, 100.0),
            (-53.0, 50.5),
            (-48.0, 46.5),
            (-18.0, 45.0),
            (-4.0, 45.0),
            (-3.75, 40.0),
            (-4.5, 18.0),
            (-2.0, -4.0),
            (-2.3, -47.0),
            (-1.0, -57.0),
            (10.5, -63.0),
            (25.0, -63.0),
        ]

        self.goal_index = 0
        self.goal_tolerance = 2.0  # 判定为到达的距离阈值（单位：米）
        self.goal_active = False

        rospy.sleep(1.0)
        self.send_next_goal()

    def send_next_goal(self):
        if self.goal_index >= len(self.goals):
            rospy.loginfo("所有目标点已发布完毕")
            self.goal_active = False
            return

        x, y = self.goals[self.goal_index]
        goal = PoseStamped()
        goal.header.frame_id = "world"
        goal.header.stamp = rospy.Time.now()
        goal.pose.position.x = x
        goal.pose.position.y = y
        goal.pose.position.z = 0.0
        goal.pose.orientation.w = 1.0  # 不关心朝向

        rospy.loginfo(f"发布目标点 {self.goal_index + 1}: ({x}, {y})")
        self.goal_pub.publish(goal)
        self.goal_active = True

    def pose_callback(self, msg):
        if not self.goal_active:
            return

        current_x = msg.pose.position.x
        current_y = msg.pose.position.y
        goal_x, goal_y = self.goals[self.goal_index]

        distance = math.hypot(goal_x - current_x, goal_y - current_y)

        if distance <= self.goal_tolerance:
            rospy.loginfo(f"到达目标 {self.goal_index + 1}，距离误差为 {distance:.2f} 米")
            self.goal_index += 1
            self.goal_active = False
            rospy.sleep(1.0)
            self.send_next_goal()

if __name__ == '__main__':
    rospy.init_node('multi_goal_manager')
    MultiGoalPublisher()
    rospy.spin()
