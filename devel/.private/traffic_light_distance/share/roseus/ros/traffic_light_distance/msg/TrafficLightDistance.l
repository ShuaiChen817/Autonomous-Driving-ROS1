;; Auto-generated. Do not edit!


(when (boundp 'traffic_light_distance::TrafficLightDistance)
  (if (not (find-package "TRAFFIC_LIGHT_DISTANCE"))
    (make-package "TRAFFIC_LIGHT_DISTANCE"))
  (shadow 'TrafficLightDistance (find-package "TRAFFIC_LIGHT_DISTANCE")))
(unless (find-package "TRAFFIC_LIGHT_DISTANCE::TRAFFICLIGHTDISTANCE")
  (make-package "TRAFFIC_LIGHT_DISTANCE::TRAFFICLIGHTDISTANCE"))

(in-package "ROS")
;;//! \htmlinclude TrafficLightDistance.msg.html


(defclass traffic_light_distance::TrafficLightDistance
  :super ros::object
  :slots (_confidence _distance ))

(defmethod traffic_light_distance::TrafficLightDistance
  (:init
   (&key
    ((:confidence __confidence) 0.0)
    ((:distance __distance) 0.0)
    )
   (send-super :init)
   (setq _confidence (float __confidence))
   (setq _distance (float __distance))
   self)
  (:confidence
   (&optional __confidence)
   (if __confidence (setq _confidence __confidence)) _confidence)
  (:distance
   (&optional __distance)
   (if __distance (setq _distance __distance)) _distance)
  (:serialization-length
   ()
   (+
    ;; float32 _confidence
    4
    ;; float32 _distance
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float32 _confidence
       (sys::poke _confidence (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _distance
       (sys::poke _distance (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float32 _confidence
     (setq _confidence (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _distance
     (setq _distance (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get traffic_light_distance::TrafficLightDistance :md5sum-) "b8d2ff46c6d416afc309012dc49b99de")
(setf (get traffic_light_distance::TrafficLightDistance :datatype-) "traffic_light_distance/TrafficLightDistance")
(setf (get traffic_light_distance::TrafficLightDistance :definition-)
      "float32 confidence   # 置信度
float32 distance     # 距离（米），若无效则为 -1


")



(provide :traffic_light_distance/TrafficLightDistance "b8d2ff46c6d416afc309012dc49b99de")


