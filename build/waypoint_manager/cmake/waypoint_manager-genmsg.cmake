# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "waypoint_manager: 0 messages, 1 services")

set(MSG_I_FLAGS "-Istd_msgs:/opt/ros/noetic/share/std_msgs/cmake/../msg;-Igeometry_msgs:/opt/ros/noetic/share/geometry_msgs/cmake/../msg;-Inav_msgs:/opt/ros/noetic/share/nav_msgs/cmake/../msg;-Iactionlib_msgs:/opt/ros/noetic/share/actionlib_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(gennodejs REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(waypoint_manager_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/hao/my_workspace/ROS_project/project/src/planning/waypoint_manager/srv/CheckWaypoint.srv" NAME_WE)
add_custom_target(_waypoint_manager_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "waypoint_manager" "/home/hao/my_workspace/ROS_project/project/src/planning/waypoint_manager/srv/CheckWaypoint.srv" "geometry_msgs/PoseStamped:std_msgs/Header:geometry_msgs/Point:geometry_msgs/Quaternion:geometry_msgs/Pose"
)

#
#  langs = gencpp;geneus;genlisp;gennodejs;genpy
#

### Section generating for lang: gencpp
### Generating Messages

### Generating Services
_generate_srv_cpp(waypoint_manager
  "/home/hao/my_workspace/ROS_project/project/src/planning/waypoint_manager/srv/CheckWaypoint.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/PoseStamped.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/waypoint_manager
)

