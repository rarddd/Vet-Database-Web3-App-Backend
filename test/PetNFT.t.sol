// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/forge-std/src/Test.sol";
import "src/PetNFT.sol";

contract MintPetTest is Test {
    PetNFT public petNFT;

    function setUp() public {
        petNFT = new PetNFT();
        // mintPet.setNumber(0);
    }

    //     function testIncrement() public {
    //         counter.increment();
    //         assertEq(counter.number(), 1);
    //     }

    //     function testSetNumber(uint256 x) public {
    //         counter.setNumber(x);
    //         assertEq(counter.number(), x);
    //     }
}
