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
<%
	String errMsg = request.getParameter("errCode");
	String errorMessage = request.getParameter("error");
	String successMessage = request.getParameter("success");
%>
 
	<div class="register-container">
		<h2>Login</h2>
		<form action="../dbRelated/verifyUser.jsp" method="post">
			<label>Email:</label><input type="text" name="email" required><br>
			<label>Password:</label><input type="password" name="password"
				required><br> <input type="submit" value="Login">
				<%
					if (errorMessage != null) {
					%>
					<div style="color: red; text_align: center;">
						<p><%=errorMessage%></p>
					</div>
					<%
					} else if (successMessage != null) {
					%>
				
					<div style="color: green; text_align: center;">
						<p><%=successMessage%></p>
					</div>
				<%
				}
				%>
		</form>
	</div>
<%@ include file="../footer.html" %> 
</body>
</html>
	