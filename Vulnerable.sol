// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Vulnerable {
    mapping(address => uint256) public balances;

    // Użytkownik może zdeponować środki
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Użytkownik może wypłacić środki, podatny na reentrancy
    function withdraw() public {
        uint256 bal = balances[msg.sender];
        require(bal > 0, "Insufficient balance");

        // Wysyłanie środków przed aktualizacją stanu
        (bool success, ) = msg.sender.call{value: bal}("");
        require(success, "Transfer failed");

        // Aktualizacja salda po wysłaniu środków (podatność)
        balances[msg.sender] = 0;
    }

    // Funkcja zwracająca saldo kontraktu
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
