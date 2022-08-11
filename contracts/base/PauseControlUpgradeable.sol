// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";

/**
 * @title PauseControlUpgradeable base contract
 * @dev Extends OpenZeppelin's PausableUpgradeable contract and AccessControlUpgradeable contract.
 * Introduces the {PAUSER_ROLE} role to control the paused state the contract that is inherited from this one.
 * The admins of the {PAUSER_ROLE} roles are accounts with the role defined in the init() function.
 */
abstract contract PauseControlUpgradeable is AccessControlUpgradeable, PausableUpgradeable {

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    function __PauseControl_init(bytes32 pauserRoleAdmin) internal initializer {
        __Context_init_unchained();
        __ERC165_init_unchained();
        __Pausable_init_unchained();
        __PauseControl_init_unchained(pauserRoleAdmin);
    }

    function __PauseControl_init_unchained(bytes32 pauserRoleAdmin) internal initializer {
        _setRoleAdmin(PAUSER_ROLE, pauserRoleAdmin);
    }

    /**
     * @dev Triggers the paused state of the contract.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     * - The caller should have the {PAUSER_ROLE} role.
     *
     * Emits a {Paused} event if it is executed successfully.
     */
    function pause() external onlyRole(PAUSER_ROLE) {
        _pause();
    }

    /**
     * @dev Triggers the unpaused state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     * - The caller should have the {PAUSER_ROLE} role.
     *
     * Emits a {Unpaused} event if it is executed successfully.
     */
    function unpause() external onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     */
    uint256[50] private __gap;
}
