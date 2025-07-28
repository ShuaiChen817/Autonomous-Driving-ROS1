#include <ros/ros.h>
#include <simulation/VehicleControl.h>
#include <geometry_msgs/Twist.h>
#include <nav_msgs/Odometry.h>

#include <cmath>
#include <algorithm>

static inline double clamp(double v, double lo, double hi){
  return std::max(lo, std::min(hi, v));
}

class SimpleFastController{
public:
  SimpleFastController(ros::NodeHandle& nh, ros::NodeHandle& pnh){
    // topics
    pnh.param<std::string>("cmd_vel_topic",  cmd_vel_topic_,  std::string("/cmd_vel"));
    pnh.param<std::string>("odom_topic",     odom_topic_,     std::string("/odom"));
    pnh.param<std::string>("out_topic",      out_topic_,      std::string("/car_command"));

    // params
    pnh.param<double>("wheelbase",       L_,             2.7);
    pnh.param<double>("steer_gain",      steer_gain_,    1.6);
    pnh.param<double>("max_steer",       max_steer_,     0.6);
    pnh.param<double>("max_steer_rate",  max_sr_,        3.0);
    pnh.param<double>("k_accel",         k_accel_,       8.0);
    pnh.param<double>("k_brake",         k_brake_,       2.0);
    pnh.param<double>("coast_band",      coast_band_,    0.1);
    pnh.param<double>("min_v_to_steer",  min_v_to_steer_,0.02);
    pnh.param<double>("cmd_timeout",     cmd_to_,        2.0);
    pnh.param<double>("odom_timeout",    odom_to_,       2.0);
    pnh.param<double>("steer_sign",      steer_sign_,    -1.0);

    cmd_pub_  = nh.advertise<simulation::VehicleControl>(out_topic_, 1);
    vel_sub_  = nh.subscribe(cmd_vel_topic_, 1, &SimpleFastController::cmdVelCb, this);
    odom_sub_ = nh.subscribe(odom_topic_,    1, &SimpleFastController::odomCb,   this);

    last_cmd_  = ros::Time::now();
    last_odom_ = ros::Time::now();

    steer_cmd_ = 0.0;
  }

  void spin(){
    ros::Rate r(20.0); // 20Hz
    while(ros::ok()){
      ros::spinOnce();
      step();
      r.sleep();
    }
  }

private:
  // ros
  ros::Publisher cmd_pub_;
  ros::Subscriber vel_sub_, odom_sub_;
  std::string cmd_vel_topic_, odom_topic_, out_topic_;

  // states
  bool have_cmd_{false}, have_odom_{false};
  double vx_cmd_{0.0}, wz_cmd_{0.0};
  double vx_meas_{0.0};
  double steer_cmd_{0.0};
  ros::Time last_cmd_, last_odom_;

  // params
  double L_, steer_gain_, max_steer_, max_sr_;
  double k_accel_, k_brake_, coast_band_;
  double min_v_to_steer_, cmd_to_, odom_to_, steer_sign_;

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

  void step(){
    simulation::VehicleControl out; out.Reserved = 0.0;
    const ros::Time now = ros::Time::now();
    bool cmd_timeout  = (now - last_cmd_ ).toSec() > cmd_to_;
    bool odom_timeout = (now - last_odom_).toSec() > odom_to_;

    if(!have_cmd_ || cmd_timeout){
      // emergency brake
      out.Throttle = 0.0; out.Brake = 1.0; out.Steering = 0.0;
      cmd_pub_.publish(out);
      return;
    }

    // ---------- Steering ----------
    double steer_des = 0.0;
    if(std::fabs(vx_cmd_) > min_v_to_steer_ && std::fabs(wz_cmd_) > 1e-6){
      // Ackermann
      steer_des = std::atan2(L_ * wz_cmd_, vx_cmd_) * steer_gain_;
    }
    steer_des *= steer_sign_;
    steer_des  = clamp(steer_des, -max_steer_, max_steer_);

    // rate limit
    double max_step = max_sr_ * 0.05; // 0.05 = 1/20Hz
    double d = clamp(steer_des - steer_cmd_, -max_step, max_step);
    steer_cmd_ += d;

    
    if(std::fabs(vx_cmd_) < min_v_to_steer_) steer_cmd_ = 0.0;

    out.Steering = steer_cmd_;

    // ---------- Longitudinal ----------
    if(!have_odom_ || odom_timeout){
      // no feedback, simple open loop
      out.Throttle = (vx_cmd_ > 0.05)? 0.5 : 0.0;
      out.Brake    = (vx_cmd_ > 0.05)? 0.0 : 0.8;
    }else{
      double v_err = vx_cmd_ - vx_meas_;
      if(std::fabs(v_err) <= coast_band_){
        // coasting
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
