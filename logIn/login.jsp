<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<title>Login - Sparklean</title>
<link rel="stylesheet" href="../css/styles.css">
<link rel="stylesheet" href="../css/navbarStyles.css">
</head>
<body>
<%@ include file="../navbar.jsp" %> 
	<div class="register-container">
		<h2>Login</h2>
		<form action="dbRelated/verifyUser.jsp" method="post">
			<label>Email:</label><input type="text" name="email" required><br>
			<label>Password:</label><input type="password" name="password"
				required><br> <input type="submit" value="Login">

		</form>
	</div>
</body>
</html>
	