### Generating Module File
_generate_module_cpp(waypoint_manager
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/waypoint_manager
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(waypoint_manager_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(waypoint_manager_generate_messages waypoint_manager_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/hao/my_workspace/ROS_project/project/src/planning/waypoint_manager/srv/CheckWaypoint.srv" NAME_WE)
add_dependencies(waypoint_manager_generate_messages_cpp _waypoint_manager_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(waypoint_manager_gencpp)
add_dependencies(waypoint_manager_gencpp waypoint_manager_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS waypoint_manager_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages

### Generating Services
_generate_srv_eus(waypoint_manager
  "/home/hao/my_workspace/ROS_project/project/src/planning/waypoint_manager/srv/CheckWaypoint.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/PoseStamped.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/waypoint_manager
)

### Generating Module File
_generate_module_eus(waypoint_manager
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/waypoint_manager
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(waypoint_manager_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(waypoint_manager_generate_messages waypoint_manager_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/hao/my_workspace/ROS_project/project/src/planning/waypoint_manager/srv/CheckWaypoint.srv" NAME_WE)
add_dependencies(waypoint_manager_generate_messages_eus _waypoint_manager_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(waypoint_manager_geneus)
add_dependencies(waypoint_manager_geneus waypoint_manager_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS waypoint_manager_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages

### Generating Services
_generate_srv_lisp(waypoint_manager
  "/home/hao/my_workspace/ROS_project/project/src/planning/waypoint_manager/srv/CheckWaypoint.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/PoseStamped.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/waypoint_manager
)

### Generating Module File
_generate_module_lisp(waypoint_manager
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/waypoint_manager
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(waypoint_manager_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(waypoint_manager_generate_messages waypoint_manager_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/hao/my_workspace/ROS_project/project/src/planning/waypoint_manager/srv/CheckWaypoint.srv" NAME_WE)
add_dependencies(waypoint_manager_generate_messages_lisp _waypoint_manager_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(waypoint_manager_genlisp)
add_dependencies(waypoint_manager_genlisp waypoint_manager_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS waypoint_manager_generate_messages_lisp)

### Section generating for lang: gennodejs
### Generating Messages

### Generating Services
_generate_srv_nodejs(waypoint_manager
  "/home/hao/my_workspace/ROS_project/project/src/planning/waypoint_manager/srv/CheckWaypoint.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/PoseStamped.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/waypoint_manager
)

### Generating Module File
_generate_module_nodejs(waypoint_manager
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/waypoint_manager
  "${ALL_GEN_OUTPUT_FILES_nodejs}"
)

add_custom_target(waypoint_manager_generate_messages_nodejs
  DEPENDS ${ALL_GEN_OUTPUT_FILES_nodejs}
)
add_dependencies(waypoint_manager_generate_messages waypoint_manager_generate_messages_nodejs)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/hao/my_workspace/ROS_project/project/src/planning/waypoint_manager/srv/CheckWaypoint.srv" NAME_WE)
add_dependencies(waypoint_manager_generate_messages_nodejs _waypoint_manager_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(waypoint_manager_gennodejs)
add_dependencies(waypoint_manager_gennodejs waypoint_manager_generate_messages_nodejs)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS waypoint_manager_generate_messages_nodejs)

### Section generating for lang: genpy
### Generating Messages

### Generating Services
_generate_srv_py(waypoint_manager
  "/home/hao/my_workspace/ROS_project/project/src/planning/waypoint_manager/srv/CheckWaypoint.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/PoseStamped.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/waypoint_manager
)

### Generating Module File
_generate_module_py(waypoint_manager
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/waypoint_manager
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(waypoint_manager_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(waypoint_manager_generate_messages waypoint_manager_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/hao/my_workspace/ROS_project/project/src/planning/waypoint_manager/srv/CheckWaypoint.srv" NAME_WE)
add_dependencies(waypoint_manager_generate_messages_py _waypoint_manager_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(waypoint_manager_genpy)
add_dependencies(waypoint_manager_genpy waypoint_manager_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS waypoint_manager_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/waypoint_manager)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/waypoint_manager
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(waypoint_manager_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()
if(TARGET geometry_msgs_generate_messages_cpp)
  add_dependencies(waypoint_manager_generate_messages_cpp geometry_msgs_generate_messages_cpp)
endif()
if(TARGET nav_msgs_generate_messages_cpp)
  add_dependencies(waypoint_manager_generate_messages_cpp nav_msgs_generate_messages_cpp)
endif()

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/waypoint_manager)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/waypoint_manager
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_eus)
  add_dependencies(waypoint_manager_generate_messages_eus std_msgs_generate_messages_eus)
endif()
if(TARGET geometry_msgs_generate_messages_eus)
  add_dependencies(waypoint_manager_generate_messages_eus geometry_msgs_generate_messages_eus)
endif()
if(TARGET nav_msgs_generate_messages_eus)
  add_dependencies(waypoint_manager_generate_messages_eus nav_msgs_generate_messages_eus)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/waypoint_manager)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/waypoint_manager
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(waypoint_manager_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()
if(TARGET geometry_msgs_generate_messages_lisp)
  add_dependencies(waypoint_manager_generate_messages_lisp geometry_msgs_generate_messages_lisp)
endif()
if(TARGET nav_msgs_generate_messages_lisp)
  add_dependencies(waypoint_manager_generate_messages_lisp nav_msgs_generate_messages_lisp)
endif()

if(gennodejs_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/waypoint_manager)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/waypoint_manager
    DESTINATION ${gennodejs_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_nodejs)
  add_dependencies(waypoint_manager_generate_messages_nodejs std_msgs_generate_messages_nodejs)
endif()
if(TARGET geometry_msgs_generate_messages_nodejs)
  add_dependencies(waypoint_manager_generate_messages_nodejs geometry_msgs_generate_messages_nodejs)
endif()
if(TARGET nav_msgs_generate_messages_nodejs)
  add_dependencies(waypoint_manager_generate_messages_nodejs nav_msgs_generate_messages_nodejs)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/waypoint_manager)
  install(CODE "execute_process(COMMAND \"/usr/bin/python3\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/waypoint_manager\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/waypoint_manager
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(waypoint_manager_generate_messages_py std_msgs_generate_messages_py)
endif()
if(TARGET geometry_msgs_generate_messages_py)
  add_dependencies(waypoint_manager_generate_messages_py geometry_msgs_generate_messages_py)
endif()
if(TARGET nav_msgs_generate_messages_py)
  add_dependencies(waypoint_manager_generate_messages_py nav_msgs_generate_messages_py)
endif()
