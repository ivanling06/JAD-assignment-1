<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Services</title>
    <link rel="stylesheet" href="../css/navbarAdminStyles.css">
    <link rel="stylesheet" href="../css/adminStyles.css">
</head>
<style>
    table, th, td {
        border: 1px solid black;
        border-collapse: collapse;
    }

    th, td {
        padding: 8px;
        text-align: left;
    }
</style>
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
            <td><%= image %></td>
            <td><%= categoryId %></td>
            <td>
                <button onclick="location.href='editMemberForm.jsp?id=<%= id %>&name=<%= name %>'">Edit</button>
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
