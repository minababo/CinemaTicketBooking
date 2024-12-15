package main.webapp.admin.servlets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

    // Database credentials
    private static final String URL = "jdbc:mysql://localhost:3306/your_database_name"; // Replace with your DB URL
    private static final String USERNAME = "your_username"; // Replace with your DB username
    private static final String PASSWORD = "your_password"; // Replace with your DB password

    // Static block to register the driver
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // JDBC driver for MySQL
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Failed to load database driver!", e);
        }
    }

    /**
     * Get a connection to the database.
     *
     * @return Connection object
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    /**
     * Close the connection safely.
     *
     * @param conn the Connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}