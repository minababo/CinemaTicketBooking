<%@ page import="java.sql.*" %>
<%

    String selectedSeats = request.getParameter("selectedSeats"); // Comma-separated seat IDs
    String movieId = request.getParameter("movie_id");
    String time = request.getParameter("time");
    String date = request.getParameter("date");
    String userName = request.getParameter("name");
    String userEmail = request.getParameter("email");
    String userPhone = request.getParameter("phone");

    Connection conn = null;
    PreparedStatement checkSeatStmt = null;
    PreparedStatement holdSeatStmt = null;

    try {
        String jdbcURL = "jdbc:mysql://localhost:3306/cinematicketbooking";
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL);

        conn.setAutoCommit(false);

        // Change seats to 'TENTATIVE'
        String[] seatIds = selectedSeats.split(",");
        for (String seatId : seatIds) {
            // Check if the seat is still available
            String checkSeatQuery = "SELECT booking_status FROM seats WHERE seat_id = ? FOR UPDATE";
            checkSeatStmt = conn.prepareStatement(checkSeatQuery);
            checkSeatStmt.setInt(1, Integer.parseInt(seatId));
            ResultSet rs = checkSeatStmt.executeQuery();

            if (rs.next() && !"AVAILABLE".equals(rs.getString("booking_status"))) {
                throw new Exception("Seat ID " + seatId + " is no longer available.");
            }

            rs.close();

            // Mark the seat as 'TENTATIVE'
            String holdSeatQuery = "UPDATE seats SET booking_status = 'TENTATIVE' WHERE seat_id = ?";
            holdSeatStmt = conn.prepareStatement(holdSeatQuery);
            holdSeatStmt.setInt(1, Integer.parseInt(seatId));
            holdSeatStmt.executeUpdate();
        }

        // Commit the changes to hold seats temporarily
        conn.commit();

        // Redirect to PayPal payment page (use your PayPal integration here)
        session.setAttribute("selectedSeats", selectedSeats);
        session.setAttribute("movieId", movieId);
        session.setAttribute("time", time);
        session.setAttribute("date", date);
        session.setAttribute("userName", userName);
        session.setAttribute("userEmail", userEmail);
        session.setAttribute("userPhone", userPhone);

        response.sendRedirect("paypalRedirect.jsp"); // Forward to PayPal

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
        if (checkSeatStmt != null) try { checkSeatStmt.close(); } catch (SQLException ignore) {}
        if (holdSeatStmt != null) try { holdSeatStmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>