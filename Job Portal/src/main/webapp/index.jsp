<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Portal | Home</title>
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
        .welcome-container {
            max-width: 800px;
            background: white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border-radius: 10px;
            padding: 40px;
        }
        .welcome-container h1 {
            color: #333;
        }
        .button-container {
            margin-top: 20px;
        }
        .btn {
            display: inline-block;
            padding: 12px 25px;
            margin: 10px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            transition: 0.3s;
        }
        .btn:hover {
            background-color: #0056b3;
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
        <a href="mailto:onlinejobportal6b@gmail.com">Contact Us</a>
    </nav>

    <!-- Main Content -->
    <div class="content">
        <div class="welcome-container">
            <h1>Welcome to Job Portal</h1>
            <p>Find the best jobs that match your skills and apply with ease.</p>
            <p>Whether you're a job seeker looking for new opportunities or an employer searching for the right talent, we've got you covered.</p>
            <div class="button-container">
                <a href="login.jsp" class="btn">Login</a>
                <a href="register.jsp" class="btn">Register</a>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        &copy; 2025 Job Portal. All Rights Reserved. | 
        <a href="about.jsp">About Us</a> | 
        <a href="mailto:onlinejobportal6b@gmail.com">Contact Us</a>
    </footer>

</body>
</html>