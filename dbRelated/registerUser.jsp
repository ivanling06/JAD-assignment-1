<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>

<%
    // Retrieve form data
    String firstName = request.getParameter("first_name");
    String lastName = request.getParameter("last_name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String phoneNumber = request.getParameter("phone_number");

    // Check if all fields are filled
    if (firstName != null && lastName != null && email != null && password != null && phoneNumber != null &&
        !firstName.isEmpty() && !lastName.isEmpty() && !email.isEmpty() && !password.isEmpty() && !phoneNumber.isEmpty()) {

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

            // Insert user data into the database using PreparedStatement
            String sqlStr = "INSERT INTO user (first_name, last_name, email, password, phone_number) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sqlStr);
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setString(3, email);
            pstmt.setString(4, hashedPassword);
            pstmt.setString(5, phoneNumber);

            // Execute the insert
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<h3>Registration successful! You can now <a href='login.jsp'>log in</a>.</h3>");
            } else {
                out.println("<h3>Registration failed. Please try again.</h3>");
            }

            // Close the connection
            conn.close();
        } catch (Exception e) {
            // Log the error internally (use a logging framework in a real project)
            out.println("<h3>An error occurred. Please try again later.</h3>");
            e.printStackTrace();
        }
    } else {
        out.println("<h3>Please fill in all fields.</h3>");
    }
%>
