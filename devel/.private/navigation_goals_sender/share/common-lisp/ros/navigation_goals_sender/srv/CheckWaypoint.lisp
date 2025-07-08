; Auto-generated. Do not edit!


(cl:in-package navigation_goals_sender-srv)


;//! \htmlinclude CheckWaypoint-request.msg.html

(cl:defclass <CheckWaypoint-request> (roslisp-msg-protocol:ros-message)
  ((current_pose
    :reader current_pose
    :initarg :current_pose
    :type geometry_msgs-msg:Pose
    :initform (cl:make-instance 'geometry_msgs-msg:Pose)))
)

(cl:defclass CheckWaypoint-request (<CheckWaypoint-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <CheckWaypoint-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'CheckWaypoint-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name navigation_goals_sender-srv:<CheckWaypoint-request> is deprecated: use navigation_goals_sender-srv:CheckWaypoint-request instead.")))

(cl:ensure-generic-function 'current_pose-val :lambda-list '(m))
(cl:defmethod current_pose-val ((m <CheckWaypoint-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader navigation_goals_sender-srv:current_pose-val is deprecated.  Use navigation_goals_sender-srv:current_pose instead.")
  (current_pose m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <CheckWaypoint-request>) ostream)
  "Serializes a message object of type '<CheckWaypoint-request>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'current_pose) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <CheckWaypoint-request>) istream)
  "Deserializes a message object of type '<CheckWaypoint-request>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'current_pose) istream)
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<CheckWaypoint-request>)))
  "Returns string type for a service object of type '<CheckWaypoint-request>"
  "navigation_goals_sender/CheckWaypointRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'CheckWaypoint-request)))
  "Returns string type for a service object of type 'CheckWaypoint-request"
  "navigation_goals_sender/CheckWaypointRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<CheckWaypoint-request>)))
  "Returns md5sum for a message object of type '<CheckWaypoint-request>"
  "fd3bf256af2f5620dd30fdc56eb0cf84")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'CheckWaypoint-request)))
  "Returns md5sum for a message object of type 'CheckWaypoint-request"
  "fd3bf256af2f5620dd30fdc56eb0cf84")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<CheckWaypoint-request>)))
  "Returns full string definition for message of type '<CheckWaypoint-request>"
  (cl:format cl:nil "geometry_msgs/Pose current_pose~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'CheckWaypoint-request)))
  "Returns full string definition for message of type 'CheckWaypoint-request"
  (cl:format cl:nil "geometry_msgs/Pose current_pose~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <CheckWaypoint-request>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'current_pose))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <CheckWaypoint-request>))
  "Converts a ROS message object to a list"
  (cl:list 'CheckWaypoint-request
    (cl:cons ':current_pose (current_pose msg))
))
;//! \htmlinclude CheckWaypoint-response.msg.html

(cl:defclass <CheckWaypoint-response> (roslisp-msg-protocol:ros-message)
  ((is_close_enough
    :reader is_close_enough
    :initarg :is_close_enough
    :type cl:boolean
    :initform cl:nil)
   (next_waypoint
    :reader next_waypoint
    :initarg :next_waypoint
    :type geometry_msgs-msg:PoseStamped
    :initform (cl:make-instance 'geometry_msgs-msg:PoseStamped)))
)

(cl:defclass CheckWaypoint-response (<CheckWaypoint-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <CheckWaypoint-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'CheckWaypoint-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name navigation_goals_sender-srv:<CheckWaypoint-response> is deprecated: use navigation_goals_sender-srv:CheckWaypoint-response instead.")))

(cl:ensure-generic-function 'is_close_enough-val :lambda-list '(m))
(cl:defmethod is_close_enough-val ((m <CheckWaypoint-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader navigation_goals_sender-srv:is_close_enough-val is deprecated.  Use navigation_goals_sender-srv:is_close_enough instead.")
  (is_close_enough m))

(cl:ensure-generic-function 'next_waypoint-val :lambda-list '(m))
(cl:defmethod next_waypoint-val ((m <CheckWaypoint-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader navigation_goals_sender-srv:next_waypoint-val is deprecated.  Use navigation_goals_sender-srv:next_waypoint instead.")
  (next_waypoint m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <CheckWaypoint-response>) ostream)
  "Serializes a message object of type '<CheckWaypoint-response>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'is_close_enough) 1 0)) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'next_waypoint) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <CheckWaypoint-response>) istream)
  "Deserializes a message object of type '<CheckWaypoint-response>"
    (cl:setf (cl:slot-value msg 'is_close_enough) (cl:not (cl:zerop (cl:read-byte istream))))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'next_waypoint) istream)
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<CheckWaypoint-response>)))
  "Returns string type for a service object of type '<CheckWaypoint-response>"
  "navigation_goals_sender/CheckWaypointResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'CheckWaypoint-response)))
  "Returns string type for a service object of type 'CheckWaypoint-response"
  "navigation_goals_sender/CheckWaypointResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<CheckWaypoint-response>)))
  "Returns md5sum for a message object of type '<CheckWaypoint-response>"
  "fd3bf256af2f5620dd30fdc56eb0cf84")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'CheckWaypoint-response)))
  "Returns md5sum for a message object of type 'CheckWaypoint-response"
  "fd3bf256af2f5620dd30fdc56eb0cf84")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<CheckWaypoint-response>)))
  "Returns full string definition for message of type '<CheckWaypoint-response>"
  (cl:format cl:nil "bool is_close_enough~%geometry_msgs/PoseStamped next_waypoint~%~%================================================================================~%MSG: geometry_msgs/PoseStamped~%# A Pose with reference coordinate frame and timestamp~%Header header~%Pose pose~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'CheckWaypoint-response)))
  "Returns full string definition for message of type 'CheckWaypoint-response"
  (cl:format cl:nil "bool is_close_enough~%geometry_msgs/PoseStamped next_waypoint~%~%================================================================================~%MSG: geometry_msgs/PoseStamped~%# A Pose with reference coordinate frame and timestamp~%Header header~%Pose pose~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <CheckWaypoint-response>))
  (cl:+ 0
     1
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'next_waypoint))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <CheckWaypoint-response>))
  "Converts a ROS message object to a list"
  (cl:list 'CheckWaypoint-response
    (cl:cons ':is_close_enough (is_close_enough msg))
    (cl:cons ':next_waypoint (next_waypoint msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'CheckWaypoint)))
  'CheckWaypoint-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'CheckWaypoint)))
  'CheckWaypoint-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'CheckWaypoint)))
  "Returns string type for a service object of type '<CheckWaypoint>"
  "navigation_goals_sender/CheckWaypoint")