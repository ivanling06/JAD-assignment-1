<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Service</title>
</head>
<body>
    <%@page import="java.sql.*" %>
    <%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
        Connection conn = DriverManager.getConnection(connURL);

        String updateSQL = "UPDATE service SET name = ?, description = ?, price = ?, image_path = ?, category_id = ? WHERE service_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(updateSQL);

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String image = request.getParameter("image");
        String serviceIdStr = request.getParameter("service_id");
        String categoryIdStr = request.getParameter("category_id");

        if (name == null || description == null || priceStr == null || image == null || serviceIdStr == null || categoryIdStr == null) {
            throw new Exception("Missing parameters");
        }

        
        System.out.println("Name: " + request.getParameter("name"));
        System.out.println("Description: " + request.getParameter("description"));
        System.out.println("Price: " + request.getParameter("price"));
        System.out.println("Image: " + request.getParameter("image"));
        System.out.println("Service ID: " + request.getParameter("service_id"));
        System.out.println("Category ID: " + request.getParameter("category_id"));
        
        double price = Double.parseDouble(priceStr);
        int serviceId = Integer.parseInt(serviceIdStr);
        int categoryId = Integer.parseInt(categoryIdStr);

        pstmt.setString(1, name);
        pstmt.setString(2, description);
        pstmt.setDouble(3, price);
        pstmt.setString(4, image);
        pstmt.setInt(5, categoryId);
        pstmt.setInt(6, serviceId);

        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            response.sendRedirect("manage_services.jsp");
        } else {
            out.println("<div style='color:red;'>Update failed. No rows were affected.</div>");
        }

        pstmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<div style='color:red;'>Error: " + e.getMessage() + "</div>");
    }
    %>
</body>
</html>
