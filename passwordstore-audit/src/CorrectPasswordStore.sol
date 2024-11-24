// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

/**
 * @author SecureDev
 * @title PasswordStore
 * @notice A secure contract for storing a hashed password. Only the owner can manage it.
 */
contract PasswordStore {
    error PasswordStore__NotOwner();

    address private immutable i_owner;
    bytes32 private s_passwordHash;

    event PasswordUpdated(address indexed owner);

    constructor(bytes32 initialPasswordHash) {
        i_owner = msg.sender;
        s_passwordHash = initialPasswordHash;
    }

    /**
     * @notice Restricts access to the owner.
     */
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert PasswordStore__NotOwner();
        }
        _;
    }

    /**
     * @notice Allows the owner to set a new hashed password.
     * @param newPasswordHash The hash of the new password.
     */
    function setPassword(bytes32 newPasswordHash) external onlyOwner {
        s_passwordHash = newPasswordHash;
        emit PasswordUpdated(i_owner);
    }

    /**
     * @notice Verifies if a provided password matches the stored hash.
     * @param password The plaintext password to verify.
     * @return True if the password is correct, false otherwise.
     */
    function verifyPassword(string memory password) external view onlyOwner returns (bool) {
        return keccak256(abi.encodePacked(password)) == s_passwordHash;
    }
}

/*
The password is stored as a hash using keccak256.

Added an onlyOwner modifier to restrict access to sensitive functions.

Instead of exposing the password, a verifyPassword function is added to check if the input matches the stored hash.
Gas Optimization:

Used immutable for i_owner since it doesn’t change after initialization.
*/