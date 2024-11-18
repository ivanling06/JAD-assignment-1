<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<div class="navbar">
	<div class="navbar-container">
		<a href="home.jsp"> <img src="images/logo.png" alt="Sparklean"
			class="logo-image" style="padding-left: 40px;">
		</a>
		<ul class="navbar-menu">
			<li><a href="home.jsp">Home</a></li>
			<li class="dropdown"><a href="#" class="dropdown-btn">Services</a>
				<div class="dropdown-content">
					<!-- Category 1 -->
					<div class="dropdown-submenu">
						<a href="#">Home Cleaning</a>
						<div class="dropdown-content-submenu">
							<a href="#">Basic Home Cleaning</a> <a href="#">Deep Home
								Cleaning</a> <a href="#">Move-out Cleaning</a>
						</div>
					</div>
					<!-- Category 2 -->
					<div class="dropdown-submenu">
						<a href="#">Office Cleaning</a>
						<div class="dropdown-content-submenu">
							<a href="#">Regular Office Cleaning</a> <a href="#">Deep
								Office Cleaning</a> <a href="#">Window Cleaning</a>
						</div>
					</div>
					<!-- Category 3 -->
					<div class="dropdown-submenu">
						<a href="#">Specialized Cleaning</a>
						<div class="dropdown-content-submenu">
							<a href="#">Carpet Cleaning</a> <a href="#">Upholstery
								Cleaning</a> <a href="#">Tile & Grout Cleaning</a>
						</div>
					</div>
				</div></li>
			<li><a href="contact.jsp">Contact</a></li>
			<li class="dropdown">
				<%
				String userId = (String) session.getAttribute("userId");
				String username = (String) session.getAttribute("username"); // Assume username is set in the session after login
				%> <a href="#" class="dropdown-btn"> <%=(userId != null) ? username : "Account"%>
			</a>
				<ul class="dropdown-content">
					<%
					if (userId == null) {
					%>
					<li><a href="login.jsp">Login</a></li>
					<li><a href="register.jsp">Register</a></li>
					<%
					} else {
					%>
					<li><a href="profile.jsp">Profile</a></li>
					<li><a href="logout.jsp">Logout</a></li>
					<%
					}
					%>
				</ul>
			</li>

		</ul>
	</div>
</div>
