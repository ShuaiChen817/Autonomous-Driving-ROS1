
#include "ros/ros.h"
#include "geometry_msgs/Pose.h"
#include "geometry_msgs/PointStamped.h"
#include "waypoint_manager/CheckWaypoint.h"
#include "nav_msgs/Odometry.h"
#include <vector>
#include <cmath>

class WaypointCheckerServer {
private:
    ros::NodeHandle nh_;
    ros::ServiceServer service_;
    ros::Publisher waypoint_pub_;
    std::vector<std::vector<double>> waypoints_ = {
         {-62.8, -12.29},  // 第一个点设为当前位置
    {-50.0, -12.0},

    };
    int current_waypoint_index_ = 0;

    bool isClose(const geometry_msgs::Pose& current_pose, const std::vector<double>& goal_pose) {
        double distance = std::hypot(current_pose.position.x - goal_pose[0], current_pose.position.y - goal_pose[1]);
        return distance < 999.0;
    }

    bool checkWaypoint(waypoint_manager::CheckWaypoint::Request &req,
                       waypoint_manager::CheckWaypoint::Response &res) {
        if (current_waypoint_index_ >= waypoints_.size()) {
            ROS_WARN("All waypoints reached.");
            return false;
        }

        const auto& goal = waypoints_[current_waypoint_index_];
        if (isClose(req.current_pose, goal)) {
            current_waypoint_index_++;
            if (current_waypoint_index_ < waypoints_.size()) {
                res.next_waypoint.pose.position.x = waypoints_[current_waypoint_index_][0];
                res.next_waypoint.pose.position.y = waypoints_[current_waypoint_index_][1];
                res.is_close_enough = true;
            }
        } else {
            res.is_close_enough = false;
        }
        return true;
    }

public:
    WaypointCheckerServer() {
        service_ = nh_.advertiseService("check_waypoint", &WaypointCheckerServer::checkWaypoint, this);
        waypoint_pub_ = nh_.advertise<geometry_msgs::PointStamped>("/received_waypoints", 10);
    }

    void publishWaypoint() {
        if (current_waypoint_index_ < waypoints_.size()) {
            // 先发主要航点
            geometry_msgs::PointStamped goal_msg;
            goal_msg.header.stamp = ros::Time::now();
            goal_msg.header.frame_id = "OurCar/INS";
            goal_msg.point.x = waypoints_[current_waypoint_index_][0];
            goal_msg.point.y = waypoints_[current_waypoint_index_][1];
            waypoint_pub_.publish(goal_msg);

            // 再插入一个临近点以满足 epsilon 条件（避免手动插入）
            geometry_msgs::PointStamped final_msg = goal_msg;
            final_msg.point.x += 0.05;  // 插入与上一个点非常近的点（小于 epsilon）
            final_msg.point.y += 0.05;
            final_msg.header.stamp = ros::Time::now();
            waypoint_pub_.publish(final_msg);

            ROS_INFO("Published waypoint #%d and final trigger point.", current_waypoint_index_);
        }
    }
};

nav_msgs::Odometry latest_odom;
void odomCallback(const nav_msgs::Odometry::ConstPtr& msg) {
    latest_odom = *msg;
}

int main(int argc, char **argv) {
    ros::init(argc, argv, "waypoint_manager");
    ros::NodeHandle nh;

    WaypointCheckerServer server;
    ros::Subscriber odom_sub = nh.subscribe("odom", 1000, odomCallback);
    ros::ServiceClient client = nh.serviceClient<waypoint_manager::CheckWaypoint>("check_waypoint");
    waypoint_manager::CheckWaypoint srv;

    ros::Rate rate(10);
    ROS_INFO("Waypoint Manager Running...");

    while (ros::ok()) {
        ros::spinOnce();
        if (latest_odom.header.seq != 0) {
            srv.request.current_pose = latest_odom.pose.pose;
            if (client.call(srv)) {
                if (srv.response.is_close_enough) {
                    ROS_INFO("Client: Close to waypoint.");
                    server.publishWaypoint();  //  只有接近后才发下一个航点
                }
            }
        }
        rate.sleep();
    }
    return 0;
}
