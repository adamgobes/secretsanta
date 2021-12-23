// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.9;

import "../lib/IERC721.sol";

contract SecretSanta {
    /// @dev tracks loan count
    uint256 private _nonce;

    mapping(uint256 => address[]) public members;
    mapping(uint256 => uint256) public expiryMap;
    mapping(uint256 => mapping(address => bool)) public hasSentGift;
    mapping(uint256 => mapping(address => address)) public whoHasWho;

    modifier secretSantaGroupExists(uint256 groupId) {
        require(members[groupId].length > 0, "group not initialized yet");
        _;
    }

    modifier groupNotExpired(uint256 groupId) {
        require(expiryMap[groupId] < block.timestamp, "group has expired");
        _;
    }

    function createGroup(address[] memory groupMembers, uint256 expiry)
        external
        returns (uint256)
    {
        uint256 id = ++_nonce;

        members[id] = groupMembers;
        expiryMap[id] = expiry;

        for (uint256 index = 0; index < groupMembers.length; index++) {
            hasSentGift[id][groupMembers[index]] = false;
            whoHasWho[id][groupMembers[index]] = groupMembers[
                (index + 1) % groupMembers.length
            ];
        }

        return id;
    }
}
