// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "forge-std/console.sol";

contract multiSignatureWallet {
    event submitTxn(uint index);
    event approved(address owner, uint index);
    event cancelled(address owner, uint index);
    //this array stores the owners addresses
    address[] public owners;
    //unlike the previous contracts, this has multiple owners,so to check if the msg.sender is
    //an owner, we need to create a mapping that will indicate that the sender is an owner.
    mapping(address => bool) isOwner;
    mapping(uint => mapping(address => bool)) public approval; //this will map the index of tx to multiple owners and their confirmations
    //thresold of approvers
    uint256 public thresold;
    //to take the data of the transaction and store it inside an array of transations, we need to
    //first define the structure of the transaction object
    struct transaction {
        address to; //reciever's address
        uint value; //amount
        bytes data;
        bool executed; //to keep trac of whether or not this transaction is executed
    }

    transaction[] transactions; //array to store the data in the form of structure

    modifier ownerOnly() {
        require(isOwner[msg.sender], "only owners can access this");
        _;
    }

    //when deploying this contract e have to specify owner rights to the contracts
    //also we need to give the thresold
    constructor(address[] memory _owners, uint256 _thresold) {
        require(_owners.length > 0, "owners are not enterd");
        require(
            _thresold > 1 && _thresold <= owners.length,
            "not correct input"
        );
        //to add owner at each index to our owners array
        for (uint i; i < _owners.length; i++) {
            address owner = _owners[i];
            require(!isOwner[owner], "owner already exists");
            isOwner[owner] = true; //add the owner
            owners.push(owner);
        }

        thresold = _thresold;
    }

    modifier txnExists(uint _index) {
        require(_index < transactions.length, "transaction does not exist");
        _;
    }
    modifier notApproved(uint _index) {
        require(!approval[_index][msg.sender], "txn approved");
        _;
    }

    modifier notExecuted(uint _index) {
        require(!transactions[_index].executed, "transaction executed");
        _;
    }

    function deposit() public payable {}

    function getBalance() internal view {
        address(this).balance;
    }

    function submitNewTxn(
        address _to,
        uint _value,
        bytes calldata _data
    ) public {
        transactions.push(
            transaction({to: _to, value: _value, data: _data, executed: false})
        );
        emit submitTxn(transactions.length - 1);
    }

    function approveTxn(
        uint _index
    )
        external
        ownerOnly
        txnExists(_index)
        notApproved(_index)
        notExecuted(_index)
    {
        approval[_index][msg.sender] = true;
        emit approved(msg.sender, _index);
        require(_getApprovalCount(_index) >= thresold, "not enough approvals");

        //actually make the transaction we need to make sure that the approvals are more that the thresold
        //we can do that by counting the number true given by the owners in the aproval mapping
        //this is done in another function to avoid code complexityand then called inside of approveTxn
    }

    function _getApprovalCount(uint _index) private view returns (uint count) {
        for (uint i; i < owners.length; i++) {
            if (approval[_index][owners[i]]) {
                count = count + 1;
                return count;
            }
        }
    }

    function transact(
        uint _index
    ) external txnExists(_index) notExecuted(_index) {
        transaction storage _transactions = transactions[_index];
        _transactions.executed = true;
        (bool success, ) = _transactions.to.call{value: _transactions.value}(
            _transactions.data
        );
        require(success, "txn failed");
        console.log("transaction succeded");
    }

    function Cancle(
        uint _index
    ) external ownerOnly txnExists(_index) notExecuted(_index) {
        require(approval[_index][msg.sender], "not approved by the sender");
        approval[_index][msg.sender] = false;
        emit cancelled(msg.sender, _index);
    }
}

