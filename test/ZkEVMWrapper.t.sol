// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {MockERC20} from "src/mocks/MockERC20.sol";
import {MockZkEVMBridge} from "src/mocks/MockZkEVMBridge.sol";
import {ZkEVMWrapper} from "src/ZkEVMWrapper.sol";
import {IZkEVMBridge} from "src/interfaces/IZkEVMBridge.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {IERC20Permit} from "openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol";
import {SigUtils} from "./SigUtils.t.sol";
import "forge-std/Test.sol";

contract ZkEVMWrapperTest is Test {
    MockERC20 public token;
    ZkEVMWrapper public wrapper;
    MockZkEVMBridge public bridge;
    SigUtils public sigUtils;

    function setUp() external {
        token = new MockERC20();
        sigUtils = new SigUtils(IERC20Permit(token).DOMAIN_SEPARATOR());
        bridge = new MockZkEVMBridge();
        wrapper = new ZkEVMWrapper(IZkEVMBridge(address(bridge)));
    }

    function testDeposit(address user, uint256 tokenAmount, uint256 etherAmount, address destination)
        external
        payable
    {
        vm.assume(user != address(0) && etherAmount != 0);
        vm.deal(user, etherAmount);
        token.mint(user, tokenAmount);
        vm.startPrank(user);
        token.approve(address(wrapper), tokenAmount);
        wrapper.deposit{value: etherAmount}(IERC20(token), tokenAmount, destination);
        assertEq(token.balanceOf(address(bridge)), tokenAmount);
        assertEq(address(bridge).balance, etherAmount);
    }

    function testDepositPermit(
        uint256 privKey,
        uint256 tokenAmount,
        uint256 etherAmount,
        address destination,
        uint256 deadline
    ) external payable {
        // privkey value must be lower than secp256k1 curve order
        vm.assume(
            privKey != 0 && privKey < 115792089237316195423570985008687907852837564279074904382605163141518161494337
        );
        address user = vm.addr(privKey);
        vm.assume(user != address(0) && deadline > 0 && etherAmount != 0);
        vm.deal(user, etherAmount);
        console.log(user.balance);
        token.mint(user, tokenAmount);
        vm.startPrank(user);
        SigUtils.Permit memory permit =
            SigUtils.Permit({owner: user, spender: address(wrapper), value: tokenAmount, nonce: 0, deadline: deadline});
        bytes32 digest = sigUtils.getTypedDataHash(permit);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privKey, digest);
        wrapper.deposit{value: etherAmount}(IERC20(token), tokenAmount, destination, deadline, v, r, s);
        assertEq(token.balanceOf(address(bridge)), tokenAmount);
        assertEq(address(bridge).balance, etherAmount);
    }
}
