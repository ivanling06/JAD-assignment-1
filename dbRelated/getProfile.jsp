<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Profile</title>
    <link rel="stylesheet" href="../css/navbarUserStyles.css"> <!-- Include custom CSS -->
    <style>
        * {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            margin: 20px;
            background-color: #f9f9f9;
            padding-bottom: 40px; /* Added spacing between body and footer */
        }

        h2 {
            color: #333;
            margin-bottom: 20px;
        }

        .profile-container {
            background-color: #ffffff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            padding: 2em;
            max-width: 600px;
            margin: 0 auto;
        }

        .profile-container p {
            font-size: 1.1rem;
            margin-bottom: 15px;
            color: #555;
        }

        .profile-container strong {
            color: #333;
        }

        .btn-edit {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 1rem;
            transition: background-color 0.3s;
            margin-top: 20px;
            display: inline-block;
        }

        .btn-edit:hover {
            background-color: #0056b3;
        }

        .error-message {
            color: red;
            font-weight: bold;
            margin-top: 20px;
        }

        .success-message {
            color: green;
            font-weight: bold;
            margin-top: 20px;
        }

        .input-field {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        .input-field:focus {
            border-color: #007bff;
        }

        .section-title {
            color: #0057b8;
            font-size: 1.5rem;
            margin-bottom: 15px;
        }

        form {
            margin-top: 20px;
        }

        input[type="submit"] {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        .navbar {
            position: fixed;
            width: 100%;
            top: 0;
            left: 0;
            background-color: #004d99;
            padding: 10px 20px;
            z-index: 1000;
        }

        .navbar a {
            color: white;
            margin: 0 15px;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <%@ include file="../navbar.jsp" %>

    <%@ page import="java.sql.*" %>

    <%
        // Initialize database resources
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Step 1: Retrieve user ID from session
            String user_id = (String) session.getAttribute("userId");

            if (user_id == null) {
                // Redirect to login if no session exists
                response.sendRedirect("../logIn/login.jsp");
                return;
            }
            
         // Step 3: Check if the session user ID matches the ID being edited
            String editUserId = request.getParameter("user_id");
         
            if (editUserId != null && !user_id.equals(editUserId)) {
                session.invalidate();
                return;
            }

            // Step 2: Load JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Step 3: Define Connection URL
            String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?serverTimezone=UTC";
            conn = DriverManager.getConnection(connURL, "root", "root123");

            // Step 4: Create PreparedStatement
            String sqlStr = "SELECT * FROM user WHERE user_id = ?";
            pstmt = conn.prepareStatement(sqlStr);

            // Step 5: Set parameter using the session user ID
            pstmt.setString(1, user_id);

            // Step 6: Execute the query
            rs = pstmt.executeQuery();

            // Step 7: Process the result
            if (rs.next()) {
                String name = rs.getString("username");
                String email = rs.getString("email");
                String phone = rs.getString("phone_number");
        %>
            <div class="profile-container" style="margin-top: 100px; margin-bottom: 50px;">
                <h2>Your Profile</h2>
                <div class="section-title">User Information</div>

                <!-- Form to edit profile information -->
                <form action="updateProfile.jsp" method="post">
                    <!-- Hidden field to send user_id -->
                    <input type="hidden" name="user_id" value="<%= user_id %>">
                    
                    <label for="name"><strong>Name:</strong></label>
                    <input type="text" id="name" name="name" value="<%= name %>" class="input-field" required>

                    <label for="email"><strong>Email:</strong></label>
                    <input type="email" id="email" name="email" value="<%= email %>" class="input-field" required>

                    <label for="phone"><strong>Phone Number:</strong></label>
                    <input type="tel" id="phone" name="phone" value="<%= phone %>" class="input-field" required>

                    <input type="submit" value="Save Changes">
                </form>

                <% if (request.getParameter("error") != null) { %>
                    <p class="error-message"><%= request.getParameter("error") %></p>
                <% } %>
                <% if (request.getParameter("success") != null) { %>
                    <p class="success-message"><%= request.getParameter("success") %></p>
                <% } %>
            </div>
        <% } else { %>
            <p class="error-message">No user found for the current user ID.</p>
        <% } %>
        <% } catch (Exception e) {
            // Handle any errors
            System.err.println("Error: " + e.getMessage());
        } %>

    <%@ include file="../footer.html" %>
</body>
</html>
