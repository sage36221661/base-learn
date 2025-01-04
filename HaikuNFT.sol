// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract HaikuNFT is ERC721 {
    // Errors
    error HaikuNotUnique();
    error NotYourHaiku(uint256 id);
    error NoHaikusShared();

    // Structs
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    // State variables
    Haiku[] public haikus;
    mapping(address => uint256[]) public sharedHaikus;
    uint256 public counter = 1; // Start from 1 as specified

    // Line tracking for uniqueness check
    mapping(string => bool) private usedLines;

    constructor() ERC721("HaikuNFT", "HAIKU") {
        // Push a dummy haiku at index 0 since we don't use id 0
        haikus.push(Haiku(address(0), "", "", ""));
    }

    function mintHaiku(
        string calldata _line1,
        string calldata _line2,
        string calldata _line3
    ) external {
        // Check uniqueness of each line
        if (usedLines[_line1] || usedLines[_line2] || usedLines[_line3]) {
            revert HaikuNotUnique();
        }

        // Mark lines as used
        usedLines[_line1] = true;
        usedLines[_line2] = true;
        usedLines[_line3] = true;

        // Create and store the haiku
        haikus.push(Haiku({
            author: msg.sender,
            line1: _line1,
            line2: _line2,
            line3: _line3
        }));

        // Mint the NFT
        _mint(msg.sender, counter);

        // Increment counter for next ID
        counter++;
    }

    function shareHaiku(address _to, uint256 _tokenId) public {
        // Check ownership
        if (ownerOf(_tokenId) != msg.sender) {
            revert NotYourHaiku(_tokenId);
        }

        // Add to shared haikus
        sharedHaikus[_to].push(_tokenId);
    }

    function getMySharedHaikus() public view returns (Haiku[] memory) {
        uint256[] storage sharedIds = sharedHaikus[msg.sender];
        
        // Check if any haikus were shared
        if (sharedIds.length == 0) {
            revert NoHaikusShared();
        }

        // Create array of shared haikus
        Haiku[] memory shared = new Haiku[](sharedIds.length);
        for (uint256 i = 0; i < sharedIds.length; i++) {
            shared[i] = haikus[sharedIds[i]];
        }

        return shared;
    }
} 