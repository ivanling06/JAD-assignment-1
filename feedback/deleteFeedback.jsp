<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Delete Feedback</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 2rem;
	text-align: center;
}

.message {
	margin-top: 2rem;
	font-size: 1.2rem;
}

.success {
	color: #28a745;
}

.error {
	color: #dc3545;
}

a {
	color: #007bff;
	text-decoration: none;
}

a:hover {
	text-decoration: underline;
}
</style>
</head>
<body>
	<%
    // Check if the user is logged in
    String userIdStr = (String) session.getAttribute("userId");
if (userIdStr == null) {
    // Redirect to login with a query parameter
    response.sendRedirect("../logIn/login.jsp?error=notLoggedIn");
    return;
}

    int sessionUserId = Integer.parseInt(userIdStr);

    // Get the feedback_id from the request
    String feedbackIdStr = request.getParameter("feedback_id");
    if (feedbackIdStr == null || feedbackIdStr.isEmpty()) {
        response.sendRedirect("feedback.jsp?errorCode=4"); // Invalid access
        return;	
    }

    int feedbackId = Integer.parseInt(feedbackIdStr);

    // Database connection
    String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";

    try (Connection conn = DriverManager.getConnection(connURL)) {
        System.out.println("Database connection established.");

        // Validate that feedback belongs to the logged-in user
        String validateSql = "SELECT user_id FROM feedback WHERE feedback_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(validateSql)) {
            pstmt.setInt(1, feedbackId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (!rs.next()) {
                    response.sendRedirect("feedback.jsp?errorCode=5"); // Feedback not found
                    return;
                }

                int feedbackOwnerId = rs.getInt("user_id");
                if (feedbackOwnerId != sessionUserId) {
                    response.sendRedirect("feedback.jsp?errorCode=6"); // Unauthorized access
                    return;
                }
            }
        }

        // Step 1: Clear the foreign key reference in the booking table
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
                response.sendRedirect("feedback.jsp?success=Feedback deleted successfully!");
                return;
            } else {
                request.setAttribute("error", "Failed to delete feedback. Please try again.");
            }
        }
    } catch (Exception e) {
        System.err.println("An unexpected error occurred: " + e.getMessage());
        e.printStackTrace(); // Debugging
        request.setAttribute("error", "An unexpected error occurred. Please try again.");
    }
%>

	<div
		class="message <%= request.getAttribute("error") != null ? "error" : "success" %>">
		<%= request.getAttribute("error") != null ? request.getAttribute("error") : "Feedback deleted successfully." %>
	</div>
	<a href="feedback.jsp">Go back to Feedback</a>
</body>
</html>
