<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Step 1: Check if the user is logged in
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("../logIn/login.jsp");
        return;
    }

    // Step 2: Fetch and validate parameters from the request
    String cartId = request.getParameter("cartId");
    String serviceId = request.getParameter("serviceId");
    String bookingDate = request.getParameter("bookingDate");
    String bookingTime = request.getParameter("bookingTime");
    String specialRequests = request.getParameter("specialRequests");
    int quantity;

    try {
        if (cartId == null || serviceId == null || bookingDate == null || bookingTime == null) {
            response.sendRedirect("editCartItem.jsp?error=Missing required parameters.&cartId=" + (cartId != null ? cartId : ""));
            return;
        }
        quantity = Integer.parseInt(request.getParameter("quantity"));
    } catch (NumberFormatException e) {
        response.sendRedirect("editCartItem.jsp?error=Invalid quantity.&cartId=" + (cartId != null ? cartId : ""));
        return;
    }

    // Database variables
    Connection conn = null;
    PreparedStatement checkStmt = null;
    PreparedStatement updateStmt = null;
    ResultSet rs = null;

    try {
        // Step 3: Establish a database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);
        conn.setAutoCommit(false); // Enable transaction management

        // Step 4: Check for existing booking conflicts
        String checkSql = "SELECT " +
                          "  (SELECT COUNT(*) FROM booking WHERE booking_date = ? AND booking_time = ?) + " +
                          "  (SELECT COUNT(*) FROM cart WHERE booking_date = ? AND booking_time = ? AND cart_id != ?) AS total_conflicts";
        checkStmt = conn.prepareStatement(checkSql);
        checkStmt.setString(1, bookingDate);
        checkStmt.setString(2, bookingTime);
        checkStmt.setString(3, bookingDate);
        checkStmt.setString(4, bookingTime);
        checkStmt.setString(5, cartId);

        rs = checkStmt.executeQuery();
        int totalConflicts = rs.next() ? rs.getInt("total_conflicts") : 0;

        if (totalConflicts > 0) {
            response.sendRedirect("editCartItem.jsp?error=Entry already exists for the selected date and time.&cartId=" + cartId);
        } else {
            // Step 5: Update the `cart` table
            String updateSql = "UPDATE cart " +
                               "SET service_id = ?, booking_date = ?, booking_time = ?, quantity = ?, special_requests = ? " +
                               "WHERE cart_id = ?";
            updateStmt = conn.prepareStatement(updateSql);
            updateStmt.setString(1, serviceId);
            updateStmt.setString(2, bookingDate);
            updateStmt.setString(3, bookingTime);
            updateStmt.setInt(4, quantity);
            updateStmt.setString(5, specialRequests != null ? specialRequests : ""); // Handle null specialRequests
            updateStmt.setString(6, cartId);

            int rowsUpdated = updateStmt.executeUpdate();
            if (rowsUpdated > 0) {
                conn.commit(); // Commit transaction
                response.sendRedirect("cart.jsp?success=Cart item updated successfully.");
            } else {
                conn.rollback(); // Rollback transaction on failure
                response.sendRedirect("editCartItem.jsp?error=Failed to update cart entry. Please try again.&cartId=" + cartId);
            }
        }
    } catch (Exception e) {
        if (conn != null) {
            try {
                conn.rollback(); // Rollback transaction in case of an exception
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
        }
        e.printStackTrace(); // Log the exception for debugging
        response.sendRedirect("editCartItem.jsp?error=An unexpected error occurred.&cartId=" + (cartId != null ? cartId : ""));
    } finally {
        // Step 6: Cleanup resources
        try {
            if (rs != null) rs.close();
            if (checkStmt != null) checkStmt.close();
            if (updateStmt != null) updateStmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
