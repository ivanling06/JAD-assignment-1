<%@ page import="java.sql.*" %>

<%
    String adminUser = (String) session.getAttribute("username");
    if (adminUser == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
%>

<html>
<head>
    <title>Admin Dashboard</title>
</head>
<body>
    <h2>Welcome, <%= adminUser %></h2>
    <a href="manage_services.jsp">Manage Services</a> | 
    <a href="manage_members.jsp">Manage Members</a> | 
    <a href="LogoutServlet">Logout</a>
</body>
</html>
