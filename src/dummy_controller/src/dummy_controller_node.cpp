#include <ros/ros.h>
#include <simulation/VehicleControl.h>
#include <geometry_msgs/Twist.h>
#include <nav_msgs/Odometry.h>
#include <std_msgs/Int32.h>

#include <cmath>
#include <algorithm>
#include <string>

static inline double clamp(double v, double lo, double hi){
  return std::max(lo, std::min(hi, v));
}

class SimpleFastController{
public:
  SimpleFastController(ros::NodeHandle& nh, ros::NodeHandle& pnh){
    // topics
    pnh.param<std::string>("cmd_vel_topic",     cmd_vel_topic_,     std::string("/cmd_vel"));
    pnh.param<std::string>("odom_topic",        odom_topic_,        std::string("/odom"));
    pnh.param<std::string>("out_topic",         out_topic_,         std::string("/car_command"));
    pnh.param<std::string>("mode_topic",        mode_topic_,        std::string("/controller_command"));

    // params
    pnh.param<double>("wheelbase",       L_,               2.7);
    pnh.param<double>("steer_gain",      steer_gain_,      1.6);
    pnh.param<double>("steer_gain_turn", steer_gain_turn_, 3.0);   // 仅转弯时可放大
    pnh.param<double>("max_steer",       max_steer_,       2.0);
    pnh.param<double>("max_steer_rate",  max_sr_,          6.0);
    pnh.param<double>("k_accel",         k_accel_,         12.0);
    pnh.param<double>("k_brake",         k_brake_,         2.0);
    pnh.param<double>("coast_band",      coast_band_,      0.1);
    pnh.param<double>("min_v_to_steer",  min_v_to_steer_,  0.02);
    pnh.param<double>("cmd_timeout",     cmd_to_,          2.0);
    pnh.param<double>("odom_timeout",    odom_to_,         2.0);
    pnh.param<double>("steer_sign",      steer_sign_,     -1.0);

    // 模式相关纵向缩放
    pnh.param<double>("turn_speed_scale",  turn_speed_scale_,  0.6); // 转弯时降速
    pnh.param<double>("merge_speed_scale", merge_speed_scale_, 0.5); // 并线时降速

    cmd_pub_   = nh.advertise<simulation::VehicleControl>(out_topic_, 1);
    vel_sub_   = nh.subscribe(cmd_vel_topic_, 1, &SimpleFastController::cmdVelCb, this);
    odom_sub_  = nh.subscribe(odom_topic_,    1, &SimpleFastController::odomCb,   this);
    mode_sub_  = nh.subscribe(mode_topic_,    1, &SimpleFastController::modeCb,   this);

    last_cmd_  = ros::Time::now();
    last_odom_ = ros::Time::now();

    steer_cmd_  = 0.0;
  }

  void spin(){
    ros::Rate r(50.0); // 20Hz
    while(ros::ok()){
      ros::spinOnce();
      step();
      r.sleep();
    }
  }

private:
  // ros
  ros::Publisher  cmd_pub_;
  ros::Subscriber vel_sub_, odom_sub_, mode_sub_;
  std::string cmd_vel_topic_, odom_topic_, out_topic_, mode_topic_;

  // states
  bool   have_cmd_{false}, have_odom_{false};
  double vx_cmd_{0.0}, wz_cmd_{0.0};
  double vx_meas_{0.0};
  double steer_cmd_{0.0};
  int    ctrl_mode_{1}; // 0:stop 1:normal 2:turning 3:merge
  ros::Time last_cmd_, last_odom_;

  // params
  double L_, steer_gain_, steer_gain_turn_, max_steer_, max_sr_;
  double k_accel_, k_brake_, coast_band_;
  double min_v_to_steer_, cmd_to_, odom_to_, steer_sign_;
  double turn_speed_scale_, merge_speed_scale_;

  // callbacks
  void cmdVelCb(const geometry_msgs::Twist::ConstPtr& m){
    vx_cmd_ = m->linear.x;
    wz_cmd_ = m->angular.z;
    have_cmd_ = true;
    last_cmd_ = ros::Time::now();
  }

  void odomCb(const nav_msgs::Odometry::ConstPtr& m){
    vx_meas_ = m->twist.twist.linear.x;
    have_odom_ = true;
    last_odom_ = ros::Time::now();
  }

  void modeCb(const std_msgs::Int32::ConstPtr& m){
    ctrl_mode_ = m->data;
  }

  void step(){
    simulation::VehicleControl out; out.Reserved = 0.0;
    const ros::Time now = ros::Time::now();
    bool cmd_timeout  = (now - last_cmd_ ).toSec() > cmd_to_;
    bool odom_timeout = (now - last_odom_).toSec() > odom_to_;

    // 优先级：无cmd/timeout 或 状态机要求停 => 直接刹停
    if(!have_cmd_ || cmd_timeout || ctrl_mode_ == 0){
      out.Throttle = 0.0; out.Brake = 1.0; out.Steering = 0.0;
      cmd_pub_.publish(out);
      return;
    }

    // --- 根据模式调整速度/转向增益 ---
    double vx_cmd_eff = vx_cmd_;
    double steer_gain_eff = steer_gain_;

    if(ctrl_mode_ == 2){ // Turning
      vx_cmd_eff       = vx_cmd_ * turn_speed_scale_;
      steer_gain_eff   = steer_gain_turn_;
    }else if(ctrl_mode_ == 3){ // Merge
      vx_cmd_eff       = vx_cmd_ * merge_speed_scale_;
      // 转向增益不一定改，可根据需要
    }

    // ---------- Steering ----------
    double steer_des = 0.0;
    if(std::fabs(vx_cmd_eff) > min_v_to_steer_ && std::fabs(wz_cmd_) > 1e-6){
      // Ackermann
      steer_des = std::atan2(L_ * wz_cmd_, vx_cmd_eff) * steer_gain_eff;
    }
    steer_des *= steer_sign_;
    steer_des  = clamp(steer_des, -max_steer_, max_steer_);

    // rate limit
    double max_step = max_sr_ * 0.05; // 0.05 = 1/20Hz
    double delta    = clamp(steer_des - steer_cmd_, -max_step, max_step);
    steer_cmd_ += delta;

    if(std::fabs(vx_cmd_eff) < min_v_to_steer_) steer_cmd_ = 0.0;
    out.Steering = steer_cmd_;

    // ---------- Longitudinal ----------
    if(!have_odom_ || odom_timeout){
      out.Throttle = (vx_cmd_eff > 0.05)? 0.5 : 0.0;
      out.Brake    = (vx_cmd_eff > 0.05)? 0.0 : 0.8;
    }else{
      double v_err = vx_cmd_eff - vx_meas_;
      if(std::fabs(v_err) <= coast_band_){
        out.Throttle = 0.0;
        out.Brake    = 0.0;
      }else if(v_err > 0){
        out.Throttle = clamp(k_accel_ * v_err, 0.0, 1.0);
        out.Brake    = 0.0;
      }else{
        out.Throttle = 0.0;
        out.Brake    = clamp(k_brake_ * (-v_err), 0.0, 1.0);
      }
    }

    cmd_pub_.publish(out);
  }
};

int main(int argc, char** argv){
  ros::init(argc, argv, "simple_fast_controller");
  ros::NodeHandle nh;
  ros::NodeHandle pnh("~");
  SimpleFastController node(nh, pnh);
  node.spin();
  return 0;
}
