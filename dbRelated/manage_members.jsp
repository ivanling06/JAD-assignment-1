<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Members</title>
<%@ include file="../checkRole.jsp" %>
    <link rel="stylesheet" href="../css/navbarAdminStyles.css">
    <link rel="stylesheet" href="../css/adminStyles.css">
<style>

*{
    font-family: 'Poppins', sans-serif;
}

body{
    margin-right: 30px;
    margin-left: 30px;
}
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 2rem;
    background-color: #ffffff;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    border-radius: 8px;
    overflow: hidden;
}

table th, table td {
    padding: 1rem;
    text-align: left;
    border-bottom: 1px solid #e0e0e0;
}

table th {
    background-color: #0057b8;
    color: #ffffff;
    font-weight: bold;
}

table tr:hover {
    background-color: #f4f7fb;
}

table td:last-child {
    text-align: center;
}

/* Button styling for actions */
button {
    background-color: #007bff;
    color: #ffffff;
    border: none;
    padding: 0.5rem 1rem;
    font-size: 0.9rem;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
}

button:hover {
    background-color: #0056b3;
}

/* Table Input Styling */
table input[type="text"],
table input[type="number"],
table textarea,
table select {
    padding: 0.5rem;
    font-size: 1rem;
    border: 1px solid #ccc;
    border-radius: 5px;
    transition: border-color 0.3s;
    font-family: 'Poppins', sans-serif;
    width: 100%; /* Ensures the fields span the table cell */
    box-sizing: border-box;
    background-color: #f9f9f9; /* Light background for contrast */
}

/* Focus styling for table inputs */
table input[type="text"]:focus,
table input[type="number"]:focus,
table textarea:focus,
table select:focus {
    border-color: #007bff;
    outline: none;
    box-shadow: 0 0 4px rgba(0, 123, 255, 0.2);
}
</style>  
</head>
<body>
    <%@include file="../adminNavbar.html" %>
    <%@ page import="java.sql.*" %>
    
        <%
        

    	if (userId == null) {
    	    // Redirect to login page
    	    response.sendRedirect("../logIn/login.jsp");
    	    return; // Stop further execution
    	}
    	
        // Check if a userId was passed in the request
        String userIdParam = request.getParameter("userId");
        if (userIdParam != null && !userIdParam.isEmpty()) {
        
            // Optionally redirect to addNewAdmin.jsp
            response.sendRedirect("addNewAdmin.jsp?userIdParam="+userIdParam);
            return; // Prevent further processing of this page
        }
    %>

    <%
    	int id;
    	String email, phoneNumber, registerDate, role;

        try {
            // Step 1: Load JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Step 2: Define Connection URL
            String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";

            // Step 3: Establish connection to URL
            Connection conn = DriverManager.getConnection(connURL);

            // Step 4: Create Statement object
            Statement stmt = conn.createStatement();

            // Step 5: Execute SQL Command
            String sqlStr = "SELECT * FROM user " +
                "ORDER BY user_id ASC";
            ResultSet rs = stmt.executeQuery(sqlStr);
    %>
	<h1 style="margin-top: 100px;">Manage Members</h1>
    <table>
        <tr>
            <th>User ID</th>
            <th>Username</th>
            <th>Email</th>
            <th>Phone Number</th>
            <th>Registration date</th>
            <th>Role</th>
            <th>Update/Delete</th>
            <th>Remove/Add As Admin</th>
        </tr>
        
        <%
            while (rs.next()) {
                id = rs.getInt("user_id");
                username = rs.getString("username");
                email = rs.getString("email");
                phoneNumber = rs.getString("phone_number");
                registerDate = rs.getString("registration_date");
                role = rs.getString("role");
        %>
        <tr>
        	<td><input type="text" name="user_id" value="<%= id %>" readonly></td>
        	<td><input type="text" name="username" value="<%= username %>" required></td>
            <td><input type="text" name="email" value="<%= email %>" required></td>
            <td><input type="number" name="phoneNumber" value="<%= phoneNumber %>" required></td>
            <td><input type="text" name="registration_date" value="<%= registerDate %>" readonly></td>
            <td><input type="text" name="role" value="<%= role %>" readonly></td>
            <td>
      		 	<button style="background-color: #0057b8;" onclick="location.href='update_user.jsp?passedId=<%= id %>'">Update</button>
      		 	<button style="background-color: #dc3545;" onclick="location.href='delete_user.jsp?passedId=<%= id %>'">Delete</button>
            </td>
            <td>
      		 	<button style="background-color: #0057b8;" onclick="location.href='addNewAdmin.jsp?passedId=<%= id %>'">Add</button>
      		 	<button style="background-color: #dc3545;" onclick="location.href='removeAdmin.jsp?passedId=<%= id %>'">Remove</button>
            </td>
        </tr>
        <%
            }
            
            // Step 7: Close resources
            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
        }
    %>
    </table>
</body>
</html>
