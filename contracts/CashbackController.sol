// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;

import { IERC20Upgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import { SafeERC20Upgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import { AccessControlUpgradeable } from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

import { PauseControlUpgradeable } from "./base/PauseControlUpgradeable.sol";
import { RescueControlUpgradeable } from "./base/RescueControlUpgradeable.sol";
import { StoragePlaceholder200 } from "./base/StoragePlaceholder.sol";
import { ICashbackController } from "./interfaces/ICashbackController.sol";

contract CashbackController is
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

    // -------------------- Errors -----------------------------------

    /// @dev The zero token address has been passed as a function argument.
    error ZeroTokenAddress();

    /// @dev The recipient is the zero address.
    error ZeroRecipientAddress();

    /// @dev The balance of the contract is less than the cashback amount to be sent.
    error InsufficientCashbackBalance();

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

    function setCashbackRate()

    function sendCashback(
        address token,
        address recipient,
        uint256 transaction_amount
    ) external whenNotPaused onlyRole(CASHBACK_CONTROLLER_ROLE) {
        if (token == address(0)) {
            revert ZeroTokenAddress();
        }
        if (recipient == address(0)) {
            revert ZeroRecipientAddress();
        }

        erc20.safeTransfer(recipient)
    }
}
