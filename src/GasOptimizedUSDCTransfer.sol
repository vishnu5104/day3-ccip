// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract GasOptimizedUSDCTransfer is KeeperCompatibleInterface {
    IERC20 public usdc;
    address public recipient;
    uint256 public amount;
    bool public transferScheduled;

    constructor(address _usdc) {
        usdc = IERC20(_usdc);
    }

    function scheduleTransfer(address _recipient, uint256 _amount) external {
        recipient = _recipient;
        amount = _amount;
        transferScheduled = true;
    }

    function transferUsdc() external {
        require(transferScheduled, "No transfer scheduled");
        require(
            usdc.balanceOf(address(this)) >= amount,
            "Insufficient balance"
        );

        // Estimate the gas needed for the transfer
        uint256 estimatedGas = estimateGas(recipient, amount);

        // Increase by 10%
        uint256 gasLimit = (estimatedGas * 110) / 100;

        // Perform the transfer
        usdc.transfer(recipient, amount);

        transferScheduled = false;
    }

    function estimateGas(
        address recipient,
        uint256 amount
    ) internal view returns (uint256) {
        // Since actual gas estimation isn’t possible directly on-chain,
        // This function is a placeholder. Use Chainlink Keepers to manage
        // the execution and gas costs efficiently.
        return 50000; // Placeholder value
    }

    // Chainlink Keeper interface methods
    function checkUpkeep(
        bytes calldata
    ) external view override returns (bool upkeepNeeded, bytes memory) {
        upkeepNeeded =
            transferScheduled &&
            usdc.balanceOf(address(this)) >= amount;
    }

    function performUpkeep(bytes calldata) external override {
        if (transferScheduled && usdc.balanceOf(address(this)) >= amount) {
            transferUsdc();
        }
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract GasOptimizedUSDCTransfer is KeeperCompatibleInterface {
    IERC20 public usdc;
    address public recipient;
    uint256 public amount;
    bool public transferScheduled;

    constructor(address _usdc) {
        usdc = IERC20(_usdc);
    }

    function scheduleTransfer(address _recipient, uint256 _amount) external {
        recipient = _recipient;
        amount = _amount;
        transferScheduled = true;
    }

    function transferUsdc() external {
        require(transferScheduled, "No transfer scheduled");
        require(
            usdc.balanceOf(address(this)) >= amount,
            "Insufficient balance"
        );

        // Estimate the gas needed for the transfer
        uint256 estimatedGas = estimateGas(recipient, amount);

        // Increase by 10%
        uint256 gasLimit = (estimatedGas * 110) / 100;

        // Perform the transfer
        usdc.transfer(recipient, amount);

        transferScheduled = false;
    }

    function estimateGas(
        address recipient,
        uint256 amount
    ) internal view returns (uint256) {
        // Since actual gas estimation isn’t possible directly on-chain,
        // This function is a placeholder. Use Chainlink Keepers to manage
        // the execution and gas costs efficiently.
        return 50000; // Placeholder value
    }

    // Chainlink Keeper interface methods
    function checkUpkeep(
        bytes calldata
    ) external view override returns (bool upkeepNeeded, bytes memory) {
        upkeepNeeded =
            transferScheduled &&
            usdc.balanceOf(address(this)) >= amount;
    }

    function performUpkeep(bytes calldata) external override {
        if (transferScheduled && usdc.balanceOf(address(this)) >= amount) {
            transferUsdc();
        }
    }
}
