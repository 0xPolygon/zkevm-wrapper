// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {IERC20Permit} from "openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol";
import {SafeERC20} from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {IZkEVMBridge} from "./IZkEVMBridge.sol";

contract ZkEVMWrapper {
    using SafeERC20 for IERC20;
    using SafeERC20 for IERC20Permit;

    IZkEVMBridge private immutable _zkEVMBridge;

    constructor(IZkEVMBridge zkEVMBridge_) {
        _zkEVMBridge = zkEVMBridge_;
    }

    function deposit(IERC20 token, uint256 amount, address destination) external payable {
        require(msg.value != 0, "ZkEVMWrapper: no ETH sent");
        token.safeTransferFrom(msg.sender, address(this), amount);
        token.forceApprove(address(_zkEVMBridge), amount);
        _zkEVMBridge.bridgeAsset(
            1, // destinationNetwork
            destination,
            amount,
            address(token),
            false, // forceUpdateGlobalExitRoot
            "" // permitData
        );
        _zkEVMBridge.bridgeAsset{value: msg.value}(
            1, // destinationNetwork
            destination,
            msg.value,
            address(0),
            true, // forceUpdateGlobalExitRoot
            "" // permitData
        );
    }

    function deposit(IERC20 token, uint256 amount, address destination, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
        external
        payable
    {
        require(msg.value != 0, "ZkEVMWrapper: no ETH sent");
        IERC20Permit(address(token)).safePermit(msg.sender, address(this), amount, deadline, v, r, s);
        token.safeTransferFrom(msg.sender, address(this), amount);
        token.forceApprove(address(_zkEVMBridge), amount);
        _zkEVMBridge.bridgeAsset(
            1, // destinationNetwork
            destination,
            amount,
            address(token),
            false, // forceUpdateGlobalExitRoot
            "" // permitData
        );
        _zkEVMBridge.bridgeAsset{value: msg.value}(
            1, // destinationNetwork
            destination,
            msg.value,
            address(0),
            true, // forceUpdateGlobalExitRoot
            "" // permitData
        );
    }
}
