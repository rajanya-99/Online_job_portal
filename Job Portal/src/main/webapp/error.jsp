<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error | Job Portal</title>
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
            height: 100vh;
        }
        .error-container {
            background: white;
            padding: 30px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border-radius: 10px;
            text-align: center;
            width: 400px;
        }
        .error-icon {
            font-size: 50px;
            color: #dc3545;
            margin-bottom: 15px;
        }
        h2 {
            margin-bottom: 10px;
            color: #dc3545;
        }
        p {
            color: #333;
            font-size: 16px;
            margin-bottom: 20px;
        }
        .btn {
            display: inline-block;
            padding: 10px 15px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin: 5px;
            font-size: 16px;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        .btn-home {
            background-color: #28a745;
        }
        .btn-home:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <h2>Oops! Something went wrong.</h2>
        
        <%
            String errorMessage = request.getParameter("message");
            if (errorMessage == null || errorMessage.isEmpty()) {
                errorMessage = "An unknown error occurred.";
            }
        %>
        
        <p>Error: <%= errorMessage %></p>

        <a href="javascript:history.back()" class="btn">🔙 Go Back</a>
        <a href="index.jsp" class="btn btn-home">🏠 Home</a>
    </div>
</body>
</html>