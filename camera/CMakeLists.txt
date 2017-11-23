cmake_minimum_required(VERSION 3.8)
project(camera)

set(CMAKE_CXX_STANDARD 17)

find_package(OpenCV REQUIRED)

set(SOURCE_FILES main.cpp camera.h)
add_executable(camera ${SOURCE_FILES})

include_directories(${OpenCV_INCLUDE_DIRS})
target_link_libraries(camera ${OpenCV_LIBS})