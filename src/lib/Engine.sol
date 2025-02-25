// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

library Engine {
    type Grid is uint16;

    function toGrid(uint16 value) internal pure returns (Grid) {
        return Grid.wrap(value & 0x1ff);
    }
}
