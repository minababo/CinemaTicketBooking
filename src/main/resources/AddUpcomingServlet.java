package main.webapp.admin.servlets;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.sql.*;

public class AddUpcomingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Retrieve form data
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("image_url");
        String releaseDate = request.getParameter("release_date"); // Ensure the date format matches your DB schema

        try {
            // Database connection details
            String jdbcURL = "jdbc:mysql://localhost:3306/cinematicketbooking";

            // Establish connection
            Connection connection = DriverManager.getConnection(jdbcURL);

            // Prepare the SQL statement
            String insertQuery = "INSERT INTO upcoming_movies (title, description, image_url, release_date) VALUES (?, ?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(insertQuery);
            statement.setString(1, title);
            statement.setString(2, description);
            statement.setString(3, imageUrl);
            statement.setString(4, releaseDate); // Ensure the date format is "YYYY-MM-DD"

            // Execute the update
            int rowsInserted = statement.executeUpdate();

            // Close resources
            statement.close();
            connection.close();

            if (rowsInserted > 0) {
                // Redirect to success page or admin dashboard
                response.sendRedirect("adminDashboard.jsp?success=Movie added successfully");
            } else {
                response.sendRedirect("addUpcoming.jsp?error=Failed to add movie"); // Redirect back with error
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addUpcoming.jsp?error=An error occurred while adding the movie"); // Redirect to form
        }
    }
}