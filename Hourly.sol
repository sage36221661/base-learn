// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./Employee.sol";

contract Hourly is Employee {
    uint256 public hourlyRate;

    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _hourlyRate
    ) Employee(_idNumber, _managerId) {
        hourlyRate = _hourlyRate;
    }

    function getAnnualCost() public view override returns (uint256) {
        // 2080 hours = 40 hours per week * 52 weeks
        return hourlyRate * 2080;
    }
} 