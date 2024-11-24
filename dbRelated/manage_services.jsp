<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Services</title>
<%@ include file="../checkRole.jsp" %>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="../css/navbarAdminStyles.css">
<link rel="stylesheet" href="../css/adminStyles.css">
<style>
/* Apply Poppins font to the entire page */
body {
    margin-right: 30px;
    margin-left: 30px;
    font-family: 'Poppins', sans-serif;
}

/* Table styling */
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
    font-weight: 600;
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
    font-family: 'Poppins', sans-serif;
    font-weight: 500;
}

button:hover {
    background-color: #0056b3;
}

/* Form styling */
.inline-service-form {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
}

.form-container {
    width: 100%; /* Matches table width */
    max-width: 100%; /* Prevents overflow */
    margin-top: 2rem; /* Adjust vertical spacing */
    background-color: #ffffff;
    padding: 1.5rem;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    box-sizing: border-box; /* Ensures padding doesn't affect the width */
}

/* Label styling */
.inline-service-form label {
    font-weight: 600;
    color: #0057b8;
    margin-bottom: 0.5rem;
    font-family: 'Poppins', sans-serif;
}

/* Input and Textarea styling */
.inline-service-form input[type="text"],
.inline-service-form input[type="number"],
.inline-service-form textarea,
.inline-service-form select {
    padding: 0.5rem;
    font-size: 1rem;
    border: 1px solid #ccc;
    border-radius: 5px;
    transition: border-color 0.3s;
    width: 100%;
    box-sizing: border-box;
    font-family: 'Poppins', sans-serif;
}

/* Focus styling for inputs */
.inline-service-form input[type="text"]:focus,
.inline-service-form input[type="number"]:focus,
.inline-service-form textarea:focus,
.inline-service-form select:focus {
    border-color: #007bff;
    outline: none;
    box-shadow: 0 0 4px rgba(0, 123, 255, 0.2);
}

.inline-service-form textarea {
    resize: vertical;
    max-width: 100%;
    min-height: 100px;
}

/* Submit Button styling */
.inline-service-form button {
    padding: 0.7rem 1.5rem;
    font-size: 1rem;
    background-color: #007bff;
    color: #ffffff;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
    align-self: flex-start;
    font-family: 'Poppins', sans-serif;
    font-weight: 600;
}

.inline-service-form button:hover {
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

.btn-save, .btn-delete {
    padding: 6px 12px;
    border: none;
    cursor: pointer;
    text-align: center;
    font-size: 14px;
    margin: 5px;
}

.btn-save {
    background-color: #4CAF50;
    color: white;
}

.btn-save:hover {
    background-color: #45a049;
}

.btn-delete {
    background-color: #f44336;
    color: white;
}

.btn-delete:hover {
    background-color: #e53935;
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
           String sqlStr = "SELECT s.service_id, s.name, s.description, s.price, sc.name, s.image_path, s.category_id " +
                "FROM service s " +
                "JOIN service_category sc ON s.category_id = sc.category_id " +
                "WHERE 1=1 " + 
                "ORDER BY s.service_id ASC";
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
            <th>Image Path</th>
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
        <form action="update_service.jsp" method="post">
        <!-- Hidden field for service ID -->
        <td><input type="hidden" name="service_id" value="<%= id %>"><%= id %></td>

        <!-- Editable fields -->
        <td><input type="text" name="name" value="<%= name %>" required></td>
        <td><input type="text" name="description" value="<%= description %>" required></td>
        <td><input type="number" name="price" value="<%= price %>" required></td>
        <td><input type="text" name="image" value="<%= image %>" required></td>
        <td><img src="..<%= image %>" class="table-image class-table"></td>

        <!-- Category dropdown -->
        <td>
            <select name="category_id" required>
                <option value="1" <%=(categoryId == 1) ? "selected" : ""%>>Home Cleaning</option>
                <option value="2" <%=(categoryId == 2) ? "selected" : ""%>>Office Cleaning</option>
                <option value="3" <%=(categoryId == 3) ? "selected" : ""%>>Specialized Cleaning</option>
            </select>
        </td>

        <!-- Update button -->
        <td>
            <button type="submit">Update</button>
            <form action="delete_service.jsp" method="post" style="display: inline;">
            <input type="hidden" name="service_id" value="<%= id %>">
            <input type="submit" value="Delete" class="btn-delete" 
                   onclick="return confirm('Are you sure you want to delete this service?')">
        </form>
        </td>
    </form>
	
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
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Get all input fields of type number
        const numberInputs = document.querySelectorAll('input[type="number"]');

        // Add an event listener to each number input
        numberInputs.forEach(input => {
            // Prevent invalid keys from being pressed
            input.addEventListener('keydown', function(event) {
                if (
                    event.key === 'e' || 
                    event.key === 'E' || 
                    event.key === '+' || 
                    event.key === '-'
                ) {
                    event.preventDefault();
                }
            });

            // Optional: Clean up invalid characters if pasted into the field
            input.addEventListener('input', function() {
                this.value = this.value.replace(/[eE+\-]/g, '');
            });
        });
    });
</script>
</html>
