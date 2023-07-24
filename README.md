# ZkEVM Wrapper [![test](https://github.com/0xPolygon/zkevm-wrapper/actions/workflows/test.yml/badge.svg)](https://github.com/0xPolygon/zkevm-wrapper/actions/workflows/test.yml)
This repository contains the ZkEVM wrapper contracts that allows any user (including smart contracts) to transfer ETH and
ERC20 tokens to ZkEVM in a single transaction.

## Features
* Transfer ETH and ERC20 tokens to ZkEVM using traditional ERC-20 approval flow
* Transfer ETH and ERC20 tokens to ZkEVM using EIP-2612 permit signatures
* Transfer ETH and ERC20 tokens to ZkEVM using DAI-style permit signatures
> ⚠️ **_NOTE:_**  The wrapper does not support fee-on-transfer tokens and will automatically revert if the token has a transfer fee.

## Usage
* Make an approval tx to the wrapper contract with the amount of tokens you want to transfer to ZkEVM
*or*
* Sign a EIP-2612 permit signature with the amount of tokens and appropriate deadline you want to transfer to ZkEVM
*or*
* Sign a Dai-style permit signature with the amount of tokens and appropriate expiry and nonce you want to transfer to ZkEVM

Then,
* Call the appropriate `deposit()` function on the wrapper contract with the ether, amount of ERC-20 tokens (and signature, if any) that you want to transfer to ZkEVM

## Deployment addresses
| Network | Address | Etherscan link |
| ------- | ------- | -------------- |
| Ethereum mainnet | `0x047E0b64743071b897A6177F1796E98b4C3f344E` | https://etherscan.io/address/0x047e0b64743071b897a6177f1796e98b4c3f344e |
| Testnet (Goerli) | `0xDb5328c50B166545d1e830BB509944d4B98CBb23` | https://goerli.etherscan.io/address/0xDb5328c50B166545d1e830BB509944d4B98CBb23 |

## Development
This repository makes use of [Foundry](https://github.com/foundry-rs/foundry) for compilation and dependency management. You can find the installation instructions [here](https://book.getfoundry.sh/getting-started/installation).

To build the project, run:
```bash
forge build
```
To run the tests, run:
```bash
forge test
```
## Licensing
All source code is released under the MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT).

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in the work by you, as defined in the MIT license, shall be licensed as above, without any additional terms or conditions.
