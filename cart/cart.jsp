<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Cart</title>
    <link rel="stylesheet" href="../css/styles.css">
    <link rel="stylesheet" href="../css/navbarStyles.css">
    <link rel="stylesheet" href="../css/cartStyles.css">
    
</head>
<body>
	<%@ include file="../navbar.jsp" %> 
	<%
    //String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("../logIn/login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);

        // Retrieve cart items for the user
        String sql = "SELECT * FROM cart WHERE user_id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, userId);
        rs = stmt.executeQuery();
%>
    <h1>Your Cart</h1>
    <table border="1">
        <tr>
            <th>Service</th>
            <th>Date</th>
            <th>Time</th>
            <th>Quantity</th>
            <th>Special Requests</th>
            <th>Actions</th>
        </tr>
        <%
            while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("service_id") %></td>
            <td><%= rs.getDate("booking_date") %></td>
            <td><%= rs.getTime("booking_time") %></td>
            <td><%= rs.getInt("quantity") %></td>
            <td><%= rs.getString("special_requests") %></td>
            <td>
                <a href="editCartItem.jsp?cartId=<%= rs.getInt("cart_id") %>">Edit</a>
                <a href="deleteCartItem.jsp?cartId=<%= rs.getInt("cart_id") %>">Delete</a>
            </td>
        </tr>
        <%
            }
        %>
    </table>
    <br>
    <form action="checkout.jsp" method="post">
        <button type="submit">Checkout</button>
    </form>
    <%@ include file="../footer.html" %> 
</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
