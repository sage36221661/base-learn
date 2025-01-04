// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./Salaried.sol";
import "./Manager.sol";

contract EngineeringManager is Salaried, Manager {
    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _annualSalary
    ) Salaried(_idNumber, _managerId, _annualSalary) {
    }
} 