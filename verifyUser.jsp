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
            // Login successful, set session attribute directly
            session.setAttribute("username", username);  // No need to declare session, it's already available
            out.println("Login successful!");
            // Redirect or forward to a secured page
            response.sendRedirect("adminDashboard.jsp");
        } else {
            out.println("Invalid username or password.");
        }

        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
