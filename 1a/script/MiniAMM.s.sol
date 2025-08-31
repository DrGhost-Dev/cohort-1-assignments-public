// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {MiniAMM} from "../src/MiniAMM.sol";
import {MockERC20} from "../src/MockERC20.sol";

contract MiniAMMScript is Script {
    MiniAMM public miniAMM;
    MockERC20 public token0;
    MockERC20 public token1;

    function setUp() public {}

    function run() public {
        uint256 deployKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployKey);

        // Deploy mock ERC20 tokens
        //token0 = new MockERC20();
        //token1 = new MockERC20("tokenB", "TB");
        address tokenA = 0x6e9e41dCB609089D9De5B47AcA07d213E0AB3C41;
        address tokenB = 0x6E840AA1Ba90bF86D0dE1590Cd2eC95d9aE59751;
        // Deploy MiniAMM with the tokens
        miniAMM = new MiniAMM(tokenA, tokenB);

        vm.stopBroadcast();
    }
}
