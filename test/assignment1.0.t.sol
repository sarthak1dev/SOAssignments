// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";
import "src/assignment1.sol";

contract assignment1Test is DSTest {
    samToken public samTokenInstance;

    function setUp() public {
        samTokenInstance = new samToken();
    }

    function testValidRaiseAmount() public {
        uint256 amount = 15; // Within limits
        samTokenInstance.raise(amount);
    }

    function testTooLowRaiseAmount() public {
        uint256 amount = 5; // Below minimum, test should fail
        samTokenInstance.raise(amount);
    }

    function testTooHighRaiseAmount() public {
        uint256 amount = 25; // Above maximum test should fail
        samTokenInstance.raise(amount);
    }
}
