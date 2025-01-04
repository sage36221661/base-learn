// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Manager {
    uint256[] public employeeIds;

    function addReport(uint256 employeeId) public {
        employeeIds.push(employeeId);
    }

    function resetReports() public {
        delete employeeIds;
    }
} 