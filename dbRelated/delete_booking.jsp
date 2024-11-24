<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
 <%@page import="java.sql.*" %>
 <!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Booking</title>
    <link rel="stylesheet" href="../css/navbarAdminStyles.css">
    <%@ include file="../adminNavbar.html" %>
    <%@ include file="../checkRole.jsp" %>
</head>
<body>
   
    <%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?serverTimezone=UTC";
        Connection conn = DriverManager.getConnection(connURL, "root", "root123");

        String bookingIdStr = request.getParameter("booking_id");
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            out.println("<div style='color:red;'>Error: Missing or empty booking ID.</div>");
            return;
        }

        int bookingId = Integer.parseInt(bookingIdStr);
        String deleteSQL = "DELETE FROM booking WHERE booking_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(deleteSQL);
        pstmt.setInt(1, bookingId);

        int rowsAffected = pstmt.executeUpdate();
        out.println("<div>Debug: Rows affected = " + rowsAffected + "</div>");

        if (rowsAffected > 0) {
            response.sendRedirect("manage_booking.jsp?success=deleted!");
        } else {
            out.println("<div style='color:red;'>Delete failed. Booking ID not found or already deleted.</div>");
        }

        pstmt.close();
        conn.close();
    } catch (NumberFormatException e) {
        out.println("<div style='color:red;'>Error: Invalid booking ID format. Must be an integer.</div>");
        e.printStackTrace();
    } catch (SQLException e) {
        out.println("<div style='color:red;'>Database error: " + e.getMessage() + "</div>");
        e.printStackTrace();
    } catch (Exception e) {
        out.println("<div style='color:red;'>Unexpected error: " + e.getMessage() + "</div>");
        e.printStackTrace();
    }
    %>
</body>
</html>
