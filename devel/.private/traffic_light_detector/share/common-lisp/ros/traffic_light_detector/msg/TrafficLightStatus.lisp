; Auto-generated. Do not edit!


(cl:in-package traffic_light_detector-msg)


;//! \htmlinclude TrafficLightStatus.msg.html

(cl:defclass <TrafficLightStatus> (roslisp-msg-protocol:ros-message)
  ((color
    :reader color
    :initarg :color
    :type cl:string
    :initform "")
   (confidence
    :reader confidence
    :initarg :confidence
    :type cl:float
    :initform 0.0))
)

(cl:defclass TrafficLightStatus (<TrafficLightStatus>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <TrafficLightStatus>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'TrafficLightStatus)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name traffic_light_detector-msg:<TrafficLightStatus> is deprecated: use traffic_light_detector-msg:TrafficLightStatus instead.")))

(cl:ensure-generic-function 'color-val :lambda-list '(m))
(cl:defmethod color-val ((m <TrafficLightStatus>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader traffic_light_detector-msg:color-val is deprecated.  Use traffic_light_detector-msg:color instead.")
  (color m))

(cl:ensure-generic-function 'confidence-val :lambda-list '(m))
(cl:defmethod confidence-val ((m <TrafficLightStatus>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader traffic_light_detector-msg:confidence-val is deprecated.  Use traffic_light_detector-msg:confidence instead.")
  (confidence m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <TrafficLightStatus>) ostream)
  "Serializes a message object of type '<TrafficLightStatus>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'color))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'color))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'confidence))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <TrafficLightStatus>) istream)
  "Deserializes a message object of type '<TrafficLightStatus>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'color) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'color) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'confidence) (roslisp-utils:decode-single-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<TrafficLightStatus>)))
  "Returns string type for a message object of type '<TrafficLightStatus>"
  "traffic_light_detector/TrafficLightStatus")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'TrafficLightStatus)))
  "Returns string type for a message object of type 'TrafficLightStatus"
  "traffic_light_detector/TrafficLightStatus")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<TrafficLightStatus>)))
  "Returns md5sum for a message object of type '<TrafficLightStatus>"
  "7c6888484e259b845906032dcb46689c")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'TrafficLightStatus)))
  "Returns md5sum for a message object of type 'TrafficLightStatus"
  "7c6888484e259b845906032dcb46689c")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<TrafficLightStatus>)))
  "Returns full string definition for message of type '<TrafficLightStatus>"
  (cl:format cl:nil "string color   # \"red\", \"green\", \"yellow\", \"unknown\"~%float32 confidence~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'TrafficLightStatus)))
  "Returns full string definition for message of type 'TrafficLightStatus"
  (cl:format cl:nil "string color   # \"red\", \"green\", \"yellow\", \"unknown\"~%float32 confidence~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <TrafficLightStatus>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'color))
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <TrafficLightStatus>))
  "Converts a ROS message object to a list"
  (cl:list 'TrafficLightStatus
    (cl:cons ':color (color msg))
    (cl:cons ':confidence (confidence msg))
))
