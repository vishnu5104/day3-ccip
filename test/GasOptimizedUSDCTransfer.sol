// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./GasOptimizedUSDCTransfer.sol";

contract GasOptimizedUSDCTransferTest is Test {
    IERC20 usdc;
    GasOptimizedUSDCTransfer transferContract;
    address owner;
    address recipient = address(0x123);
    uint256 amount = 1000e6; // Assuming USDC has 6 decimals

    function setUp() public {
        owner = address(this);

        // Deploy a mock USDC token for testing
        usdc = new MockUSDC();

        // Deploy the GasOptimizedUSDCTransfer contract
        transferContract = new GasOptimizedUSDCTransfer(address(usdc));

        // Fund the transfer contract with USDC
        usdc.mint(address(transferContract), amount);
    }

    function testScheduleAndPerformTransfer() public {
        // Schedule a transfer
        transferContract.scheduleTransfer(recipient, amount);

        // Verify the transfer is scheduled
        (
            address scheduledRecipient,
            uint256 scheduledAmount,
            bool isScheduled
        ) = (
                transferContract.recipient(),
                transferContract.amount(),
                transferContract.transferScheduled()
            );

        assertEq(scheduledRecipient, recipient);
        assertEq(scheduledAmount, amount);
        assertTrue(isScheduled);

        // Simulate Chainlink Keepers triggering the transfer
        transferContract.performUpkeep("");

        // Verify the transfer has occurred
        uint256 recipientBalance = usdc.balanceOf(recipient);
        assertEq(recipientBalance, amount);
    }
}

// Mock USDC Token for Testing
contract MockUSDC is IERC20 {
    string public name = "Mock USDC";
    string public symbol = "USDC";
    uint8 public decimals = 6;

    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint256)) public override allowance;

    function totalSupply() external view override returns (uint256) {
        return 0;
    }

    function transfer(
        address to,
        uint256 amount
    ) external override returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function approve(
        address spender,
        uint256 amount
    ) external override returns (bool) {
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external override returns (bool) {
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
    }
}
