// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/// -----------------------------------------------------------------------
/// Imports
/// -----------------------------------------------------------------------

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract PetNFT is ERC721, Ownable {
    /// -----------------------------------------------------------------------
    /// Struct
    /// -----------------------------------------------------------------------
    struct Pet {
        string arweaveStorageLocation;
        string name;
    }

    /// -----------------------------------------------------------------------
    /// Storage Variables
    /// -----------------------------------------------------------------------

    mapping(uint256 => Pet) private _pets;
    uint256 private _totalSupply;

    /// -----------------------------------------------------------------------
    /// Constructor
    /// -----------------------------------------------------------------------

    constructor() ERC721("Nft", "PET") {}

    /// -----------------------------------------------------------------------
    /// User Functions
    /// -----------------------------------------------------------------------

    // Only owner can mint a new Pet NFT
    function mintPet(
        string memory _name,
        string memory _arweaveStorageLocation
    ) external onlyOwner returns (uint256) {
        uint256 tokenId = _totalSupply + 1;
        _mint(msg.sender, tokenId);
        _pets[tokenId] = Pet(_arweaveStorageLocation, _name);
        return tokenId;
    }

    /*  
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }
    */

    // Only owner can update Arweave storage location
    function updateArweaveStorageLocation(
        uint256 _tokenId,
        string memory _newArweaveStorageLocation
    ) external onlyOwner {
        require(_exists(_tokenId), "Pet does not exist");
        _pets[_tokenId].arweaveStorageLocation = _newArweaveStorageLocation;
    }

    /// -----------------------------------------------------------------------
    /// Getter Function
    /// -----------------------------------------------------------------------
    // Public function to get details of a specific pet
    function getPet(
        uint256 _tokenId
    )
        public
        view
        returns (string memory name, string memory arweaveStorageLocation)
    {
        require(_exists(_tokenId), "Pet does not exist");
        return (_pets[_tokenId].name, _pets[_tokenId].arweaveStorageLocation);
    }
}
