// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract EmployeeStorage {
    // Custom error for too many shares
    error TooManyShares(uint256 totalShares);

    // Storage optimization:
    // shares (uint16) + salary (uint32) can be packed into one slot
    uint16 private shares;      // max 5000, so uint16 is enough
    uint32 private salary;      // max 1,000,000, so uint32 is enough
    string public name;         // needs its own slot
    uint256 public idNumber;    // needs full uint256 as per requirement

    constructor() {
        // Initialize with the required test values
        shares = 1000;
        name = "Pat";
        salary = 50000;
        idNumber = 112358132134;
    }

    function viewSalary() public view returns (uint32) {
        return salary;
    }

    function viewShares() public view returns (uint16) {
        return shares;
    }

    function grantShares(uint16 _newShares) public {
        // Check if _newShares itself is too large
        if (_newShares > 5000) {
            revert("Too many shares");
        }

        // Calculate total shares after grant
        uint16 totalShares = shares + _newShares;

        // Check if total would exceed 5000
        if (totalShares > 5000) {
            revert TooManyShares(totalShares);
        }

        shares = totalShares;
    }

    /**
    * Do not modify this function.  It is used to enable the unit test for this pin
    * to check whether or not you have configured your storage variables to make
    * use of packing.
    *
    * If you wish to cheat, simply modify this function to always return `0`
    * I'm not your boss ¯\_(ツ)_/¯
    *
    * Fair warning though, if you do cheat, it will be on the blockchain having been
    * deployed by your wallet....FOREVER!
    */
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload (_slot)
        }
    }

    /**
    * Warning: Anyone can use this function at any time!
    */
    function debugResetShares() public {
        shares = 1000;
    }
} 