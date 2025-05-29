// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract UUPSTokenV2 is Initializable {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    // New V2 state variables
    mapping(address => bool) public isMinter;
    uint256 public maxSupply;
    
    // UUPS implementation slot
    address private _implementation;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address indexed minter, address indexed to, uint256 value);
    
    // Initializer for V2 - must be separate from V1's
    function initializeV2() public reinitializer(2) {
        maxSupply = 2000000 * 10**18; // New feature in V2
    }
    
    // All previous functions from V1...
    function transfer(address to, uint256 value) external returns (bool) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }
    
    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        require(balanceOf[from] >= value, "Insufficient balance");
        require(allowance[from][msg.sender] >= value, "Not approved");
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }
    
    // New V2 functions
    function addMinter(address minter) external {
        require(msg.sender == owner, "Only owner");
        isMinter[minter] = true;
    }
    
    function mint(address to, uint256 value) external {
        require(isMinter[msg.sender], "Not minter");
        require(totalSupply + value <= maxSupply, "Exceeds max supply");
        _mint(to, value);
        emit Mint(msg.sender, to, value);
    }
    
    function _mint(address to, uint256 value) internal {
        balanceOf[to] += value;
        totalSupply += value;
        emit Transfer(address(0), to, value);
    }
    
    // UUPS upgrade authorization function
    function _authorizeUpgrade() internal virtual {
        require(msg.sender == owner, "Only owner can upgrade");
    }
}