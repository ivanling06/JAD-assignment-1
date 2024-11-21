<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Service</title>
<style>
	.debugBox {
		border:1px solid red; padding:1em; margin: 1em 0;
	}
</style>

</head>
<body>
    <%@page import="java.sql.*" %>

    <%
    try {
        // Step 1: Load JDBC Driver
        Class.forName("com.mysql.jdbc.Driver");

        // Step 2: Define Connection URL
        String connURL = "jdbc:mysql://localhost:3306/db1?user=root&password=root123&serverTimezone=UTC";

        // Step 3: Establish connection to URL
        Connection conn = DriverManager.getConnection(connURL);

        // Step 4: Prepare SQL Update Query using PreparedStatement
        String updateSQL = "UPDATE user SET username = ?, email = ?, phone_number = ? WHERE user_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(updateSQL);

        // Step 5: Set parameters from the form
        String name = request.getParameter("name");
        String password = request.getParameter("password");
        int id = Integer.parseInt(request.getParameter("id"));
        
        pstmt.setString(1, name);       // Set name
        pstmt.setString(2, password);   // Set password
        pstmt.setInt(3, id);            // Set id

        // Step 6: Execute Update and get number of rows affected
        int rowsAffected = pstmt.executeUpdate();
%>
        <div class="debugBox">
            <div>Num rows affected: <%= rowsAffected %></div>
        </div>
        
        <div style="border:1px solid red; padding:1em; margin:1em 0;">
            <% if(rowsAffected == 0) { %>
                Update failed
            <% } else { %>
                Update success
            <% } %>   
        </div>
        
    <%
    } catch (SQLIntegrityConstraintViolationException e) {
    %>    	
        <div class="debugBox">
            Duplicate entry... Try again.
        </div>
    <%
    } catch (SQLSyntaxErrorException e) {
    %>	
        <div class="debugBox">
            Invalid SQL Syntax.
        </div>
    <%
    } catch (Exception e) {
        System.err.println("Error :" + e);
    }
%>

</body>
</html>