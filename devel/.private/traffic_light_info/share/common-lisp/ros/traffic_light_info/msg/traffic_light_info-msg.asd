
(cl:in-package :asdf)

(defsystem "traffic_light_info-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "TrafficLightInfo" :depends-on ("_package_TrafficLightInfo"))
    (:file "_package_TrafficLightInfo" :depends-on ("_package"))
  ))