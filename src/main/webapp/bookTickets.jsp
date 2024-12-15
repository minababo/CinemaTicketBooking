<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.*" %>
<%@ page import="java.util.*" %>

<%!
    public Connection getConnection() throws Exception {
        String jdbcURL = "jdbc:mysql://localhost:3306/cinematicketbooking";

        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(jdbcURL);
    }
%>

<%
    String movie_id = request.getParameter("movie_id");
    List<Map<String, String>> movies = new ArrayList<>();
    Map<String, String> selectedMovie = null;

    try {
        Connection connection = getConnection();

        String allMoviesQuery = "SELECT * FROM movies";
        PreparedStatement allMoviesStmt = connection.prepareStatement(allMoviesQuery);
        ResultSet allMoviesRs = allMoviesStmt.executeQuery();

        while (allMoviesRs.next()) {
            Map<String, String> movie = new HashMap<>();
            movie.put("movie_id", allMoviesRs.getString("movie_id"));
            movie.put("title", allMoviesRs.getString("title"));
            movies.add(movie);


            if (movie_id != null && movie_id.equals(allMoviesRs.getString("movie_id"))) {
                selectedMovie = new HashMap<>();
                selectedMovie.put("movie_id", allMoviesRs.getString("movie_id"));
                selectedMovie.put("title", allMoviesRs.getString("title"));
                selectedMovie.put("description", allMoviesRs.getString("description"));
            }
        }

        allMoviesRs.close();
        allMoviesStmt.close();
        connection.close();
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }

    List<String> nextFiveDays = new ArrayList<>();
    LocalDate today = LocalDate.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    for (int i = 0; i < 5; i++) {
        nextFiveDays.add(today.plusDays(i).format(formatter));
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Home - ABC Cinemas</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap');

        body { font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #010409;
            color: #cccccc;
            .movie-box
        {
                display: inline-block;
                padding: 10px;
                margin: 8px;
                background-color: #f0f0f0;
                border: 1px solid #ccc;
                border-radius: 5px;
                text-align: center;
                cursor: pointer;
        }
            .movie-box:hover {
                background-color: #ddd;
                color: #0070ff;
            }
            .selected {
                border: 2px solid #0070ff;
                background-color: #0070ff;
            }
        }
        main { padding: 20px; text-align: center; }
    </style>
    <script>
        let selectedSeats = [];

        function updateSeatSelection(seatId) {
            const seatDiv = document.getElementById(`seat_${seatId}`);
            if (seatDiv.classList.contains("booked")) {
                return;
            }

            if (selectedSeats.includes(seatId)) {
                seatDiv.classList.remove("selected");
                selectedSeats = selectedSeats.filter(id => id !== seatId);
            } else {
                seatDiv.classList.add("selected");
                selectedSeats.push(seatId);
            }

            document.getElementById("selectedSeats").value = selectedSeats.join(",");
        }
        function selectMovie(movieId) {
            // Deselect all movies
            const movieBoxes = document.querySelectorAll('.movie-box');
            movieBoxes.forEach(box => box.classList.remove('selected'));

            // Select the clicked movie
            const selectedMovie = document.getElementById('movie_' + movieId);
            selectedMovie.classList.add('selected');

            // Set the hidden input value
            document.getElementById('selectedMovieId').value = movieId;
        }
    </script>
</head>
<body>
<!-- Navbar -->
<section id="navbar" style="padding: 0">
<%@ include file="./navbar.jsp"%>
</section>
<!-- Page Content -->
<div class="container" style="text-align: center">
<h1>Book Your Tickets</h1>

<!-- Movie Box Selection -->
<h2>Select a Movie:</h2>
<div>
    <% for (Map<String, String> movie : movies) { %>
    <div class="movie-box" id="movie_<%= movie.get("movie_id") %>" onclick="selectMovie('<%= movie.get("movie_id") %>')">
        <h3><%= movie.get("title") %></h3>
    </div>
    <% } %>
</div>

<!-- Booking Form -->
<form action="confirmBooking.jsp" method="post">
    <!-- Hidden input to hold selected movie_id -->
    <input type="hidden" id="selectedMovieId" name="movie_id">

    <!-- Time Selection -->
    <h2>Select Time:</h2>
    <select name="time" required>
        <option value="">-- Choose a Time --</option>
        <option value="10:30AM">10:30AM</option>
        <option value="1:00PM">1:00PM</option>
        <option value="3:00PM">3:00PM</option>
        <option value="7:00PM">7:00PM</option>
    </select>
    <br><br>

    <!-- Date Selection -->
    <h2>Select Date:</h2>
    <select name="date" required>
        <option value="">-- Choose a Date --</option>
        <% for (String date : nextFiveDays) { %>
        <option value="<%= date %>"><%= date %></option>
        <% } %>
    </select>
    <br><br>

    <!-- Seat Selection -->
    <h2>Select Your Seats:</h2>
    <div class="seat-grid" id="seatGrid">
        <%
            try {
                Connection connection = getConnection();
                String query = "SELECT * FROM seats WHERE movie_id = ? ORDER BY seat_row, seat_column";
                PreparedStatement stmt = connection.prepareStatement(query);
                stmt.setString(1, movie_id);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    String seatId = rs.getString("seat_id");
                    int seatRow = rs.getInt("seat_row");
                    int seatColumn = rs.getInt("seat_column");
                    boolean isBooked = rs.getBoolean("is_booked");

        %>
        <div
                id="seat_<%= seatId %>"
                class="seat <%= isBooked ? "booked" : "" %>"
                data-seat-id="<%= seatId %>"
                onclick="updateSeatSelection('<%= seatId %>')">
        </div>
        <%      }
            rs.close();
            stmt.close();
            connection.close();
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
        %>
    </div>

    <!-- Hidden field to send selected seats to the backend -->
    <input type="hidden" id="selectedSeats" name="selectedSeats">
    <input type="hidden" name="movie_id" value="<%= movie_id %>">
    <input type="hidden" name="time">
    <input type="hidden" name="date">
    <button type="submit">Confirm Booking</button>
</form>
</div>
</body>

</html>
