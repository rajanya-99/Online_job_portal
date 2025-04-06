<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us | Job Portal</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f2f5;
            text-align: center;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .navbar {
            background-color: #007bff;
            padding: 15px 0;
            display: flex;
            justify-content: center;
            gap: 20px;
        }
        .navbar a {
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            font-size: 16px;
            transition: 0.3s;
            border-radius: 5px;
        }
        .navbar a:hover {
            background-color: #0056b3;
        }
        .content {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 50px 20px;
        }
        .about-container {
            max-width: 800px;
            background: white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border-radius: 10px;
            padding: 40px;
            text-align: left;
        }
        .about-container h1 {
            color: #333;
            text-align: center;
        }
        .about-container p {
            color: #555;
            line-height: 1.6;
        }
        .footer {
            background-color: #343a40;
            color: white;
            text-align: center;
            padding: 20px;
            margin-top: auto;
        }
        .footer a {
            color: #ffcc00;
            text-decoration: none;
            font-weight: bold;
        }
        .footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar">
        <a href="index.jsp">Home</a>
        <a href="about.jsp">About Us</a>
        <a href="login.jsp">Login</a>
        <a href="register.jsp">Register</a>
        <a href="mailto:poulomidas2801@gmail.com">Contact Us</a>
    </nav>

    <!-- Main Content -->
    <div class="content">
        <div class="about-container">
            <h1>About Job Portal</h1>
            <p>Welcome to <strong>Job Portal</strong>, your one-stop destination for finding and posting job opportunities.</p>
            <p>Our mission is to bridge the gap between job seekers and employers by providing a seamless and efficient platform for career growth.</p>
            <p>We offer a user-friendly interface, smart job recommendations, and easy application tracking to ensure a smooth hiring process.</p>
            <p>Whether you're looking for your dream job or the perfect candidate, Job Portal is here to help you succeed.</p>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        &copy; 2025 Job Portal. All Rights Reserved. | 
        <a href="index.jsp">Home</a> | 
        <a href="mailto:poulomidas2801@gmail.com">Contact Us</a>
    </footer>

</body>
</html>