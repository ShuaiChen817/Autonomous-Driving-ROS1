#include <ros/ros.h>
#include <simulation/VehicleControl.h>
#include <nav_msgs/Odometry.h>
#include <nav_msgs/Path.h>
#include <geometry_msgs/PoseStamped.h>
#include <std_msgs/Int32.h>
#include <tf/tf.h>
#include <cmath>

constexpr float loop_interval = 0.05;  // 20Hz
constexpr float lookahead_dist = 5.0;
constexpr float max_steering = 0.6;
constexpr float target_speed = 6.0;
constexpr float pre_move_speed = 2.0;
constexpr float pre_move_distance = 5.0;

class ControllerNode {
public:
    ControllerNode(ros::NodeHandle& nh) {
        control_pub_ = nh.advertise<simulation::VehicleControl>("/car_command", 1);
        odom_sub_ = nh.subscribe("/odom", 1, &ControllerNode::odomCallback, this);
        path_sub_ = nh.subscribe("/plan", 1, &ControllerNode::pathCallback, this);
        mode_sub_ = nh.subscribe("/controller_command", 1, &ControllerNode::modeCallback, this);
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
    ros::Subscriber odom_sub_, path_sub_, mode_sub_;

    geometry_msgs::Pose current_pose_;
    nav_msgs::Path current_path_;
    double current_speed_ = 0.0;
    int controller_mode_ = 1;  // default to normal

    bool has_odom_ = false;
    bool has_path_ = false;
    bool pre_move_done_ = false;
    bool has_start_pose_ = false;
    geometry_msgs::Pose start_pose_;

    void odomCallback(const nav_msgs::Odometry::ConstPtr& msg) {
        current_pose_ = msg->pose.pose;
        current_speed_ = msg->twist.twist.linear.x;
        has_odom_ = true;

        if (!has_start_pose_) {
            start_pose_ = current_pose_;
            has_start_pose_ = true;
        }
    }

    void pathCallback(const nav_msgs::Path::ConstPtr& msg) {
        current_path_ = *msg;
        has_path_ = true;
    }

    void modeCallback(const std_msgs::Int32::ConstPtr& msg) {
        controller_mode_ = msg->data;
    }

    void controlStep() {
        if (!has_odom_ || !has_path_) return;

        if (!pre_move_done_) {
            preMoveStep();
            return;
        }

        if (current_path_.poses.empty()) return;

        // Get current position and yaw
        double x = current_pose_.position.x;
        double y = current_pose_.position.y;

        tf::Quaternion q(
            current_pose_.orientation.x,
            current_pose_.orientation.y,
            current_pose_.orientation.z,
            current_pose_.orientation.w);
        double roll, pitch, yaw;
        tf::Matrix3x3(q).getRPY(roll, pitch, yaw);

        // Find lookahead goal point
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

        if (!found) return;

        // Calculate yaw error
        double goal_dx = goal.pose.position.x - x;
        double goal_dy = goal.pose.position.y - y;
        double angle_to_goal = std::atan2(goal_dy, goal_dx);
        double yaw_error = angle_to_goal - yaw;
        while (yaw_error > M_PI) yaw_error -= 2 * M_PI;
        while (yaw_error < -M_PI) yaw_error += 2 * M_PI;

        // Control command
        simulation::VehicleControl cmd;

        // Mode-dependent target speed
        float current_target_speed = target_speed;
        if (controller_mode_ == 0) {
            cmd.Steering = 0.0;
            cmd.Throttle = 0.0;
            cmd.Brake = 1.0;
            control_pub_.publish(cmd);
            return;
        } else if (controller_mode_ == 2) {
            current_target_speed = 3.0;
        } else if (controller_mode_ == 3) {
            current_target_speed = 4.0;
        }

        // Steering
        double steer_cmd = yaw_error * 1.5;
        steer_cmd = std::max(-static_cast<double>(max_steering), std::min(static_cast<double>(max_steering), steer_cmd));
        cmd.Steering = steer_cmd;

        // Throttle
        double speed_error = current_target_speed - current_speed_;
        double throttle_cmd = speed_error * 0.3;
        throttle_cmd = std::max(0.0, std::min(1.0, throttle_cmd));
        cmd.Throttle = throttle_cmd;

        cmd.Brake = 0.0;
        cmd.Reserved = 0.0;

        control_pub_.publish(cmd);
    }

    void preMoveStep() {
        if (!has_start_pose_) return;

        double dx = current_pose_.position.x - start_pose_.position.x;
        double dy = current_pose_.position.y - start_pose_.position.y;
        double dist = std::hypot(dx, dy);

        if (dist >= pre_move_distance) {
            pre_move_done_ = true;
            ROS_INFO("Pre-move completed: moved %.2f meters", dist);
            return;
        }

        // Straight driving forward
        simulation::VehicleControl cmd;
        cmd.Steering = 0.0;
        double speed_error = pre_move_speed - current_speed_;
        double throttle_cmd = speed_error * 0.5;
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
