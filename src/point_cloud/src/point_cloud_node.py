#!/usr/bin/env python3
# import rospy
# import sensor_msgs.point_cloud2 as pc2
# from sensor_msgs.msg import PointCloud2
# from std_msgs.msg import Header

# def callback(msg):
#     points = pc2.read_points(msg, field_names=("x", "y", "z"), skip_nans=True)
#     filtered = [pt for pt in points if 0.0 <= pt[2] <= 1.5]

#     header = Header()
#     header.stamp = rospy.Time.now()
#     header.frame_id = msg.header.frame_id

#     filtered_msg = pc2.create_cloud_xyz32(header, filtered)
#     pub.publish(filtered_msg)

# rospy.init_node("z_filter_py")
# sub = rospy.Subscriber("/points", PointCloud2, callback)
# pub = rospy.Publisher("/filtered_cloud", PointCloud2, queue_size=1)

# rospy.spin()
