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
    String loggedInUserId = (String) session.getAttribute("userId"); // Retrieve the session userId
    out.println("<p>Logged-in User ID: " + loggedInUserId + "</p>");

    if (loggedInUserId == null) {
        out.println("<p>Error: You must be logged in to perform this action.</p>");
        return;
    }

    // Step 2: Database connection and role check for logged-in user
    try {
        // Connect to the database
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
        Connection conn = DriverManager.getConnection(connURL);

        // Query to get the logged-in user's role using the session userId
        String roleQuery = "SELECT role FROM user WHERE user_id = ?";
        PreparedStatement roleStmt = conn.prepareStatement(roleQuery);
        roleStmt.setString(1, loggedInUserId); // Use the logged-in user ID from session
        ResultSet roleResultSet = roleStmt.executeQuery();

        if (roleResultSet.next()) {
            String loggedInUserRole = roleResultSet.getString("role");
            out.println("<p>Debug: Role retrieved from database = '" + loggedInUserRole + "'</p>");  // Check the exact value

            // Check if the logged-in user is an admin
             if (!"admin".equalsIgnoreCase(loggedInUserRole)) {
                out.println("<p>Error: You do not have permission to perform this action.</p>");
                roleResultSet.close();
                roleStmt.close();
                conn.close();
                return;
            }
        } else {
            out.println("<p>Error: Logged-in user not found in the database.</p>");
            roleResultSet.close();
            roleStmt.close();
            conn.close();
            return;
        }

        roleResultSet.close();
        roleStmt.close();

        // Step 3: Retrieve and validate the userId parameter
        String userIdParam = request.getParameter("passedId");
        if (userIdParam == null || userIdParam.isEmpty()) {
            out.println("<p>Error: User ID not provided. Please go back and select a user.</p>");
            return;
        }

        int userId1;
        try {
            userId1 = Integer.parseInt(userIdParam); // Safely parse the ID from the request parameter
        } catch (NumberFormatException e) {
            out.println("<p>Error: Invalid User ID format.</p>");
            return;
        }

        // Debugging output (Optional: Remove in production)
        out.println("<p>Debug: Logged-in User ID = " + loggedInUserId + "</p>");
        out.println("<p>Debug: Received User ID to update = " + userId + "</p>");

        // Step 4: Database logic to check and update the role
        // Validate that the target user exists and is not already an admin
        String checkUserSql = "SELECT role FROM user WHERE user_id = ?";
        PreparedStatement checkStmt = conn.prepareStatement(checkUserSql);
        checkStmt.setInt(1, userId1);
        ResultSet rs = checkStmt.executeQuery();

        if (!rs.next()) {
            out.println("<p>Error: No user found with the given ID.</p>");
            rs.close();
            checkStmt.close();
            conn.close();
            return;
        }

        String currentRole = rs.getString("role");
        if (currentRole.equals("customer")) {
            out.println("<p>Error: User is already an customer.</p>");
            rs.close();
            checkStmt.close();
            conn.close();
            return;
        }

        rs.close();
        checkStmt.close();

        // Update the target user's role to "customer"
        String updateSql = "UPDATE user SET role = ? WHERE user_id = ?";
        PreparedStatement updateStmt = conn.prepareStatement(updateSql);
        updateStmt.setString(1, "customer");
        updateStmt.setInt(2, userId1);

        int rowsAffected = updateStmt.executeUpdate();

        if (rowsAffected > 0) {
            out.println("<p>Success: User role updated to customer.</p>");
        } else {
            out.println("<p>Error: Failed to update the user role.</p>");
        }

        updateStmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
</body>
</html>
