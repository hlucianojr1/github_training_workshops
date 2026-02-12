# Urban Survivor - Third Person Survival Shooter
# Godot 4 GDExtension Build Configuration
cmake_minimum_required(VERSION 3.20)
project(urban_survivor VERSION 0.1.0 LANGUAGES CXX)

# C++17 required for godot-cpp
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Output directories
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Platform detection
if(WIN32)
    set(PLATFORM_NAME "windows")
elseif(APPLE)
    set(PLATFORM_NAME "macos")
else()
    set(PLATFORM_NAME "linux")
endif()

# Architecture detection
if(APPLE)
    # On macOS, detect actual architecture (arm64 vs x86_64)
    if(CMAKE_SYSTEM_PROCESSOR STREQUAL "arm64" OR CMAKE_OSX_ARCHITECTURES STREQUAL "arm64")
        set(ARCH_NAME "arm64")
    else()
        set(ARCH_NAME "x86_64")
    endif()
elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(ARCH_NAME "x86_64")
else()
    set(ARCH_NAME "x86_32")
endif()

# Build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Build type" FORCE)
endif()

string(TOLOWER ${CMAKE_BUILD_TYPE} BUILD_TYPE_LOWER)

# godot-cpp submodule
if(NOT EXISTS "${CMAKE_SOURCE_DIR}/external/godot-cpp/CMakeLists.txt")
    message(FATAL_ERROR "godot-cpp not found. Run: git submodule update --init --recursive")
endif()

add_subdirectory(external/godot-cpp)

# Collect all source files
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
    "${CMAKE_SOURCE_DIR}/src/*.cpp"
    "${CMAKE_SOURCE_DIR}/src/*.hpp"
    "${CMAKE_SOURCE_DIR}/src/*.h"
)

# Organize source files into VS Solution Explorer filters matching directory structure
# This gives proper folder hierarchy: ai/, camera/, combat/, core/, etc.
source_group(TREE "${CMAKE_SOURCE_DIR}/src" PREFIX "Source Files" FILES ${SOURCES})

# Create the GDExtension library
add_library(${PROJECT_NAME} SHARED ${SOURCES})

target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_SOURCE_DIR}/src
    ${CMAKE_SOURCE_DIR}/src/core
    ${CMAKE_SOURCE_DIR}/src/player
    ${CMAKE_SOURCE_DIR}/src/camera
    ${CMAKE_SOURCE_DIR}/src/ai
    ${CMAKE_SOURCE_DIR}/src/inventory
    ${CMAKE_SOURCE_DIR}/src/survival
    ${CMAKE_SOURCE_DIR}/src/world
    ${CMAKE_SOURCE_DIR}/src/combat
    ${CMAKE_SOURCE_DIR}/src/ui
)

target_link_libraries(${PROJECT_NAME} PRIVATE godot::cpp)

# Set output name with platform info
# Use generator expressions for multi-config generators (Visual Studio)
# Falls back to BUILD_TYPE_LOWER for single-config generators (Ninja, Make)
set_target_properties(${PROJECT_NAME} PROPERTIES
    OUTPUT_NAME_DEBUG "lib${PROJECT_NAME}.${PLATFORM_NAME}.debug.${ARCH_NAME}"
    OUTPUT_NAME_RELEASE "lib${PROJECT_NAME}.${PLATFORM_NAME}.release.${ARCH_NAME}"
    OUTPUT_NAME_RELWITHDEBINFO "lib${PROJECT_NAME}.${PLATFORM_NAME}.release.${ARCH_NAME}"
    OUTPUT_NAME_MINSIZEREL "lib${PROJECT_NAME}.${PLATFORM_NAME}.release.${ARCH_NAME}"
    PREFIX ""
)

# Single-config fallback (Ninja, Makefiles)
if(NOT CMAKE_CONFIGURATION_TYPES)
    set_target_properties(${PROJECT_NAME} PROPERTIES
        OUTPUT_NAME "lib${PROJECT_NAME}.${PLATFORM_NAME}.${BUILD_TYPE_LOWER}.${ARCH_NAME}"
    )
endif()

# Copy library to Godot project bin folder
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_SOURCE_DIR}/game/bin"
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${PROJECT_NAME}> "${CMAKE_SOURCE_DIR}/game/bin/"
    COMMENT "Copying GDExtension library to Godot project..."
)

# Print configuration summary
message(STATUS "")
message(STATUS "=== Urban Survivor Build Configuration ===")
message(STATUS "Platform: ${PLATFORM_NAME}")
message(STATUS "Architecture: ${ARCH_NAME}")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "==========================================")
message(STATUS "")
