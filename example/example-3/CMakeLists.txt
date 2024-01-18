cmake_minimum_required(VERSION 3.26)

project(example-3)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOGEN_PARALLEL AUTO)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(example-3
    main.cpp
)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(NoCache NO_CACHEGEN)
endif()

qt_add_qml_module(${PROJECT_NAME}
    URI example
    ${NoCache}
    QML_FILES
        Main.qml
        Page1.qml
        Page2.qml
)

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/../../Qomponent/ ${CMAKE_CURRENT_BINARY_DIR}/qomponent)

target_include_directories(example-3 PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/qomponent)

target_link_libraries(example-3 PRIVATE Qt::Core Qt::Quick)
target_link_libraries(example-3 PRIVATE qomponentplugin)
