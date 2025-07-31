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
            # (-28.4, 51),
            (70.3, 52.7),   #2
            (100, 52.6),
            (120, 52.6),
            (156.0, 52.3),   #3
            # (174.4, 52.7),
            # (190, 50.7),
            # (203, 49),
            # (223.5, 40.7),
            (229.3, 16.0),   #4
            # (227.5, 18.5),
            # (213, -0.22),
            # (181.4, 2.5),
            (159.4, 4.5),   #5
            (122.4, 9.1),   #6
            (103.1, 52.3),   #7
            # (124, 13.0),
            # (116, 51.7),
            # (47.3, 46.5),
            (45.9, 26.5),   #8
            # (48.3, 50.4),
            (39.0, 3.5),   #9
        ]

        self.goal_index = 0
        self.goal_tolerance = 4  # Distance threshold for determining arrival (unit: meters)
        self.goal_active = False

        rospy.sleep(1.0)
        self.send_next_goal()

    def send_next_goal(self):
        if self.goal_index >= len(self.goals):
            rospy.loginfo("All target points have been fully released")
            self.goal_active = False
            return

        x, y = self.goals[self.goal_index]
        goal = PoseStamped()
        goal.header.frame_id = "world"
        goal.header.stamp = rospy.Time.now()
        goal.pose.position.x = x
        goal.pose.position.y = y
        goal.pose.position.z = 0.0
        goal.pose.orientation.w = 1.0  

        rospy.loginfo(f"Release target points {self.goal_index + 1}: ({x}, {y})")
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
            rospy.loginfo(f"Reach the target {self.goal_index + 1}, The distance error is {distance:.2f} m")
            self.goal_index += 1
            self.goal_active = False
            rospy.sleep(1.0)
            self.send_next_goal()

if __name__ == '__main__':
    rospy.init_node('multi_goal_manager')
    MultiGoalPublisher()
    rospy.spin()
