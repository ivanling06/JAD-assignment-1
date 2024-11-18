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

 .inline-service-form {
    display: flex;
    flex-wrap: wrap;
    align-items: flex-start;
    gap: 1rem;
    padding: 1.5rem;
    background-color: #ffffff;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    width: 100%;
}

.form-group {
    display: flex;
    flex-direction: column;
    flex-basis: 22%; /* Adjust based on how many fields you have */
    min-width: 150px;
}

.inline-service-form textarea {
    resize: horizontal; /* Allows only horizontal resizing */
    min-width: 200px;
    max-width: 300px; /* Prevents the form from breaking */
}

.inline-service-form label {
    font-weight: bold;
    color: #0057b8;
    margin-bottom: 0.5rem;
}

.inline-service-form input[type="text"],
.inline-service-form input[type="number"],
.inline-service-form textarea,
.inline-service-form select {
    padding: 0.5rem;
    font-size: 0.9rem;
    border: 1px solid #ccc;
    border-radius: 5px;
    transition: border-color 0.3s;
}

/* Button styles */
.inline-service-form button {
    padding: 0.5rem 1rem;
    font-size: 0.9rem;
    background-color: #007bff;
    color: #ffffff;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.inline-service-form button:hover {
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
    
   <div class="form-container" style="margin-top: 100px;">
    <h1>Add A New Service</h1>
    <form action="addService.jsp" method="post" class="inline-service-form">
        <div class="form-group">
            <label for="name">Service Name:</label>
            <input type="text" id="name" name="name" required>
        </div>

        <div class="form-group">
            <label for="description">Description:</label>
            <textarea id="description" name="description" rows="4" required></textarea>
        </div>

        <div class="form-group">
            <label for="price">Price:</label>
            <input type="number" id="price" name="price" step="0.01" required>
        </div>

        <div class="form-group">
            <label for="image">Image URL:</label>
            <input type="text" id="image" name="image" required>
        </div>

        <div class="form-group">
            <label for="categoryId">Category:</label>
            <select id="categoryId" name="categoryId" required>
                <option value="1">Home Cleaning</option>
                <option value="2">Office Cleaning</option>
                <option value="3">Specialised Cleaning</option>
            </select>
        </div>

        <button type="submit">Add Service</button>
    </form>
</div>
	
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
