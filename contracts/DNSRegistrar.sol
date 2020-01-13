pragma solidity ^0.5.0;

import "@rsksmart/rns-registry/contracts/RNS.sol";
import "@rsksmart/dnssec-oracle/contracts/DNSSEC.sol";
import "./DNSClaimChecker.sol";

/**
 * @dev An RNS registrar that allows the owner of a DNS name to claim the
 *      corresponding name in RNS.
 */
contract DNSRegistrar {

    DNSSEC public oracle;
    RNS public rns;

    bytes4 constant private INTERFACE_META_ID = bytes4(keccak256("supportsInterface(bytes4)"));
    bytes4 constant private DNSSEC_CLAIM_ID = bytes4(
        keccak256("claim(bytes,bytes)") ^
        keccak256("proveAndClaim(bytes,bytes,bytes)") ^
        keccak256("oracle()")
    );

    event Claim(bytes32 indexed node, address indexed owner, bytes dnsname);

    constructor(DNSSEC _dnssec, RNS _rns) public {
        oracle = _dnssec;
        rns = _rns;
    }

    /**
     * @dev Claims a name by proving ownership of its DNS equivalent.
     * @param name The name to claim, in DNS wire format.
     * @param proof A DNS RRSet proving ownership of the name. Must be verified
     *        in the DNSSEC oracle before calling. This RRSET must contain a TXT
     *        record for '_rns.' + name, with the value 'a=0x...'. Ownership of
     *        the name will be transferred to the address specified in the TXT
     *        record.
     */
    function claim(bytes memory name, bytes memory proof) public {
        address addr;
        (addr,) = DNSClaimChecker.getOwnerAddress(oracle, name, proof);

        bytes32 labelHash;
        bytes32 rootNode;
        (labelHash, rootNode) = DNSClaimChecker.getLabels(name);

        rns.setSubnodeOwner(rootNode, labelHash, addr);
        emit Claim(keccak256(abi.encodePacked(rootNode, labelHash)), addr, name);
    }

    /**
     * @dev Submits proofs to the DNSSEC oracle, then claims a name using those proofs.
     * @param name The name to claim, in DNS wire format.
     * @param input The data to be passed to the Oracle's `submitProofs` function. The last
     *        proof must be the TXT record required by the registrar.
     * @param proof The proof record for the first element in input.
     */
    function proveAndClaim(bytes memory name, bytes memory input, bytes memory proof) public {
        proof = oracle.submitRRSets(input, proof);
        claim(name, proof);
    }

    function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
        return interfaceID == INTERFACE_META_ID ||
               interfaceID == DNSSEC_CLAIM_ID;
    }
}
