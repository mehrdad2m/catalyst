cmake_minimum_required(VERSION 3.20)

project(catalyst_oqc)

set(runtime_includes "${PROJECT_SOURCE_DIR}/../../../../runtime/include")
set(backend_includes "${PROJECT_SOURCE_DIR}/../../../../runtime/lib/backend/common")
set(util_includes "${PROJECT_SOURCE_DIR}/../../../../runtime/utils")
set(runtime_lib "${RUNTIME_BUILD_DIR}/lib")
set(oqc_backend_dir "${OQC_BUILD_DIR}/backend")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(FetchContent)

find_package(pybind11 CONFIG)

if(pybind11_FOUND)
    message(STATUS "Found pybind11")
else()
    message(STATUS "Cound not find existing pybind11-dev package. Building from source.")
    set(CMAKE_POLICY_DEFAULT_CMP0127 NEW) # To suppress pybind11 CMP0127 warning

    # https://cmake.org/cmake/help/latest/module/FindPython.html
    find_package(Python COMPONENTS Interpreter Development)

    FetchContent_Declare(pybind11
    GIT_REPOSITORY https://github.com/pybind/pybind11.git
    GIT_TAG        v2.10.1
    )

    FetchContent_MakeAvailable(pybind11)
endif()

message(STATUS "Building the OQC device.")

add_library(rtd_oqc SHARED OQCDevice.cpp)

target_include_directories(rtd_oqc PUBLIC .
    ${runtime_includes}
    ${backend_includes}
    ${util_includes}
    )

set(OQC_LIBRARIES
    rtd_oqc
    catalyst_python_interpreter
)

set_target_properties(rtd_oqc PROPERTIES BUILD_RPATH "$ORIGIN/../utils")
target_link_directories(rtd_oqc PRIVATE ${runtime_lib})
target_link_libraries(rtd_oqc PRIVATE pybind11::module catalyst_python_interpreter)

set_property(TARGET rtd_oqc PROPERTY POSITION_INDEPENDENT_CODE ON)
file(COPY ${PROJECT_SOURCE_DIR}/oqc.toml DESTINATION ./backend)

add_subdirectory(tests)