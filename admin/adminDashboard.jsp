
<%@ page import="java.sql.*" %>

<%
    String adminUser = (String) session.getAttribute("username");
    if (adminUser == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="../css/navbarAdminStyles.css">
    <link rel="stylesheet" href="../css/adminStyles.css">
</head>
<body>
	<%@ include file="../adminNavbar.html" %>  
    <div class="dashboard-container">
        <h2>Welcome, <%= adminUser %>!</h2>
        <p>Select an option to manage:</p>

        <div class="dashboard-links">
            <a href="manage_feedback.jsp" class="dashboard-link">Manage Feedback</a>
            <a href="manage_services.jsp" class="dashboard-link">Manage Services</a>
            <a href="manage_members.jsp" class="dashboard-link">Manage Members</a>
            <a href="manage_bookings.jsp" class="dashboard-link">Manage Bookings</a>
        </div>
    </div>
</body>
</html>
