// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/UUPSTokenV2.sol";

contract UUPSTokenV2Test is Test {
    UUPSTokenV2 token;
    address user1 = address(0x1);
    address user2 = address(0x2);

    function setUp() public {
        token = new UUPSTokenV2();
        
        // V1 initialization manually done to simulate upgrade
        token.initialize(); // From V1 (assume inherited or same structure)
        
        // Now initialize V2
        token.initializeV2();
    }

    function testInitializeV2SetsMaxSupply() public {
        assertEq(token.maxSupply(), 2_000_000 ether);
    }

    function testOnlyOwnerCanAddMinter() public {
        vm.prank(user1);
        vm.expectRevert("Only owner");
        token.addMinter(user2);

        token.addMinter(user1);
        assertTrue(token.isMinter(user1));
    }

    function testMintingByMinter() public {
        token.addMinter(user1);

        vm.prank(user1);
        token.mint(user2, 1000 ether);

        assertEq(token.balanceOf(user2), 1000 ether);
        assertEq(token.totalSupply(), 1_000_000 ether + 1000 ether); // since V1 minted 1M
    }

    function testMintFailsIfNotMinter() public {
        vm.prank(user1);
        vm.expectRevert("Not minter");
        token.mint(user2, 1000 ether);
    }

    function testMintFailsIfExceedsMaxSupply() public {
        token.addMinter(user1);
        vm.prank(user1);
        token.mint(user2, 1_000_001 ether); // Already 1M in totalSupply from V1
        vm.prank(user1);
        vm.expectRevert("Exceeds max supply");
        token.mint(user2, 1_000_001 ether); // Triggers failure
    }
}
