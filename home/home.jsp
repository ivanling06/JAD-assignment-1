<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sparklean SG | #1 Best Cleaning Services</title>
    <link rel="stylesheet" href="../css/styles.css">
    <link rel="stylesheet" href="../css/navbarStyles.css">
</head>
<body>
    <%@ include file="../navbar.jsp" %>   
    
    <div class="main-content">
        <div class="content-wrapper">
            <div class="text-section">
                <h1>Professional Cleaning Services for a Squeaky Clean Home & Office</h1>
                <p>Experience the highest standard of cleanliness with our expert team. From spotless homes to immaculate offices, we’ve got you covered.</p>
                <button class="cta-button" onclick="window.location.href='../services/allServices.jsp'">Book a Cleaning</button>
            </div>
            <div class="image-section">
                <img src="../images/clean.png" alt="Cleaning Service Image" class="service-image">
            </div>
        </div>
        <hr>
        
        <h1>About Our Service</h1>
        <p>At Sparklean, we are committed to providing exceptional cleaning services tailored to your needs. Whether it’s regular home cleaning or a deep clean for your office, we use eco-friendly products and the latest techniques to deliver spotless results.</p>
        <div class="services-container">
    <div class="service-item">
        <div class="service-text">
            <h1>Home Cleaning</h1>
            <ul>
                <li>Keep your home spotless with ease.</li>
                <li>Flexible scheduling options</li>
                <li>Reliable and professional cleaners at your service.</li>
            </ul>
            <a href="../services/homeCleaning.jsp" class="cta-button">More Info</a>
        </div>
        <div class="service-image">
            <img src="../images/home_cleaning.png" alt="Home Cleaning">
        </div>
    </div>

    <div class="service-item">
        <div class="service-text">
            <h1>Office Cleaning</h1>
            <ul>
                <li>Maintain a pristine and productive workspace.</li>
                <li>Flexible scheduling for minimal disruption.</li>
                <li>Experienced professionals for a hygienic office.</li>
            </ul>
            <a href="../services/officeCleaning.jsp" class="cta-button">More Info</a>
        </div>
        <div class="service-image">
            <img src="../images/office_cleaning.png" alt="Home Cleaning">
        </div>
    </div>
    <div class="service-item">
        <div class="service-text">
            <h1>Deep Cleaning</h1>
            <ul>
                <li>Expert solutions for deep cleaning and tough stains.</li>
                <li>Advanced techniques for specific cleaning needs.</li>
                <li>Eco-friendly products for a safer environment.</li>
            </ul>
            <a href="../services/specialisedCleaning.jsp" class="cta-button">More Info</a>
        </div>
        <div class="service-image">
            <img src="../images/deep_cleaning.png" alt="Home Cleaning">
        </div>
    </div>
</div>
    </div>
    
    <%@ include file="../footer.html" %>   
</body>
</html>
