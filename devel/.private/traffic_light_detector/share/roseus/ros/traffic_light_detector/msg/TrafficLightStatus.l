;; Auto-generated. Do not edit!


(when (boundp 'traffic_light_detector::TrafficLightStatus)
  (if (not (find-package "TRAFFIC_LIGHT_DETECTOR"))
    (make-package "TRAFFIC_LIGHT_DETECTOR"))
  (shadow 'TrafficLightStatus (find-package "TRAFFIC_LIGHT_DETECTOR")))
(unless (find-package "TRAFFIC_LIGHT_DETECTOR::TRAFFICLIGHTSTATUS")
  (make-package "TRAFFIC_LIGHT_DETECTOR::TRAFFICLIGHTSTATUS"))

(in-package "ROS")
;;//! \htmlinclude TrafficLightStatus.msg.html


(defclass traffic_light_detector::TrafficLightStatus
  :super ros::object
  :slots (_color _confidence ))

(defmethod traffic_light_detector::TrafficLightStatus
  (:init
   (&key
    ((:color __color) "")
    ((:confidence __confidence) 0.0)
    )
   (send-super :init)
   (setq _color (string __color))
   (setq _confidence (float __confidence))
   self)
  (:color
   (&optional __color)
   (if __color (setq _color __color)) _color)
  (:confidence
   (&optional __confidence)
   (if __confidence (setq _confidence __confidence)) _confidence)
  (:serialization-length
   ()
   (+
    ;; string _color
    4 (length _color)
    ;; float32 _confidence
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; string _color
       (write-long (length _color) s) (princ _color s)
     ;; float32 _confidence
       (sys::poke _confidence (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; string _color
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _color (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;; float32 _confidence
     (setq _confidence (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get traffic_light_detector::TrafficLightStatus :md5sum-) "7c6888484e259b845906032dcb46689c")
(setf (get traffic_light_detector::TrafficLightStatus :datatype-) "traffic_light_detector/TrafficLightStatus")
(setf (get traffic_light_detector::TrafficLightStatus :definition-)
      "string color   # \"red\", \"green\", \"yellow\", \"unknown\"
float32 confidence

")



(provide :traffic_light_detector/TrafficLightStatus "7c6888484e259b845906032dcb46689c")


