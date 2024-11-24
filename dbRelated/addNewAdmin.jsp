<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add New Admin</title>
</head>
<body>
    <%@ page import="java.sql.*" %>
    <%@ include file="../checkRole.jsp" %>
<%
    String passedId = request.getParameter("passedId");
    if (passedId == null || passedId.isEmpty()) {
        out.println("<p>Error: User ID not provided. Please select a user.</p>");
        return;
    }

    // Ensure logged-in user ID exists in session
    if (userId == null) {
        response.sendRedirect("../logIn/login.jsp");
        return;
    }

    try (Connection conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC")) {
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Check the logged-in user's role
        try (PreparedStatement roleStmt = conn.prepareStatement("SELECT role FROM user WHERE user_id = ?")) {
            roleStmt.setString(1, userId);
            try (ResultSet roleRs = roleStmt.executeQuery()) {
                if (roleRs.next() && !"admin".equalsIgnoreCase(roleRs.getString("role"))) {
                    out.println("<p>Error: You are not authorized to perform this action.</p>");
                    return;
                }
            }
        }

        // Check if target user exists and is not already admin
        try (PreparedStatement checkStmt = conn.prepareStatement("SELECT role FROM user WHERE user_id = ?")) {
            checkStmt.setString(1, passedId);
            try (ResultSet userRs = checkStmt.executeQuery()) {
                if (!userRs.next()) {
                    out.println("<p>Error: Target user not found.</p>");
                    return;
                }
                if ("admin".equalsIgnoreCase(userRs.getString("role"))) {
                    out.println("<p>Error: Target user is already an admin.</p>");
                    return;
                }
            }
        }

        // Update the target user's role to admin
        try (PreparedStatement updateStmt = conn.prepareStatement("UPDATE user SET role = 'admin' WHERE user_id = ?")) {
            updateStmt.setString(1, passedId);
            int rowsAffected = updateStmt.executeUpdate();
            if (rowsAffected > 0) {
                response.sendRedirect("manage_members.jsp");
            } else {
                out.println("<p>Error: Failed to update the user role.</p>");
            }
        }
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>

</body>
</html>
