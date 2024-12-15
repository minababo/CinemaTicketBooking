<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>


<%
    // Database Connectivity
    List<Map<String, String>> movies = new ArrayList<>();
    try {
        String jdbcURL = "jdbc:mysql://localhost:3306/cinematicketbooking";

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection connection = DriverManager.getConnection(jdbcURL);

        String query = "SELECT * FROM movies";
        PreparedStatement statement = connection.prepareStatement(query);
        ResultSet resultSet = statement.executeQuery();

        while (resultSet.next()) {
            Map<String, String> movie = new HashMap<>();
            movie.put("movie_id", resultSet.getString("movie_id"));
            movie.put("title", resultSet.getString("title"));
            movie.put("description", resultSet.getString("description"));
            movie.put("image_url", resultSet.getString("image_url"));
            movie.put("trailer_url", resultSet.getString("trailer_url"));
            movies.add(movie);
        }

        resultSet.close();
        statement.close();
        connection.close();
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Now Showing</title>
    <style>
        /* Card styling to improve UI */
        .movie-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, 500px);
            gap: 20px;
            transform: translateY(-30px);
            padding: 20px;
            justify-content: start;
            margin-left: 5px;
            align-items: center;
        }

        .movie-card {
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            width: 500px;
            height: 370px;
        }

        .movie-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .movie-card .info {
        padding: 10px 15px;
        transform: translateY(-10px);
        }

        .buy-tickets, .watch-trailer {
            padding: 10px 20px;
            margin: 5px;
            text-decoration: none;
            border-radius: 5px;
            color: #fff;
        }

        .buy-tickets {
            background-color: #007BFF;
        }

        .watch-trailer {
            background-color: #28a745;
        }
        .h3 {
            color: #fff;
        }
    </style>
</head>
<body>
<!-- Render Movies -->
<div class="movie-cards">
    <% for (Map<String, String> movie : movies) { %>
    <div class="movie-card">
        <img src="<%= movie.get("image_url") %>" alt="<%= movie.get("title") %>">
        <div class="info">
            <h3><%= movie.get("title") %></h3>
            <p><%= movie.get("description") %></p>
            <a href="bookTickets.jsp?movie_id=<%= movie.get("movie_id") %>" class="book-tickets-btn" style="padding: 10px 20px; background-color: #007BFF; color: white; text-decoration: none; border-radius: 5px;">Book Tickets</a>
            <% if (movie.get("trailer_url") != null && !movie.get("trailer_url").isEmpty()) { %>
            <a href="<%= movie.get("trailer_url") %>" class="watch-trailer-btn" style="padding: 10px 20px; background-color: #286504; color: white; text-decoration: none; border-radius: 5px;" target="_blank">Watch Trailer</a>
            <% } %>
        </div>
    </div>
    <% } %>
</div>