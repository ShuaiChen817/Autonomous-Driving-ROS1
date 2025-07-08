#include "ros/ros.h"
#include "navigation_goals_sender/CheckWaypoint.h" // Include your service message header
#include "nav_msgs/Odometry.h"
#include "geometry_msgs/Pose.h"

// Global variable to store the latest odom message
nav_msgs::Odometry latest_odom;

// Callback function to update the latest odom message
void odomCallback(const nav_msgs::Odometry::ConstPtr& msg) {
    latest_odom = *msg;
}

int main(int argc, char **argv) {
    ros::init(argc, argv, "waypoint_checker_client");
    ros::NodeHandle nh;

    // Subscribe to the /odom topic
    ros::Subscriber odom_sub = nh.subscribe("odom", 1000, odomCallback);

    // Create a service client for the CheckWaypoint service
    ros::ServiceClient client = nh.serviceClient<navigation_goals_sender::CheckWaypoint>("check_waypoint");
    navigation_goals_sender::CheckWaypoint srv;

// Wait for the first odom message to be received
ros::Rate rate(10); // 10 Hz
while (ros::ok()) {
    // Check if we have received at least one odom message
    if (latest_odom.header.seq != 0) {
        // Use the latest odom message to fill the service request
        srv.request.current_pose = latest_odom.pose.pose;

        if (client.call(srv)) {
            if (srv.response.is_close_enough) {
                ROS_INFO("Close to the waypoint.");
                // Process next waypoint if provided in response
            } else {
                ROS_INFO("Not close to the waypoint.");
            }
        } else {
            ROS_ERROR("Failed to call service check_waypoint");
        }
    } else {
        ROS_INFO("Waiting for the first odom message...");
    }

    ros::spinOnce();
    rate.sleep();
}
}