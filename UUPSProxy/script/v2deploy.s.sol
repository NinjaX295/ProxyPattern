// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/UUPSTokenV2.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol";

interface IUpgradeable is IERC1967Upgrade {
    function _authorizeUpgrade(address newImplementation) external;
    function upgradeTo(address newImplementation) external;
    function initializeV2() external;
}

contract UpgradeToV2 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy new V2 implementation
        UUPSTokenV2 newImpl = new UUPSTokenV2();

        // Reference existing proxy (update this address)
        address proxyAddress = vm.envAddress("PROXY_ADDRESS");

        // Upgrade through the proxy
        IUpgradeable(proxyAddress).upgradeTo(address(newImpl));

        // Run V2 initializer
        IUpgradeable(proxyAddress).initializeV2();

        console.log("Upgraded proxy to V2 at:", proxyAddress);
        console.log("New V2 implementation:", address(newImpl));

        vm.stopBroadcast();
    }
}
