// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Token", "TKN") {
        _mint(msg.sender, initialSupply);
    }

    // Local implementation for increaseAllowance
    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public returns (bool) {
        _approve(
            _msgSender(),
            spender,
            allowance(_msgSender(), spender) + addedValue
        );
        return true;
    }

    // Local implementation for decreaseAllowance
    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public returns (bool) {
        uint256 currentAllowance = allowance(_msgSender(), spender);
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }
        return true;
    }
}
