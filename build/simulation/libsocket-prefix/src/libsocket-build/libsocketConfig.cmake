set(libsocket_INCLUDE_DIRS "/home/hao/my_workspace/ROS_project/project/build/simulation/libsocket-prefix/src/libsocket/headers")

set(libsocket_BINARY_DIR "/home/hao/my_workspace/ROS_project/project/build/simulation/libsocket-prefix/src/libsocket-build")

include(${libsocket_BINARY_DIR}/libsocketTargets.cmake)

set(libsocket_LIBRARIES socket++)
