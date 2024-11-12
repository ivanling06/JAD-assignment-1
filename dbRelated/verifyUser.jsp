<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>

<%
    // Retrieve form data
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    // Check if both fields are filled
    if (username != null && password != null && !username.isEmpty() && !password.isEmpty()) {

        try {
            // Load JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Define Connection URL
            String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
            Connection conn = DriverManager.getConnection(connURL);

            // Hash the password using SHA-256
            String hashedPassword = "";
            try {
                MessageDigest md = MessageDigest.getInstance("SHA-256");
                byte[] hashBytes = md.digest(password.getBytes());
                StringBuilder sb = new StringBuilder();
                for (byte b : hashBytes) {
                    sb.append(String.format("%02x", b));
                }
                hashedPassword = sb.toString();
            } catch (NoSuchAlgorithmException e) {
                out.println("Error: Unable to hash password.");
                return;
            }

            // Prepare the SQL statement to prevent SQL injection
            String sqlStr = "SELECT * FROM user WHERE username = ? AND password = ?";
            PreparedStatement pstmt = conn.prepareStatement(sqlStr);
            pstmt.setString(1, username);
            pstmt.setString(2, hashedPassword);
            ResultSet rs = pstmt.executeQuery();

            // Check if user exists and retrieve role
            if (rs.next()) {
                String role = rs.getString("role");

                // Set session attribute for username
                session.setAttribute("username", username);

                // Redirect based on role
                if ("Admin".equalsIgnoreCase(role)) {
                    response.sendRedirect("../admin/adminDashboard.jsp");
                } else if ("Customer".equalsIgnoreCase(role)) {
                    response.sendRedirect("../home.jsp");
                } else {
                    out.println("Unknown role. Please contact support.");
                }
            } else {
                out.println("Invalid username or password.");
            }

            // Close the connection
            conn.close();
        } catch (Exception e) {
            out.println("<h3>An error occurred. Please try again later.</h3>");
            e.printStackTrace();
        }
    } else {
        out.println("<h3>Please enter both username and password.</h3>");
    }
%>
