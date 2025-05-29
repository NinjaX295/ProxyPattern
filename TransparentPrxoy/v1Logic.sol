// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LogicV1 {
    uint256 public value;

    function setValue(uint256 _val) public {
        value = _val;
    }

    function getValue() public view returns (uint256) {
        return value;
    }
}