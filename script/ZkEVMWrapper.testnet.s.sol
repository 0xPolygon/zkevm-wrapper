// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {ZkEVMWrapper} from "src/ZkEVMWrapper.sol";
import {IZkEVMBridge} from "src/IZkEVMBridge.sol";

contract ZkEVMWrapperDeploy is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy ZkEVMWrapper
        ZkEVMWrapper wrapper = new ZkEVMWrapper(IZkEVMBridge(0xF6BEEeBB578e214CA9E23B0e9683454Ff88Ed2A7));

        vm.stopBroadcast();
    }
}
