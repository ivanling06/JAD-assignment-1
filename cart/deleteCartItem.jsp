<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String cartId = request.getParameter("cartId");

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);

        String sql = "DELETE FROM cart WHERE cart_id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, cartId);

        int rowsDeleted = stmt.executeUpdate();
        if (rowsDeleted > 0) {
            response.sendRedirect("cart.jsp"); // Redirect back to the cart page
        } else {
            out.println("<p>Failed to delete the cart item.</p>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
