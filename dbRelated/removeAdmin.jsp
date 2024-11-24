<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Remove Admin</title>
</head>
<body>
    <%@ page import="java.sql.*" %>
    <%@ include file="../checkRole.jsp" %>
<%
    // Step 1: Retrieve logged-in user ID from session
    String loggedInUserId = (String) session.getAttribute("userId");

    if (loggedInUserId == null) {
        out.println("<p>Error: You must be logged in to perform this action.</p>");
        return;
    }

    // Step 2: Database connection and role check for logged-in user
    try {
        // Load the database driver and connect
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";

        try (Connection conn = DriverManager.getConnection(connURL)) {
            // Query to check the logged-in user's role
            String roleQuery = "SELECT role FROM user WHERE user_id = ?";
            try (PreparedStatement roleStmt = conn.prepareStatement(roleQuery)) {
                roleStmt.setString(1, loggedInUserId);

                try (ResultSet roleResultSet = roleStmt.executeQuery()) {
                    if (roleResultSet.next()) {
                        String loggedInUserRole = roleResultSet.getString("role");

                        if (!"admin".equalsIgnoreCase(loggedInUserRole)) {
                            out.println("<p>Error: You do not have permission to perform this action.</p>");
                            return;
                        }
                    } else {
                        out.println("<p>Error: Logged-in user not found in the database.</p>");
                        return;
                    }
                }
            }

            // Step 3: Retrieve and validate the target userId
            String passedId = request.getParameter("passedId");
            if (passedId == null || passedId.isEmpty()) {
                out.println("<p>Error: User ID not provided. Please go back and select a user.</p>");
                return;
            }

            int targetUserId;
            try {
                targetUserId = Integer.parseInt(passedId); // Safely parse the ID
            } catch (NumberFormatException e) {
                out.println("<p>Error: Invalid User ID format.</p>");
                return;
            }

            // Step 4: Check if the target user exists and is currently an admin
            String checkUserSql = "SELECT role FROM user WHERE user_id = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkUserSql)) {
                checkStmt.setInt(1, targetUserId);

                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next()) {
                        out.println("<p>Error: No user found with the given ID.</p>");
                        return;
                    }

                    String currentRole = rs.getString("role");
                    if ("customer".equalsIgnoreCase(currentRole)) {
                        out.println("<p>Error: User is already a customer.</p>");
                        return;
                    }
                }
            }

            // Step 5: Update the target user's role to "customer"
            String updateSql = "UPDATE user SET role = 'customer' WHERE user_id = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setInt(1, targetUserId);

                int rowsAffected = updateStmt.executeUpdate();

                if (rowsAffected > 0) {
                    out.println("<p>Success: User role updated to customer.</p>");
                    response.sendRedirect("manage_members.jsp");
                } else {
                    out.println("<p>Error: Failed to update the user role.</p>");
                }
            }
        }
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
</body>
</html>
