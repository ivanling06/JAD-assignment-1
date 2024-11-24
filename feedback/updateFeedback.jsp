<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.time.LocalDate"%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Feedback</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 2rem;
        }

        .form-container {
            max-width: 600px;
            margin: auto;
            padding: 1.5rem;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .form-container h1 {
            text-align: center;
            color: #333;
        }

        .form-container label {
            font-weight: bold;
            margin-bottom: 0.5rem;
            display: block;
        }

        .form-container input, .form-container textarea, .form-container select {
            width: 100%;
            padding: 0.5rem;
            margin-bottom: 1rem;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .form-container button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 0.7rem 1.5rem;
            font-size: 1rem;
            border-radius: 5px;
            cursor: pointer;
        }

        .form-container button:hover {
            background-color: #0056b3;
        }

        .error {
            color: #dc3545;
            margin-bottom: 1rem;
        }

        .success {
            color: #28a745;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
<%
    // Check if the user is logged in
    String userIdStr = (String) session.getAttribute("userId");
    if (userIdStr == null) {
        // Redirect to login if not authenticated
        response.sendRedirect("../logIn/login.jsp");
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

    String currentComments = null;
    int currentRating = 0;

    try (Connection conn = DriverManager.getConnection(connURL)) {
        // Validate that feedback belongs to the logged-in user
        String fetchFeedbackSql = "SELECT comments, rating, user_id FROM feedback WHERE feedback_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(fetchFeedbackSql)) {
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

                // Get existing values
                currentComments = rs.getString("comments");
                currentRating = rs.getInt("rating");
            }
        }

        // If it's a POST request, handle the update
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String updatedComments = request.getParameter("comments");
            String updatedRatingStr = request.getParameter("rating");

            if (updatedComments == null || updatedRatingStr == null) {
                request.setAttribute("error", "All fields are required.");
            } else {
                int updatedRating = Integer.parseInt(updatedRatingStr);
                LocalDate updatedDate = LocalDate.now();

                String updateSql = "UPDATE feedback SET comments = ?, rating = ?, feedback_date = ? WHERE feedback_id = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
                    pstmt.setString(1, updatedComments);
                    pstmt.setInt(2, updatedRating);
                    pstmt.setDate(3, java.sql.Date.valueOf(updatedDate));
                    pstmt.setInt(4, feedbackId);

                    int rowsUpdated = pstmt.executeUpdate();
                    if (rowsUpdated > 0) {
                        response.sendRedirect("feedback.jsp?success=Feedback updated successfully!");
                        return;
                    } else {
                        request.setAttribute("error", "Failed to update feedback. Please try again.");
                    }
                }
            }
        }
    } catch (Exception e) {
        request.setAttribute("error", "An unexpected error occurred. Please try again.");
    }
%>

<div class="form-container">
    <h1>Update Feedback</h1>

    <%-- Display error or success messages --%>
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <div class="error"><%= error %></div>
    <%
        }
    %>

    <form method="post">
        <input type="hidden" name="feedback_id" value="<%= feedbackId %>">

        <label for="rating">Rating:</label>
        <select id="rating" name="rating" required>
            <option value="1" <%= (currentRating == 1) ? "selected" : "" %>>1</option>
            <option value="2" <%= (currentRating == 2) ? "selected" : "" %>>2</option>
            <option value="3" <%= (currentRating == 3) ? "selected" : "" %>>3</option>
            <option value="4" <%= (currentRating == 4) ? "selected" : "" %>>4</option>
            <option value="5" <%= (currentRating == 5) ? "selected" : "" %>>5</option>
        </select>

        <label for="comments">Comments:</label>
        <textarea id="comments" name="comments" rows="4" required><%= currentComments %></textarea>

        <button type="submit">Update Feedback</button>
    </form>
</div>
</body>
</html>
