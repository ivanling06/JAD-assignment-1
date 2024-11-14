<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Members</title>
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
    background-color: #007bff;
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
</style>    
</head>
<body>
    <%@include file="../adminNavbar.html" %>
    <%@ page import="java.sql.*" %>

    <%
    	int id;
    	String username, email, phoneNumber, registerDate, role;

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
            String sqlStr = "SELECT * FROM user";
            ResultSet rs = stmt.executeQuery(sqlStr);
    %>
	<h1>Manage Members</h1>
    <table>
        <tr>
            <th>User ID</th>
            <th>Username</th>
            <th>Email</th>
            <th>Phone Number</th>
            <th>Registration date</th>
            <th>Role</th>
            <th>Add As Admin</th>
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
            <td><%= id %></td>
            <td><%= username %></td>
            <td><%= email %></td>
            <td><%= phoneNumber %></td>
            <td><%= registerDate %></td>
 			<td><%= role %></td>
            <td>
                <button onclick="location.href='addNewAdmin.jsp?id=<%= id %>&name=<%= username %>'">Add</button>
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
