// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.12;

contract Contract {
    /**
     * @dev Deposit ETH to the contract
     */
    function deposit() external payable {}

    /**
     * @dev Withdraw ETH from the contract
     */
    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}
