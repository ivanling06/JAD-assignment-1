<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Bookings</title>
    <link rel="stylesheet" href="../css/navbarAdminStyles.css">
    <%@ include file="../adminNavbar.html" %>
    <%@ include file="../checkRole.jsp" %>
    <style>
        /* Scoped styles using the .manage-bookings-container class */
        .manage-bookings-container table {
            width: 100%;
            border-collapse: collapse;
        }
        .manage-bookings-container th, 
        .manage-bookings-container td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: left;
        }
        .manage-bookings-container th {
            background-color: #f4f4f4;
        }
        .manage-bookings-container input, 
        .manage-bookings-container select {
            width: 100%;
            padding: 5px;
        }
        .manage-bookings-container button {
            padding: 5px 10px;
            background-color: #0044cc;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .manage-bookings-container button:hover {
            background-color: #002a80;
        }
    </style>
</head>
<body>
    <h1>Manage Bookings</h1>
    <div class="manage-bookings-container">
        <table>
            <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Customer ID</th>
                    <th>Service ID</th>
                    <th>Booking Date</th>
                    <th>Booking Time</th>
                    <th>Special Requests</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
                    Connection conn = DriverManager.getConnection(connURL);
                    String query = "SELECT * FROM booking";
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(query);

                    while (rs.next()) {
                        int bookingId = rs.getInt("booking_id");
                        int customerId = rs.getInt("customer_id");
                        int serviceId = rs.getInt("service_id");
                        String bookingDate = rs.getString("booking_date");
                        String bookingTime = rs.getString("booking_time");
                        String specialRequests = rs.getString("special_requests");
                        String status = rs.getString("status");
                %>
                <tr>
                    <form action="update_booking.jsp" method="POST">
                        <td><input type="text" name="booking_id" value="<%= bookingId %>" readonly></td>
                        <td><input type="text" name="customer_id" value="<%= customerId %>" required></td>
                        <td><input type="text" name="service_id" value="<%= serviceId %>" required></td>
                        <td><input type="date" name="booking_date" value="<%= bookingDate %>" required></td>
                        <td>
                            <select name="booking_time" required>
                                <option value="08:00:00" <%= "08:00:00".equals(bookingTime) ? "selected" : "" %>>08:00 AM</option>
                                <option value="12:00:00" <%= "12:00:00".equals(bookingTime) ? "selected" : "" %>>12:00 PM</option>
                                <option value="16:00:00" <%= "16:00:00".equals(bookingTime) ? "selected" : "" %>>04:00 PM</option>
                                <option value="20:00:00" <%= "20:00:00".equals(bookingTime) ? "selected" : "" %>>08:00 PM</option>
                            </select>
                        </td>
                        <td><input type="text" name="special_requests" value="<%= specialRequests != null ? specialRequests : "" %>"></td>
                        <td>
                            <select name="status">
                                <option value="Pending" <%= "Pending".equals(status) ? "selected" : "" %>>Pending</option>
                                <option value="Confirmed" <%= "Confirmed".equals(status) ? "selected" : "" %>>Confirmed</option>
                                <option value="Cancelled" <%= "Cancelled".equals(status) ? "selected" : "" %>>Cancelled</option>
                            </select>
                        </td>
                        <td>
                            <button type="submit">Save</button>
                            <a href="delete_booking.jsp?booking_id=<%= bookingId %>" onclick="return confirm('Are you sure?');">Delete</a>
                        </td>
                    </form>
                </tr>
                <%
                    }
                    rs.close();
                    stmt.close();
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<div style='color:red;'>Error: " + e.getMessage() + "</div>");
                }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
