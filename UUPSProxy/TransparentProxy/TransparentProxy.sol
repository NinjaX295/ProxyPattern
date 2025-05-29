// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TransparentProxy {
    // Storage slot for the admin (as per EIP-1967)
    bytes32 private constant ADMIN_SLOT = bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1);
    // Storage slot for the logic/implementation contract
    bytes32 private constant IMPLEMENTATION_SLOT = bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);

    constructor(address _logic, address _admin, bytes memory _data) {
        require(_logic != address(0) && _admin != address(0), "Invalid address");

        assembly {
            sstore(IMPLEMENTATION_SLOT, _logic)
            sstore(ADMIN_SLOT, _admin)
        }

        if (_data.length > 0) {
            (bool success, ) = _logic.delegatecall(_data);
            require(success, "Initialization failed");
        }
    }

    modifier onlyAdmin() {
        require(msg.sender == _admin(), "Not proxy admin");
        _;
    }

    function _admin() internal view returns (address adm) {
        assembly {
            adm := sload(ADMIN_SLOT)
        }
    }

    function _implementation() internal view returns (address impl) {
        assembly {
            impl := sload(IMPLEMENTATION_SLOT)
        }
    }

    function admin() external onlyAdmin returns (address) {
        return _admin();
    }

    function implementation() external onlyAdmin returns (address) {
        return _implementation();
    }

    function upgradeTo(address newImplementation) external onlyAdmin {
        require(newImplementation != address(0), "Invalid implementation");
        assembly {
            sstore(IMPLEMENTATION_SLOT, newImplementation)
        }
    }

    fallback() external payable {
        address impl = _implementation();
        require(impl != address(0), "Implementation not set");

        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    receive() external payable {
        fallback();
    }
}
