// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "src/assignment1.sol";
import "forge-std/Test.sol";

contract assignment1 is Script {
    samToken public samTokenInstance;

    function setUp() public {
        samTokenInstance = new samToken();
    }

    function run() public {
        vm.broadcast();
        testValidRaiseAmount();
        testTooLowRaiseAmount();
        testTooHighRaiseAmount();
    }

    function testValidRaiseAmount() public {
        uint256 amount = 15; // Within limits
        samTokenInstance.raise(amount);
    }

    function testTooLowRaiseAmount() public {
        vm.expectRevert();
        uint256 amount = 5; // Below minimum, test should fail
        samTokenInstance.raise(amount);
    }

    function testTooHighRaiseAmount() public {
        vm.expectRevert();
        uint256 amount = 25; // Above maximum test should fail
        samTokenInstance.raise(amount);
    }
}
