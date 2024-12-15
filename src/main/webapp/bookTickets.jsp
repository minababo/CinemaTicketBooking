<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.*" %>
<%@ page import="java.util.*" %>

<%!
    // Helper function to get connection
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

        // Fetch all movies for selection
        String allMoviesQuery = "SELECT * FROM movies";
        PreparedStatement allMoviesStmt = connection.prepareStatement(allMoviesQuery);
        ResultSet allMoviesRs = allMoviesStmt.executeQuery();

        while (allMoviesRs.next()) {
            Map<String, String> movie = new HashMap<>();
            movie.put("movie_id", allMoviesRs.getString("movie_id"));
            movie.put("title", allMoviesRs.getString("title"));
            movies.add(movie);

            // If this is the selected movie, save its details
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

    // Generate the next 5 days for date selection
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
    <title>Book Tickets</title>
    <style>
        .movie-box {
            display: inline-block;
            padding: 20px;
            margin: 10px;
            background-color: #f0f0f0;
            border: 1px solid #ccc;
            border-radius: 5px;
            text-align: center;
            cursor: pointer;
        }
        .movie-box:hover {
            background-color: #ddd;
        }
        .selected {
            border: 2px solid #0070ff;
        }
    </style>
    <script>
        let selectedSeats = [];

        function updateSeatSelection(seatId) {
            const seatDiv = document.getElementById(`seat_${seatId}`);
            if (seatDiv.classList.contains("booked")) {
                return; // Ignore clicks on booked seats
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
                // Database connection
                Connection connection = getConnection();
                String query = "SELECT * FROM seats WHERE movie_id = ? ORDER BY seat_row, seat_column";
                PreparedStatement stmt = connection.prepareStatement(query);
                stmt.setString(1, movie_id); // Use the selected movie ID
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    String seatId = rs.getString("seat_id");
                    int seatRow = rs.getInt("seat_row");
                    int seatColumn = rs.getInt("seat_column");
                    boolean isBooked = rs.getBoolean("is_booked");

                    // Generate a seat box dynamically
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
            // Print an error message for debugging
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
</body>
</html>