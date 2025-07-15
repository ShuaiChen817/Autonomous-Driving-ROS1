#include <ros/ros.h>
#include <simulation/VehicleControl.h>
#include <nav_msgs/Odometry.h>
#include <nav_msgs/Path.h>
#include <geometry_msgs/PoseStamped.h>
#include <tf/tf.h>
#include <cmath>

constexpr float loop_interval = 0.05;  // Control frequency 20Hz
constexpr float lookahead_dist = 5.0;  // lookahead distance
constexpr float max_steering = 0.6;
constexpr float target_speed = 6.0;    // target speed m/s

class ControllerNode {
public:
    ControllerNode(ros::NodeHandle& nh) {
        control_pub_ = nh.advertise<simulation::VehicleControl>("/car_command", 1);
        odom_sub_ = nh.subscribe("/odom", 1, &ControllerNode::odomCallback, this);
        path_sub_ = nh.subscribe("/plan", 1, &ControllerNode::pathCallback, this);
    }

    void run() {
        ros::Rate rate(1.0 / loop_interval);
        while (ros::ok()) {
            ros::spinOnce();
            controlStep();
            rate.sleep();
        }
    }

private:
    ros::Publisher control_pub_;
    ros::Subscriber odom_sub_, path_sub_;
    geometry_msgs::Pose current_pose_;
    double current_speed_ = 0.0;
    nav_msgs::Path current_path_;
    bool has_odom_ = false;
    bool has_path_ = false;

    void odomCallback(const nav_msgs::Odometry::ConstPtr& msg) {
        current_pose_ = msg->pose.pose;
        current_speed_ = msg->twist.twist.linear.x;
        has_odom_ = true;
    }

    void pathCallback(const nav_msgs::Path::ConstPtr& msg) {
        current_path_ = *msg;
        has_path_ = true;
    }

    void controlStep() {
        if (!has_odom_ || !has_path_ || current_path_.poses.empty()) return;

        // get current position
        double x = current_pose_.position.x;
        double y = current_pose_.position.y;

        // get current orientation
        tf::Quaternion q(
            current_pose_.orientation.x,
            current_pose_.orientation.y,
            current_pose_.orientation.z,
            current_pose_.orientation.w);
        double roll, pitch, yaw;
        tf::Matrix3x3(q).getRPY(roll, pitch, yaw);

        // seek lookahead point
        geometry_msgs::PoseStamped goal;
        bool found = false;
        for (const auto& p : current_path_.poses) {
            double dx = p.pose.position.x - x;
            double dy = p.pose.position.y - y;
            if (std::hypot(dx, dy) > lookahead_dist) {
                goal = p;
                found = true;
                break;
            }
        }

        if (!found) return;  // no point found

        // calculate bias
        double goal_dx = goal.pose.position.x - x;
        double goal_dy = goal.pose.position.y - y;
        double angle_to_goal = std::atan2(goal_dy, goal_dx);
        double yaw_error = angle_to_goal - yaw;

        // Normalized angle
        while (yaw_error > M_PI) yaw_error -= 2 * M_PI;
        while (yaw_error < -M_PI) yaw_error += 2 * M_PI;

        // control calculation
        simulation::VehicleControl cmd;

        // Steering: steerign P control
        double steer_cmd = yaw_error * 1.5;  // P factor
        steer_cmd = std::max(-max_steering, std::min(max_steering, steer_cmd));
        cmd.Steering = steer_cmd;

        // Throttle: velocity P control
        double speed_error = target_speed - current_speed_;
        double throttle_cmd = speed_error * 0.3;  // P control
        throttle_cmd = std::max(0.0, std::min(1.0, throttle_cmd));
        cmd.Throttle = throttle_cmd;

        cmd.Brake = 0.0;
        cmd.Reserved = 0.0;

        control_pub_.publish(cmd);
    }
};

int main(int argc, char** argv) {
    ros::init(argc, argv, "pid_controller_node");
    ros::NodeHandle nh;
    ControllerNode controller(nh);
    controller.run();
    return 0;
}

