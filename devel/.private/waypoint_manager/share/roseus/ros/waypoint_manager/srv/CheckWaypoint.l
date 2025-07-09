;; Auto-generated. Do not edit!


(when (boundp 'waypoint_manager::CheckWaypoint)
  (if (not (find-package "WAYPOINT_MANAGER"))
    (make-package "WAYPOINT_MANAGER"))
  (shadow 'CheckWaypoint (find-package "WAYPOINT_MANAGER")))
(unless (find-package "WAYPOINT_MANAGER::CHECKWAYPOINT")
  (make-package "WAYPOINT_MANAGER::CHECKWAYPOINT"))
(unless (find-package "WAYPOINT_MANAGER::CHECKWAYPOINTREQUEST")
  (make-package "WAYPOINT_MANAGER::CHECKWAYPOINTREQUEST"))
(unless (find-package "WAYPOINT_MANAGER::CHECKWAYPOINTRESPONSE")
  (make-package "WAYPOINT_MANAGER::CHECKWAYPOINTRESPONSE"))

(in-package "ROS")

(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))


(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))


(defclass waypoint_manager::CheckWaypointRequest
  :super ros::object
  :slots (_current_pose ))

(defmethod waypoint_manager::CheckWaypointRequest
  (:init
   (&key
    ((:current_pose __current_pose) (instance geometry_msgs::Pose :init))
    )
   (send-super :init)
   (setq _current_pose __current_pose)
   self)
  (:current_pose
   (&rest __current_pose)
   (if (keywordp (car __current_pose))
       (send* _current_pose __current_pose)
     (progn
       (if __current_pose (setq _current_pose (car __current_pose)))
       _current_pose)))
  (:serialization-length
   ()
   (+
    ;; geometry_msgs/Pose _current_pose
    (send _current_pose :serialization-length)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; geometry_msgs/Pose _current_pose
       (send _current_pose :serialize s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; geometry_msgs/Pose _current_pose
     (send _current_pose :deserialize buf ptr-) (incf ptr- (send _current_pose :serialization-length))
   ;;
   self)
  )

(defclass waypoint_manager::CheckWaypointResponse
  :super ros::object
  :slots (_is_close_enough _next_waypoint ))

(defmethod waypoint_manager::CheckWaypointResponse
  (:init
   (&key
    ((:is_close_enough __is_close_enough) nil)
    ((:next_waypoint __next_waypoint) (instance geometry_msgs::PoseStamped :init))
    )
   (send-super :init)
   (setq _is_close_enough __is_close_enough)
   (setq _next_waypoint __next_waypoint)
   self)
  (:is_close_enough
   (&optional (__is_close_enough :null))
   (if (not (eq __is_close_enough :null)) (setq _is_close_enough __is_close_enough)) _is_close_enough)
  (:next_waypoint
   (&rest __next_waypoint)
   (if (keywordp (car __next_waypoint))
       (send* _next_waypoint __next_waypoint)
     (progn
       (if __next_waypoint (setq _next_waypoint (car __next_waypoint)))
       _next_waypoint)))
  (:serialization-length
   ()
   (+
    ;; bool _is_close_enough
    1
    ;; geometry_msgs/PoseStamped _next_waypoint
    (send _next_waypoint :serialization-length)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; bool _is_close_enough
       (if _is_close_enough (write-byte -1 s) (write-byte 0 s))
     ;; geometry_msgs/PoseStamped _next_waypoint
       (send _next_waypoint :serialize s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; bool _is_close_enough
     (setq _is_close_enough (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
   ;; geometry_msgs/PoseStamped _next_waypoint
     (send _next_waypoint :deserialize buf ptr-) (incf ptr- (send _next_waypoint :serialization-length))
   ;;
   self)
  )

(defclass waypoint_manager::CheckWaypoint
  :super ros::object
  :slots ())

(setf (get waypoint_manager::CheckWaypoint :md5sum-) "fd3bf256af2f5620dd30fdc56eb0cf84")
(setf (get waypoint_manager::CheckWaypoint :datatype-) "waypoint_manager/CheckWaypoint")
(setf (get waypoint_manager::CheckWaypoint :request) waypoint_manager::CheckWaypointRequest)
(setf (get waypoint_manager::CheckWaypoint :response) waypoint_manager::CheckWaypointResponse)

(defmethod waypoint_manager::CheckWaypointRequest
  (:response () (instance waypoint_manager::CheckWaypointResponse :init)))

(setf (get waypoint_manager::CheckWaypointRequest :md5sum-) "fd3bf256af2f5620dd30fdc56eb0cf84")
(setf (get waypoint_manager::CheckWaypointRequest :datatype-) "waypoint_manager/CheckWaypointRequest")
(setf (get waypoint_manager::CheckWaypointRequest :definition-)
      "geometry_msgs/Pose current_pose

================================================================================
MSG: geometry_msgs/Pose
# A representation of pose in free space, composed of position and orientation. 
Point position
Quaternion orientation

================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

================================================================================
MSG: geometry_msgs/Quaternion
# This represents an orientation in free space in quaternion form.

float64 x
float64 y
float64 z
float64 w
---
bool is_close_enough
geometry_msgs/PoseStamped next_waypoint

================================================================================
MSG: geometry_msgs/PoseStamped
# A Pose with reference coordinate frame and timestamp
Header header
Pose pose

================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
string frame_id

================================================================================
MSG: geometry_msgs/Pose
# A representation of pose in free space, composed of position and orientation. 
Point position
Quaternion orientation

================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

================================================================================
MSG: geometry_msgs/Quaternion
# This represents an orientation in free space in quaternion form.

float64 x
float64 y
float64 z
float64 w
")

(setf (get waypoint_manager::CheckWaypointResponse :md5sum-) "fd3bf256af2f5620dd30fdc56eb0cf84")
(setf (get waypoint_manager::CheckWaypointResponse :datatype-) "waypoint_manager/CheckWaypointResponse")
(setf (get waypoint_manager::CheckWaypointResponse :definition-)
      "geometry_msgs/Pose current_pose

================================================================================
MSG: geometry_msgs/Pose
# A representation of pose in free space, composed of position and orientation. 
Point position
Quaternion orientation

================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

================================================================================
MSG: geometry_msgs/Quaternion
# This represents an orientation in free space in quaternion form.

float64 x
float64 y
float64 z
float64 w
---
bool is_close_enough
geometry_msgs/PoseStamped next_waypoint

================================================================================
MSG: geometry_msgs/PoseStamped
# A Pose with reference coordinate frame and timestamp
Header header
Pose pose

================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
string frame_id

================================================================================
MSG: geometry_msgs/Pose
# A representation of pose in free space, composed of position and orientation. 
Point position
Quaternion orientation

================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

================================================================================
MSG: geometry_msgs/Quaternion
# This represents an orientation in free space in quaternion form.

float64 x
float64 y
float64 z
float64 w
")



(provide :waypoint_manager/CheckWaypoint "fd3bf256af2f5620dd30fdc56eb0cf84")


