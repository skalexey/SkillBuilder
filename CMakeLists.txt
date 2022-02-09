cmake_minimum_required(VERSION 3.14)

macro(configure_files srcDir destDir)
    message(STATUS "Configuring directory ${destDir}")
    message(STATUS "Copy from ${srcDir}")
    make_directory(${destDir})
    file(GLOB templateFiles RELATIVE ${srcDir} ${srcDir}/*)
    foreach(templateFile ${templateFiles})
        set(srcTemplatePath ${srcDir}/${templateFile})
        if(NOT IS_DIRECTORY ${srcTemplatePath})
            message(STATUS "Configuring file ${templateFile}")
            configure_file(
                    ${srcTemplatePath}
                    ${destDir}/${templateFile}
                    COPYONLY)
        endif(NOT IS_DIRECTORY ${srcTemplatePath})
    endforeach(templateFile)
endmacro(configure_files)

project(SkillBuilder VERSION 0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Quick LinguistTools REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Quick LinguistTools REQUIRED)

set(TS_FILES SkillBuilder_en_US.ts)

include_directories("include")

file(GLOB sources CONFIGURE_DEPENDS "src/*" "include/*")

set(PROJECT_SOURCES
        main.cpp
        qml.qrc
        ${TS_FILES}
        ${sources}
        UI/SkillBuilderUI.qrc
)

set (
    QML_IMPORT_PATH
    ${CMAKE_CURRENT_SOURCE_DIR}/imports ${CMAKE_CURRENT_SOURCE_DIR}/UI/imports
    CACHE
    STRING
    "Path used to locate CMake modules by Qt Creator"
    FORCE
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(SkillBuilder
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET SkillBuilder APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation

    qt_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
else()
    if(ANDROID)
        add_library(SkillBuilder SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(SkillBuilder
          ${PROJECT_SOURCES}
        )
    endif()

    qt5_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
endif()

target_compile_definitions(SkillBuilder
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(SkillBuilder
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick)

set_target_properties(SkillBuilder PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
)

if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(SkillBuilder)
    qt_finalize_executable(SkillBuilder)
endif()

message("Copy QVL artifacts")
configure_files(${CMAKE_CURRENT_SOURCE_DIR}/dependencies/DataModelBuilder/QVL/Build-cmake-${CMAKE_BUILD_TYPE}/${CMAKE_BUILD_TYPE} ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_BUILD_TYPE}/QVL)
configure_file(dependencies/DataModelBuilder/QVL/Build-cmake-${CMAKE_BUILD_TYPE}/qvl.qmltypes ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_BUILD_TYPE}/QVL/ COPYONLY)
configure_file(dependencies/DataModelBuilder/QVL/Build-cmake-${CMAKE_BUILD_TYPE}/qmldir ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_BUILD_TYPE}/QVL/ COPYONLY)
configure_file(dependencies/DataModelBuilder/QVL/Build-cmake-${CMAKE_BUILD_TYPE}/qmldir ${CMAKE_CURRENT_SOURCE_DIR}/imports/QVL/qmldir  COPYONLY)
configure_file(dependencies/DataModelBuilder/QVL/Build-cmake-${CMAKE_BUILD_TYPE}/qvl.qmltypes ${CMAKE_CURRENT_SOURCE_DIR}/imports/QVL/qvl.qmltypes COPYONLY)
