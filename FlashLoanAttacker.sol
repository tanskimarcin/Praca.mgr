// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFlashLoanProvider {
    function flashLoan(uint256 amount) external;
}

contract FlashLoanAttacker {
    IFlashLoanProvider public provider;

    event AttackExecuted(uint256 amount);

    constructor(address _provider) {
        provider = IFlashLoanProvider(_provider);
    }

    function attack(uint256 amount) public payable {
        require(amount > 0, "Amount must be greater than 0");
        require(msg.value >= amount, "Not enough ETH sent"); // Sprawdź, czy wysłano wystarczającą ilość ETH

        // Wykonaj flash loan
        provider.flashLoan(amount);
        
        // Emituj zdarzenie, aby potwierdzić, że atak został wykonany
        emit AttackExecuted(amount);
        
        // Możesz dodać logikę, aby wykorzystać pożyczone fundusze
    }
}
