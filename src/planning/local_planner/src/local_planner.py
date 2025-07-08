#!/usr/bin/env python

import rospy
import math
from mav_state_machine_msgs.msg import StartStopTask
from nav_msgs.msg import Path, Odometry
from geometry_msgs.msg import PoseStamped
from geometry_msgs.msg import Twist

class LocalPlanner:
    def __init__(self):
        rospy.init_node('local_planner', anonymous=True)
        
        # Initialize all subscribers
        # StartStopCommand : from state maschine; type : StartStopTask.msg
        self.ssc_sub = rospy.Subscriber('/ssc', StartStopTask, self.ssc_callback, queue_size=1)
        # Twist : from DWA in move_base; type : Twist.msg
        self.DWA_sub = rospy.Subscriber("/cmd_vel", Twist, self.cmd_callback, queue_size=1)
        
        # Initialize all publishers
        # Cmd_vel : to controller; type : Twist.msg
        self.cmd_pub = rospy.Publisher('/cmd_vel_to_controller', Twist, queue_size=1)
        
        self.start_cmd = True # will affect initial state: True for automatically starting, False for initially stopping
        self.cmd_vel_from_DWA = Twist()

    def ssc_callback(self, msg):
        # msg : StartStopCommand.msg, start / stop command
        self.start_cmd = msg.start

    def cmd_callback(self, msg):
        # msg : Twist.msg, desired-velocity under body frame 
        self.cmd_vel_from_DWA = msg

    def publish_next_goal(self):
        # Initialize message to be published
        cmd2controller = Twist()

        # If received stop command from state machine, do void loop once (skip current loop)
        if not self.start_cmd:
            rospy.loginfo("Stop command received. Waiting...")
            cmd2controller.linear.x = 0.0
            cmd2controller.linear.y = 0.0
            cmd2controller.linear.z = 0.0
            cmd2controller.angular.x = 0.0
            cmd2controller.angular.y = 0.0
            cmd2controller.angular.z = 0.0
        
        # Else case: update goal poses (unchanged / next) and publish it
        else:
            cmd2controller = self.cmd_vel_from_DWA
            rospy.loginfo(f"Publishing next state: {cmd2controller.linear.x}, {cmd2controller.linear.y}")
        
        self.cmd_pub.publish(cmd2controller)

    def run(self):
        rospy.loginfo("Local Planner is running at this line.")
        rate = rospy.Rate(10)  # update rate for next-state checking
        while not rospy.is_shutdown():
            self.publish_next_goal()
            rate.sleep()

if __name__ == '__main__':
    try:
        local_planner = LocalPlanner()
        local_planner.run()
    except rospy.ROSInterruptException:
        pass