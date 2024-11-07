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
    String confirmPassword = request.getParameter("confirm_password");
    String phoneNumber = request.getParameter("phone_number");
    
    if (!password.equals(confirmPassword)) {
        response.sendRedirect("../register.jsp?error=400");
        return;
    }

    // Check if all fields are filled
    if (firstName == null || lastName == null || email == null || password == null || confirmPassword == null || phoneNumber == null ||
        firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() || password.isEmpty() || confirmPassword.isEmpty() || phoneNumber.isEmpty()) {
        response.sendRedirect("../register.jsp?error=422");
    } else {
        try {
            // Load JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Define Connection URL
            String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
            Connection conn = DriverManager.getConnection(connURL);
            
            String username = firstName + lastName;
            
            // Check if username is already taken
            String checkUserSQL = "SELECT * FROM user WHERE username = ?";
            PreparedStatement checkUserStmt = conn.prepareStatement(checkUserSQL);
            checkUserStmt.setString(1, username);
            ResultSet userResult = checkUserStmt.executeQuery();
            if (userResult.next()) {
                response.sendRedirect("../register.jsp?error=410"); // Using 410 as the error code for "username already exists"
                return;
            }

            
            // Check if email is in use by other user
            String checkEmailSQL = "SELECT * FROM user WHERE email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkEmailSQL);
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Email is already in use
                response.sendRedirect("../register.jsp?error=409"); // Conflict error for duplicate email
                conn.close();
                return;
            }

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
                response.sendRedirect("../register.jsp?error=500");
                return;
            }

            // Insert user data into the database using PreparedStatement
            String sqlStr = "INSERT INTO user (username, email, password, phone_number) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sqlStr);
            pstmt.setString(1, username);
            pstmt.setString(2, email);
            pstmt.setString(3, hashedPassword);
            pstmt.setString(4, phoneNumber);

            // Execute the insert
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
            	response.sendRedirect("../register.jsp?success=1");
            } else {
                response.sendRedirect("../register.jsp?error=500");
            }

            // Close the connection
            conn.close();
        } catch (Exception e) {
            response.sendRedirect("../register.jsp?error=500");
            e.printStackTrace();
        }
    }
%>
