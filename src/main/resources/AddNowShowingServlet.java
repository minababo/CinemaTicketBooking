package main.webapp.admin.servlets;


import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.sql.*;

@WebServlet(name = "addnowshowingservlet", urlPatterns = {"/AddNowShowingServlet"})
public class AddNowShowingServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("image_url");
        String trailerUrl = request.getParameter("trailer_url");

        try {
            String jdbcURL = "jdbc:mysql://localhost:3306/cinematicketbooking";

            Connection connection = DriverManager.getConnection(jdbcURL);
            String insertQuery = "INSERT INTO movies (title, description, image_url, trailer_url) VALUES (?, ?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(insertQuery);
            statement.setString(1, title);
            statement.setString(2, description);
            statement.setString(3, imageUrl);
            statement.setString(5, trailerUrl);
            statement.executeUpdate();

            statement.close();
            connection.close();

            response.sendRedirect("adminDashboard.jsp"); // Redirect to admin dashboard
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addNowShowing.jsp?error=Error adding movie"); // Redirect to form with error
        }
    }
}