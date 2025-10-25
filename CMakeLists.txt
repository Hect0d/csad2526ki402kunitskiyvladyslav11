cmake_minimum_required(VERSION 3.14)
project(csad222642ki42kunitskiyvladyslav11 LANGUAGES CXX)

# Build settings
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# ---- math_operations module ----
# Assumes math_operations.cpp and math_operations.h are in the project root.
add_library(math_operations STATIC
    math_operations.cpp
    math_operations.h
)
target_include_directories(math_operations
    PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}
)

# ---- main executable ----
# Builds an executable named "main" from main.cpp and links math_operations.
add_executable(main
    main.cpp
)
target_link_libraries(main
    PRIVATE math_operations
)

# ---- Unit test ----
# This project uses GoogleTest via FetchContent to avoid requiring it preinstalled.
include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/release-1.12.1.zip
)
# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

enable_testing()

# Note: Many test files include the implementation directly (e.g. '#include "math_operations.cpp"').
# If your unit_test.cpp does that, do NOT also link math_operations here to avoid duplicate symbols.
# If your tests only include the header, you can set LINK_MATH_LIB_TO_TEST to ON to link the library.
option(LINK_MATH_LIB_TO_TEST "Link math_operations library into unit_test instead of relying on unit_test to include the implementation" OFF)

add_executable(unit_test
    unit_test.cpp
)

if(LINK_MATH_LIB_TO_TEST)
    target_link_libraries(unit_test
        PRIVATE
        gtest_main
        math_operations
    )
else()
    target_link_libraries(unit_test
        PRIVATE
        gtest_main
    )
endif()

target_include_directories(unit_test
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}
)

# Register the test with CTest
add_test(NAME unit_test COMMAND unit_test)

# Optional: integrate GoogleTest's helper if present
include(GoogleTest OPTIONAL)
if(TARGET gtest_main)
    gtest_discover_tests(unit_test)
endif()
