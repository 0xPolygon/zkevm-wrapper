// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {ZkEVMWrapper} from "src/ZkEVMWrapper.sol";
import {IZkEVMBridge} from "src/interfaces/IZkEVMBridge.sol";

contract ZkEVMWrapperDeploy is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy ZkEVMWrapper
        ZkEVMWrapper wrapper = new ZkEVMWrapper(IZkEVMBridge(0x2a3DD3EB832aF982ec71669E178424b10Dca2EDe));

        vm.stopBroadcast();
    }
}
