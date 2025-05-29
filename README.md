# UUPS vs Transparent Proxy Pattern in Solidity

## What is a Proxy Pattern?

The **proxy pattern** allows you to deploy upgradeable smart contracts by separating contract logic from contract storage and address. Instead of replacing deployed contracts, you point a proxy to a new logic contract.

---

## UUPS Proxy Pattern (Universal Upgradeable Proxy Standard)

### Key Components

- **Proxy contract**: Delegates all calls to a logic (implementation) contract via `delegatecall`.
- **Logic contract**: Contains actual implementation.
- **Upgrade logic is inside the implementation**.

### Structure

- Uses `ERC1967Proxy` (from OpenZeppelin).
- Logic contract includes `_authorizeUpgrade()` (for access control).
- Only the **implementation** contract knows how to upgrade itself via `upgradeTo()`.

### Example

```solidity
function upgradeTo(address newImplementation) external override onlyOwner {
    _upgradeTo(newImplementation);
}
