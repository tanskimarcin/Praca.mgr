// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RugPullExample {
    mapping(address => uint256) public balances;
    address public owner;

    constructor() {
        owner = msg.sender; // Ustalamy właściciela
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value; // Zbieranie funduszy
    }

    function withdrawAll() public {
        require(msg.sender == owner, "Only owner can withdraw"); // Brak kontroli dostępu
        payable(owner).transfer(address(this).balance); // Właściciel może wycofać wszystkie fundusze
    }

    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }
}

