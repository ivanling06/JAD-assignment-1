<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Your Bookings</title>
    <link rel="stylesheet" href="../css/navbarStyles.css">
    <%@ include file="../navbar.jsp" %>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
    </style>
</head>
<body>
    <%
    // Get the user ID from the session

    // Redirect to login if user is not logged in
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Initialize database variables
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // JDBC connection details
    String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";

    // Query to fetch bookings for the logged-in user
    String sqlStr = "SELECT b.booking_id, b.booking_date, b.booking_time, b.special_requests, b.status, s.name, bd.quantity " +
                    "FROM booking b " +
                    "JOIN booking_details bd ON b.booking_id = bd.booking_id " +
                    "JOIN service s ON bd.service_id = s.service_id " +
                    "WHERE b.customer_id = ?";

    try {
        // Establish database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(connURL);

        // Prepare and execute the query
        pstmt = conn.prepareStatement(sqlStr);
        pstmt.setString(1, userId); // Set the user ID parameter
        rs = pstmt.executeQuery();
    %>
    <h1>Your Bookings</h1>
    <table>
        <thead>
            <tr>
                <th>Booking ID</th>
                <th>Service Name</th>
                <th>Booking Date</th>
                <th>Booking Time</th>
                <th>Special Requests</th>
                <th>Status</th>
                <th>Quantity</th>
            </tr>
        </thead>
        <tbody>
        <%
            // Loop through the result set and display bookings
            while (rs.next()) {
        %>
            <tr>
                <td><%= rs.getInt("booking_id") %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getDate("booking_date") %></td>
                <td><%= rs.getTime("booking_time") %></td>
                <td><%= rs.getString("special_requests") %></td>
                <td><%= rs.getString("status") %></td>
                <td><%= rs.getInt("quantity") %></td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <%
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error fetching bookings. Please try again later.</p>");
    } finally {
        // Close resources
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
    %>
</body>
</html>
