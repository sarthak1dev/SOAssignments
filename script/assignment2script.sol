// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "src/assignment2.sol";
import "forge-std/Test.sol";

contract assignment1 is Script {
    voting public votingInstance;

    address owner;

    address account2 = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    address account3 = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;

    address account4 = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;

    address account5 = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;

    address account6 = 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB;

    address account7 = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C;

    //initializing dummy voters for real life simulation
    function setUp() public {
        string memory string1 = "sam";
        string memory string2 = "tommy";
        string memory string3 = "romy";

        votingInstance = new voting();
        votingInstance.startVoting();
        votingInstance.addCandidate(string1);
        votingInstance.addCandidate(string2);
        votingInstance.addCandidate(string3);
    }

    function run() public {
        owner = msg.sender;
        vm.broadcast();
        testcheckVotingOnce();
        testcheckVotingTwice();
    }

    function testcheckVotingOnce() public {
        string memory string3 = "romy";

        votingInstance.register();
        vm.prank(account2);
        assert((votingInstance.vote(string3)));
        //this test will work, as a voter can vote once
    }

    function testcheckVotingTwice() public {
        string memory string1 = "sam";
        string memory string2 = "tommy";

        votingInstance.register();
        votingInstance.vote(string1);
        assert((votingInstance.vote(string2)));
        //this test should fail as a voter cant vote more than one
    }

    //write a function so that owener can add candidates,
    // different voters can vote different candidates and
    //then we verify the result
    //write 2-3 such tests
    //show case that even if one user makes the function revert,other voters can continue
    //make chages to the code, so that i can get result of an indivisiual candidate too
    function realVotingSimulation() public {
        string memory string1 = "sam";
        string memory string2 = "tommy";
        string memory string3 = "romy";

        votingInstance.startVoting();
        vm.startPrank(msg.sender);
        vm.prank(account2);
        votingInstance.register();
        votingInstance.vote(string1);

        vm.prank(account3);
        votingInstance.register();
        votingInstance.vote(string1);

        vm.prank(account4);
        votingInstance.register();
        votingInstance.vote(string1);

        vm.prank(account5);
        votingInstance.register();
        votingInstance.vote(string2);

        vm.prank(account6);
        votingInstance.register();
        votingInstance.vote(string3);

        vm.prank(account7);
        votingInstance.register();
        votingInstance.vote(string2);

        assert(votingInstance.getSpecificResult(string1) == 3);
        assert(votingInstance.getSpecificResult(string2) == 2);
        assert(votingInstance.getSpecificResult(string3) == 1);
    }
}
