// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract UtilityToken is ERC20, Ownable {
    address creditTokenAddress;

    constructor() ERC20("UtilityToken", "UT") {}

    function setcreditTokenAddr(address _ct) public onlyOwner {
        creditTokenAddress = _ct;
    }

    function getBalance(address _ct) external view returns (uint256) {
        return ERC20(creditTokenAddress).balanceOf(_ct);
    }

    function issueToken(address receiver, uint256 amount) public onlyOwner {
        _mint(receiver, amount);
    }
}
