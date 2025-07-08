
(cl:in-package :asdf)

(defsystem "traffic_light_distance-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "TrafficLightDistance" :depends-on ("_package_TrafficLightDistance"))
    (:file "_package_TrafficLightDistance" :depends-on ("_package"))
  ))