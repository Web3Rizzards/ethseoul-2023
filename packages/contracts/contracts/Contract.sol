// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.12;

// import erc721
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import { ByteHasher } from "./helpers/ByteHasher.sol";
import { IWorldID } from "./interfaces/IWorldID.sol";

contract Contract is ERC721 {
    using ByteHasher for bytes;

    /// @notice Thrown when attempting to reuse a nullifier
    error InvalidNullifier();

    /// @dev The World ID instance that will be used for verifying proofs
    IWorldID internal immutable worldId;

    /// @dev The contract's external nullifier hash
    uint256 internal immutable externalNullifier;

    /// @dev The World ID group ID (always 1)
    uint256 internal immutable groupId = 1;

    /// @dev Whether a nullifier hash has been used already. Used to guarantee an action is only performed once by a single person
    mapping(uint256 => bool) internal nullifierHashes;

    uint256 currentId = 1;

    mapping(uint256 => string) internal tokenIdToUri;
    mapping(address => uint256) internal addressToTokenId;

    event Minted(address indexed to, uint256 indexed tokenId, string ipfsHash);

    /// @param _worldId The WorldID instance that will verify the proofs
    /// @param _appId The World ID app ID
    /// @param _actionId The World ID action ID
    constructor(IWorldID _worldId, string memory _appId, string memory _actionId) ERC721("Contract", "CONTRACT") {
        worldId = _worldId;
        externalNullifier = abi.encodePacked(abi.encodePacked(_appId).hashToField(), _actionId).hashToField();
    }

    /// @param signal An arbitrary input from the user, usually the user's wallet address (check README for further details)
    /// @param root The root of the Merkle tree (returned by the JS widget).
    /// @param nullifierHash The nullifier hash for this proof, preventing double signaling (returned by the JS widget).
    /// @param proof The zero-knowledge proof that demonstrates the claimer is registered with World ID (returned by the JS widget).
    /// @param cid The IPFS hash of the content to be minted
    /// @dev Feel free to rename this method however you want! We've used `claim`, `verify` or `execute` in the past.
    function mint(
        address signal,
        uint256 root,
        uint256 nullifierHash,
        uint256[8] calldata proof,
        string memory cid
    ) public {
        // First, we make sure this person hasn't done this before
        if (nullifierHashes[nullifierHash]) revert InvalidNullifier();

        // We now verify the provided proof is valid and the user is verified by World ID
        worldId.verifyProof(
            root,
            groupId,
            abi.encodePacked(signal).hashToField(),
            nullifierHash,
            externalNullifier,
            proof
        );

        // We now record the user has done this, so they can't do it again (proof of uniqueness)
        nullifierHashes[nullifierHash] = true;

        // Finally, execute your logic here, for example issue a token, NFT, etc...
        // Make sure to emit some kind of event afterwards!

        _mint(msg.sender, currentId);
        addressToTokenId[msg.sender] = currentId;
        tokenIdToUri[currentId] = cid;
        currentId++;

        emit Minted(msg.sender, currentId, cid);
    }

    /// @notice Mint a NFT without WORLD ID Verification
    /// @param cid The IPFS hash of the content to be minted
    /// @dev Feel free to rename this method however you want! We've used `claim`, `verify` or `execute` in the past.
    function devMint(string memory cid) public {
        _mint(msg.sender, currentId);
        addressToTokenId[msg.sender] = currentId;
        tokenIdToUri[currentId] = cid;
        currentId++;

        emit Minted(msg.sender, currentId, cid);
    }

    /**
     * @notice Update token CID
     * @param tokenId token id
     * @param cid cid of the token
     */
    function setTokenURI(uint256 tokenId, string memory cid) public {
        _requireMinted(tokenId);
        // require user to be owner
        require(ownerOf(tokenId) == msg.sender, "Not owner");
        tokenIdToUri[tokenId] = cid;
    }

    /**
     * @notice Update token CID
     * @param userAddress token id
     * @param cid cid of the token
     */
    function setTokenURI(address userAddress, string memory cid) public {
        uint256 _tokenId = addressToTokenId[userAddress];
        _requireMinted(_tokenId);
        // require user to be owner
        require(ownerOf(_tokenId) == msg.sender, "Not owner");
        tokenIdToUri[_tokenId] = cid;
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
    }

    function totalSupply() public view returns (uint256) {
        return currentId;
    }

    /**
     * @dev Returns the base URI for the token.
     * @param tokenId The token to get the base URI of
     * @return The IPFS hash of the token
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);

        return string(abi.encodePacked("ipfs://", tokenIdToUri[tokenId]));
    }
}
