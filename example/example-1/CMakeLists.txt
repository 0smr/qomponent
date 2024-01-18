cmake_minimum_required(VERSION 3.26)

project(example-1)

set(CMAKE_AUTOGEN_PARALLEL AUTO)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(example-1 main.cpp)
qt_add_qml_module(example-1
    URI example
    QML_FILES Main.qml
)

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/../../Qomponent/ ${CMAKE_CURRENT_BINARY_DIR}/qomponent)
target_include_directories(example-1 PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/qomponent)

target_link_libraries(example-1 PRIVATE Qt::Core Qt::Quick)
target_link_libraries(example-1 PRIVATE qomponentplugin)
