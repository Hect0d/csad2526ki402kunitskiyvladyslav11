# csad222642ki42kunitskiyvladyslav11
This project demonstrates a small C++ library (`math_operations`) with a `main` executable and GoogleTest-based unit tests.

Below are concise instructions for creating a test executable file and running the tests using the provided `CMakeLists.txt`.

Prerequisites
- CMake >= 3.14
- A C++ compiler supporting C++17
- Internet access (the CMake file uses FetchContent to download GoogleTest)

Quick build and run (default)
1. Create a build directory and configure:
   ```
   mkdir build
   cmake -S . -B build
   ```
2. Build the project and tests:
   ```
   cmake --build build --config Release
   ```
3. Run tests with CTest (recommended):
   ```
   ctest --test-dir build --verbose
   ```
   Or run the test binary directly:
   ```
   ./build/unit_test
   ```

Creating a test executable file (unit_test.cpp)
- Option A — Include the implementation directly inside the test translation unit

  If your `unit_test.cpp` includes the implementation file (for example `#include "math_operations.cpp"`), place `unit_test.cpp` in the project root and use the following minimal example:

  ```cpp
  #include <gtest/gtest.h>
  #include "math_operations.cpp" // includes implementation directly

  TEST(AddTest, Basic) {
      EXPECT_EQ(add(2,3), 5);
  }

  int main(int argc, char** argv) {
      ::testing::InitGoogleTest(&argc, argv);
      return RUN_ALL_TESTS();
  }
  ```

  Notes:
  - Do NOT link `math_operations` library into the test target in CMake if you use this pattern, otherwise you'll get duplicate symbol/linker errors.
  - This can be convenient for small projects or one-file tests.

- Option B — Include the header and link the math library

  A more typical approach is to include the public header and link the `math_operations` library that is built by CMake:

  ```cpp
  #include "math_operations.h"
  #include <gtest/gtest.h>

  TEST(AddTest, Basic) {
      EXPECT_EQ(add(2,3), 5);
  }

  int main(int argc, char** argv) {
      ::testing::InitGoogleTest(&argc, argv);
      return RUN_ALL_TESTS();
  }
  ```

  In this case you should tell CMake to link the `math_operations` library into the `unit_test` target. The supplied `CMakeLists.txt` contains an option to control this:
  - To link the library, configure with:
    ```
    cmake -S . -B build -DLINK_MATH_LIB_TO_TEST=ON
    ```
  - Then build:
    ```
    cmake --build build --config Release
    ```

How the supplied CMake setup works
- `math_operations` is defined as a static library target.
- `main` executable is built from `main.cpp` and links `math_operations`.
- `unit_test` is created as a test target. By default, `LINK_MATH_LIB_TO_TEST` is OFF to avoid duplicate symbols if tests include `math_operations.cpp` directly. Set `-DLINK_MATH_LIB_TO_TEST=ON` when your tests only include the header and you want the library linked.

Running tests (summary)
- Build:
  ```
  cmake -S . -B build
  cmake --build build --config Release
  ```
- Run all tests:
  ```
  ctest --test-dir build --verbose
  ```
  or run the test executable:
  ```
  ./build/unit_test
  ```

Tips
- If your test binary waits for user input (e.g., `std::cin.get()` used to pause), tests run non-interactively via `ctest` may hang. Remove or #ifdef-guard pause code for automated runs.
- Use `-DLINK_MATH_LIB_TO_TEST=ON` when your tests only include headers and you want the test target to link against `math_operations`. Leave it OFF if your tests include the `.cpp` implementation directly.

What I did: I added step-by-step instructions showing both ways to create a test executable (include implementation vs link library), the exact CMake option to toggle linking, and the commands to configure, build, and run the tests.

What's next: If you want, I can add an example `unit_test.cpp` file to the repo, or update `CMakeLists.txt` to place sources into `src/` and `tests/` directories and provide an example `main.cpp`.
