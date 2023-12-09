// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.0;

/**
 * @title IFlashLoanSimpleReceiver
 * @author Aave
 * @notice Defines the basic interface of a flashloan-receiver contract.
 * @dev Implement this interface to develop a flashloan-compatible flashLoanReceiver contract
 */
interface IFlashLoanReceiver {
  /**
   * @notice Executes an operation after receiving the flash-borrowed asset
   * @dev Ensure that the contract can return the debt + premium, e.g., has
   *      enough funds to repay and has approved the Pool to pull the total amount
   * @param amount The amount of the flash-borrowed asset
   * @param fee The fee of the flash-borrowed asset
   * @param initiator The address of the flashloan initiator
   * @return True if the execution of the operation succeeds, false otherwise
   */
  function executeOperation(
    uint256 amount,
    uint256 fee,
    address initiator
  ) external returns (bool);


}