
(cl:in-package :asdf)

(defsystem "point_cloud-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :sensor_msgs-msg
               :std_msgs-msg
)
  :components ((:file "_package")
    (:file "PointCloudStamped" :depends-on ("_package_PointCloudStamped"))
    (:file "_package_PointCloudStamped" :depends-on ("_package"))
  ))