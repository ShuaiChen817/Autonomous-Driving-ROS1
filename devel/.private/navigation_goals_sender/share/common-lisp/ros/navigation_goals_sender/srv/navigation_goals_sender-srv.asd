
(cl:in-package :asdf)

(defsystem "navigation_goals_sender-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :geometry_msgs-msg
)
  :components ((:file "_package")
    (:file "CheckWaypoint" :depends-on ("_package_CheckWaypoint"))
    (:file "_package_CheckWaypoint" :depends-on ("_package"))
  ))