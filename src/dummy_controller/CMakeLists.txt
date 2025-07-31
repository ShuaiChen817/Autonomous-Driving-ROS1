cmake_minimum_required(VERSION 3.0.2)
project(dummy_controller)   

find_package(catkin REQUIRED COMPONENTS
  roscpp
  geometry_msgs
  nav_msgs
  simulation  
)

catkin_package()

include_directories(
  ${catkin_INCLUDE_DIRS}
)

add_executable(dummy_controller_node src/dummy_controller_node.cpp)
target_link_libraries(dummy_controller_node ${catkin_LIBRARIES})
add_dependencies(dummy_controller_node ${catkin_EXPORTED_TARGETS})
