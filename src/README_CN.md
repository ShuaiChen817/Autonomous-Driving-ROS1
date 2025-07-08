ROS简介课程项目 —— 自动驾驶
概述
本仓库是“ROS简介”课程项目 自动驾驶 的一部分。它包含一个基于Unity的驾驶仿真包和一个用于控制车辆的虚拟控制器，帮助你理解如何控制车辆。

系统要求
操作系统：Ubuntu 20.04（可原生安装或通过Windows子系统WSL运行）

ROS版本：ROS Noetic

所需工具：

标准ROS工具：catkin、roscore 等

Git

Git LFS（大文件存储工具，用于下载Unity二进制文件和大型资源）

安装Git LFS的方法：

bash
Copy
Edit
sudo apt install git-lfs
git lfs install
仓库结构
本仓库包含两个ROS包：

simulation/

包含一个基于Unity的仿真环境，模拟车辆在虚拟城市中的感知和运动。

包含启动文件、配置脚本和ROS集成逻辑。

dummy_controller/

一个基本的ROS节点，用于在仿真中控制车辆。

用于演示如何发布控制指令。

快速开始
克隆仓库到工作空间的 /src 文件夹下
你的工作空间应如下所示：

text
Copy
Edit
your_workspace/
└── src/
    ├── simulation/
    ├── dummy_controller/
    ├── CMakeList.txt
    ├── setup_script.sh
    └── README.md
运行设置脚本
该脚本会确保仿真所需的文件和脚本是可执行的：

bash
Copy
Edit
bash src/setup_script.sh
注意：你可以自由修改此脚本以帮助他人更方便地设置项目。

编译工作空间
bash
Copy
Edit
catkin build
编译成功后，工作空间中将自动生成 devel、build 和 logs 文件夹。

运行仿真
在运行该命令之前，请确保已启动 roscore：

bash
Copy
Edit
source devel/setup.bash
roslaunch simulation simulation.launch
此时会弹出一个窗口，你可以使用方向键或WASD键控制车辆。

注意：此launch文件只是一个最小示例，确保Unity仿真部分可以被ROS访问。你当然也可以构建并使用你自己的launch文件！

运行Dummy控制器节点
在roscore和仿真节点都已启动的前提下，在另一个终端运行以下命令：

bash
Copy
Edit
source devel/setup.bash
rosrun dummy_controller dummy_controller_node
此时车辆应该可以自动加速和转向。

自定义仿真
仿真节点提供多种可配置参数，例如传感器设置、socket端口等。详情请参考 simulation包中的README.md。

项目作业
任务说明和提交要求请参阅上传至Moodle的项目PDF文档。请务必仔细阅读。

技术支持
如遇到问题或有疑问，请通过 我的邮箱 联系我，我会尽我所能提供帮助。
