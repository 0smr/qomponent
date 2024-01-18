cmake_minimum_required(VERSION 3.23.0)
project(qomponent VERSION 0.2.0)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(QML_IMPORT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/.." CACHE STRING "QML Import Path for QtCreator")
set(QML2_IMPORT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/.." CACHE STRING "QML2 Import Path for QtCreator")

set(CMAKE_INCLUDE_CURRENT_DIR ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Quick)
if(QT_VERSION_MAJOR EQUAL 6)
    find_package(Qt6 REQUIRED COMPONENTS Core Quick Qml ShaderTools)
    set(QT_LIBS Qt::Core Qt::Quick Qt::Qml)
else()
    find_package(Qt5 REQUIRED COMPONENTS Core Quick Qml)
    set(QT_LIBS Qt5::Core Qt5::Quick Qt5::Qml)
    qt5_add_resources(resource_file ${CMAKE_CURRENT_SOURCE_DIR}/qomponent.qrc)
endif()

add_library(qomponent STATIC ${resource_file})

if(QT_VERSION_MAJOR EQUAL 6)
    # QTP0001: The new behavior ensures that modules are put into the QML Import Path
    #   and can be found without further setup.
    qt_policy(SET QTP0001 NEW)

    set_source_files_properties(${CMAKE_CURRENT_SOURCE_DIR}/Qomponent.qml PROPERTIES
        QT_QML_SINGLETON_TYPE TRUE
    )

    set_source_files_properties(${CMAKE_CURRENT_SOURCE_DIR}/scripts.js PROPERTIES
        QT_QML_SOURCE_TYPENAME Scripts
    )

    file(GLOB QML_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "*.qml" "*/*.qml")

    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(NoCache NO_CACHEGEN)
    endif()

    qt_add_qml_module(qomponent
        URI qomponent
        VERSION 0.2
        ${NoCache}
        QML_FILES ${QML_FILES}
        QML_FILES scripts.js
        RESOURCES shader/saturation-spectrom.frag
    )

    qt_add_resources(qomponent "fonts"
        PREFIX /qomponent
        FILES font/mplus1code.ttf
    )

    qt6_add_shaders(qomponent "shaders"
        PREFIX /qomponent
        FILES shader/color-ring.frag
              shader/focus.frag
              shader/grid-ruler.frag
              shader/pie.frag
              shader/ruler.frag
              shader/bar-chart.frag
              shader/iball.frag
              shader/qrect.frag
              shader/elastic.frag
              shader/ripple-mask.frag
              shader/boxshadow.frag
              shader/value-spectrom.frag
              shader/saturation-spectrom.frag
    )
else()
    target_include_directories(qomponent PUBLIC .)
    target_link_libraries(qomponent ${QT_LIBS})
endif()
