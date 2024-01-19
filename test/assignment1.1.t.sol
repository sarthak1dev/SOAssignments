// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/console.sol";
import "ds-test/test.sol";
import "src/assignment1.sol";

contract assignment1Test is DSTest {
    samToken public samTokenInstance;
    uint256 public currentRaise;

    function setUp() public {
        samTokenInstance = new samToken();
    }

    function testPublicSale() public {
        //cap for presale raise is 1000, so we need to see if th contract switches to public sale on the 1001th transaction

        uint256 amount = 20;
        samTokenInstance.raise(amount);
        samTokenInstance.raise(amount);
        samTokenInstance.raise(amount);
        samTokenInstance.raise(amount);
        samTokenInstance.raise(amount);
        samTokenInstance.raise(amount);
        samTokenInstance.raise(amount);
        samTokenInstance.raise(amount);
        samTokenInstance.raise(amount);
        samTokenInstance.raise(amount);
        samTokenInstance.raise(amount);
        assert(samTokenInstance.raise(21)); //when the code reaches publicSale part of the code, the function switches and starts returning true,hence we can verify presale ends after a max cap
    }

    function testCurrentRaise() public {
        uint amount = 15;
        samTokenInstance.raise(amount); //15
        samTokenInstance.raise(amount); //30
        samTokenInstance.raise(amount); //45
        samTokenInstance.raise(amount); //60
    }
}
