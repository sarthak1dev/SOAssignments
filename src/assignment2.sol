// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "forge-std/console.sol";

//note to the reader,after the contract is deployed, even tho proprer errors are mentioned,in the vote function, the "revert
// 	The transaction has been reverted to the initial state.
// Note: The called function should be payable if you send value and the value you send should be less than your current balance.
// Debug the transaction to get more information." error shows up, i do not know what to do with it, would love to talk to the devs at supraoracles.
contract voting {
    mapping(string => uint) public candidates; //to maintain the key value pair of candidates and their votes
    mapping(address => uint) public voters; //list to verify if the person is registered with the help of array
    string[] public candidateNames; //to simultanously maintain names of candidates with the same index as in the mapping, to help in getResult();
    address owner;
    bool isVotingStarted = false;
    event getVotes(string name, uint votes); //logs the candidates and the their current vote count

    constructor() {
        candidates;
        voters;
        owner = msg.sender; //only the caller of the contract is the owner
    }

    //this modifier checks if you have voted or not, every address in default has
    modifier notVoted() {
        require(voters[msg.sender] == 0, "you have not registered");
        _;
    }
    modifier isRegistered() {
        //registration adds addresses to the array and give a value of 1, this modifier checks if address has 1
        require(voters[msg.sender] == 1);
        _;
    }
    //when a person votes, the count is set to 2,this modifier reverts addresses who already voted
    modifier hasVoted() {
        if (voters[msg.sender] == 2) {
            revert("you already voted");
        }
        _;
    }
    // modifier isRegistered (){
    //     require(msg.sender == owner,"only owners can add candidates");
    //     _;
    // }
    modifier isOwner() {
        require(msg.sender == owner, "only owner can access this");
        _;
    }

    function startVoting() public isOwner {
        isVotingStarted = true;
    }

    function stopVoting() public isOwner {
        isVotingStarted = false;
    }

    function register() public notVoted {
        voters[msg.sender] = 1;
    }

    function addCandidate(string memory _name) public isOwner {
        candidates[_name] = 2;
        candidateNames.push(_name);
    }

    function vote(
        string memory _name
    ) public isRegistered hasVoted returns (bool) {
        if (isVotingStarted == false) {
            revert("voting not started");
        }
        if (candidates[_name] == 0) {
            revert("candidate does not exist");
        }

        candidates[_name] += 1; //check if candidate exists?
        voters[msg.sender] = 2;
        console.log("thank you for voting");
        return true;
    }

    //result can be called by any address and proper data is emitted>
    function getCurrentStatus() public {
        for (uint i = 0; i < candidateNames.length; i++) {
            string memory name = candidateNames[i];
            uint voteNum = candidates[name];
            emit getVotes(name, voteNum);
        }
    }

    function getSpecificResult(
        string calldata name
    ) public view returns (uint256) {
        uint256 indvResult = candidates[name];
        return indvResult;
    }
}
