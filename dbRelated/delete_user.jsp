<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Delete User</title>
</head>
<body>
    <%@page import="java.sql.*" %>
    <%@ include file="../checkRole.jsp" %>

    <%
    try {
        // Step 1: Load JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Step 2: Define Connection URL
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?serverTimezone=UTC";
        Connection conn = DriverManager.getConnection(connURL, "root", "root123");

        // Step 3: Prepare SQL Update Query using PreparedStatement
        String deleteSQL = "DELETE FROM user WHERE user_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(deleteSQL);

        // Step 4: Get parameters from the form
       	String userIdStr = request.getParameter("passedId");
        
        System.out.println("Service ID: " + userIdStr);

        // Check if any parameter is missing or null
         if (userIdStr == null || userIdStr.isEmpty()) {
            System.err.println("User ID is missing.");
            throw new Exception("Missing or invalid parameters");
        }

        // Convert service_id to the correct data type
        int userId1 = Integer.parseInt(userIdStr);

        // Step 5: Set parameters for the PreparedStatement
        pstmt.setInt(1, userId1);

        // Debugging: Print out the SQL query being executed
        System.out.println("Executing SQL: " + deleteSQL);

        // Step 6: Execute Update and get number of rows affected
        int rowsAffected = pstmt.executeUpdate();

        // Debugging: Print the number of rows affected
        System.out.println("Rows affected: " + rowsAffected);
    %>
        <div class="debugBox">
            <div>Num rows affected: <%= rowsAffected %></div>
        </div>

        <div style="border:1px solid red; padding:1em; margin:1em 0;">
            <% if(rowsAffected == 0) { %>
                Delete failed
            <% } else { %>
                Deleted user successfully
                <% 	response.sendRedirect("manage_members.jsp"); %>
            <% } %>
        </div>

    <%
    } catch (SQLIntegrityConstraintViolationException e) {
        System.err.println("SQLIntegrityConstraintViolationException: " + e.getMessage());
    %>
        <div class="debugBox">
            User has bookings... Unable to delete
        </div>
    <%
    } catch (SQLSyntaxErrorException e) {
        System.err.println("SQLSyntaxErrorException: " + e.getMessage());
    %>
        <div class="debugBox">
            Invalid SQL Syntax.
        </div>
    <%
    } catch (Exception e) {
        System.err.println("Error: " + e.getMessage());
    }
    %>

</body>
</html>
