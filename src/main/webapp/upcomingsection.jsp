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
<!-- Render Upcoming Movies -->
<div class="movie-cards">
  <% for (Map<String, String> movie : upcomingMovies) { %>
  <div class="movie-card" style="border: 1px solid #ccc; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 5px rgba(0,0,0,0.1); margin: 0 auto; max-width: 250px;">
    <img src="<%= movie.get("image_url") %>" alt="<%= movie.get("title") %>" style="width: 100%; height: auto;">
    <div class="info" style="padding: 15px;">
      <h3><%= movie.get("title") %></h3>
      <p><%= movie.get("description") %></p>
      <p><strong>Release Date:</strong> <%= movie.get("release_date") %></p>
      <% if (movie.get("trailer_url") != null && !movie.get("trailer_url").isEmpty()) { %>
      <a href="<%= movie.get("trailer_url") %>" target="_blank" style="color: #007BFF; text-decoration: none;">Watch Trailer</a>
      <% } %>
    </div>
  </div>
  <% } %>
</div>