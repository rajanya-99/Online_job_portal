<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || sessionUser.getAttribute("user_id") == null || !"employer".equals(sessionUser.getAttribute("role"))) {
    	response.sendRedirect("login.jsp?message=Session expired. Please log in again.");
        return;
    }

    String message = request.getParameter("message");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post a Job | Job Portal</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .container {
            background: white;
            padding: 30px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            width: 90%;
            max-width: 500px;
            text-align: center;
        }
        h2 {
            color: #333;
            margin-bottom: 20px;
        }
        .success {
            color: green;
            font-weight: bold;
            margin-bottom: 15px;
        }
        form {
            display: flex;
            flex-direction: column;
            text-align: left;
        }
        label {
            font-weight: bold;
            margin-top: 10px;
        }
        input, textarea, select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }
        textarea {
            resize: vertical;
            height: 80px;
        }
        .btn-primary {
            margin-top: 15px;
            padding: 10px;
            background-color: #007bff;
            color: white;
            font-size: 16px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            transition: 0.3s;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .back-link {
            display: block;
            margin-top: 15px;
            color: #007bff;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Post a Job</h2>

        <% if (message != null && !message.isEmpty()) { %>
            <p class="success"><%= message %></p>
        <% } %>

        <form action="PostJobServlet" method="post">
            <label for="title">Job Title:</label>
            <input type="text" id="title" name="title" required>

            <label for="description">Description:</label>
            <textarea id="description" name="description" required></textarea>

            <label for="category">Category:</label>
            <select id="category" name="category">
                <option value="Software">Software</option>
                <option value="Marketing">Marketing</option>
                <option value="Finance">Finance</option>
                <option value="Education">Education</option>
            </select>

            <label for="salary">Salary:</label>
            <input type="number" id="salary" name="salary" required>

            <label for="location">Location:</label>
            <input type="text" id="location" name="location" required>

            <label for="experience">Experience Required (Years):</label>
            <input type="number" id="experience" name="experience" required>

            <label for="job_type">Job Type:</label>
            <select id="job_type" name="job_type">
                <option value="Full-Time">Full-Time</option>
                <option value="Part-Time">Part-Time</option>
                <option value="Remote">Remote</option>
            </select>

            <button type="submit" class="btn-primary">Post Job</button>
        </form>

        <a href="employer_dashboard.jsp" class="back-link">Back to Dashboard</a>
    </div>
</body>
</html>