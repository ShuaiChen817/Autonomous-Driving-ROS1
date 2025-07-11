cmake_minimum_required(VERSION 3.0.2)
project(waypoint_manager)

## 使用 C++11
add_compile_options(-std=c++11)

## 找到 catkin 包及其依赖
find_package(catkin REQUIRED COMPONENTS
  roscpp
  rospy
  std_msgs
  message_generation
  geometry_msgs
  nav_msgs
)

## 生成服务
add_service_files(
  FILES
  CheckWaypoint.srv
)

## 生成消息代码
generate_messages(
  DEPENDENCIES
  std_msgs
  geometry_msgs
  nav_msgs
)

## 配置 catkin_package
catkin_package(
  CATKIN_DEPENDS roscpp rospy std_msgs message_runtime geometry_msgs nav_msgs
)

## 包含头文件路径
include_directories(
  ${catkin_INCLUDE_DIRS}
)

## 可执行文件 waypoint_manager
add_executable(waypoint_manager src/waypoint_manager.cpp)

## 添加依赖（确保在 message 编译后再编译 node）
add_dependencies(waypoint_manager ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})

## 链接所需库
target_link_libraries(waypoint_manager
  ${catkin_LIBRARIES}
)
