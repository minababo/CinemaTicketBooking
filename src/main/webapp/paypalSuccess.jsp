<%@ page import="java.sql.*" %>
<%

    // Retrieve data from session (saved during tentative booking)
    String selectedSeats = (String) session.getAttribute("selectedSeats");
    String movieId = (String) session.getAttribute("movieId");
    String time = (String) session.getAttribute("time");
    String date = (String) session.getAttribute("date");
    String userName = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");
    String userPhone = (String) session.getAttribute("userPhone");

    Connection conn = null;
    PreparedStatement finalizeSeatStmt = null;
    PreparedStatement insertBookingStmt = null;

    try {
        // Establish connection
        String jdbcURL = "jdbc:mysql://localhost:3306/cinematicketbooking";
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL);

        // Start transaction
        conn.setAutoCommit(false);

        // Finalize booking: Change seats to 'BOOKED'
        String[] seatIds = selectedSeats.split(",");
        for (String seatId : seatIds) {
            String finalizeSeatQuery = "UPDATE seats SET booking_status = 'BOOKED' WHERE seat_id = ?";
            finalizeSeatStmt = conn.prepareStatement(finalizeSeatQuery);
            finalizeSeatStmt.setInt(1, Integer.parseInt(seatId));
            finalizeSeatStmt.executeUpdate();
        }

        // Insert booking record
        String insertBookingQuery = "INSERT INTO bookings (movie_id, booking_date, booking_time, user_name, user_email, user_phone, price) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        insertBookingStmt = conn.prepareStatement(insertBookingQuery);
        insertBookingStmt.setInt(1, Integer.parseInt(movieId));
        insertBookingStmt.setString(2, date);
        insertBookingStmt.setString(3, time);
        insertBookingStmt.setString(4, userName);
        insertBookingStmt.setString(5, userEmail);
        insertBookingStmt.setString(6, userPhone);

        // Calculate price (e.g., Rs. 1000 per seat)
        int price = seatIds.length * 1000;
        insertBookingStmt.setInt(7, price);

        insertBookingStmt.executeUpdate();

        // Commit transaction
        conn.commit();

        out.println("<h2>Booking Confirmed!</h2>");
        out.println("<p>Thank you, " + userName + "!</p>");
        out.println("<p>Total Price: Rs. " + price + "</p>");
        out.println("<a href='index.jsp'>Go Back to Home</a>");

    } catch (Exception e) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                out.println("<p>Rollback Error: " + rollbackEx.getMessage() + "</p>");
            }
        }
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        if (finalizeSeatStmt != null) try { finalizeSeatStmt.close(); } catch (SQLException ignore) {}
        if (insertBookingStmt != null) try { insertBookingStmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>