// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.9;

import "lib/ds-test/src/test.sol";
import "src/SecretSanta.sol";

contract ContractTest is DSTest {
    SecretSanta secretSanta;

    function setUp() public {
        secretSanta = new SecretSanta();
    }

    function testCreateGroup(address[] memory _groupMembers, uint256 expiry)
        public
    {
        uint256 id = secretSanta.createGroup(_groupMembers, expiry);
        for (uint256 index = 0; index < _groupMembers.length; index++) {
            assertEq(secretSanta.members(id, index), _groupMembers[index]);
            assertEq(
                secretSanta.whoHasWho(id, _groupMembers[index]),
                _groupMembers[(index + 1) % _groupMembers.length]
            );
            assertTrue(!secretSanta.hasSentGift(id, _groupMembers[index]));
        }
        assertEq(secretSanta.expiryMap(id), expiry);
    }
}
