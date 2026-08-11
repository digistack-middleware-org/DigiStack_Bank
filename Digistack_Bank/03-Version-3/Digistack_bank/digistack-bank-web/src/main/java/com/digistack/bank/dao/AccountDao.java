package com.digistack.bank.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Logger;

public class AccountDao {

    private static final Logger logger = Logger.getLogger(AccountDao.class.getName());

    private static final String DB_URL = "jdbc:postgresql://192.168.10.30:5432/digistack_bank";
    private static final String DB_USER = "digistack_app";
    private static final String DB_PASSWORD = "Wasadmin@951951";

    /**
     * Returns the current balance for the account belonging to the given user ID.
     * Returns null if no account is found.
     */
    public BigDecimal getBalance(int userId) {
        String sql = "SELECT balance FROM accounts WHERE user_id = ?";

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("balance");
                }
            }

        } catch (SQLException e) {
            logger.severe("AccountDao.getBalance: database error: " + e.getMessage());
        }

        return null;
    }

    /**
     * Updates the balance for the account belonging to the given user ID.
     * Returns true if exactly one row was updated.
     */
    public boolean updateBalance(int userId, BigDecimal newBalance) {
        String sql = "UPDATE accounts SET balance = ? WHERE user_id = ?";

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBigDecimal(1, newBalance);
            stmt.setInt(2, userId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected == 1;

        } catch (SQLException e) {
            logger.severe("AccountDao.updateBalance: database error: " + e.getMessage());
            return false;
        }
    }
}