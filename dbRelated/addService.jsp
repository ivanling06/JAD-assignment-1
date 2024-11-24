<%@ page import="java.sql.*" %>
<%
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    double price = Double.parseDouble(request.getParameter("price"));
    String image = request.getParameter("image");
    int categoryId = Integer.parseInt(request.getParameter("categoryId"));

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
        Connection conn = DriverManager.getConnection(connURL);
        
        String sqlStr = "INSERT INTO service (name, description, price, image_path, category_id) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(sqlStr);
        
        pstmt.setString(1, name);
        pstmt.setString(2, description);
        pstmt.setDouble(3, price);
        pstmt.setString(4, image);
        pstmt.setInt(5, categoryId);

        int rowsAffected = pstmt.executeUpdate();
        
        if (rowsAffected > 0) {
            response.sendRedirect("manage_services.jsp?success=added!");
        } else {
        	response.sendRedirect("manage_services.jsp?error= Error");
        }
        
        pstmt.close();
        conn.close();

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>