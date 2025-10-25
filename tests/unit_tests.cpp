#include <gtest/gtest.h>

// Include the implementation directly so this single translation unit can be
// compiled without separately linking math_operations.cpp.
// You can change the path to match your layout (e.g. "../math_operations.cpp").
#include "math_operations.cpp"

#include <climits>
#include <iostream>

// Basic correctness
TEST(AddTest, PositiveNumbers) {
    EXPECT_EQ(add(2, 3), 5);
}

TEST(AddTest, NegativeNumbers) {
    EXPECT_EQ(add(-2, -3), -5);
}

TEST(AddTest, MixedSign) {
    EXPECT_EQ(add(-5, 5), 0);
    EXPECT_EQ(add(7, 0), 7);
}

TEST(AddTest, Zero) {
    EXPECT_EQ(add(0, 0), 0);
}

// Property: commutativity
TEST(AddTest, Commutative) {
    int a = 123;
    int b = -456;
    EXPECT_EQ(add(a, b), add(b, a));
}

// Edge values within safe range (avoid signed overflow)
TEST(AddTest, LargeValues) {
    EXPECT_EQ(add(INT_MAX - 1, 1), INT_MAX);
    EXPECT_EQ(add(INT_MIN, 0), INT_MIN);
}

// Small additional checks
TEST(AddTest, Identity) {
    EXPECT_EQ(add(0, 42), 42);
    EXPECT_EQ(add(42, 0), 42);
}

int main(int argc, char** argv) {
    ::testing::InitGoogleTest(&argc, argv);
    int result = RUN_ALL_TESTS();
    std::cout << "Press Enter to exit..." << std::endl;
    std::cin.get(); // Wait for Enter before closing the console
    return result;
}
