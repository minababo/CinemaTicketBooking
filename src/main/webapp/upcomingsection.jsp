<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
  // List to hold upcoming movie data
  List<Map<String, String>> upcomingMovies = new ArrayList<>();

  try {
    String jdbcURL = "jdbc:mysql://localhost:3306/cinematicketbooking";

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection connection = DriverManager.getConnection(jdbcURL);

    // SQL Query to fetch upcoming movies
    String query = "SELECT * FROM upcoming_movies ORDER BY release_date ASC";
    PreparedStatement statement = connection.prepareStatement(query);
    ResultSet resultSet = statement.executeQuery();

    while (resultSet.next()) {
      Map<String, String> movie = new HashMap<>();
      movie.put("movie_id", resultSet.getString("movie_id"));
      movie.put("title", resultSet.getString("title"));
      movie.put("description", resultSet.getString("description"));
      movie.put("release_date", resultSet.getString("release_date"));
      movie.put("image_url", resultSet.getString("image_url"));
      movie.put("trailer_url", resultSet.getString("trailer_url"));
      upcomingMovies.add(movie);
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
  <title>Upcoming Movies</title>
  <style>
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
      border: 1px solid #2d3138;
      border-radius: 5px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      overflow: hidden;
      width: 500px;
      height: 390px;
      background-color: #0e1116;
    }

    .movie-card img {
      width: 100%;
      height: 180px;
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
  </style>
</head>
<body>
<!-- Render Upcoming Movies -->
<div class="movie-cards">
  <% for (Map<String, String> movie : upcomingMovies) { %>
  <div class="movie-card">
    <img src="<%= movie.get("image_url") %>" alt="<%= movie.get("title") %>">
    <div class="info" style="padding: 15px;">
      <h3><%= movie.get("title") %></h3>
      <p><%= movie.get("description") %></p>
      <p style="display: flex; align-items: center; justify-content: space-between;">
        <span><strong>Release Date:</strong> <%= movie.get("release_date") %></span>
        <% if (movie.get("trailer_url") != null && !movie.get("trailer_url").isEmpty()) { %>
        <a href="<%= movie.get("trailer_url") %>" target="_blank" style="padding: 10px 20px; background-color: #286504; color: white; text-decoration: none; border-radius: 5px;">Watch Trailer</a>
        <% } %>
      </p>
    </div>
  </div>
  <% } %>
</div>
</body>
</html>