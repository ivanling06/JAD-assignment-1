<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.time.LocalDate"%>
<!DOCTYPE html>
<html>
<head>
    <title>Submit Feedback</title>
</head>
<body>
<%
    // Get the session user ID
    String strUserId = (String) session.getAttribute("userId");
    if (strUserId == null) {
        // Redirect to login if no session exists
        response.sendRedirect("../logIn/login.jsp");
        return;
    }

    int sessionUserId = Integer.parseInt(strUserId);

    // Get form data
    String bookingIdStr = request.getParameter("booking_id");
    String comments = request.getParameter("comments");
    String ratingStr = request.getParameter("rating");

    if (bookingIdStr == null || comments == null || ratingStr == null) {
        response.sendRedirect("feedback.jsp?error= all parameters must be filled");
        return;
    }

    int bookingId;
    int rating;
    try {
        bookingId = Integer.parseInt(bookingIdStr);
        rating = Integer.parseInt(ratingStr);
    } catch (NumberFormatException e) {
    	response.sendRedirect("feedback.jsp?error= Invalid input. Booking ID and Rating must be numeric.");
        return;
    }

    LocalDate feedbackDate = LocalDate.now();

    // Database connection details
    String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";

    try (
        Connection conn = DriverManager.getConnection(connURL);
    ) {
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Step 1: Check if feedback already exists
        String checkFeedbackSql = "SELECT feedback_id FROM booking WHERE booking_id = ? AND feedback_id IS NOT NULL";
        try (PreparedStatement pstmt = conn.prepareStatement(checkFeedbackSql)) {
            pstmt.setInt(1, bookingId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                	response.sendRedirect("feedback.jsp?errorCode=1");
                    return;
                }
            }
        }

        // Step 2: Validate booking belongs to the session user and fetch service ID
        String validateSql = "SELECT user_id, service_id FROM booking WHERE booking_id = ?";
        int userIdFromBooking;
        int serviceId;

        try (PreparedStatement pstmt = conn.prepareStatement(validateSql)) {
            pstmt.setInt(1, bookingId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (!rs.next()) {
                	response.sendRedirect("feedback.jsp?errorCode=2");
                    return;
                }
                userIdFromBooking = rs.getInt("user_id");
                serviceId = rs.getInt("service_id");
            }
        }

        if (userIdFromBooking != sessionUserId) {
        	response.sendRedirect("feedback.jsp?errorCode=3");
            return;
        }

        // Step 3: Insert feedback into the feedback table
        String insertSql = "INSERT INTO feedback (booking_id, user_id, service_id, rating, comments, feedback_date) VALUES (?, ?, ?, ?, ?, ?)";
        int feedbackId;
        try (PreparedStatement pstmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, bookingId);
            pstmt.setInt(2, sessionUserId);
            pstmt.setInt(3, serviceId);
            pstmt.setInt(4, rating);
            pstmt.setString(5, comments);
            pstmt.setDate(6, java.sql.Date.valueOf(feedbackDate));

            int rowsInserted = pstmt.executeUpdate();
            if (rowsInserted > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        feedbackId = generatedKeys.getInt(1);
                    } else {
                        out.println("<p>Failed to retrieve feedback ID. Please try again.</p>");
                        return;
                    }
                }
            } else {
                out.println("<p>Failed to submit feedback. Please try again.</p>");
                return;
            }
        }

        // Step 4: Update booking table with feedback ID
        String updateBookingSql = "UPDATE booking SET feedback_id = ? WHERE booking_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(updateBookingSql)) {
            pstmt.setInt(1, feedbackId);
            pstmt.setInt(2, bookingId);

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("feedback.jsp?success=Feedback added successfully!");
            } else {
                response.sendRedirect("feedback.jsp?error=Failed to add feedback. Please try again.");
            }
        }
    } catch (Exception e) {
    	   response.sendRedirect("feedbackForm.jsp?error=Database error: " + e.getMessage());
    }
%>
</body>
</html>
