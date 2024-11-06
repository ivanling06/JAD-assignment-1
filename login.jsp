<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
    <title>Login Page</title>
</head>
<body>
    <!-- Navigation Tabs -->
    <nav>
        <a href="login.jsp">Login</a> |
        <a href="register.jsp">Register</a>
    </nav>

    <h2>Login</h2>
    <form action="verifyUser.jsp" method="post">
        <label>Username:</label><input type="text" name="username" required><br>
        <label>Password:</label><input type="password" name="password" required><br>
        <input type="submit" value="Login">
    </form>
</body>
</html>
