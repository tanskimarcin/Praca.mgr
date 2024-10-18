// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

contract UnderflowTest {
    mapping(address => uint8) public balances;

    // Użytkownik wpłaca środki (imitujemy liczby uint8)
    function deposit(uint8 amount) public {
        balances[msg.sender] += amount;
    }

    // Użytkownik wypłaca środki
    function withdraw(uint8 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;  // Możliwy underflow tutaj
    }

    // Funkcja do zasilenia kontraktu etherem
    receive() external payable {}
}
