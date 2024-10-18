// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

contract VulnerableBank {
    mapping(address => uint8) public balances;

    // Użytkownik wpłaca środki
    function deposit(uint8 amount) public {
        balances[msg.sender] += amount;  // Możliwy overflow tutaj
    }

    // Użytkownik wypłaca środki
    function withdraw(uint8 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient funds");
        balances[msg.sender] -= amount;  // Możliwy underflow tutaj
    }

    // Funkcja do zasilenia kontraktu etherem
    receive() external payable {}
}
