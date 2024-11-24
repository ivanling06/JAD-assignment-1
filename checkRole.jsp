<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
<%
    // Retrieve session userId
    String userId = (String) session.getAttribute("userId");
	String username = (String) session.getAttribute("username");

    if (userId == null) {
        // Redirect if the session is invalid
        response.sendRedirect("../logIn/login.jsp?errCode=invalidLogin");
        return;  // Stop further processing of the page
    }

    // Initialize user variables
    String userRole = null;

    try {
        // Load JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Define Connection URL
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
        Connection conn = DriverManager.getConnection(connURL);

        // Query to retrieve user details using userId
        String sqlStr = "SELECT role, username FROM user WHERE user_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sqlStr);
        pstmt.setString(1, userId);
        ResultSet rs = pstmt.executeQuery();

        // Retrieve user details
        if (rs.next()) {
            userRole = rs.getString("role").trim(); // Trim to avoid whitespace issues
            username = rs.getString("username");
        } else {
            // Redirect if no user found
            response.sendRedirect("../logIn/login.jsp?errCode=invalidLogin");
            return;
        }

        // Close the connection
        conn.close();
    } catch (Exception e) {
        out.println("<h3>An error occurred while retrieving user details.</h3>");
        e.printStackTrace();
        return;
    }

    // Check if the user is an admin
    if (!"Admin".equals(userRole)) { // Use case-sensitive check for security
        response.sendRedirect("../logIn/login.jsp?errCode=invalidLogin");
        return;
    }
%>