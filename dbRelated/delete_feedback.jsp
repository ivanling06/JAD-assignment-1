<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Delete Feedback</title>
    <%@ include file="../checkRole.jsp" %>
</head>
<body>
    <h1>Delete Feedback</h1>
    <%
    try {
        // Get the feedback_id from the request
        int feedbackId = Integer.parseInt(request.getParameter("feedback_id"));

        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
        Connection conn = DriverManager.getConnection(connURL);

        // Step 1: Clear foreign key reference in booking table
        String clearBookingSql = "UPDATE booking SET feedback_id = NULL WHERE feedback_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(clearBookingSql)) {
            pstmt.setInt(1, feedbackId);
            pstmt.executeUpdate();
            System.out.println("Cleared foreign key reference in booking table for feedback_id=" + feedbackId);
        }

        // Step 2: Delete the feedback
        String deleteSql = "DELETE FROM feedback WHERE feedback_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(deleteSql)) {
            pstmt.setInt(1, feedbackId);
            int rowsDeleted = pstmt.executeUpdate();

            if (rowsDeleted > 0) {
                System.out.println("Successfully deleted feedback_id=" + feedbackId);
                response.sendRedirect("manage_feedback.jsp?success=Feedback deleted successfully!");
                return;
            } else {
            	response.sendRedirect("manage_feedback.jsp?error=failed");
            }
        }
    } catch (Exception e) {
        System.err.println("An unexpected error occurred: " + e.getMessage());
        e.printStackTrace();
        request.setAttribute("error", "An unexpected error occurred. Please try again.");
    }
%>
</body>
</html>
