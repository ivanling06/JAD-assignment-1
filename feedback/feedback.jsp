<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Feedback</title>
<link rel="stylesheet" href="../css/styles.css">
<link rel="stylesheet" href="../css/navbarStyles.css">
<style>
/* General Body Styling */
body {
	font-family: Arial, sans-serif;
	background-color: #f5f5f5;
	margin: 0;
	padding: 0;
}

/* Form Container */
.form-container {
	max-width: 800px;
	background-color: #ffffff;
	padding: 20px;
	margin: 20px auto;
	border-radius: 8px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.form-container h1 {
	text-align: center;
	color: #333;
}

.form-group {
	margin-bottom: 15px;
}

.form-group label {
	display: block;
	font-weight: bold;
	color: #555;
	margin-bottom: 5px;
}

.form-group select, .form-group textarea, .form-group input {
	width: 100%;
	padding: 10px;
	border: 1px solid #ccc;
	border-radius: 4px;
	font-size: 16px;
}

/* Star Rating */
.star-rating {
	display: flex;
	gap: 5px;
	flex-direction: row-reverse;
	/* Reverse the order for left-to-right selection */
}

.star-rating label {
	font-size: 30px;
	color: #ccc; /* Default grey */
	cursor: pointer;
	transition: color 0.3s ease;
}

.star-rating input {
	display: none;
}

.star-rating input:checked ~ label, .star-rating label:hover,
	.star-rating label:hover ~ label {
	color: gold; /* Highlight color for selected and hovered stars */
}

/* Table Styling */
table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	border-radius: 8px;
	overflow: hidden;
}

th {
	background-color: #0057b8; /* Default background color */
	color: #ffffff; /* Default text color */
	padding: 10px;
	text-align: left;
	cursor: default;
	color: #ffffff;
}

th, td {
	padding: 10px;
	text-align: left;
	border-bottom: 1px solid #ddd;
}

tr:hover {
	background-color: #f1f1f1;
}

/* Button Styling */
.action-buttons {
	display: flex;
	gap: 10px;
}

.action-button {
	padding: 8px 15px;
	border: none;
	border-radius: 4px;
	font-size: 14px;
	cursor: pointer;
}

.btn-update {
	background-color: #28a745;
	color: white;
}

.btn-delete {
	background-color: #dc3545;
	color: white;
}

.btn-update:hover {
	background-color: #218838;
}

