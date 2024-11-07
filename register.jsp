<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style>
 .message-container  {
    position: relative;
    top: -20px; /* Adjust this value to move the message closer or farther from the form */
    margin-bottom: 20px;
}

    .error-message {
        color: #d8000c;
        background-color: #ffd2d2;
        border: 1px solid #d8000c;
    }

    .success-message {
        color: #4F8A10;
        background-color: #DFF2BF;
        border: 1px solid #4F8A10;
    }
</style>
<meta charset="UTF-8">
<title>Register - Sparklean</title>
<link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <%@ include file="navbar.html"%>

    <div class="register-container">
        <h1>Register</h1>
        <form action="dbRelated/registerUser.jsp" method="post">
            <label for="first_name">First Name:</label>
            <input type="text" id="first_name" name="first_name" required>
            
            <label for="last_name">Last Name:</label>
            <input type="text" id="last_name" name="last_name" required>
            
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
            
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            
            <label for="confirm_password">Confirm Password:</label>
            <input type="password" id="confirm_password" name="confirm_password" required>
            
            <label for="phone_number">Phone Number:</label>
            <input type="text" id="phone_number" name="phone_number" required>
            
            <button type="submit" class="register-button">Register</button>
        </form>
    </div>

     <% 
    String errorCode = request.getParameter("error");
    String successCode = request.getParameter("success");
    if (errorCode != null) {
    %>
     <div class="message-container error-message">
        <% if ("422".equals(errorCode)) { %>
            <p>Please fill in all required fields.</p>
        <% } else if ("500".equals(errorCode)) { %>
            <p>Registration failed due to a system error. Please try again later.</p>
        <% } else if ("400".equals(errorCode)) { %>
            <p>Passwords do not match. Please try again.</p>
        <% } else if ("409".equals(errorCode)) { %>
            <p>This email is already registered. Please use a different email.</p>
        <% } else if ("410".equals(errorCode)) { %>
            <p>This username is already taken. Please choose a different username.</p>
        <% } %>
    </div>
    <% } else if ("1".equals(successCode)) { %>
     <div class="message-container success-message">
        <p>Successfully registered! You can now <a href="login.jsp">log in</a>.</p>
    </div>
    <% } %>

    <%@ include file="footer.html"%>
</body>
</html>
