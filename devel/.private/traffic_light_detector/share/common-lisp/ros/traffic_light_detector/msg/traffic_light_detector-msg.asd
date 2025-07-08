
(cl:in-package :asdf)

(defsystem "traffic_light_detector-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "TrafficLightStatus" :depends-on ("_package_TrafficLightStatus"))
    (:file "_package_TrafficLightStatus" :depends-on ("_package"))
  ))