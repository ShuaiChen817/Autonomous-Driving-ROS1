#!/usr/bin/env python3
import rospy
import smach
import smach_ros

from std_msgs.msg import Int32, Bool
from geometry_msgs.msg import PoseWithCovarianceStamped
from traffic_light_info.msg import TrafficLightInfo
from geometry_msgs.msg import Twist
import time

# ====== Shared data class ======
class TrafficLightData:
    def __init__(self):
        self.color = "unknown"
        self.distance = -1.0
        self.is_turning = False
        self.turning_start_time = None
        self.is_merging = False
        self.position_x = 0.0
        self.position_y = 0.0
        self.started_driving = False
        self.latest_angular_z = 0.0

traffic_data = TrafficLightData()

# ====== Callbacks ======
def traffic_light_info_cb(msg):
    traffic_data.color = msg.color
    traffic_data.distance = msg.distance

def merging_cb(msg):
    traffic_data.is_merging = msg.data

def amcl_pose_cb(msg):
    traffic_data.position_x = msg.pose.pose.position.x
    traffic_data.position_y = msg.pose.pose.position.y

    if abs(traffic_data.position_x) > 0.1 or abs(traffic_data.position_y) > 0.1:
        traffic_data.started_driving = True

# ====== Turning detection via /cmd_vel ======
TURNING_THRESHOLD = 0.1
TURNING_MIN_DURATION = 0.2

def cmd_vel_cb(msg):
    now = time.time()
    angular_z = abs(msg.angular.z)
    turning = angular_z > TURNING_THRESHOLD

    traffic_data.latest_angular_z = msg.angular.z  

    if turning:
        if traffic_data.turning_start_time is None:
            traffic_data.turning_start_time = now
        elif (now - traffic_data.turning_start_time) >= TURNING_MIN_DURATION:
            traffic_data.is_turning = True
    else:
        # 如果已经进入 turning 状态并停止转动，才重置状态
        if traffic_data.is_turning:
            rospy.loginfo("[cmd_vel_cb] turning stopped.")
        traffic_data.turning_start_time = None
        traffic_data.is_turning = False

    rospy.loginfo(f"[cmd_vel_cb] angular.z = {msg.angular.z:.2f}, is_turning = {traffic_data.is_turning}, turning_start_time = {traffic_data.turning_start_time}")



# ====== State: Normal Driving ======
class NormalDriving(smach.State):
    def __init__(self, pub):
        smach.State.__init__(self, outcomes=['red_light_close', 'merging', 'turning', 'reach_goal', 'continue_driving'])
        self.pub = pub

    def execute(self, userdata):
        rospy.loginfo("State: NormalDriving")
        self.pub.publish(1)

        rospy.loginfo(f"[NormalDriving] is_turning: {traffic_data.is_turning}, angular.z: {traffic_data.latest_angular_z:.2f}")

        if traffic_data.started_driving and abs(traffic_data.position_x) < 0.1 and abs(traffic_data.position_y) < 0.1:
            rospy.loginfo("Returned to (0,0) after start -> switch to ReachGoal state")
            return 'reach_goal'

        if traffic_data.is_merging:
            rospy.loginfo("Detected merging situation -> switch to VehicleMerge state")
            return 'merging'

        if traffic_data.is_turning:
            rospy.loginfo("Detected turning -> switch to Turning state")
            return 'turning'

        # red light
        if traffic_data.color.strip().lower() == "red" and 0 < traffic_data.distance < 20:
            rospy.logwarn("RED light detected within 20m -> switch to EmergencyBrake")
            return 'red_light_close'

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

        if traffic_data.color != "red" or (traffic_data.color == "red" and traffic_data.distance >= 20):
            rospy.loginfo("Safe to resume driving.")
            return 'resume_driving'

        rospy.sleep(0.1)
        return 'stay_braking'

# ====== State: Turning ======
class Turning(smach.State):
    def __init__(self, pub):
        smach.State.__init__(self, outcomes=['finished_turning', 'keep_turning', 'red_light_detected'])
        self.pub = pub

    def execute(self, userdata):

        if traffic_data.color.strip().lower() == "red" and 0 < traffic_data.distance <= 20:
            rospy.logwarn("RED light during turn -> switch to EmergencyBrake")
            return 'red_light_detected'
        
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

    rospy.Subscriber('/traffic_light_info', TrafficLightInfo, traffic_light_info_cb)
    rospy.Subscriber('/is_merging', Bool, merging_cb)
    rospy.Subscriber('/amcl_pose', PoseWithCovarianceStamped, amcl_pose_cb)
    rospy.Subscriber('/cmd_vel', Twist, cmd_vel_cb)

    controller_pub = rospy.Publisher('/controller_command', Int32, queue_size=10)

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
                         'keep_turning':'TURNING',
                         'red_light_detected':'EMERGENCY_BRAKE'})

        smach.StateMachine.add('VEHICLE_MERGE', VehicleMerge(controller_pub),
            transitions={'done_merging':'NORMAL_DRIVING',
                         'keep_merging':'VEHICLE_MERGE'})

        smach.StateMachine.add('EMERGENCY_BRAKE', EmergencyBrake(controller_pub),
            transitions={'resume_driving':'NORMAL_DRIVING',
                         'stay_braking':'EMERGENCY_BRAKE'})

        smach.StateMachine.add('REACH_GOAL', ReachGoal(controller_pub),
            transitions={'done':'REACH_GOAL'})
        
    # Start introspection server
    sis = smach_ros.IntrospectionServer('server_name', sm, '/SM_ROOT')
    sis.start()

    outcome = sm.execute()

    rospy.spin()  # prevent node from exiting
    sis.stop()    # optional: stop when shutting down

if __name__ == '__main__':
    main()
