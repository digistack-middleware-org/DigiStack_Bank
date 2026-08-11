package com.digistack.bank.service;

import java.math.BigDecimal;
import java.util.logging.Logger;

import com.digistack.bank.dao.AccountDao;

public class AccountService {

    private static final Logger logger = Logger.getLogger(AccountService.class.getName());

    private final AccountDao accountDao = new AccountDao();

    /**
     * Returns the current balance for the given user, or null if no account exists.
     */
    public BigDecimal getBalance(int userId) {
        return accountDao.getBalance(userId);
    }

    /**
     * Deposits the given amount into the user's account.
     * Returns true if successful, false if the deposit was invalid or failed.
     */
    public boolean deposit(int userId, BigDecimal amount) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            logger.warning("AccountService.deposit: rejected non-positive amount for userId=" + userId);
            return false;
        }

        BigDecimal currentBalance = accountDao.getBalance(userId);
        if (currentBalance == null) {
            logger.warning("AccountService.deposit: no account found for userId=" + userId);
            return false;
        }

        BigDecimal newBalance = currentBalance.add(amount);
        boolean success = accountDao.updateBalance(userId, newBalance);

        if (success) {
            logger.info("AccountService.deposit: userId=" + userId + " deposited " + amount + ", new balance=" + newBalance);
        }

        return success;
    }

    /**
     * Withdraws the given amount from the user's account.
     * Returns true if successful, false if the withdrawal was invalid, would
     * overdraw the account, or failed.
     */
    public boolean withdraw(int userId, BigDecimal amount) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            logger.warning("AccountService.withdraw: rejected non-positive amount for userId=" + userId);
            return false;
        }

        BigDecimal currentBalance = accountDao.getBalance(userId);
        if (currentBalance == null) {
            logger.warning("AccountService.withdraw: no account found for userId=" + userId);
            return false;
        }

        if (currentBalance.compareTo(amount) < 0) {
            logger.warning("AccountService.withdraw: rejected overdraft attempt for userId=" + userId
                    + " (balance=" + currentBalance + ", requested=" + amount + ")");
            return false;
        }

        BigDecimal newBalance = currentBalance.subtract(amount);
        boolean success = accountDao.updateBalance(userId, newBalance);

        if (success) {
            logger.info("AccountService.withdraw: userId=" + userId + " withdrew " + amount + ", new balance=" + newBalance);
        }

        return success;
    }
}