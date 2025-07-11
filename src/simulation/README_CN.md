仿真包（Simulation Package）
包概览（Package Overview）
仿真包包含两个主要部分：Unity仿真器和ROS-Unity桥接模块。

Unity仿真器（Unity Simulator）
Unity仿真器位于 simulation\unity_sim\Build_Ubuntu。启动Unity仿真器只需运行二进制文件 AD_Sim.x86_64。

ROS-Unity桥接模块（ROS-Unity Bridge）
ROS-Unity桥接模块由三个组件组成：参数读取器、TCP流接收器、命令发送器。

参数读取器（Parameter Reader）
参数读取器会加载仿真配置文件并将必要的参数发布到ROS参数服务器。要检查参数是否正确加载，只需运行 rosparam list 并使用 rosparam get 命令查询参数。

TCP流接收器（TCP Stream Receiver）
流接收器通过TCP与Unity建立连接，从仿真器接收必要的信息。请注意：一旦连接断开（例如Unity仿真器进程终止），该进程将立即自我终止。这一设计是为了确保ROS和Unity之间的数据延迟只在仿真启动时测量一次，因此一旦仿真器进程关闭，接收器也应被关闭。

命令发送器（Command Transmitter）
通过UDP发送驾驶控制指令，实现对车辆的远程控制。该节点将以100Hz的频率发送指令，无论Unity实例是否存在。

快速开始（Getting Started）
要启动所有必要节点，只需运行：

bash
Copy
Edit
roslaunch simulation simulation.launch
注意：如果你发现Unity仿真器进程立即退出，请参考 已知问题：启动时Unity仿真器进程退出 部分。

自定义仿真（Customize the Simulation）
Unity仿真器和ROS包在启动时会读取配置文件：simulation\unity_sim\Build_Ubuntu\AD_Sim_Data\StreamingAssets\simulation_config.json，你可以通过该文件自定义仿真内容。

spawnIndexData/spawnIndex
指定ego车辆的出生位置索引，范围为0到9。

eventEnable
将布尔值设置为 false 可以禁用对应事件的触发。事件描述请参见项目PDF文件。

controlConfig
address 和 port
定义运行Unity仿真器的机器的地址和端口。如果Unity和ROS运行在同一台机器上，请将地址保留为 127.0.0.1。

controllerOnly
设置为 true 时，车辆仅能通过键盘输入控制。

controllerOverride
设置为 true 时，当按下键盘按键时，键盘输入将覆盖ROS节点发送的控制指令。若同时将 controllerOnly 设为 true，Unity将忽略此字段。

sensorConfig
address 和 port
定义运行ROS节点的机器的地址和端口。如果Unity和ROS运行在同一台机器上，请将地址保留为 127.0.0.1。

groundRemoval
设置为 true 时，深度相机中道路部分将被处理为null，如下图所示。



truePose
设置为 false 时，ego车辆的位姿将不会发布到ROS主题中。

已知问题：启动时Unity仿真器进程退出（Known Issue: Unity-sim process dies when launching）
尝试分别启动仿真进程，而不是通过ROS的launch文件统一启动。

运行：

bash
Copy
Edit
./src/simulation/unity_sim/Build_Ubuntu/AD_Sim.x86_64
然后在另一个终端运行：

bash
Copy
Edit
source devel/setup.bash
roslaunch simulation simulation_no_Unity.launch
目前此问题的具体原因尚不明确 :(。

可选方案：在不同机器上运行ROS与Unity仿真器（Alternative: Run the ROS and Unity Simulator on Different Machines）
由于TCP/UDP通信不限于本地机器，你也可以尝试将Unity仿真器运行在另一台机器上，例如在Windows上运行Unity仿真器，在WSL中运行ROS。
如果你这么做，请确保两台机器上的 simulation_config.json 文件内容一致，否则ROS-Unity桥接模块可能无法正常工作。

Windows版本的Unity仿真器已经提供，详见Moodle上的项目说明PDF文件。
