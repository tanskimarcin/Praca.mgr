// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vulnerable {
    mapping(address => uint256) public balances;

    // Użytkownik może zdeponować środki
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Użytkownik może wypłacić środki, ale jest podatny na atak reentrancy
    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // Przekazanie środków przed zaktualizowaniem salda (podatność)
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");

        balances[msg.sender] -= _amount;
    }

    // Funkcja zwracająca saldo kontraktu
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
