<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%

	String userId = (String) session.getAttribute("userId");
	if (userId == null) {
	    // Redirect to login page
	    response.sendRedirect("../logIn/login.jsp");
	    return; // Stop further execution
	}

    String serviceId = request.getParameter("serviceId");
    String serviceName = request.getParameter("serviceName");
    String price = request.getParameter("price");
    String status = "PENDING"; // Default status
    String bookingDate = new java.sql.Date(System.currentTimeMillis()).toString();
    String bookingTime = new java.sql.Time(System.currentTimeMillis()).toString();
    String specialRequests = ""; // Example field, modify as needed

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);

        String sqlStr = "INSERT INTO booking (customer_id, service_id, booking_date, booking_time, special_requests, status, created_at) " +
                        "VALUES (?, ?, ?, ?, ?, ?, NOW())";
        pstmt = conn.prepareStatement(sqlStr);
        pstmt.setString(1, userId);
        pstmt.setString(2, serviceId);
        pstmt.setString(3, bookingDate);
        pstmt.setString(4, bookingTime);
        pstmt.setString(5, specialRequests);
        pstmt.setString(6, status);

        int rowsInserted = pstmt.executeUpdate();
        if (rowsInserted > 0) {
            out.println("<h3>Service added to cart successfully!</h3>");
        } else {
            out.println("<h3>Failed to add service to cart. Please try again.</h3>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h3>An error occurred. Please try again later.</h3>");
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
<a href="allServices.jsp">Back to Services</a>
