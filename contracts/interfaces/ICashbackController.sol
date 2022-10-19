// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;

interface ICashbackController {
    event SetCashbackRate(uint32 oldRate, uint32 newRate);

    event CashbackBypassed(bytes16 authorizationId, uint256 amount);

    error UnsafeCashbackRate(uint32 proposedRate);

    event SendCashback(
        address indexed token,
        address indexed recipient,
        uint256 transaction_amount,
        uint256 remainderBalance // current balance of the contract after sending the cashback
    );

    function setCashbackRate(uint32 newRate) external;

    function sendCashback(
        address token,
        address recipient,
        uint256 transaction_amount
    ) external;
}
