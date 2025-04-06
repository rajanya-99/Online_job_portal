package com.portal.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:oracle:thin:@localhost:1521:XE"; // Ensure your DB URL is correct
    private static final String USER = "system"; // Use your actual Oracle username
    private static final String PASSWORD = "admin"; // Use your actual Oracle password

    static {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver"); // Load Oracle driver
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("Oracle JDBC Driver not found!");
        }
    }

    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;  // Return null if connection fails
        }
    }
}