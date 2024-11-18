<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Services</title>
    <link rel="stylesheet" href="../css/navbarAdminStyles.css">
    <link rel="stylesheet" href="../css/adminStyles.css">
<style>

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

.table-image {
    width: 150px;
    height: 100px;
    object-fit: cover;
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
        String name, description, image;
        double price;
        int categoryId;

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
            String sqlStr = "SELECT * FROM service";
            ResultSet rs = stmt.executeQuery(sqlStr);
    %>
	<h1>Manage Services</h1>
    <table>
        <tr>
            <th>Service ID</th>
            <th>Name</th>
            <th>Description</th>
            <th>Price</th>
            <th>Image</th>
            <th>Category ID</th>
            <th>Action</th>
        </tr>

        <%
            while (rs.next()) {
                id = rs.getInt("service_id");
                name = rs.getString("name");
                description = rs.getString("description");
                price = rs.getDouble("price");
                image = rs.getString("image_path");
                categoryId = rs.getInt("category_id");
        %>
        <tr>
            <td><%= id %></td>
            <td><%= name %></td>
            <td><%= description %></td>
            <td><%= price %></td>
            <td><img src="..<%= image %>" class="table-image"></td>
            <td><%= categoryId %></td>
            <td>
                <button onclick="location.href='editServiceForm.jsp?id=<%= id %>&name=<%= name %>'">Edit</button>
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
