// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract BasicMath {
    function adder(uint _a, uint _b) public pure returns (uint sum, bool error) {
        // Try to add the numbers
        unchecked {
            sum = _a + _b;
            // Check for overflow by comparing with one of the inputs
            // If sum < _a (or _b), it means overflow occurred
            if (sum < _a) {
                return (0, true); // Overflow occurred
            }
            return (sum, false); // No overflow
        }
    }

    function subtractor(uint _a, uint _b) public pure returns (uint difference, bool error) {
        // If _b > _a, underflow will occur
        if (_b > _a) {
            return (0, true); // Underflow would occur
        }
        
        difference = _a - _b;
        return (difference, false); // No underflow
    }
} 