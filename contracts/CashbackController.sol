// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;

import { IERC20Upgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import { SafeERC20Upgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import { AccessControlUpgradeable } from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

import { PauseControlUpgradeable } from "./base/PauseControlUpgradeable.sol";
import { RescueControlUpgradeable } from "./base/RescueControlUpgradeable.sol";
import { StoragePlaceholder200 } from "./base/StoragePlaceholder.sol";
import { ICashbackController } from "./interfaces/ICashbackController.sol";

abstract contract CashbackController is
    AccessControlUpgradeable,
    PauseControlUpgradeable,
    RescueControlUpgradeable,
    StoragePlaceholder200,
    ICashbackController
{
    using SafeERC20Upgradeable for IERC20Upgradeable;

    /// @dev The role of this contract owner.
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");

    bytes32 public constant CASHBACK_CONTROLLER_ROLE = keccak256("CASHBACK_CONTROLLER_ROLE");

    uint32 cashbackRate = 0;
    // -------------------- Errors -----------------------------------

    /// @dev The zero token address has been passed as a function argument.
    error ZeroTokenAddress();

    /// @dev The recipient is the zero address.
    error ZeroRecipientAddress();

    // ------------------- Functions ---------------------------------

    /**
     * @dev The initialize function of the upgradable contract.
     * See details https://docs.openzeppelin.com/upgrades-plugins/1.x/writing-upgradeable
     */
    function initialize() external initializer {
        __CashbackController_init();
    }

    function __CashbackController_init() internal onlyInitializing {
        __AccessControl_init_unchained();
        __Context_init_unchained();
        __ERC165_init_unchained();
        __Pausable_init_unchained();
        __PauseControl_init_unchained(OWNER_ROLE);
        __RescueControl_init_unchained(OWNER_ROLE);

        __CashbackController_init_unchained();
    }

    function __CashbackController_init_unchained() internal onlyInitializing {
        _setRoleAdmin(OWNER_ROLE, OWNER_ROLE);
        _setRoleAdmin(CASHBACK_CONTROLLER_ROLE, OWNER_ROLE);

        _setupRole(OWNER_ROLE, _msgSender());
    }

    function setCashbackRate(uint32 newRate) external whenNotPaused onlyRole(CASHBACK_CONTROLLER_ROLE) {
        uint32 oldRate = cashbackRate;
        cashbackRate = newRate;

        emit SetCashbackRate(oldRate, newRate);
    }

    function sendCashback(
        address token,
        address recipient,
        uint256 transactionAmount,
        bytes16 authorizationId
    ) external whenNotPaused onlyRole(CASHBACK_CONTROLLER_ROLE) {
        if (token == address(0)) {
            revert ZeroTokenAddress();
        }
        if (recipient == address(0)) {
            revert ZeroRecipientAddress();
        }

        IERC20Upgradeable erc20 = IERC20Upgradeable(token);
        uint256 remainderBalance = address(this).balance;
        uint256 cashbackAmount = transactionAmount * cashbackRate;

        if (remainderBalance < cashbackAmount) {
            emit CashbackBypassed(authorizationId, cashbackAmount);
        } else {
            erc20.safeTransfer(recipient, cashbackAmount);
            emit SendCashback(token, recipient, cashbackAmount, remainderBalance);
        }
    }
}
