// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IDiamondCut.sol";
import "./libraries/LibDiamond.sol";

contract DiamondCutFacet is IDiamondCut {
    function diamondCut(
        FacetCut[] calldata _cut,
        address _init,
        bytes calldata _calldata
    ) external override {
        LibDiamond.diamondCut(_cut, _init, _calldata);
    }
}
