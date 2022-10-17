// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract Xiabing is ERC721, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;
    bytes32 public merkleRoot;
    mapping(address => bool) public claimed;

    string public _baseUri =
        "ipfs://bafybeievhnrvp4rj4oitxuo6iyz3boefn7hgjyuiqcpchfy7b3ltztqvru/";

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("XiaBing", "XBT") {}

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseUri;
    }

    function baseURI() public view returns (string memory) {
        return _baseUri;
    }

    function safeMint(address to) public onlyOwner {
        _mint(to);
    }

    function _mint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function mint(uint256 qty, bytes32[] calldata merkleProof) public payable {
        require(claimed[msg.sender] == false, "already claimed");
        require(qty > 0, "qty > 0");
        claimed[msg.sender] = true;
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProof.verify(merkleProof, merkleRoot, leaf) == true,
            "invalid merkle proof"
        );
        for (uint256 index = 0; index < qty; index++) {
            _mint(msg.sender);
        }
    }

    function setBaseURI(string memory uri) public onlyOwner {
        _baseUri = uri;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        _requireMinted(tokenId);

        return
            bytes(_baseUri).length > 0
                ? string(
                    abi.encodePacked(_baseUri, tokenId.toString(), ".json")
                )
                : "";
    }
}
