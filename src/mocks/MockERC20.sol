// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20, ERC20Permit} from "openzeppelin-contracts/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

contract MockERC20 is ERC20Permit {
    constructor() ERC20("TEST", "TEST") ERC20Permit("TEST") {
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
