<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Cart Item</title>
    <%
		String userId = (String) session.getAttribute("userId");
		if (userId == null) {		
		    response.sendRedirect("../logIn/login.jsp");
		    return;
		}
		String cartId = request.getParameter("cartId");
	    String serviceId = request.getParameter("service_id");
	    String bookingDate = request.getParameter("bookingDate");
	    String bookingTime = request.getParameter("bookingTime");
	    String quantity = request.getParameter("quantity");
	    String specialRequests = request.getParameter("specialRequests");

	    // Redirect back if cartId is missing
	    if (cartId == null || cartId.isEmpty()) {
	        response.sendRedirect("cart.jsp?error=Missing cartId.");
	        return;
	    }
	%>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f8ff; /* Light blue background */
            color: #00274d; /* Dark blue text */
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #ffffff; /* White background for form */
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Soft shadow */
            border: 1px solid #d1e7ff; /* Light blue border */
        }
        h1 {
            text-align: center;
            color: #0056b3; /* Medium blue for headers */
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        label {
            font-weight: bold;
            color: #00274d; /* Dark blue for labels */
        }
        input, select, textarea {
            padding: 10px;
            border: 1px solid #bcd4e6; /* Light blue border */
            border-radius: 5px;
            width: 100%;
            font-size: 16px;
            box-sizing: border-box;
        }
        input:focus, textarea:focus {
            border-color: #0056b3; /* Medium blue on focus */
            outline: none;
            box-shadow: 0 0 4px #0056b3; /* Subtle glow */
        }
        button {
            padding: 10px 15px;
            background-color: #0056b3; /* Medium blue button */
            color: #ffffff; /* White text */
            font-size: 16px;
            font-weight: bold;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        button:hover {
            background-color: #003c82; /* Darker blue on hover */
        }
        .error-message, .success-message {
            padding: 10px;
            border-radius: 5px;
            font-size: 14px;
            margin-bottom: 15px;
        }
        .error-message {
            background-color: #f8d7da; /* Light red */
            color: #721c24; /* Dark red text */
            border: 1px solid #f5c6cb; /* Light red border */
        }
        .success-message {
            background-color: #d4edda; /* Light green */
            color: #155724; /* Dark green text */
            border: 1px solid #c3e6cb; /* Light green border */
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Edit Cart Item</h1>
        <%
            // Display error or success messages
            String error = request.getParameter("error");
            String success = request.getParameter("success");
            if (error != null) {
        %>
            <div class="error-message"><%= error %></div>
        <%
            }
            if (success != null) {
        %>
            <div class="success-message"><%= success %></div>
        <%
            }
        %>
        <!-- Form to update cart item -->
        <form action="updateCartItem.jsp" method="post">
            <input type="hidden" name="cartId" value="<%= cartId %>">
            
            <label for="serviceId">Service ID:</label>
            <input type="text" id="serviceId" name="serviceId" value="<%= serviceId != null ? serviceId : "" %>" readonly>

            <label for="bookingDate">Booking Date:</label>
            <input type="date" id="bookingDate" name="bookingDate" value="<%= bookingDate != null ? bookingDate : "" %>" required>

            <label for="bookingTime">Select Time Slot:</label>
            <select id="bookingTime" name="bookingTime" required>
                <option value="">-- Select a Time Slot --</option>
                <option value="08:00:00" <%= "08:00:00".equals(bookingTime) ? "selected" : "" %>>8:00 AM - 12:00 PM</option>
                <option value="12:00:00" <%= "12:00:00".equals(bookingTime) ? "selected" : "" %>>12:00 PM - 4:00 PM</option>
                <option value="16:00:00" <%= "16:00:00".equals(bookingTime) ? "selected" : "" %>>4:00 PM - 8:00 PM</option>
                <option value="20:00:00" <%= "20:00:00".equals(bookingTime) ? "selected" : "" %>>8:00 PM - 12:00 AM</option>
            </select>

            <label for="quantity">Quantity:</label>
            <input type="number" id="quantity" name="quantity" value="<%= quantity != null ? quantity : "" %>" required>

            <label for="specialRequests">Special Requests:</label>
            <textarea id="specialRequests" name="specialRequests" rows="3"><%= specialRequests != null ? specialRequests : "" %></textarea>

            <button type="submit">Update Cart</button>
        </form>
    </div>
</body>
</html>
