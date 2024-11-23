<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>All Services</title>
    <link rel="stylesheet" href="../css/services.css"> 
    <link rel="stylesheet" href="../css/navbarStyles.css"><!-- Link to external CSS -->
</head>
<body>
<%@ include file="../navbar.jsp" %>  

    <h1>All Services</h1>
    <div class="services">
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            int currentPage = 1; // Default to the first page
            int pageSize = 12; // Number of services per page
            int totalPages = 1; // Default total pages

            // Get the current page from the query string
            if (request.getParameter("page") != null) {
                currentPage = Integer.parseInt(request.getParameter("page"));
            }

            int offset = (currentPage - 1) * pageSize; // Calculate the offset for the query

            try {
                // Load JDBC Driver
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Define Connection URL
                String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
                conn = DriverManager.getConnection(connURL);

                // Prepare SQL to fetch services with pagination
                String sqlStr = "SELECT * FROM service LIMIT ? OFFSET ?";
                pstmt = conn.prepareStatement(sqlStr);
                pstmt.setInt(1, pageSize); // Set the limit
                pstmt.setInt(2, offset);  // Set the offset

                // Execute query
                rs = pstmt.executeQuery();

                // Loop through results and display them
                while (rs.next()) {
                	String serviceId = rs.getString("service_id");
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
                        <!-- Add to Cart button -->
				        <form action="addToCart.jsp" method="POST" class="add-to-cart-form">
				            <input type="hidden" name="serviceId" value="<%= serviceId %>">
				            <input type="hidden" name="serviceName" value="<%= serviceName %>">
				            <input type="hidden" name="price" value="<%= price %>">
				            <button type="submit" class="add-to-cart-button">Add to Cart</button>
				        </form>
                    </div>
                    
        <%
                }

                // Calculate total number of pages
                String countQuery = "SELECT COUNT(*) AS total FROM service";
                Statement countStmt = conn.createStatement();
                ResultSet countRs = countStmt.executeQuery(countQuery);
                int totalServices = 0;
                if (countRs.next()) {
                    totalServices = countRs.getInt("total");
                }
                totalPages = (int) Math.ceil((double) totalServices / pageSize);

                countRs.close();
                countStmt.close();
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

    <!-- Pagination Links -->
<div class="pagination">
    <ul>
        <% if (currentPage > 1) { %>
            <li><a href="?page=<%= currentPage - 1 %>">Previous</a></li>
        <% } else { %>
            <li class="disabled"><span>Previous</span></li>
        <% } %>

        <% 
            for (int i = 1; i <= totalPages; i++) { 
                if (i == currentPage) { 
        %>
            <li class="active"><span><%= i %></span></li>
        <% 
                } else { 
        %>
            <li><a href="?page=<%= i %>"><%= i %></a></li>
        <% 
                } 
            } 
        %>

        <% if (currentPage < totalPages) { %>
            <li><a href="?page=<%= currentPage + 1 %>">Next</a></li>
        <% } else { %>
            <li class="disabled"><span>Next</span></li>
        <% } %>
    </ul>
</div>



    <%@ include file="../footer.html" %>  
</body>
</html>