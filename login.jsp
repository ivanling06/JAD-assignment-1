<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<title>Login - Sparklean</title>
<link rel="stylesheet" href="css/styles.css">
</head>
<body>
	<div class="register-container">
		<h2>Login</h2>
		<form action="dbRelated/verifyUser.jsp" method="post">
			<label>Username:</label><input type="text" name="username" required><br>
			<label>Password:</label><input type="password" name="password"
				required><br> <input type="submit" value="Login">

		</form>
	</div>
</body>
</html>
