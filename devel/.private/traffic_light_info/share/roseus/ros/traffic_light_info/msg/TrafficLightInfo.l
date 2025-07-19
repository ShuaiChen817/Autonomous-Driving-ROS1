;; Auto-generated. Do not edit!


(when (boundp 'traffic_light_info::TrafficLightInfo)
  (if (not (find-package "TRAFFIC_LIGHT_INFO"))
    (make-package "TRAFFIC_LIGHT_INFO"))
  (shadow 'TrafficLightInfo (find-package "TRAFFIC_LIGHT_INFO")))
(unless (find-package "TRAFFIC_LIGHT_INFO::TRAFFICLIGHTINFO")
  (make-package "TRAFFIC_LIGHT_INFO::TRAFFICLIGHTINFO"))

(in-package "ROS")
;;//! \htmlinclude TrafficLightInfo.msg.html


(defclass traffic_light_info::TrafficLightInfo
  :super ros::object
  :slots (_color _distance ))

(defmethod traffic_light_info::TrafficLightInfo
  (:init
   (&key
    ((:color __color) "")
    ((:distance __distance) 0.0)
    )
   (send-super :init)
   (setq _color (string __color))
   (setq _distance (float __distance))
   self)
  (:color
   (&optional __color)
   (if __color (setq _color __color)) _color)
  (:distance
   (&optional __distance)
   (if __distance (setq _distance __distance)) _distance)
  (:serialization-length
   ()
   (+
    ;; string _color
    4 (length _color)
    ;; float32 _distance
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; string _color
       (write-long (length _color) s) (princ _color s)
     ;; float32 _distance
       (sys::poke _distance (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; string _color
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _color (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;; float32 _distance
     (setq _distance (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get traffic_light_info::TrafficLightInfo :md5sum-) "2fe2f86e4799e07c5c56845f52355235")
(setf (get traffic_light_info::TrafficLightInfo :datatype-) "traffic_light_info/TrafficLightInfo")
(setf (get traffic_light_info::TrafficLightInfo :definition-)
      "string color       # red/unknown
float32 distance   # 单位米，识别失败为 -1.0
")



(provide :traffic_light_info/TrafficLightInfo "2fe2f86e4799e07c5c56845f52355235")


