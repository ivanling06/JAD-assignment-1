<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Profile</title>
</head>
<body>

<%@ page import="java.sql.*" %>

<%
    // Retrieve form data
    String userId1 = (String) session.getAttribute("userId");
    String userId = request.getParameter("user_id");
    String newName = request.getParameter("name");
    String newEmail = request.getParameter("email");
    String newPhone = request.getParameter("phone");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Load JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Connection URL
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL, "root", "root123");

        // Check if name, email, or phone already exist for another user
        String checkSql = "SELECT COUNT(*) AS count " +
                          "FROM user u " +
                          "WHERE (u.username = ? OR u.email = ? OR u.phone_number = ?) AND u.user_id != ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setString(1, newName);
        pstmt.setString(2, newEmail);
        pstmt.setString(3, newPhone);
        pstmt.setString(4, userId1);
        rs = pstmt.executeQuery();

        rs.next();
        int count = rs.getInt("count");

        if (count > 0) {
            // Redirect back with an error if a conflict is found
            response.sendRedirect("getProfile.jsp?error=The provided name, email, or phone is already in use by another user.");
            return;
        }

        // Proceed to update user info if no conflicts
        String updateSql = "UPDATE user SET username = ?, email = ?, phone_number = ? WHERE user_id = ?";
        pstmt = conn.prepareStatement(updateSql);
        pstmt.setString(1, newName);
        pstmt.setString(2, newEmail);
        pstmt.setString(3, newPhone);
        pstmt.setString(4, userId);

        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            // Redirect to profile page with a success message
            response.sendRedirect("getProfile.jsp?success=Profile updated successfully.");
        } else {
            // Redirect with error message if update failed
            response.sendRedirect("getProfile.jsp?error=Failed to update profile. Please try again.");
        }

    } catch (Exception e) {
        // Handle exceptions
        response.sendRedirect("getProfile.jsp?error=" + e.getMessage());
    }
%>
</body>
</html>
