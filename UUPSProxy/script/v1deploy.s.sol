// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/UUPSTokenV1.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployV1 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy logic contract
        UUPSTokenV1 logic = new UUPSTokenV1();

        // Encode initialize() call
        bytes memory data = abi.encodeWithSignature("initialize()");

        // Deploy proxy with logic and initializer
        ERC1967Proxy proxy = new ERC1967Proxy(address(logic), data);

        console.log("Logic (V1) deployed at:", address(logic));
        console.log("Proxy deployed at:", address(proxy));

        vm.stopBroadcast();
    }
}
