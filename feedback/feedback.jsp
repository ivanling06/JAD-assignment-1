<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Feedback</title>
  <link rel="stylesheet" href="../css/styles.css">
  <link rel="stylesheet" href="../css/navbarStyles.css">
<style>
    .star-rating {
        display: flex;
        justify-content: flex-start;
        align-items: center;
    }

    .star-rating input {
        display: none;
    }

    .star-rating label {
        font-size: 30px;
        color: #ccc;
        cursor: pointer;
    }

    .star-rating input:checked ~ label {
        color: #ffcc00;
    }

    .star-rating input:hover ~ label {
        color: #ffcc00;
    }
</style>
</head>
<body>
    <%@include file="../navbar.jsp" %>
    <%@ page import="java.sql.*" %>

    <%
        int id;
        String name, comments, serviceName;
        double rating;
        String feedbackDate;

        try {
            // Step 1: Load JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Step 2: Define Connection URL
            String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";

            // Step 3: Establish connection to URL
            Connection conn = DriverManager.getConnection(connURL);

            // Step 4: Create Statement object
            Statement stmt = conn.createStatement();

            // Step 5: Execute SQL Command to fetch feedback and ratings
            String sqlStr = "SELECT f.comments, f.rating, f.feedback_date, s.name " +
                "FROM feedback f " +
                "JOIN service s ON f.service_id = s.service_id " +
                "ORDER BY f.feedback_date DESC"; // Ordering by feedback date for display
            ResultSet rs = stmt.executeQuery(sqlStr);
    %>

    <!-- Add New Feedback Form -->
    <div class="form-container" style="margin-top: 100px;">
        <h1>Add Feedback</h1>
        <form action="addFeedback.jsp" method="post" class="inline-feedback-form">
            <div class="form-group">
                <label for="service_id">Select Service:</label>
                <select id="service_id" name="service_id" required>
                    <option value="1">Home Cleaning</option>
                    <option value="2">Office Cleaning</option>
                    <option value="3">Specialized Cleaning</option>
                </select>
            </div>

            <div class="form-group">
                <label for="comments">Comment:</label>
                <textarea id="comments" name="comments" rows="4" required></textarea>
            </div>

            <div class="form-group">
                <label for="rating">Rating:</label>
                <div class="star-rating">
                    <input type="radio" id="star5" name="rating" value="5">
                    <label for="star5">&#9733;</label>
                    <input type="radio" id="star4" name="rating" value="4">
                    <label for="star4">&#9733;</label>
                    <input type="radio" id="star3" name="rating" value="3">
                    <label for="star3">&#9733;</label>
                    <input type="radio" id="star2" name="rating" value="2">
                    <label for="star2">&#9733;</label>
                    <input type="radio" id="star1" name="rating" value="1">
                    <label for="star1">&#9733;</label>
                </div>
            </div>

            <button type="submit">Submit Feedback</button>
        </form>
    </div>

    <h1>All Feedback</h1>
    <table>
        <tr>
            <th>Service Name</th>
            <th>Comment</th>
            <th>Rating</th>
            <th>Feedback Date</th>
        </tr>

        <%
            while (rs.next()) {
                comments = rs.getString("comments");
                rating = rs.getDouble("rating");
                feedbackDate = rs.getString("feedback_date");
                serviceName = rs.getString("name");
        %>
        <tr>
            <td><%= serviceName %></td>
            <td><textarea rows="4" readonly><%= comments %></textarea></td>
            <td>
                <div class="star-rating">
                    <%
                        // Display stars based on rating
                        for (int i = 1; i <= 5; i++) {
                            if (i <= rating) {
                    %>
                                <label>&#9733;</label>
                    <%
                            } else {
                    %>
                                <label>&#9733;</label>
                    <%
                            }
                        }
                    %>
                </div>
            </td>
            <td><%= feedbackDate %></td>
        </tr>
        <%
            }
            
            // Step 7: Close resources
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
        }
    %>
    </table>
</body>
</html>