.btn-delete:hover {
	background-color: #c82333;
}
</style>
</head>
<body>
	<%@ include file="../navbar.jsp"%>
	<%@ page import="java.sql.*"%>

	<%
	// Fetch session user ID
	if (userId == null) {
		response.sendRedirect("../logIn/login.jsp");
		return;
	}
	String strUserID = (String) session.getAttribute("userId");
	int sessionUserId = strUserID != null ? Integer.parseInt(strUserID) : 0;

	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	String connURL = "jdbc:mysql://localhost:3306/jad-assignment1?user=root&password=root123&serverTimezone=UTC";

	// Query to fetch bookings where the session user ID matches the customer ID
	String sql = "SELECT b.booking_id, s.name AS service_name, b.booking_date " + "FROM booking b "
			+ "JOIN service s ON b.service_id = s.service_id " + "WHERE b.user_id = ? " + "ORDER BY b.booking_date DESC";

	boolean hasBookings = false;

	try {
		// Step 1: Load JDBC Driver
		Class.forName("com.mysql.cj.jdbc.Driver");

		// Step 2: Establish connection
		conn = DriverManager.getConnection(connURL);

		// Step 3: Prepare statement
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, sessionUserId); // Compare session user ID with customer ID

		// Step 4: Execute query
		rs = pstmt.executeQuery();
	%>

	<!-- Add New Feedback Form -->
	<div class="form-container">
		<h1>Add Feedback</h1>
		<%
		String successMessage = request.getParameter("success");
		String errorCode = request.getParameter("errorCode");
		String errorMessage = null;

		// Map error codes to user-friendly messages
		if ("1".equals(errorCode)) {
			errorMessage = "Feedback already exists for this booking. You cannot submit feedback again.";
		} else if ("2".equals(errorCode)) {
			errorMessage = "Invalid booking ID. Please try again.";
		} else if ("3".equals(errorCode)) {
			errorMessage = "You can only submit feedback for your own bookings.";
		}

		// Display success or error message
		if (successMessage != null) {
		%>
		<div class="success"
			style="color: #28a745; font-weight: bold; margin-bottom: 15px;">
			<%=successMessage%>
		</div>
		<%
		} else if (errorMessage != null) {
		%>
		<div class="error"
			style="color: #dc3545; font-weight: bold; margin-bottom: 15px;">
			<%=errorMessage%>
		</div>
		<%
		}
		%>
	</div>

	<form action="addFeedback.jsp" method="post">
		<div class="form-group">
			<label for="booking_id">Select Your Booking:</label> <select
				id="booking_id" name="booking_id" required>
				<%
				if (!rs.isBeforeFirst()) {
				%>
				<option value="">No bookings found. Please book a service
					or login to leave feedback!</option>
				<%
				} else {
				hasBookings = true;
				while (rs.next()) {
					int bookingId = rs.getInt("booking_id");
					String serviceName = rs.getString("service_name");
					String bookingDate = rs.getString("booking_date");
				%>
				<option value="<%=bookingId%>">
					<%=serviceName%> (Booked on
					<%=bookingDate%>)
				</option>
				<%
				}
				}
				%>
			</select>
		</div>

		<div class="form-group">
			<label for="comments">Comment:</label>
			<textarea id="comments" name="comments" rows="4" required></textarea>
		</div>

		<div class="form-group">
			<label for="rating">Rating:</label>
			<div class="star-rating" style="padding-right: 615px;">
				<input type="radio" id="star5" name="rating" value="5"> <label
					for="star5" data-value="5">&#9733;</label> <input type="radio"
					id="star4" name="rating" value="4"> <label for="star4"
					data-value="4">&#9733;</label> <input type="radio" id="star3"
					name="rating" value="3"> <label for="star3" data-value="3">&#9733;</label>
				<input type="radio" id="star2" name="rating" value="2"> <label
					for="star2" data-value="2">&#9733;</label> <input type="radio"
					id="star1" name="rating" value="1"> <label for="star1"
					data-value="1">&#9733;</label>
			</div>
		</div>

		<button type="submit" class="action-button btn-update"
			<%=!hasBookings ? "disabled" : ""%>>Submit Feedback</button>
	</form>
	</div>

	<%
	} catch (Exception e) {
	out.println("<p>Error fetching bookings: " + e.getMessage() + "</p>");
	} finally {
	// Explicitly close resources
	if (rs != null)
		try {
			rs.close();
		} catch (SQLException ignore) {
		}
	if (pstmt != null)
		try {
			pstmt.close();
		} catch (SQLException ignore) {
		}
	if (conn != null)
		try {
			conn.close();
		} catch (SQLException ignore) {
		}
	}

	// Step 2: Fetch all feedback
	try {
	conn = DriverManager.getConnection(connURL);

	String feedbackSql = "SELECT f.feedback_id, f.comments, f.rating, DATE(f.feedback_date) AS feedback_date, "
			+ "s.name AS service_name, u.username AS customer_name " + "FROM feedback f "
			+ "JOIN booking b ON f.booking_id = b.booking_id " + "JOIN service s ON b.service_id = s.service_id "
			+ "JOIN user u ON f.user_id = u.user_id " + "ORDER BY f.feedback_date DESC";

	pstmt = conn.prepareStatement(feedbackSql);
	rs = pstmt.executeQuery();
	%>
	<!-- Feedback List -->
	<div class="form-container">
		<h1>All Feedback</h1>
		<%
		String successMessage = request.getParameter("success");
		String errorCode = request.getParameter("errorCode");
		String errorMessage = null;

		// Map error codes to user-friendly messages
		if ("3".equals(errorCode)) {
			errorMessage = "You can only edit or delete your own feedback.";
		} else if ("4".equals(errorCode)) {
			errorMessage = "Invalid feedback ID. Please check and try again.";
		} else if ("5".equals(errorCode)) {
			errorMessage = "Feedback not found. It may have been deleted or does not exist.";
		}

		// Display success or error message
		if (successMessage != null) {
		%>
		<div class="success"
			style="color: #28a745; font-weight: bold; margin-bottom: 15px;">
			<%=successMessage%>
		</div>
		<%
		} else if (errorMessage != null) {
		%>
		<div class="error"
			style="color: #dc3545; font-weight: bold; margin-bottom: 15px;">
			<%=errorMessage%>
		</div>
		<%
		}
		%>
		<table>
			<thead>
				<tr>
					<th>Name</th>
					<th>Service Used</th>
					<th>Comments</th>
					<th>Rating</th>
					<th>Posted On</th>
					<th>Actions</th>
				</tr>
			</thead>
			<tbody>
				<%
				if (!rs.isBeforeFirst()) {
				%>
				<tr>
					<td colspan="6" style="text-align: center;">No feedback
						available</td>
				</tr>
				<%
				} else {
				while (rs.next()) {
					String name = rs.getString("customer_name");
					String serviceName = rs.getString("service_name");
					String comments = rs.getString("comments");
					int rating = rs.getInt("rating");
					String date = rs.getString("feedback_date");
					int feedbackId = rs.getInt("feedback_id");
				%>
				<tr>
					<td><%=name%></td>
					<td><%=serviceName%></td>
					<td><%=comments%></td>
					<td><%=rating%> &#9733;</td>
					<td><%=date%></td>
					<td>
						<div class="action-buttons">
							<form action="updateFeedback.jsp" method="get"
								style="display: inline;">
								<input type="hidden" name="feedback_id" value="<%=feedbackId%>">
								<button type="submit" class="action-button btn-update">Update</button>
							</form>
							<form action="deleteFeedback.jsp" method="post"
								style="display: inline;">
								<input type="hidden" name="feedback_id" value="<%=feedbackId%>">
								<button type="submit" class="btn-delete"
									onclick="return confirm('Are you sure you want to delete this feedback?')">
									Delete</button>
							</form>
						</div>
					</td>
				</tr>
				<%
				}
				}
				%>
			</tbody>
		</table>
	</div>

	<%
	} catch (Exception e) {
	out.println("<p>Error fetching feedback: " + e.getMessage() + "</p>");
	} finally {
	// Explicitly close resources
	if (rs != null)
		try {
			rs.close();
		} catch (SQLException ignore) {
		}
	if (pstmt != null)
		try {
			pstmt.close();
		} catch (SQLException ignore) {
		}
	if (conn != null)
		try {
			conn.close();
		} catch (SQLException ignore) {
		}
	}
	%>

	<script>
    document.querySelectorAll('.star-rating label').forEach(label => {
        label.addEventListener('mouseover', function () {
            // Highlight all stars up to the hovered one
            const value = this.getAttribute('data-value');
            document.querySelectorAll('.star-rating label').forEach(star => {
                star.style.color = star.getAttribute('data-value') <= value ? 'gold' : '#ccc';
            });
        });

        label.addEventListener('mouseleave', function () {
            // Reset colors based on the selected star
            const selectedValue = document.querySelector('.star-rating input:checked')?.value || 0;
            document.querySelectorAll('.star-rating label').forEach(star => {
                star.style.color = star.getAttribute('data-value') <= selectedValue ? 'gold' : '#ccc';
            });
        });

        label.addEventListener('click', function () {
            // Select the clicked star and fill all to its left
            const value = this.getAttribute('data-value');
            document.querySelectorAll('.star-rating input').forEach(input => {
                input.checked = input.value === value;
            });
            document.querySelectorAll('.star-rating label').forEach(star => {
                star.style.color = star.getAttribute('data-value') <= value ? 'gold' : '#ccc';
            });
        });
    });

    // Initialize star colors on page load
    window.addEventListener('load', function () {
        const selectedValue = document.querySelector('.star-rating input:checked')?.value || 0;
        document.querySelectorAll('.star-rating label').forEach(star => {
            star.style.color = star.getAttribute('data-value') <= selectedValue ? 'gold' : '#ccc';
        });
    });
</script>
	<%@ include file="../footer.html"%>
</body>
</html>
