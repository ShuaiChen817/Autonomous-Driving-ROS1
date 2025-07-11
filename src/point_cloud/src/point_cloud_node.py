#!/usr/bin/env python3
import rospy
from point_cloud.msg import PointCloudStamped
from sensor_msgs.msg import PointCloud2
from std_msgs.msg import Header
import sensor_msgs.point_cloud2 as pc2

def main():
    rospy.init_node("point_cloud_test_node")

    pub = rospy.Publisher("/my_pointcloud_topic", PointCloudStamped, queue_size=10)
    raw_pub = rospy.Publisher("/raw_cloud", PointCloud2, queue_size=10)  # ✅ 可视化用

    rate = rospy.Rate(1)

    while not rospy.is_shutdown():
        header = Header()
        header.stamp = rospy.Time.now()
        header.frame_id = "depth_camera_link"

        # ✅ 构造几个简单点：x, y, z
        points = [
            (1.0, 1.0, 1.0),
            (2.0, 0.0, 1.5),
            (0.0, 2.0, 1.2)
        ]

        # ✅ 自动生成合法 PointCloud2 消息（包含 fields 和 data）
        cloud = pc2.create_cloud_xyz32(header, points)

        # ✅ 封装成自定义消息
        msg = PointCloudStamped()
        msg.header = header
        msg.cloud = cloud

        pub.publish(msg)       # 发布自定义消息（你自己定义的）
        raw_pub.publish(cloud) # 发布标准 PointCloud2（RViz 可直接显示）

        rate.sleep()

if __name__ == "__main__":
    main()
