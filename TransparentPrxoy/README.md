# 🛡 Transparent Proxy Pattern (EIP-1967 Based)

This repository implements the **Transparent Proxy Pattern**, a widely-used method for creating upgradeable smart contracts. It separates contract logic from storage and allows controlled upgrades by an admin.

---

## 📚 Overview

The Transparent Proxy Pattern uses:

- A **proxy contract** that stores all the state
- One or more **logic (implementation) contracts** that contain the business logic
- An **admin address** that has exclusive rights to upgrade the logic contract

It follows [EIP-1967](https://eips.ethereum.org/EIPS/eip-1967) for defining storage slots to avoid collisions with implementation logic.

---

## ⚙ How It Works

When you interact with the **proxy contract**, it **delegates** your call to the current **implementation contract** using `delegatecall`.

However, if you're the **admin**, and you try to interact with business functions through the proxy, you’ll be blocked — admins can only access upgrade-related functions.

---

### 🔁 Workflow Diagram

