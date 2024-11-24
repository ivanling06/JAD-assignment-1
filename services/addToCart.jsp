<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
String userId = (String) session.getAttribute("userId");
if (userId == null) {
    response.sendRedirect("../logIn/login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add to Cart</title>
    <link rel="stylesheet" href="../css/navbarStyles.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f8fb;
            color: #333;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 50%;
            margin: 3rem auto;
            background-color: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 2rem;
        }

        h1 {
            text-align: center;
            color: #0044cc;
            margin-bottom: 1rem;
        }

        label {
            font-weight: bold;
            margin-bottom: 0.5rem;
            display: block;
            color: #0044cc;
        }

        input, select {
            width: 100%;
            padding: 0.8rem;
            margin-bottom: 1rem;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }

        input[type="date"] {
            cursor: pointer;
        }

        button {
            width: 100%;
            background-color: #0044cc;
            color: white;
            border: none;
            padding: 1rem;
            font-size: 1rem;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #003399;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .error {
            color: red;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
	<% 
	    String errorMessage = request.getParameter("error");
		String successMessage = request.getParameter("success");
	%>
    <div class="container">
        <h1>Add to Cart</h1>
        <form action="../dbRelated/processAddToCart.jsp" method="POST">
            <input type="text" name="serviceId" value="<%= request.getParameter("serviceId") %>" readonly>

            <div class="form-group">
                <label for="bookingDate">Select Date:</label>
                <input type="date" id="bookingDate" name="bookingDate" required>
                <div id="dateError" class="error"></div>
            </div>

            <div class="form-group">
                <label for="bookingTime">Select Time Slot:</label>
                <select id="bookingTime" name="bookingTime" required>
                    <option value="">-- Select a Time Slot --</option>
                    <option value="08:00:00">8:00 AM - 12:00 PM</option>
                    <option value="12:00:00">12:00 PM - 4:00 PM</option>
                    <option value="16:00:00">4:00 PM - 8:00 PM</option>
                    <option value="20:00:00">8:00 PM - 12:00 AM</option>
                </select>
                <div id="timeError" class="error"></div>
            </div>

            <div class="form-group">
                <label for="quantity">Enter Quantity:</label>
                <input type="number" id="quantity" name="quantity" min="1" max="10" required>
            </div>

            <button type="submit">Add to Cart</button>
            
            <% if (errorMessage != null) { %>
		        <div style="color: red; text_align: center;">
		            <p><%= errorMessage %></p>
		        </div>
		    <% }else if (successMessage != null) { %>
		
		        <div style="color: green; text_align: center;">
		            <p><%= successMessage %></p>
		        </div>
		    <% } %>
        </form>
    </div>


</body>
</html>
