<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Book Service</title>
    <link rel="stylesheet" href="../css/formStyles.css">
</head>
<body>
<%
		String userId = (String) session.getAttribute("userId");
		if (userId == null) {
		    response.sendRedirect("../logIn/login.jsp");
		    return;
		}
%>

    <h1>Book Service</h1>
    <form action="../dbRelated/processAddToCart.jsp" method="POST">
        <input type="hidden" name="serviceId" value="<%= request.getParameter("serviceId") %>">

        <label for="bookingDate">Select Date:</label>
        <input type="date" id="bookingDate" name="bookingDate" required>

        <label for="bookingTime">Select Time Slot:</label>
        <select id="bookingTime" name="bookingTime" required>
            <option value="08:00:00">8:00 AM - 12:00 PM</option>
            <option value="12:00:00">12:00 PM - 4:00 PM</option>
            <option value="16:00:00">4:00 PM - 8:00 PM</option>
            <option value="20:00:00">8:00 PM - 12:00 AM</option>
        </select>

        <label for="quantity">Quantity:</label>
        <input type="number" id="quantity" name="quantity" min="1" value="1" required>

        <label for="specialRequests">Special Requests:</label>
        <textarea id="specialRequests" name="specialRequests" placeholder="Any special requests..." rows="4"></textarea>

        <button type="submit">Add to Cart</button>
    </form>
</body>
</html>
