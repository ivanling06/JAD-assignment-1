<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Cart Item</title>
    <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
    <h1>Edit Cart Item</h1>
    <%
        String cartId = request.getParameter("cartId");
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
            conn = DriverManager.getConnection(connURL);

            // Retrieve the specific cart item details
            String sql = "SELECT * FROM cart WHERE cart_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, cartId);
            rs = stmt.executeQuery();

            if (rs.next()) {
    %>
    <form action="updateCartItem.jsp" method="post">
        <input type="hidden" name="cartId" value="<%= rs.getInt("cart_id") %>">
        <label>Service:</label>
        <input type="text" name="serviceId" value="<%= rs.getString("service_id") %>" required><br>
        <label>Date:</label>
        <input type="date" name="bookingDate" value="<%= rs.getDate("booking_date") %>" required><br>
        <label>Time:</label>
        <input type="time" name="bookingTime" value="<%= rs.getTime("booking_time") %>" required><br>
        <label>Quantity:</label>
        <input type="number" name="quantity" value="<%= rs.getInt("quantity") %>" required><br>
        <label>Special Requests:</label>
        <textarea name="specialRequests"><%= rs.getString("special_requests") %></textarea><br>
        <button type="submit">Update</button>
    </form>
    <%
            } else {
                out.println("<p>Cart item not found!</p>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    %>
</body>
</html>
