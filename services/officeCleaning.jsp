<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Services</title>
    <link rel="stylesheet" href="../css/services.css"> 
    <link rel="stylesheet" href="../css/navbarStyles.css"><!-- Link to external CSS -->
</head>
<body>
<%@ include file="../navbar.jsp" %>  

    <h1>Our Services</h1>
    <div class="services">
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                // Load JDBC Driver
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Define Connection URL
                String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
                conn = DriverManager.getConnection(connURL);

                // Prepare SQL to fetch service data
                String sqlStr = "SELECT * FROM service WHERE category_id = ?";
                pstmt = conn.prepareStatement(sqlStr);

                // Dynamically set the category_id
                int categoryId = 2;
                pstmt.setInt(1, categoryId);

                // Execute query
                rs = pstmt.executeQuery();

                // Loop through results and display them
                while (rs.next()) {
                    String serviceName = rs.getString("name");
                    String description = rs.getString("description");
                    double price = rs.getDouble("price");
                    String imagePath = rs.getString("image_path");
        %>
                    <div class="service">
                        <img src="..<%= imagePath %>" alt="<%= serviceName %>" class="service-image">
                        <h2><%= serviceName %></h2>
                        <p class="description"><%= description %></p>
                        <p class="price">Price: $<%= price %>0</p>
                    </div>
        <%
                }
            } catch (Exception e) {
                out.println("<h3>An error occurred while retrieving services. Please try again later.</h3>");
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
    </div>
    <%@ include file="../footer.html" %>  
</body>
</html>
