// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CreditToken is ERC20Capped, Ownable {
    constructor(uint256 cap) ERC20("CreditToken", "CT") ERC20Capped(cap) {}

    function issueToken(address receiver, uint256 amount) public onlyOwner {
        _mint(receiver, amount);
    }
}
