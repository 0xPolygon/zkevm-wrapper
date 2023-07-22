// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract SigUtils {
    bytes32 internal DOMAIN_SEPARATOR;
    bytes32 internal DAI_DOMAIN_SEPARATOR;

    constructor(bytes32 _DOMAIN_SEPARATOR, bytes32 _DAI_DOMAIN_SEPARATOR) {
        DOMAIN_SEPARATOR = _DOMAIN_SEPARATOR;
        DAI_DOMAIN_SEPARATOR = _DAI_DOMAIN_SEPARATOR;
    }

    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    bytes32 public constant DAI_PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;

    struct Permit {
        address owner;
        address spender;
        uint256 value;
        uint256 nonce;
        uint256 deadline;
    }

    struct DaiPermit {
        address holder;
        address spender;
        uint256 nonce;
        uint256 expiry;
        bool allowed;
    }

    // computes the hash of an EIP-2612 permit
    function getStructHash(Permit memory _permit) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(PERMIT_TYPEHASH, _permit.owner, _permit.spender, _permit.value, _permit.nonce, _permit.deadline)
        );
    }

    // computes the hash of a Dai permit
    function getDaiStructHash(DaiPermit memory _permit) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                DAI_PERMIT_TYPEHASH, _permit.holder, _permit.spender, _permit.nonce, _permit.expiry, _permit.allowed
            )
        );
    }

    // computes the hash of the fully encoded EIP-712 message for the domain, which can be used to recover the signer
    function getTypedDataHash(Permit memory _permit) public view returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, getStructHash(_permit)));
    }

    // computes the hash of the fully encoded EIP-712 message for the domain, which can be used to recover the signer
    function getDaiTypedDataHash(DaiPermit memory _permit) public view returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x01", DAI_DOMAIN_SEPARATOR, getDaiStructHash(_permit)));
    }
}
