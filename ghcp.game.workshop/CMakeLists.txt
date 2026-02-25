cmake_minimum_required(VERSION 3.20)
project(urban_survivor LANGUAGES CXX)

# ── C++ standard ──────────────────────────────────────────────────────
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# ── godot-cpp dependency ──────────────────────────────────────────────
add_subdirectory(external/godot-cpp)

# Fix PDB contention (C1041) during parallel MSVC builds of godot-cpp
if(MSVC)
    target_compile_options(godot-cpp PRIVATE /FS)
endif()

# ── Collect source files ──────────────────────────────────────────────
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
    src/*.cpp
    src/*.hpp
)

# ── Shared library target ────────────────────────────────────────────
add_library(${PROJECT_NAME} SHARED ${SOURCES})

target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
)

target_link_libraries(${PROJECT_NAME} PRIVATE godot-cpp)

# ── MSVC compiler flags ──────────────────────────────────────────────
if(MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE
        /W4
        /permissive-
        /bigobj
    )
endif()

# ── Output naming & directory ─────────────────────────────────────────
# Match the naming convention expected by the .gdextension file:
#   liburban_survivor.windows.template_debug.x86_64.dll
# godot-cpp 4.3 uses: {system}.{build_type}.{bits}
string(TOLOWER "${CMAKE_SYSTEM_NAME}" SYSTEM_NAME)

set(OUTPUT_DIR "${CMAKE_SOURCE_DIR}/game/bin/")

# Multi-config generators (Visual Studio) need per-config output names.
# Single-config generators use CMAKE_BUILD_TYPE directly.
if(CMAKE_CONFIGURATION_TYPES)
    # Visual Studio / multi-config: use generator expressions
    set(SUFFIX_DEBUG   "${SYSTEM_NAME}.template_debug.x86_64")
    set(SUFFIX_RELEASE "${SYSTEM_NAME}.template_release.x86_64")

    set_target_properties(${PROJECT_NAME} PROPERTIES
        PREFIX "lib"
        OUTPUT_NAME_DEBUG          "urban_survivor.${SUFFIX_DEBUG}"
        OUTPUT_NAME_RELEASE        "urban_survivor.${SUFFIX_RELEASE}"
        OUTPUT_NAME_MINSIZEREL     "urban_survivor.${SUFFIX_RELEASE}"
        OUTPUT_NAME_RELWITHDEBINFO "urban_survivor.${SUFFIX_DEBUG}"

        # Prevent VS from appending /Debug or /Release subdirectories
        RUNTIME_OUTPUT_DIRECTORY         "$<1:${OUTPUT_DIR}>"
        RUNTIME_OUTPUT_DIRECTORY_DEBUG   "$<1:${OUTPUT_DIR}>"
        RUNTIME_OUTPUT_DIRECTORY_RELEASE "$<1:${OUTPUT_DIR}>"
        LIBRARY_OUTPUT_DIRECTORY         "$<1:${OUTPUT_DIR}>"
        LIBRARY_OUTPUT_DIRECTORY_DEBUG   "$<1:${OUTPUT_DIR}>"
        LIBRARY_OUTPUT_DIRECTORY_RELEASE "$<1:${OUTPUT_DIR}>"
        PDB_OUTPUT_DIRECTORY             "$<1:${OUTPUT_DIR}>"
        PDB_OUTPUT_DIRECTORY_DEBUG       "$<1:${OUTPUT_DIR}>"
        PDB_OUTPUT_DIRECTORY_RELEASE     "$<1:${OUTPUT_DIR}>"
    )
else()
    # Single-config (Makefiles, Ninja)
    string(TOLOWER "${CMAKE_BUILD_TYPE}" BUILD_TYPE_LOWER)
    if(BUILD_TYPE_LOWER STREQUAL "debug")
        set(TARGET_SUFFIX "template_debug")
    else()
        set(TARGET_SUFFIX "template_release")
    endif()

    set(BITS 64)
    if(NOT CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(BITS 32)
    endif()

    set_target_properties(${PROJECT_NAME} PROPERTIES
        PREFIX "lib"
        OUTPUT_NAME "urban_survivor.${SYSTEM_NAME}.${TARGET_SUFFIX}.x86_${BITS}"
        RUNTIME_OUTPUT_DIRECTORY "${OUTPUT_DIR}"
        LIBRARY_OUTPUT_DIRECTORY "${OUTPUT_DIR}"
        PDB_OUTPUT_DIRECTORY     "${OUTPUT_DIR}"
    )
endif()
