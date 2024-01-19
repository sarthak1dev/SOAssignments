// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";
import "src/assignment2.sol";
import "lib/forge-std/test/Vm.t.sol";

contract assignment2Test is DSTest {
    voting public votingInstance;
    address account2 = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    address account3 = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;

    address account4 = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;

    address account5 = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;

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

    function testcheckVotingOnce() public {
        string memory string3 = "romy";

        votingInstance.register();
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
}

//trying to implement mock accounts and simulation but failed
