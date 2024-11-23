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
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Step 2: Define Connection URL
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?serverTimezone=UTC";
        Connection conn = DriverManager.getConnection(connURL, "root", "root123");

        // Step 3: Prepare SQL Update Query using PreparedStatement
        String updateSQL = "UPDATE service SET name = ?, description = ?, price = ?, image_path = ?, category_id = ? WHERE service_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(updateSQL);

        // Step 4: Get parameters from the form
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String image = request.getParameter("image");
        String serviceIdStr = request.getParameter("service_id");
        String categoryIdStr = request.getParameter("category_id");
        

        // Debugging: Check if parameters are null and print their values
        System.out.println("Received data:");
        System.out.println("Name: " + name);
        System.out.println("Description: " + description);
        System.out.println("Price: " + priceStr);
        System.out.println("Image: " + image);
        System.out.println("Service ID: " + serviceIdStr);
        System.out.println("Category ID: " + categoryIdStr);

        // Check if any parameter is missing or null
         if (name == null || description == null || priceStr == null || image == null || serviceIdStr == null || categoryIdStr == null) {
            System.err.println("One or more required parameters are missing.");
            throw new Exception("Missing parameters");
        }

        // Convert price and service_id to the correct data types
        double price = Double.parseDouble(priceStr); 
        int serviceId = Integer.parseInt(serviceIdStr); 
        int categoryId = Integer.parseInt(categoryIdStr);

        // Step 5: Set parameters for the PreparedStatement
        pstmt.setString(1, name);
        pstmt.setString(2, description);
        pstmt.setDouble(3, price);
        pstmt.setString(4, image);
        pstmt.setInt(5, categoryId);
        pstmt.setInt(6, serviceId);

        // Debugging: Print out the SQL query being executed
        System.out.println("Executing SQL: " + updateSQL);

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
                Update failed
            <% } else { %>
                Update success
                <% 	response.sendRedirect("manage_services.jsp"); %>
            <% } %>
        </div>

    <%
    } catch (SQLIntegrityConstraintViolationException e) {
        System.err.println("SQLIntegrityConstraintViolationException: " + e.getMessage());
    %>
        <div class="debugBox">
            Duplicate entry... Try again.
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
