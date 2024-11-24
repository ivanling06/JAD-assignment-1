<%@ page import="java.sql.*" %>

<%@ include file="../checkRole.jsp" %>

<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="../css/navbarAdminStyles.css">
    <link rel="stylesheet" href="../css/adminStyles.css">
</head>
<body>
    <%@ include file="../adminNavbar.html" %>
    <div class="dashboard-container">
        <h2>Welcome <%= username %></h2>
        <p>Select an option to manage:</p>

        <div class="dashboard-links">
            <a href="manage_feedback.jsp" class="dashboard-link">Manage Feedback</a>
            <a href="../dbRelated/manage_services.jsp" class="dashboard-link">Manage Services</a>
            <a href="../dbRelated/manage_members.jsp" class="dashboard-link">Manage Members</a>
            <a href="../dbRelated/manage_booking.jsp" class="dashboard-link">Manage Bookings</a>
        </div>
    </div>
</body>
</html>
