// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IERC20Metadata} from "openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {SafeERC20} from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

contract MockZkEVMBridge {
    using SafeERC20 for IERC20Metadata;

    uint32 public depositCount;

    event BridgeEvent(
        uint256 leafType,
        uint256 originNetwork,
        address originTokenAddress,
        uint256 destinationNetwork,
        address destinationAddress,
        uint256 leafAmount,
        bytes metadata,
        uint32 depositCount
    );

    function bridgeAsset(
        uint32 destinationNetwork,
        address destinationAddress,
        uint256 amount,
        IERC20Metadata token,
        bool, /* forceUpdateGlobalExitRoot*/
        bytes calldata /* permitData */
    ) public payable {
        address originTokenAddress;
        uint32 originNetwork;
        bytes memory metadata;
        uint256 leafAmount = amount;

        if (address(token) == address(0)) {
            // Ether transfer
            if (msg.value != amount) {
                revert();
            }

            // Ether is treated as ether from mainnet
            originNetwork = 0;
        } else {
            // Check msg.value is 0 if tokens are bridged
            if (msg.value != 0) {
                revert();
            } else {
                uint256 balanceBefore = IERC20Metadata(token).balanceOf(address(this));
                IERC20Metadata(token).safeTransferFrom(msg.sender, address(this), amount);
                uint256 balanceAfter = IERC20Metadata(token).balanceOf(address(this));

                // Override leafAmount with the received amount
                leafAmount = balanceAfter - balanceBefore;

                originTokenAddress = address(token);
                originNetwork = 0;

                // Encode metadata
                metadata = abi.encode(token.name(), token.symbol(), token.decimals());
            }
        }

        emit BridgeEvent(
            0,
            originNetwork,
            originTokenAddress,
            destinationNetwork,
            destinationAddress,
            leafAmount,
            metadata,
            uint32(depositCount++)
        );
    }
}
