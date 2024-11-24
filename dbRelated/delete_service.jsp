<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="../checkRole.jsp" %>
<%
    String serviceId = request.getParameter("service_id");

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);

        String sql = "DELETE FROM service WHERE service_id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, serviceId);

        int rowsDeleted = stmt.executeUpdate();
        if (rowsDeleted > 0) {
            response.sendRedirect("manage_services.jsp?success= deleted"); // Redirect back to the cart page
        } else {
        	response.sendRedirect("manage_services.jsp?error= failed to delete");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
