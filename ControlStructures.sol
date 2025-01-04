// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract ControlStructures {
    // Custom error for after hours
    error AfterHours(uint time);

    function fizzBuzz(uint _number) public pure returns (string memory) {
        // Check if number is divisible by both 3 and 5
        if (_number % 3 == 0 && _number % 5 == 0) {
            return "FizzBuzz";
        }
        // Check if number is divisible by 3
        if (_number % 3 == 0) {
            return "Fizz";
        }
        // Check if number is divisible by 5
        if (_number % 5 == 0) {
            return "Buzz";
        }
        // If none of the above conditions are true
        return "Splat";
    }

    function doNotDisturb(uint _time) public pure returns (string memory) {
        // Check if time is >= 2400 (panic condition)
        if (_time >= 2400) {
            assert(false); // This will trigger a panic
        }

        // Check after hours condition (> 2200 or < 800)
        if (_time > 2200 || _time < 800) {
            revert AfterHours(_time);
        }

        // Check lunch time (1200-1259)
        if (_time >= 1200 && _time <= 1259) {
            revert("At lunch!");
        }

        // Check morning hours (800-1199)
        if (_time >= 800 && _time <= 1199) {
            return "Morning!";
        }

        // Check afternoon hours (1300-1799)
        if (_time >= 1300 && _time <= 1799) {
            return "Afternoon!";
        }

        // Check evening hours (1800-2200)
        if (_time >= 1800 && _time <= 2200) {
            return "Evening!";
        }

        // This line should never be reached due to the comprehensive conditions above
        revert("Invalid time");
    }
} 