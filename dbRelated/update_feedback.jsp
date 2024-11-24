<%@ page import="java.sql.*" %>
<%@ include file="../checkRole.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update Feedback</title>
</head>
<body>
    <h1>Update Feedback</h1>
    <%
    try {
        // Get parameters from the form
        int feedbackId = Integer.parseInt(request.getParameter("feedback_id"));
        int userId1 = Integer.parseInt(request.getParameter("user_id"));
        int serviceId = Integer.parseInt(request.getParameter("service_id"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comments = request.getParameter("comments");
        String feedbackDate = request.getParameter("feedback_date");
        int bookingId = Integer.parseInt(request.getParameter("booking_id"));

        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
        Connection conn = DriverManager.getConnection(connURL);

        // Update query
        String query = "UPDATE feedback SET user_id = ?, service_id = ?, rating = ?, comments = ?, feedback_date = ?, booking_id = ? WHERE feedback_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, userId1);
        pstmt.setInt(2, serviceId);
        pstmt.setInt(3, rating);
        pstmt.setString(4, comments);
        pstmt.setString(5, feedbackDate);
        pstmt.setInt(6, bookingId);
        pstmt.setInt(7, feedbackId);

        int rowsUpdated = pstmt.executeUpdate();

        if (rowsUpdated > 0) {
            response.sendRedirect("manage_feedback.jsp?success= updated!");
        } else {
        	response.sendRedirect("manage_feedback.jsp?error= error encountered");
        }

        // Close resources
        pstmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<div style='color:red;'>Error: " + e.getMessage() + "</div>");
    }
    %>
    <a href="manage_service.jsp">Back to Manage Feedback</a>
</body>
</html>
