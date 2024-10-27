//SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract CounterContract {
    address owner;

    struct Counter {
        uint number;
        string description;
    }

    Counter counter;

    modifier onlyOnwner() {
        require(msg.sender == owner, "Only the Owner can");
        _;
    }

    constructor(uint initial_value, string memory description) {
        owner = msg.sender;
        counter = Counter(initial_value, description);
    }

    function incremenet_counter() external onlyOnwner {
        counter.number += 1;
    }

    function decrement_number() external onlyOnwner {
        counter.number -= 1;
    }

    function get_counter() external view returns (uint) {
        return counter.number;
    }

    function get_description() external view returns (string memory) {
        return counter.description;
    }
}
