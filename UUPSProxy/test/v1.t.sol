// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/UUPSTokenV1.sol";

contract UUPSTokenV1Test is Test {
    UUPSTokenV1 token;
    address user1 = address(0x1);
    address user2 = address(0x2);

    function setUp() public {
        token = new UUPSTokenV1();
        token.initialize();
    }

    function testInitialValues() public {
        assertEq(token.name(), "Upgradeable Token");
        assertEq(token.symbol(), "UPT");
        assertEq(token.decimals(), 18);
        assertEq(token.totalSupply(), 1_000_000 ether);
        assertEq(token.balanceOf(address(this)), 1_000_000 ether);
    }

    function testTransfer() public {
        token.transfer(user1, 100 ether);
        assertEq(token.balanceOf(user1), 100 ether);
        assertEq(token.balanceOf(address(this)), 1_000_000 ether - 100 ether);
    }

    function testApproveAndTransferFrom() public {
        token.approve(user1, 200 ether);
        vm.prank(user1);
        token.transferFrom(address(this), user2, 200 ether);

        assertEq(token.balanceOf(user2), 200 ether);
        assertEq(token.allowance(address(this), user1), 0);
        assertEq(token.balanceOf(address(this)), 1_000_000 ether - 200 ether);
    }

    function testOnlyOwnerCanAuthorizeUpgrade() public {
        vm.prank(user1);
        vm.expectRevert("Only owner can upgrade");
        token._authorizeUpgrade();
    }
}
