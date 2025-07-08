#!/usr/bin/env python
import rospy
import smach
import smach_ros

from std_msgs.msg import Int32, Bool
from geometry_msgs.msg import PoseWithCovarianceStamped
from Camera_msgs.msg import TrafficLightStatus, TrafficLightDistance
from geometry_msgs.msg import Twist
from geometry_msgs.msg import PoseWithCovarianceStamped


# ====== Shared data class ======
class TrafficLightData:
    def __init__(self):
        self.color = "unknown"
        self.distance = -1.0
        self.is_turning = False
        self.is_merging = False
        self.position_x = 0.0
        self.position_y = 0.0
        self.started_driving = False

traffic_data = TrafficLightData()

# ====== Callbacks ======
def traffic_light_status_cb(msg):
    traffic_data.color = msg.color

def traffic_light_distance_cb(msg):
    traffic_data.distance = msg.distance

def merging_cb(msg):
    traffic_data.is_merging = msg.data

def amcl_pose_cb(msg):
    traffic_data.position_x = msg.pose.pose.position.x
    traffic_data.position_y = msg.pose.pose.position.y

    # Once moved away from (0,0), consider started
    if abs(traffic_data.position_x) > 0.1 or abs(traffic_data.position_y) > 0.1:
        traffic_data.started_driving = True
def cmd_vel_cb(msg):
    if abs(msg.angular.z) > 0.1:  # !! what should be the number here
        traffic_data.is_turning = True
    else:
        traffic_data.is_turning = False


# ====== State: Normal Driving ======
class NormalDriving(smach.State):
    def __init__(self, pub):
        smach.State.__init__(self, outcomes=['turning', 'merging', 'red_light_close', 'reach_goal', 'continue_driving'])
        self.pub = pub

    def execute(self, userdata):
        rospy.loginfo("State: NormalDriving")
        self.pub.publish(1)

        # Highest priority: reach goal
        if (traffic_data.started_driving and 
            abs(traffic_data.position_x) < 0.1 and abs(traffic_data.position_y) < 0.1):
            rospy.loginfo("Returned to (0,0) after start -> switch to ReachGoal state")
            return 'reach_goal'

        # Next: red light close
        if traffic_data.color == "red" and 0 < traffic_data.distance < 5:
            rospy.loginfo("RED light detected within 5m -> switch to EmergencyBrake")
            return 'red_light_close'
        # Next: yellow light close
        if traffic_data.color == "yellow" and 0 < traffic_data.distance < 8:
            rospy.loginfo("YELLOW light detected within 6m -> switch to EmergencyBrake")
            return 'red_light_close'

        # Next: merging
        if traffic_data.is_merging:
            rospy.loginfo("Detected merging situation -> switch to VehicleMerge state")
            return 'merging'

        # Next: turning
        if traffic_data.is_turning:
            rospy.loginfo("Detected turning -> switch to Turning state")
            return 'turning'

        rospy.sleep(0.1)
        return 'continue_driving'

# ====== State: Emergency Brake ======
class EmergencyBrake(smach.State):
    def __init__(self, pub):
        smach.State.__init__(self, outcomes=['resume_driving', 'stay_braking'])
        self.pub = pub

    def execute(self, userdata):
        rospy.loginfo("State: EmergencyBrake")
        self.pub.publish(0)

        if ((traffic_data.color not in ["red", "yellow"]) or
            (traffic_data.color == "red" and traffic_data.distance >= 5) or
            (traffic_data.color == "yellow" and traffic_data.distance >= 8)):
            rospy.loginfo("Safe to resume driving.")
            return 'resume_driving'

        rospy.sleep(0.1)
        return 'stay_braking'

# ====== State: Turning ======
class Turning(smach.State):
    def __init__(self, pub):
        smach.State.__init__(self, outcomes=['finished_turning', 'keep_turning'])
        self.pub = pub

    def execute(self, userdata):
        rospy.loginfo("State: Turning - sending 2 to controller")
        self.pub.publish(2)
        rospy.sleep(0.1)

        if not traffic_data.is_turning:
            rospy.loginfo("Finished turning.")
            return 'finished_turning'
        return 'keep_turning'

# ====== State: Vehicle Merge ======
class VehicleMerge(smach.State):
    def __init__(self, pub):
        smach.State.__init__(self, outcomes=['done_merging', 'keep_merging'])
        self.pub = pub

    def execute(self, userdata):
        rospy.loginfo("State: VehicleMerge - sending 3 to controller")
        self.pub.publish(3)
        rospy.sleep(0.1)

        if not traffic_data.is_merging:
            rospy.loginfo("Finished merging.")
            return 'done_merging'
        return 'keep_merging'

# ====== State: Reach Goal ======
class ReachGoal(smach.State):
    def __init__(self, pub):
        smach.State.__init__(self, outcomes=['done'])
        self.pub = pub

    def execute(self, userdata):
        rospy.loginfo("State: ReachGoal - sending 0 to stop at goal")
        self.pub.publish(0)
        rospy.sleep(0.1)
        return 'done'

# ====== Main function ======
def main():
    rospy.init_node('extended_traffic_state_machine', anonymous=True)

    # Subscribers
    rospy.Subscriber('/traffic_light_status', TrafficLightStatus, traffic_light_status_cb)
    rospy.Subscriber('/traffic_light_distance', TrafficLightDistance, traffic_light_distance_cb)
    rospy.Subscriber('/is_merging', Bool, merging_cb)
    rospy.Subscriber('/amcl_pose', PoseWithCovarianceStamped, amcl_pose_cb)
    rospy.Subscriber('/cmd_vel', Twist, cmd_vel_cb)  # from planner

    # Publisher
    controller_pub = rospy.Publisher('/controller_command', Int32, queue_size=10)

    # State machine
    sm = smach.StateMachine(outcomes=['finished'])

    with sm:
        smach.StateMachine.add('NORMAL_DRIVING', NormalDriving(controller_pub),
            transitions={'turning':'TURNING',
                         'merging':'VEHICLE_MERGE',
                         'red_light_close':'EMERGENCY_BRAKE',
                         'reach_goal':'REACH_GOAL',
                         'continue_driving':'NORMAL_DRIVING'})

        smach.StateMachine.add('TURNING', Turning(controller_pub),
            transitions={'finished_turning':'NORMAL_DRIVING',
                         'keep_turning':'TURNING'})

        smach.StateMachine.add('VEHICLE_MERGE', VehicleMerge(controller_pub),
            transitions={'done_merging':'NORMAL_DRIVING',
                         'keep_merging':'VEHICLE_MERGE'})

        smach.StateMachine.add('EMERGENCY_BRAKE', EmergencyBrake(controller_pub),
            transitions={'resume_driving':'NORMAL_DRIVING',
                         'stay_braking':'EMERGENCY_BRAKE'})

        smach.StateMachine.add('REACH_GOAL', ReachGoal(controller_pub),
            transitions={'done':'REACH_GOAL'})  

    outcome = sm.execute()

if __name__ == '__main__':
    main()
