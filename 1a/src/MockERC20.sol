// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IMockERC20} from "./IMockERC20.sol";

// Add as many variables or functions as you would like
// for the implementation. The goal is to pass `forge test`.
contract MockERC20 is ERC20, IMockERC20 {
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}

    // Implement
    function freeMintTo(uint256 amount, address to) external {
        require(amount > 0 && to != address(0), "both amount and to can not be zero");
        require(to != msg.sender, "to can not equal to sender");

        _mint(to, amount);
    }

    // Implement
    function freeMintToSender(uint256 amount) external {
        require(amount > 0, "amount can not be less than zero");

        _mint(msg.sender, amount);
    }
}
