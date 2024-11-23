<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Step 1: Check if the user is logged in
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("../logIn/login.jsp");
        return;
    }

    // Step 2: Fetch parameters from the request
    String serviceId = request.getParameter("serviceId");
    String bookingDate = request.getParameter("bookingDate");
    String bookingTime = request.getParameter("bookingTime");
    String specialRequests = request.getParameter("specialRequests");
    int quantity;

    try {
        quantity = Integer.parseInt(request.getParameter("quantity"));
    } catch (NumberFormatException e) {
        response.sendRedirect("../services/addToCart.jsp?error=Invalid quantity.");
        return;
    }

    // Database variables
    Connection conn = null;
    PreparedStatement checkStmt = null;
    PreparedStatement insertCartStmt = null;
    ResultSet rs = null;

    try {
        // Step 3: Establish a database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);
        conn.setAutoCommit(false); // Enable transaction management

        // Step 4: Check for existing booking with the same date and time
        String checkSql = "SELECT COUNT(*) AS count " +
                      "FROM booking b " +
                      "WHERE b.booking_date = ? AND b.booking_time = ? " +
                      "UNION ALL " +
                      "SELECT COUNT(*) AS count " +
                      "FROM cart c " +
                      "WHERE c.booking_date = ? AND c.booking_time = ?";
        checkStmt = conn.prepareStatement(checkSql);
        checkStmt.setString(1, bookingDate);
        checkStmt.setString(2, bookingTime);
        checkStmt.setString(3, bookingDate);
        checkStmt.setString(4, bookingTime);
        rs = checkStmt.executeQuery();

        int totalConflicts = 0;
        while (rs.next()) {
            totalConflicts += rs.getInt("count");
        }

        if (totalConflicts > 0) {
        	response.sendRedirect("../services/addToCart.jsp?error=Entry already exists for the selected date and time.&serviceId=" + serviceId);

        } else {
            // Step 5: Insert into the `cart` table
            String insertCartSql = "INSERT INTO cart (user_id, service_id, booking_date, booking_time, quantity, special_requests) " +
                                   "VALUES (?, ?, ?, ?, ?, ?)";
            insertCartStmt = conn.prepareStatement(insertCartSql);
            insertCartStmt.setString(1, userId);
            insertCartStmt.setString(2, serviceId);
            insertCartStmt.setString(3, bookingDate);
            insertCartStmt.setString(4, bookingTime);
            insertCartStmt.setInt(5, quantity);
            insertCartStmt.setString(6, specialRequests);

            int rowsInserted = insertCartStmt.executeUpdate();
            if (rowsInserted > 0) {
                conn.commit(); // Commit transaction
                response.sendRedirect("../services/allServices.jsp?success=Added to cart!");
            } else {
                conn.rollback(); // Rollback transaction on failure
                response.sendRedirect("../services/addToCart.jsp?error=Failed to add cart entry. Please try again.");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("../services/addToCart.jsp?error=An error occurred. Please try again later.");
    } finally {
        // Step 6: Cleanup resources
        try {
            if (rs != null) rs.close();
            if (checkStmt != null) checkStmt.close();
            if (insertCartStmt != null) insertCartStmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
