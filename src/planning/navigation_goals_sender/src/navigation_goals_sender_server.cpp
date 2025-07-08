#include "ros/ros.h"
#include "geometry_msgs/Pose.h"
#include "geometry_msgs/PointStamped.h"
#include "navigation_goals_sender/CheckWaypoint.h"
#include <vector>
#include <cmath>

class WaypointCheckerServer {
private:
    ros::NodeHandle nh_;
    ros::ServiceServer service_;
    ros::Publisher waypoint_pub_;
    std::vector<std::vector<double>> waypoints_ =  {

        {-61.0,12.0},//0 0
        //{-25.0, -61.0}, 
        //{-34.0, -61.0},
        {-48.0, 52.0},//1
        //{-52.5, -14.0},
        //{-52.5, 40.0},
        {70.0, 52.7},//2
        //{-52.5, 120.0},
        //{-42.0, 121.5},
        //{-18.0, 121.5},
        {141.6, 51.0},//3
        //{-52.5, 186.0},
        //{-50.0, 208.0},
        //{-48.0, 215.0},
        //{-42.0, 226.0},
        {229.3, 16.0},//4
       // {-5.0, 226.0},
        //{-2.0, 200.0},
        {141.37, 3.3},//5
        //{-4.5, 132.0},
        {122.4, 9.1},//6
        //{-18.0, 121.5},
        //{-42.0, 121.5},
        //{-52.5, 120.0},
        //{-52.5, 115.0},
        {103.0, 52.3},//7
        //{-50.0, 80.0},
       // {-48.0, 46.5},
        {103.0, 52.0},//8
        //{-4.0, 45.0},
        {39.0, 3.5},//9
        //{-4,5, 18.0},
        
        //{-2.00, -4.0},
        //{-2.30, -47.00},

        //{-1.00, -57.00},

        //{10.5, -63.00},
        {-61.0,12.0},//10

    };
    int current_waypoint_index_ = 0;

    bool isClose(const geometry_msgs::Pose& current_pose, const std::vector<double>& goal_pose) {
        double distance = std::sqrt(std::pow(current_pose.position.x - goal_pose[0], 2) +
                                    std::pow(current_pose.position.y - goal_pose[1], 2));
        return distance < 5.0; // Threshold for being "close enough" TODO:change to a parameter?
    }

    bool checkWaypoint(navigation_goals_sender::CheckWaypoint::Request &req,
                       navigation_goals_sender::CheckWaypoint::Response &res) {
        // Check if the last waypoint has been reached
        if (current_waypoint_index_ >= waypoints_.size()) {
            ROS_WARN("All waypoints have been reached.");
            return false;
        }

        const auto& current_goal = waypoints_[current_waypoint_index_];
        if (isClose(req.current_pose, current_goal)) {
            current_waypoint_index_++; // Move to the next waypoint
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
        // Initialize waypoints_ vector here with your waypoints
    }

    void run() {
        ROS_INFO("Waypoint Checker Server Ready.");
        ros::Rate loop_rate(10);
        while (ros::ok()) {
            if (current_waypoint_index_ < waypoints_.size() && current_waypoint_index_ > 0) {
                geometry_msgs::PointStamped goal_msg;
                goal_msg.header.stamp = ros::Time::now();
                goal_msg.header.frame_id = "world"; // Or your relevant frame
                goal_msg.point.x = waypoints_[current_waypoint_index_][0];
                goal_msg.point.y = waypoints_[current_waypoint_index_][1];

                waypoint_pub_.publish(goal_msg);
            }
            ros::spinOnce();
            loop_rate.sleep();
        }
    }
};

int main(int argc, char **argv) {
    ros::init(argc, argv, "waypoint_checker_server");
    WaypointCheckerServer server;
    server.run();
    return 0;
}
