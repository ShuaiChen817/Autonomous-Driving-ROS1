; Auto-generated. Do not edit!


(cl:in-package traffic_light_info-msg)


;//! \htmlinclude TrafficLightInfo.msg.html

(cl:defclass <TrafficLightInfo> (roslisp-msg-protocol:ros-message)
  ((color
    :reader color
    :initarg :color
    :type cl:string
    :initform "")
   (distance
    :reader distance
    :initarg :distance
    :type cl:float
    :initform 0.0))
)

(cl:defclass TrafficLightInfo (<TrafficLightInfo>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <TrafficLightInfo>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'TrafficLightInfo)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name traffic_light_info-msg:<TrafficLightInfo> is deprecated: use traffic_light_info-msg:TrafficLightInfo instead.")))

(cl:ensure-generic-function 'color-val :lambda-list '(m))
(cl:defmethod color-val ((m <TrafficLightInfo>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader traffic_light_info-msg:color-val is deprecated.  Use traffic_light_info-msg:color instead.")
  (color m))

(cl:ensure-generic-function 'distance-val :lambda-list '(m))
(cl:defmethod distance-val ((m <TrafficLightInfo>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader traffic_light_info-msg:distance-val is deprecated.  Use traffic_light_info-msg:distance instead.")
  (distance m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <TrafficLightInfo>) ostream)
  "Serializes a message object of type '<TrafficLightInfo>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'color))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'color))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'distance))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <TrafficLightInfo>) istream)
  "Deserializes a message object of type '<TrafficLightInfo>"
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
    (cl:setf (cl:slot-value msg 'distance) (roslisp-utils:decode-single-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<TrafficLightInfo>)))
  "Returns string type for a message object of type '<TrafficLightInfo>"
  "traffic_light_info/TrafficLightInfo")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'TrafficLightInfo)))
  "Returns string type for a message object of type 'TrafficLightInfo"
  "traffic_light_info/TrafficLightInfo")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<TrafficLightInfo>)))
  "Returns md5sum for a message object of type '<TrafficLightInfo>"
  "2fe2f86e4799e07c5c56845f52355235")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'TrafficLightInfo)))
  "Returns md5sum for a message object of type 'TrafficLightInfo"
  "2fe2f86e4799e07c5c56845f52355235")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<TrafficLightInfo>)))
  "Returns full string definition for message of type '<TrafficLightInfo>"
  (cl:format cl:nil "string color       # red/unknown~%float32 distance   # 单位米，识别失败为 -1.0~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'TrafficLightInfo)))
  "Returns full string definition for message of type 'TrafficLightInfo"
  (cl:format cl:nil "string color       # red/unknown~%float32 distance   # 单位米，识别失败为 -1.0~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <TrafficLightInfo>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'color))
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <TrafficLightInfo>))
  "Converts a ROS message object to a list"
  (cl:list 'TrafficLightInfo
    (cl:cons ':color (color msg))
    (cl:cons ':distance (distance msg))
))
