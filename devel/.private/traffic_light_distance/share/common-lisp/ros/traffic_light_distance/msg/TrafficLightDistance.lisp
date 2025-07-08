; Auto-generated. Do not edit!


(cl:in-package traffic_light_distance-msg)


;//! \htmlinclude TrafficLightDistance.msg.html

(cl:defclass <TrafficLightDistance> (roslisp-msg-protocol:ros-message)
  ((confidence
    :reader confidence
    :initarg :confidence
    :type cl:float
    :initform 0.0)
   (distance
    :reader distance
    :initarg :distance
    :type cl:float
    :initform 0.0))
)

(cl:defclass TrafficLightDistance (<TrafficLightDistance>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <TrafficLightDistance>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'TrafficLightDistance)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name traffic_light_distance-msg:<TrafficLightDistance> is deprecated: use traffic_light_distance-msg:TrafficLightDistance instead.")))

(cl:ensure-generic-function 'confidence-val :lambda-list '(m))
(cl:defmethod confidence-val ((m <TrafficLightDistance>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader traffic_light_distance-msg:confidence-val is deprecated.  Use traffic_light_distance-msg:confidence instead.")
  (confidence m))

(cl:ensure-generic-function 'distance-val :lambda-list '(m))
(cl:defmethod distance-val ((m <TrafficLightDistance>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader traffic_light_distance-msg:distance-val is deprecated.  Use traffic_light_distance-msg:distance instead.")
  (distance m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <TrafficLightDistance>) ostream)
  "Serializes a message object of type '<TrafficLightDistance>"
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'confidence))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'distance))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <TrafficLightDistance>) istream)
  "Deserializes a message object of type '<TrafficLightDistance>"
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'confidence) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'distance) (roslisp-utils:decode-single-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<TrafficLightDistance>)))
  "Returns string type for a message object of type '<TrafficLightDistance>"
  "traffic_light_distance/TrafficLightDistance")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'TrafficLightDistance)))
  "Returns string type for a message object of type 'TrafficLightDistance"
  "traffic_light_distance/TrafficLightDistance")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<TrafficLightDistance>)))
  "Returns md5sum for a message object of type '<TrafficLightDistance>"
  "b8d2ff46c6d416afc309012dc49b99de")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'TrafficLightDistance)))
  "Returns md5sum for a message object of type 'TrafficLightDistance"
  "b8d2ff46c6d416afc309012dc49b99de")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<TrafficLightDistance>)))
  "Returns full string definition for message of type '<TrafficLightDistance>"
  (cl:format cl:nil "float32 confidence   # 置信度~%float32 distance     # 距离（米），若无效则为 -1~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'TrafficLightDistance)))
  "Returns full string definition for message of type 'TrafficLightDistance"
  (cl:format cl:nil "float32 confidence   # 置信度~%float32 distance     # 距离（米），若无效则为 -1~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <TrafficLightDistance>))
  (cl:+ 0
     4
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <TrafficLightDistance>))
  "Converts a ROS message object to a list"
  (cl:list 'TrafficLightDistance
    (cl:cons ':confidence (confidence msg))
    (cl:cons ':distance (distance msg))
))
