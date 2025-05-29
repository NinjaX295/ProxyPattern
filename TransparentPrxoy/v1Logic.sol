// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LogicV1 {
    uint256 public value;
    address implementationAddress;


    function setValue(uint256 _val) public {
        value = _val;
    }

    function getValue() public view returns (uint256) {
        return value;
    }
    function updateAddress(address updatedAddress)external onlyowner{
        
   implementationAddress=updatedAddress;
  
    }
    function ViewImplementationAddress()public pure view{
        return implementationAddress;
    }
    
}