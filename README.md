## Project Name

Autonomous Driving

## Authors

Group27

## Description

This project is part of the Introduction to ROS course in ss25 at TUM and aims to implement an autonomous vehicle that navigates through an urban environment within a Unity simulation, using ROS as the middleware framework.

### Completed missions

In this project, we are fulfilling all the requirements without the help of a semantic camera:

+ Successfully working perception pipeline

+ Successfully working path planning

+ Successfully working trajectory planning

+ Successfully avoiding other cars

+ Successfully stopping/driving at street lights

+ Time to complete the mission

+ Using Yolov5 to recognise objects. Solving the problem **without using a semantic camera**

Functional modules created and resources referenced to achieve the assignments:

|                   Task                   | Conteibutor           | Packages/Tools Unilised                             |
| :--------------------------------------: | --------------------- | --------------------------------------------------- |
| Point Cloud Generation & Octomap Mapping | Hao Zhang,Kaidong Guo | depth_image_proc, octomap_ros, octomap_server, RVIZ |
|         Traffic Light Detection          | Hao Zhang             | YOLOv5, RGB Camera, depth camera, OpenCV          |
|              Global Planner              | Shuai Chen            | move_base, nav_msgs, tf                             |
|              Local Planner               | Shuai Chen            | teb_local_planner                                   |
|            Controller Design             | Fangxu Han            | No            |
|              State Machine               | Keqing Zhang          | SMACH                           |
|       System Integration & Testing       | All                   | Unity Simulation, RVIZ, ROS1                        |



## Requirements

Make sure you already had ```ros-noetic-desktop-full``` installed.

## Installation

### 1. Local installation

Install dependencies:

```bash
sudo apt-get update && sudo apt-get install -y \
python3-rosdep \
python3-rosinstall \
python3-rosinstall-generator \
python3-wstool \
build-essential \
opencv-contrib-python\
python3-catkin-tools \
ros-noetic-rviz \
ros-noetic-octomap-server \
ros-noetic-navigation \
ros-noetic-octomap-rviz-plugins \
ros-noetic-teb-local-planner \
ros-noetic-move-slow-clear \
ros-noetic-global-planner \
ros-noetic-smach \
ros-noetic-smach-ros \
ros-noetic-smach-viewer \
ros-noetic-cv-bridge \
ros-noetic-image-transport \
ros-noetic-eigen-conversions \
ros-noetic-move-base \
ros-noetic-base-local-planner \
tf_conversions \
depth_image_proc \
```

### 2. Install Yolov5

1. creat a local yolo file and clone yolov5

```bash
git clone https://github.com/ultralytics/yolov5.git
```

2. Check whether the installation was successful

```bash
cd yolov5
git checkout v6.1
output：Note: switching to 'v6.1'.
```

3. Install dependencies

```bash
pip install -r
requirements.txt
```

4. Test

```bash
python3 detect.py
--source data/images --weights [yolov5s.pt](http://yolov5s.pt/) --conf0.25
output:mage 1/2
data/images/bus.jpg: 640x480 1 bus, 2 persons
Results saved to
runs/detect/exp
```

5. Change the address

find the traffic_light_info file in src:

(1).open the ```traffic_light_info.py ``` and change the path of yolo5 into your own path
```bash
sys.path.append("/your own yolo5 path/yolov5")
```
(2)open the ```traffic_light_info.launch``` and change the path of yolo5 into your own path
```bash
<param name="model_path" value="/your own yolo5 path/YoloV5/yolov5s.pt" />
```

### 3. build the project using ```catkin build``` under *.../catkin_ws/*

### 4. ```source devel/setup.bash```

### 5. ```roslaunch simulation simulation.launch```
Option: If you want to change the controller to closed-loop control based on odometry feedback, you can modify the code to receive odom signals before starting the simulation.

### 6. ```rosrun local_planner multi_goal_manager.py```



## Support

Contact @hao Zhang at hao_zhang99@outlook.comfor help with starting the software.

## License

MIT License.

## Future Improvements

+ Fine-tune TEB parameters to improve local planning smoothness

+ Integrate PID/MPC-based controller for smoother actuation

+ The current algorithm struggles to accurately recognize each traffic light in complex scenarios, such as when multiple lights overlap or are partially occluded, and therefore requires optimization.

