// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.10;

import "./IFlashLoanReceiver.sol";
import "./IWETH9.sol";


contract FlashLoan{

    uint256 immutable loanPercent;
    uint256 internal constant PERCENTAGE_FACTOR = 1e4;
    uint256 feeCollected;
    address payable weth;
    address payable relayer;

    // Half percentage factor (50.00%)
    uint256 internal constant HALF_PERCENTAGE_FACTOR = 0.5e4;

    event FlashLoan(
        address indexed target,
        address initiator,
        uint256 amount,
        uint256 premium
    );

    constructor(address payable _relayer, uint256 _loanPercent){
        relayer = _relayer;
        loanPercent = _loanPercent;
    }
    function percentMul(uint256 value, uint256 percentage) internal pure returns (uint256 result) {
    // to avoid overflow, value <= (type(uint256).max - HALF_PERCENTAGE_FACTOR) / percentage
    assembly {
      if iszero(
        or(
          iszero(percentage),
          iszero(gt(value, div(sub(not(0), HALF_PERCENTAGE_FACTOR), percentage)))
        )
      ) {
        revert(0, 0)
      }

      result := div(add(mul(value, percentage), HALF_PERCENTAGE_FACTOR), PERCENTAGE_FACTOR)
    }
  }

    function executeFlashLoanSimple(
        address receiverAddress,
        uint256 amount
    ) external {

        IFlashLoanReceiver receiver = IFlashLoanReceiver(receiverAddress);
        uint256 fee = percentMul(amount, loanPercent);
        IWETH9(weth).transfer(receiverAddress, amount);

        require(
        receiver.executeOperation(
            amount,
            fee,
            msg.sender
        ),
        "INVALID_FLASHLOAN_EXECUTOR_RETURN"
        );

        uint256 amountPlusPremium = amount + fee;

        IWETH9(weth).transferFrom(
            receiverAddress,
            address(this),
            amountPlusPremium
        );

        IWETH9(weth).withdraw(fee);
        relayer.transfer(fee);
        
        emit FlashLoan(
            receiverAddress,
            msg.sender,
            amount,
            fee
        );
    }
}