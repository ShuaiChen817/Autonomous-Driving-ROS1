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
            # (-62.8, -12.3),   #0
            (-51.0, 45.4),   #1
            # (-29.0, 52),
            # (0, 52),
            # (30, 52),
            (70.3, 52.7),   #2
            # (100, 52.6),
            # (120, 52.6),
            (141.6, 52.9),   #3
            # (169, 52),
            # (203, 49),
            # (227.5, 37.0),
            # (229.3, 16.0),   #4
            (223.0, 3.6),     #这个点存在问题
            # (183.5, 3.0),
            (141.4, 3.3),   #5
            # (124.7, 5.7),
            (122.4, 9.1),   #6
            # (121.8, 20),
            # (120.7, 48.9),
            (103.1, 52.3),   #7
            # (75.5, 53.5),
            # (59.0, 53.5),
            # (49, 52),
            (45.9, 26.5),   #8
            # (47.2, 15.0),
            # (42.0, 4.7),
            (39.0, 3.5),   #9
        ]

        self.goal_index = 0
        self.goal_tolerance = 4  # 判定为到达的距离阈值（单位：米）
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
