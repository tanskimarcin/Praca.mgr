// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract SafeMathTest {
    uint8 public counter;
    function increment() public {
        counter += 1; // Rzuci wyjątek, jeśli wynik przekracza 255
    }

    function decrement() public {
        counter -= 1; // Rzuci wyjątek, jeśli wynik będzie poniżej 0
    }
}
