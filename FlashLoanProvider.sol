// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FlashLoanProvider {
    event LoanTaken(address borrower, uint256 amount);
    
    // Mapping do przechowywania pożyczek
    mapping(address => uint256) public loans;

    // Konstruktor oznaczony jako payable
    constructor() payable {}

    // Funkcja symulująca pożyczkę flash
    function flashLoan(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(address(this).balance >= amount, "Not enough funds in the contract");

        // Emituj zdarzenie, że pożyczka została wzięta
        emit LoanTaken(msg.sender, amount);
        
        // Przechowuj kwotę pożyczki w mappingu
        loans[msg.sender] += amount;

        // Rzeczywisty transfer środków do pożyczkobiorcy
        payable(msg.sender).transfer(amount);
    }

    // Funkcja do sprawdzania, ile pieniędzy zostało pożyczonych przez adres
    function getLoanAmount(address borrower) public view returns (uint256) {
        return loans[borrower];
    }

    // Wymagana funkcja do otrzymywania Etheru
    receive() external payable {}

    // Funkcja do sprawdzania salda kontraktu
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
