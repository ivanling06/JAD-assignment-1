<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("../logIn/login.jsp");
        return;
    }

    String serviceId = request.getParameter("serviceId");
    String bookingDate = request.getParameter("bookingDate");
    String bookingTime = request.getParameter("bookingTime");
    String specialRequests = request.getParameter("specialRequests");
    int quantity = Integer.parseInt(request.getParameter("quantity"));

    Connection conn = null;
    PreparedStatement checkStmt = null;
    PreparedStatement insertBookingStmt = null;
    PreparedStatement insertDetailsStmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);

        // Check if a booking already exists with the same date and time
        String checkSql = "SELECT COUNT(*) AS count FROM booking WHERE booking_date = ? AND booking_time = ?";
        checkStmt = conn.prepareStatement(checkSql);
        checkStmt.setString(1, bookingDate);
        checkStmt.setString(2, bookingTime);
        rs = checkStmt.executeQuery();

        if (rs.next() && rs.getInt("count") > 0) {
            out.println("<h3>Error: A booking already exists for the selected date and time.</h3>");
        } else {
            // Insert into the booking table
            String bookingSql = "INSERT INTO booking (customer_id, service_id, booking_date, booking_time, special_requests, status, created_at) " +
                                "VALUES (?, ?, ?, ?, ?, 'PENDING', NOW())";
            insertBookingStmt = conn.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS);
            insertBookingStmt.setString(1, userId);
            insertBookingStmt.setString(2, serviceId);
            insertBookingStmt.setString(3, bookingDate);
            insertBookingStmt.setString(4, bookingTime);
            insertBookingStmt.setString(5, specialRequests);

            int rowsInserted = insertBookingStmt.executeUpdate();
            if (rowsInserted > 0) {
                // Get the generated booking_id
                ResultSet generatedKeys = insertBookingStmt.getGeneratedKeys();
                int bookingId = 0;
                if (generatedKeys.next()) {
                    bookingId = generatedKeys.getInt(1);
                }

                // Insert into the booking_details table
                String detailsSql = "INSERT INTO booking_details (booking_id, service_id, quantity) VALUES (?, ?, ?)";
                insertDetailsStmt = conn.prepareStatement(detailsSql);
                insertDetailsStmt.setInt(1, bookingId);
                insertDetailsStmt.setString(2, serviceId);
                insertDetailsStmt.setInt(3, quantity);

                int detailsInserted = insertDetailsStmt.executeUpdate();
                if (detailsInserted > 0) {
                    out.println("<h3>Booking added successfully!</h3>");
                    response.sendRedirect("../services/allServices.jsp");
                } else {
                    out.println("<h3>Error: Failed to add booking details.</h3>");
                }
            } else {
                out.println("<h3>Error: Failed to add booking. Please try again.</h3>");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h3>An error occurred. Please try again later.</h3>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (checkStmt != null) checkStmt.close();
            if (insertBookingStmt != null) insertBookingStmt.close();
            if (insertDetailsStmt != null) insertDetailsStmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
<a href="allServices.jsp">Back to Services</a>
