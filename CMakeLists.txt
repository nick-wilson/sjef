cmake_minimum_required(VERSION 3.15)
project(iterative-solver CXX)

include(FetchContent)
FetchContent_Declare(
        LibraryManager
        GIT_REPOSITORY https://github.com/molpro/library-manager.git
        GIT_TAG 0.11.5
)
FetchContent_MakeAvailable(LibraryManager)

LibraryManager_Project()
message(VERBOSE "PROJECT_VERSION=${PROJECT_VERSION}")
message(VERBOSE "PROJECT_VERSION_FULL=${PROJECT_VERSION_FULL}")

option(BUILD_TESTS "Whether to build tests or not" ON)
option(BUILD_PROGRAM "Whether to build sjef bash program or not" ON)

project(sjef LANGUAGES CXX C VERSION ${PROJECT_VERSION})
set(SJEF_VERSION ${PROJECT_VERSION_FULL})

set(PROGRAM_FILENAME "sjef")
set(PROGRAM_NAME "sjef-program")

if (MSVC)
add_compile_options(/EHsc /permissive-)
endif ()

set(CMAKE_POLICY_DEFAULT_CMP0048 NEW)
add_subdirectory(src)

if (BUILD_TESTS)
    enable_testing()
    add_subdirectory(test)
endif ()

if (BUILD_PROGRAM)
    add_subdirectory(program)
endif ()

find_package(Doxygen)
if (DOXYGEN_FOUND)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile @ONLY)
    add_custom_target(${PROJECT_NAME}-doc ALL
            DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/html/index.html
            )
    file(GLOB_RECURSE headers src/*.h */*.md *.md src/*.cpp)
    add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/html/index.html
            COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
            DEPENDS ${headers} ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            COMMENT "Generating API documentation with Doxygen" VERBATIM
            )
endif (DOXYGEN_FOUND)
