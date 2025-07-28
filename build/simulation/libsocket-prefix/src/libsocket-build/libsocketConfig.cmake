set(libsocket_INCLUDE_DIRS "/home/fangxu/ws/build/simulation/libsocket-prefix/src/libsocket/headers")

set(libsocket_BINARY_DIR "/home/fangxu/ws/build/simulation/libsocket-prefix/src/libsocket-build")

include(${libsocket_BINARY_DIR}/libsocketTargets.cmake)

set(libsocket_LIBRARIES socket++)
