<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update User</title>
</head>
<body>
    <%@ page import="java.sql.*" %>
    <%@ include file="../checkRole.jsp" %>
    <%
    try {
        // Load the MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Connection string
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
        Connection conn = DriverManager.getConnection(connURL);

        // Fetch parameters
        String newUsername = request.getParameter("username");
        String email = request.getParameter("email");
        String phoneNumberStr = request.getParameter("phone_number");
        String userIdStr = request.getParameter("user_id");

        // Validate input data
        if (newUsername == null || newUsername.trim().isEmpty()) {
            throw new Exception("Invalid username provided.");
        }
        if (email == null || !email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
            throw new Exception("Invalid email provided.");
        }
        if (phoneNumberStr == null || !phoneNumberStr.matches("\\d{8}")) {
            throw new Exception("Invalid phone number provided.");
        }
        if (userIdStr == null || !userIdStr.matches("\\d+")) {
            throw new Exception("Invalid user ID provided.");
        }

        // Parse phone number and user ID
        int phoneNumber = Integer.parseInt(phoneNumberStr);
        int updatedUserId = Integer.parseInt(userIdStr);

        // Secure SQL query using PreparedStatement
        String updateSQL = "UPDATE user SET username = ?, email = ?, phone_number = ? WHERE user_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(updateSQL);

        pstmt.setString(1, newUsername);    // Update username
        pstmt.setString(2, email);      // Update email
        pstmt.setInt(3, phoneNumber);   // Update phone number
        pstmt.setInt(4, updatedUserId);        // Ensure correct user_id

        // Execute the query
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            response.sendRedirect("manage_members.jsp?message=success");
        } else {
            out.println("<div style='color:red;'>Update failed. No rows were affected.</div>");
        }

        // Close resources
        pstmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<div style='color:red;'>Error: " + e.getMessage() + "</div>");
    }
    %>
</body>
</html>
