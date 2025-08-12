// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; //may not work as i have put lib into gitignore//if this location doesnt work use    import "@openzeppelin/contracts/token/ERC20/ERC20.sol";   //erc20 is used for native eth to token interactions
import "forge-std/console.sol";

//this step ensures that the eth the user sends is within the limit of 5 and 1000.
contract samToken is ERC20 {
    uint256 currentRaise;
    uint256 public maxTotalRaise = 400; //ether,the cap is lowers for the ease of testing,it can be raised s per the need
    uint256 public maxPresaleRaise = 200; //ether
    address public owner;
    //this is initialized with false, whenever the public sale has started
    //this  will be set to true to know if public sale has started.if
    //public sale has not ended people can claim refund
    mapping(address => uint256) public ethBal;
    event area(string);

    constructor() ERC20("samToken", "SMT") {
        owner = msg.sender;
    }

    function raise(
        uint256 amount
    ) public payable returns (bool publicSaleStart) {
        require(amount > 10, "you need to send greater than 10"); //test this
        require(amount < 22, "you need to send lesser than 22"); //for the ease of testing, i have kept the upper limit to 21
        if (currentRaise < maxPresaleRaise) {
            currentRaise = currentRaise + amount;
            ethBal[msg.sender] += amount; //map user to the eth they contributed,so that they can be refunded when needed
            _mint(msg.sender, 1);
            emit area("traded_in_presale"); //users can see in which sale thry got the tokens.
            console.log(currentRaise);
            console.log(address(this));
        } else if (currentRaise < maxTotalRaise) {
            //test presale end and public sale begin
            currentRaise = currentRaise + amount;
            _mint(msg.sender, 1);
            ethBal[msg.sender] += amount; //map user to the eth they contributed,so that they can be refunded when needed
            emit area("traded_in_publicsale"); //users can see in which sale thry got the tokens.
            console.log(currentRaise);
            return (publicSaleStart = true);
        }
    }

    function refund() public payable {
        if (
            currentRaise < maxPresaleRaise && currentRaise < maxTotalRaise //if the rounds are not finishedthen refund
        ) {
            uint256 refundAmount = ethBal[msg.sender];
            payable(msg.sender).transfer(refundAmount);
            address smc = address(this);
            approve(smc, 100);
            payable(msg.sender).transfer(refundAmount);
            currentRaise = (currentRaise - 100);
            ethBal[msg.sender] -= 100; //reduces their eth raised bal in our records
        } else {
            revert("cannot refund");
        }
    }

    function getBalance() public view returns (uint) {
        return balanceOf(msg.sender);
    }
}
