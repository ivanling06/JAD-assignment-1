<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Booking</title>
    <link rel="stylesheet" href="../css/navbarAdminStyles.css">
    <%@ include file="../adminNavbar.html" %>
    <%@ include file="../checkRole.jsp" %>
</head>
<body>
    <%@page import="java.sql.*" %>

    <%
    try {
        // Step 1: Load JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Step 2: Define Connection URL
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
        Connection conn = DriverManager.getConnection(connURL);

        // Step 3: Prepare SQL Update Query
        String updateSQL = "UPDATE booking SET customer_id = ?, service_id = ?, booking_date = ?, booking_time = ?, special_requests = ?, status = ?, feedback = ? WHERE booking_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(updateSQL);

        // Step 4: Get parameters from the request
        String bookingIdStr = request.getParameter("booking_id");
        String customerIdStr = request.getParameter("customer_id");
        String serviceIdStr = request.getParameter("service_id");
        String bookingDate = request.getParameter("booking_date");
        String bookingTime = request.getParameter("booking_time");
        String specialRequests = request.getParameter("special_requests");
        String status = request.getParameter("status");
        String feedback = request.getParameter("feedback");

        if (bookingIdStr == null || customerIdStr == null || serviceIdStr == null || bookingDate == null || bookingTime == null || status == null) {
            throw new Exception("Missing parameters.");
        }

        // Convert parameters to appropriate types
        int bookingId = Integer.parseInt(bookingIdStr);
        int customerId = Integer.parseInt(customerIdStr);
        int serviceId = Integer.parseInt(serviceIdStr);

        // Step 5: Set parameters for the PreparedStatement
        pstmt.setInt(1, customerId);
        pstmt.setInt(2, serviceId);
        pstmt.setString(3, bookingDate);
        pstmt.setString(4, bookingTime);
        pstmt.setString(5, specialRequests != null ? specialRequests : "");
        pstmt.setString(6, status);
        pstmt.setString(7, feedback != null ? feedback : "");
        pstmt.setInt(8, bookingId);

        // Step 6: Execute Update and check the result
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            response.sendRedirect("manage_booking.jsp?success=Successfully updated!");
        } else {
        	response.sendRedirect("manage_booking.jsp?failed");
        }

        pstmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<div style='color:red;'>Error: " + e.getMessage() + "</div>");
    }
    %>
</body>
</html>
