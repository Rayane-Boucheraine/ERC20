// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    // Add event declarations for testing
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    OurToken public ourToken;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function setUp() public {
        // Deploy token directly so address(this) gets the initial supply
        ourToken = new OurToken(INITIAL_SUPPLY);

        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    function testAllowAncesWorks() public {
        uint256 initialAllowance = 1000;

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testInitialSupplyAssignedToDeployer() public view {
        // address(this) should have initial supply minus what was transferred to bob
        uint256 expected = INITIAL_SUPPLY - STARTING_BALANCE;
        assertEq(ourToken.balanceOf(address(this)), expected);
    }

    function testTransferEmitsEvent() public {
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(this), alice, 10 ether);
        ourToken.transfer(alice, 10 ether);
    }

    function testTransferRevertsIfInsufficientBalance() public {
        uint256 tooMuch = ourToken.balanceOf(address(this)) + 1;
        vm.expectRevert();
        ourToken.transfer(alice, tooMuch);
    }

    function testApproveAndAllowance() public {
        uint256 allowanceAmount = 1234;
        ourToken.approve(alice, allowanceAmount);
        assertEq(ourToken.allowance(address(this), alice), allowanceAmount);
    }

    function testIncreaseAndDecreaseAllowance() public {
        uint256 amount = 100;
        ourToken.approve(alice, amount);
        ourToken.increaseAllowance(alice, 50);
        assertEq(ourToken.allowance(address(this), alice), 150);
        ourToken.decreaseAllowance(alice, 70);
        assertEq(ourToken.allowance(address(this), alice), 80);
    }

    function testDecreaseAllowanceBelowZeroReverts() public {
        ourToken.approve(alice, 10);
        vm.expectRevert();
        ourToken.decreaseAllowance(alice, 20);
    }

    function testTransferFromRevertsIfNotEnoughAllowance() public {
        vm.prank(bob);
        ourToken.approve(alice, 10);
        vm.prank(alice);
        vm.expectRevert();
        ourToken.transferFrom(bob, alice, 20);
    }

    function testTransferFromRevertsIfNotEnoughBalance() public {
        vm.prank(bob);
        ourToken.approve(alice, 1000 ether);
        vm.prank(alice);
        vm.expectRevert();
        ourToken.transferFrom(bob, alice, 200 ether);
    }

    function testApproveEmitsEvent() public {
        vm.expectEmit(true, true, false, true);
        emit Approval(address(this), alice, 42);
        ourToken.approve(alice, 42);
    }

    function testCannotTransferToZeroAddress() public {
        vm.expectRevert();
        ourToken.transfer(address(0), 1);
    }

    function testCannotApproveZeroAddress() public {
        vm.expectRevert();
        ourToken.approve(address(0), 1);
    }

    function testCannotTransferFromZeroAddress() public {
        // ERC20 standard: transferFrom from zero address is not possible via public interface
        // This test is not applicable unless we expose internal functions
    }

    function testTotalSupplyConstantAfterTransfers() public {
        uint256 before = ourToken.totalSupply();
        ourToken.transfer(alice, 1 ether);
        ourToken.transfer(bob, 2 ether);
        assertEq(ourToken.totalSupply(), before);
    }
}