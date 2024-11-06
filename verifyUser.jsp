<%@page import="java.sql.*" %>

<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    try {
        // Use a configuration utility or resource file to store database credentials
        Class.forName("com.mysql.jdbc.Driver");

        // Step 2: Define Connection URL
        //                                        |--port number  
        //                                        |       | -- schema name
        //                                        |       |            |
        //                                        |       |            |                     |-- your password
        //                                      |---|  |------|     |------|          |-----------| 
        String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";

        // Step 3: Establish connection to URL
        Connection conn = DriverManager.getConnection(connURL);

        // Step 4: Create Statement object
        Statement stmt = conn.createStatement();
        
        // Use PreparedStatement to prevent SQL injection
        String sqlStr = "SELECT * FROM user WHERE username = ? AND password = ?";
        PreparedStatement pstmt = conn.prepareStatement(sqlStr);
        pstmt.setString(1, username);
        pstmt.setString(2, password);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            String role = rs.getString("role"); // Retrieve the user's role

            // Set session attribute for username
            session.setAttribute("username", username);

            if ("Admin".equalsIgnoreCase(role)) {
                // Redirect to admin dashboard
                response.sendRedirect("admin/adminDashboard.jsp");
            } else if ("Customer".equalsIgnoreCase(role)) {
                // Redirect to customer dashboard or page
                response.sendRedirect("home.jsp");
            } else {
                out.println("Unknown role. Please contact support.");
            }
        } else {
            out.println("Invalid username or password.");
        }
        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
