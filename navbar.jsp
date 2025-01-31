<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
			<%
				String userId = (String) session.getAttribute("userId");
				String username = (String) session.getAttribute("username"); // Assume username is set in the session after login
			%>
<div class="navbar">
	<div class="navbar-container">
		<a href="../home/home.jsp"> <img src="../images/logo.png" alt="Sparklean"
			class="logo-image" style="padding-left: 40px;">
		</a>
		<ul class="navbar-menu">
			<li><a href="../home/home.jsp">Home</a></li>
			<li class="dropdown"><a href="../services/allServices.jsp" class="dropdown-btn">Services</a>
				<div class="dropdown-content">
					<!-- Category 1 -->
					<div class="dropdown-submenu">
						<a href="../services/homeCleaning.jsp">Home Cleaning</a>
					</div>
					<!-- Category 2 -->
					<div class="dropdown-submenu">
						<a href="../services/officeCleaning.jsp">Office Cleaning</a>
					</div>
					<!-- Category 3 -->
					<div class="dropdown-submenu">
						<a href="../services/specialisedCleaning.jsp">Specialized Cleaning</a>
					</div>
				</div></li>
			<%
			if (userId != null) { // Only render these items if the user is logged in
			%>
			<li><a href="../cart/cart.jsp">Your Cart</a></li>
			<li><a href="../booking/displayBooking.jsp">Your Bookings</a></li>
			<li><a href="../feedback/feedback.jsp">Feedback</a></li>
			<%
			}
			%>
			<li class="dropdown">
				<a href="#" class="dropdown-btn"> <%=(userId != null) ? username : "Account"%> </a>
				<ul class="dropdown-content">
					<%
					if (userId == null) {
					%>
					<li><a href="../logIn/login.jsp">Login</a></li>
					<li><a href="../logIn/register.jsp">Register</a></li>
					<%
					} else {
					%>
					<li><a href="../dbRelated/getProfile.jsp">Profile</a></li>
					<li><a href="../logIn/logout.jsp">Logout</a></li>
					<%
					}
					%>
				</ul>
			</li>
		</ul>
	</div>
</div>

