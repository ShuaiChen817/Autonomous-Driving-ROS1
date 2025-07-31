#include <ros/ros.h>
#include <tf/transform_broadcaster.h>
#include <nav_msgs/Odometry.h>
#include <Eigen/Dense>
#include <eigen_conversions/eigen_msg.h>
#include <geometry_msgs/PoseStamped.h>
#include <geometry_msgs/TwistStamped.h>

class OdomFromUnityNode {
public:
    OdomFromUnityNode() {
        pose_sub = nh.subscribe("/Unity_ROS_message_Rx/OurCar/CoM/pose", 1, &OdomFromUnityNode::PoseCallback, this);
        twist_sub = nh.subscribe("/Unity_ROS_message_Rx/OurCar/CoM/twist", 1, &OdomFromUnityNode::TwistCallback, this);
        odom_pub = nh.advertise<nav_msgs::Odometry>("odom", 1);
    }

private:
    void PoseCallback(const geometry_msgs::PoseStamped::ConstPtr& msg) {
        latest_pose = *msg;
        pose_received = true;
        PublishOdom();
    }

    void TwistCallback(const geometry_msgs::TwistStamped::ConstPtr& msg) {
        latest_twist = *msg;
        twist_received = true;
        PublishOdom();
    }

    void PublishOdom() {
        if (!pose_received || !twist_received) return;

        odom.header.stamp = latest_pose.header.stamp;
        odom.header.frame_id = "world";  //告诉 ROS 这条数据是相对于 world 坐标系来描述的(隐性功能：向系统声明创建坐标系odom)
        odom.child_frame_id = "OurCar/INS";  //声明TF关系，但是并未广播，需要另外处理(这个脚本不包含)
        odom.pose.pose.position = latest_pose.pose.position;

        Eigen::Quaterniond q;
        Eigen::Matrix3d R;
        tf::quaternionMsgToEigen(latest_pose.pose.orientation, q);
        R = q.toRotationMatrix();

        // 坐标系转换（使得 x-前进，z-向上）
        Eigen::Matrix3d mat;
        mat << 0.0,  0.0, 1.0,
               -1.0,  0.0, 0.0,
               0.0,  1.0, 0.0;
        Eigen::Matrix3d rot_mat = mat * R;
        Eigen::Quaterniond rot_q(rot_mat);
        odom.pose.pose.orientation.x = rot_q.x();
        odom.pose.pose.orientation.y = rot_q.y();
        odom.pose.pose.orientation.z = rot_q.z();
        odom.pose.pose.orientation.w = rot_q.w();

        // 速度变换
        Eigen::Vector3d velocity, orientation;
        velocity << latest_twist.twist.linear.x, latest_twist.twist.linear.y, latest_twist.twist.angular.z;
        orientation << latest_twist.twist.angular.x, latest_twist.twist.angular.y, latest_twist.twist.angular.z;

        Eigen::Quaterniond q_odom;
        tf::quaternionMsgToEigen(odom.pose.pose.orientation, q_odom);
        R = q_odom.toRotationMatrix();

        Eigen::Vector3d velocity_odom = R * velocity;
        Eigen::Vector3d orientation_odom = R * orientation;

        odom.twist.twist.linear.x = velocity_odom[0];
        odom.twist.twist.linear.y = velocity_odom[1];
        // pass
        // odom.twist.twist.angular.z = velocity_odom[2];
        odom.twist.twist.linear.z = velocity_odom[2];    //之前的代码漏了给z线性速度转换
        odom.twist.twist.angular.x = orientation_odom[0];
        odom.twist.twist.angular.y = orientation_odom[1];
        odom.twist.twist.angular.z = -orientation_odom[2];

        odom_pub.publish(odom);

        // pass 添加TF广播：odom -> OurCar/INS
        // static tf::TransformBroadcaster br;
        // tf::Transform transform;
        // transform.setOrigin(tf::Vector3(
        //     odom.pose.pose.position.x,
        //     odom.pose.pose.position.y,
        //     odom.pose.pose.position.z
        // ));
        // tf::Quaternion q;
        // q.setX(odom.pose.pose.orientation.x);
        // q.setY(odom.pose.pose.orientation.y);
        // q.setZ(odom.pose.pose.orientation.z);
        // q.setW(odom.pose.pose.orientation.w);
        // transform.setRotation(q);

        // br.sendTransform(tf::StampedTransform(transform, odom.header.stamp, "odom", "OurCar/INS"));
    }

    ros::NodeHandle nh;
    ros::Subscriber pose_sub;
    ros::Subscriber twist_sub;
    ros::Publisher odom_pub;

    geometry_msgs::PoseStamped latest_pose;
    geometry_msgs::TwistStamped latest_twist;
    nav_msgs::Odometry odom;
    bool pose_received = false;
    bool twist_received = false;
};

int main(int argc, char** argv) {
    ros::init(argc, argv, "odometry_publisher");
    OdomFromUnityNode odom_broadcaster;
    ros::spin();
} 