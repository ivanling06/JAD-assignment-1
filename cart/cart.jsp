
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<title>Cart</title>
<link rel="stylesheet" href="../css/styles.css">
<link rel="stylesheet" href="../css/navbarStyles.css">
<link rel="stylesheet" href="../css/cartStyles.css">

</head>
<body>
	<%@ include file="../navbar.jsp"%>

	<%
	//String userId = (String) session.getAttribute("userId");
	if (userId == null) {
		response.sendRedirect("../logIn/login.jsp");
		return;
	}

	String errorMessage = request.getParameter("error");
	String successMessage = request.getParameter("success");

	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;

	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
		conn = DriverManager.getConnection(connURL);

		// Retrieve cart items for the user
		String sql = "SELECT * FROM cart WHERE user_id = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, userId);
		rs = stmt.executeQuery();
	%>
	<h1 class="cart-title">Your Cart</h1>
	<table class="cart-table">
		<tr class="cart-header">
			<th>Service</th>
			<th>Date</th>
			<th>Time</th>
			<th>Quantity</th>
			<th>Special Requests</th>
			<th>Actions</th>
		</tr>
		<%
		while (rs.next()) {
			String specialRequests = rs.getString("special_requests");
		%>
		<tr class="cart-row">
			<td><%=rs.getString("service_id")%></td>
			<td><%=rs.getDate("booking_date")%></td>
			<td><%=rs.getTime("booking_time")%></td>
			<td><%=rs.getInt("quantity")%></td>
			<td><%=specialRequests == null || specialRequests.isEmpty() ? "Nothing yet" : specialRequests%></td>
			<td class="cart-actions"><a class="edit-link"
				href="editCartItem.jsp?cartId=<%=rs.getInt("cart_id")%>
				&service_id=<%=rs.getString("service_id")%>
				&bookingDate=<%=rs.getDate("booking_date")%>
				&bookingTime=<%=rs.getTime("booking_time")%>
				&quantity=<%=rs.getInt("quantity")%>
				&specialRequests=<%=specialRequests == null || specialRequests.isEmpty() ? "" : specialRequests%>">Edit</a>
				<a class="delete-link"
				href="deleteCartItem.jsp?cartId=<%=rs.getInt("cart_id")%>">Delete</a>
			</td>
		</tr>
		<%
		}	
		%>
	</table>
	<br>
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
	<form class="checkout-form" action="checkOut.jsp" method="post">
		<button type="submit" class="checkout-button">Checkout</button>
	</form>

	<%@ include file="../footer.html"%>
</body>
</html>
<%
} catch (Exception e) {
e.printStackTrace();
} finally {
try {
	if (rs != null)
		rs.close();
	if (stmt != null)
		stmt.close();
	if (conn != null)
		conn.close();
} catch (SQLException e) {
	e.printStackTrace();
}
}
%>
