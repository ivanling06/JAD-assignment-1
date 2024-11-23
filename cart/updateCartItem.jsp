<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String cartId = request.getParameter("cartId");
    String serviceId = request.getParameter("serviceId");
    String bookingDate = request.getParameter("bookingDate");
    String bookingTime = request.getParameter("bookingTime");
    String quantity = request.getParameter("quantity");
    String specialRequests = request.getParameter("specialRequests");

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);

        String sql = "UPDATE cart SET service_id = ?, booking_date = ?, booking_time = ?, quantity = ?, special_requests = ? WHERE cart_id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, serviceId);
        stmt.setString(2, bookingDate);
        stmt.setString(3, bookingTime);
        stmt.setString(4, quantity);
        stmt.setString(5, specialRequests);
        stmt.setString(6, cartId);

        int rowsUpdated = stmt.executeUpdate();
        if (rowsUpdated > 0) {
            response.sendRedirect("cart.jsp"); // Redirect back to the cart page
        } else {
            out.println("<p>Failed to update the cart item.</p>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
