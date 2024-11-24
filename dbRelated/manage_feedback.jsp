<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Feedback</title>
    <link rel="stylesheet" href="../css/navbarAdminStyles.css">
    <%@ include file="../adminNavbar.html" %>
    <%@ include file="../checkRole.jsp" %>
    <style>
        .manage-feedback-container table {
            width: 100%;
            border-collapse: collapse;
        }
        .manage-feedback-container th, 
        .manage-feedback-container td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: left;
        }
        .manage-feedback-container th {
            background-color: #f4f4f4;
        }
        .manage-feedback-container input, 
        .manage-feedback-container select {
            width: 100%;
            padding: 5px;
        }
        .manage-feedback-container button {
            padding: 5px 10px;
            background-color: #0044cc;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .manage-feedback-container button:hover {
            background-color: #002a80;
        }
    </style>
</head>
<body>
    <h1>Manage Feedback</h1>
    <div class="manage-feedback-container">
        <table>
            <thead>
                <tr>
                    <th>Feedback ID</th>
                    <th>User ID</th>
                    <th>Service ID</th>
                    <th>Rating</th>
                    <th>Comments</th>
                    <th>Feedback Date</th>
                    <th>Booking ID</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
String successMsg = request.getParameter("success");
String errMsg = request.getParameter("error");

if (errMsg != null) {
    %>
    <div style="color: red; text-align: center;">
        <p><%= errMsg %></p>
    </div>
    <%
} else if (successMsg != null) {
    %>
    <div style="color: green; text-align: center;">
        <p><%= successMsg %></p>
    </div>
    <%
}

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
    Connection conn = DriverManager.getConnection(connURL);
    String query = "SELECT * FROM feedback";
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery(query);

    while (rs.next()) {
        int feedbackId = rs.getInt("feedback_id");
        int serviceId = rs.getInt("service_id");
        int rating = rs.getInt("rating");
        String comments = rs.getString("comments");
        String feedbackDate = rs.getString("feedback_date");
        int bookingId = rs.getInt("booking_id");
%>
<tr>
    <form action="update_feedback.jsp" method="POST">
        <td><input type="text" name="feedback_id" value="<%= feedbackId %>" readonly></td>
        <td><input type="text" name="user_id" value="<%= userId %>" required></td>
        <td><input type="text" name="service_id" value="<%= serviceId %>" required></td>
        <td>
            <select name="rating" required>
                <% for (int i = 1; i <= 5; i++) { %>
                    <option value="<%= i %>" <%= (i == rating) ? "selected" : "" %>><%= i %></option>
                <% } %>
            </select>
        </td>
        <td><input type="text" name="comments" value="<%= comments != null ? comments : "" %>"></td>
        <td><input type="date" name="feedback_date" value="<%= feedbackDate %>" required></td>
        <td><input type="text" name="booking_id" value="<%= bookingId %>" required></td>
        <td>
            <button type="submit">Save</button>
            <a href="delete_feedback.jsp?feedback_id=<%= feedbackId %>" onclick="return confirm('Are you sure?');">Delete</a>
        </td>
    </form>
</tr>
<%
    }
    rs.close();
    stmt.close();
    conn.close();
} catch (Exception e) {
    e.printStackTrace();
    out.println("<div style='color:red;'>Error: " + e.getMessage() + "</div>");
}
%>

            </tbody>
        </table>
    </div>
</body>
</html>
