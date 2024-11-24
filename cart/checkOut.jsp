<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Checkout</title>
    <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
    <h1>Checkout</h1>
    <%
        String customerId = (String) session.getAttribute("userId");
        if (customerId == null) {
            response.sendRedirect("../logIn/login.jsp");
            return;
        }

        Connection conn = null;
        PreparedStatement bookingStmt = null;
        PreparedStatement bookingDetailsStmt = null;
        PreparedStatement cartStmt = null;
        ResultSet cartRs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";
            conn = DriverManager.getConnection(connURL);

            conn.setAutoCommit(false); // Start transaction

            // Fetch cart items for the customer
            String fetchCartSQL = "SELECT * FROM cart WHERE user_id = ?";
            cartStmt = conn.prepareStatement(fetchCartSQL);
            cartStmt.setString(1, customerId);
            cartRs = cartStmt.executeQuery();

            if (!cartRs.next()) {
                out.println("<p>Your cart is empty. Add items to checkout.</p>");
                response.sendRedirect("../cart/cart.jsp?error=Checkout failed. Your cart is empty!");
                return;
            }

            // Insert into booking table
            String insertBookingSQL = "INSERT INTO booking (user_id, service_id, booking_date, booking_time, special_requests, status, created_at) " +
                                       "VALUES (?, ?, ?, ?, ?, ?, NOW())";
            bookingStmt = conn.prepareStatement(insertBookingSQL, Statement.RETURN_GENERATED_KEYS);

            String insertBookingDetailsSQL = "INSERT INTO booking_details (booking_id, service_id, quantity) VALUES (?, ?, ?)";
            bookingDetailsStmt = conn.prepareStatement(insertBookingDetailsSQL);

            do {
                int serviceId = cartRs.getInt("service_id");
                String bookingDate = cartRs.getString("booking_date");
                String bookingTime = cartRs.getString("booking_time");
                String specialRequests = cartRs.getString("special_requests");
                int quantity = cartRs.getInt("quantity");

                // Insert one booking per cart item
                bookingStmt.setString(1, customerId);
                bookingStmt.setInt(2, serviceId);
                bookingStmt.setString(3, bookingDate);
                bookingStmt.setString(4, bookingTime);
                bookingStmt.setString(5, specialRequests != null ? specialRequests : "");
                bookingStmt.setString(6, "Pending"); // Default status

                bookingStmt.executeUpdate();

                // Get generated booking_id
                ResultSet bookingKeys = bookingStmt.getGeneratedKeys();
                int bookingId = 0;
                if (bookingKeys.next()) {
                    bookingId = bookingKeys.getInt(1);
                }

                // Insert into booking_details
                bookingDetailsStmt.setInt(1, bookingId);
                bookingDetailsStmt.setInt(2, serviceId);
                bookingDetailsStmt.setInt(3, quantity);
                bookingDetailsStmt.addBatch();

            } while (cartRs.next());

            // Execute batch for booking_details
            bookingDetailsStmt.executeBatch();

            // Clear cart
            String deleteCartSQL = "DELETE FROM cart WHERE user_id = ?";
            PreparedStatement clearCartStmt = conn.prepareStatement(deleteCartSQL);
            clearCartStmt.setString(1, customerId);
            clearCartStmt.executeUpdate();

            conn.commit(); // Commit transaction
            response.sendRedirect("../cart/cart.jsp?success=Successfully checked out!");
            
        } catch (Exception e) {
            if (conn != null) conn.rollback(); // Rollback on error
            e.printStackTrace();
            response.sendRedirect("../cart/cart.jsp?error=Checkout failed. Please try again later!");
        } finally {
            if (cartRs != null) cartRs.close();
            if (cartStmt != null) cartStmt.close();
            if (bookingStmt != null) bookingStmt.close();
            if (bookingDetailsStmt != null) bookingDetailsStmt.close();
            if (conn != null) conn.close();
        }
    %>
</body>
</html>
