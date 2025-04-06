<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.portal.util.DBConnection" %>

<%
    // Prevent Back Button After Logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");

    // Validate User Session & Role
    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || sessionUser.getAttribute("user_id") == null || !"job_seeker".equals(sessionUser.getAttribute("role"))) {
        response.sendRedirect("login.jsp?message=Unauthorized access. Please log in.");
        return;
    }

    // Get Job ID from Request
    String jobIdParam = request.getParameter("job_id");
    if (jobIdParam == null || jobIdParam.isEmpty()) {
        response.sendRedirect("job_seeker_dashboard.jsp?message=Invalid job selection.");
        return;
    }

    int jobId = Integer.parseInt(jobIdParam);
    int userId = (Integer) sessionUser.getAttribute("user_id");

    // Fetch Job Title
    String jobTitle = "";
    try (Connection con = DBConnection.getConnection();
         PreparedStatement psJob = con.prepareStatement("SELECT title FROM jobs WHERE job_id = ?")) {
        
        psJob.setInt(1, jobId);
        try (ResultSet rsJob = psJob.executeQuery()) {
            if (rsJob.next()) {
                jobTitle = rsJob.getString("title");
            } else {
                response.sendRedirect("job_seeker_dashboard.jsp?message=Job not found.");
                return;
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apply for Job | Job Portal</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background: white;
            padding: 30px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            text-align: center;
            width: 400px;
        }
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        label {
            display: block;
            margin: 10px 0 5px;
            text-align: left;
            font-weight: bold;
        }
        input, textarea, button {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }
        button {
            background-color: #007bff;
            color: white;
            cursor: pointer;
            border: none;
            transition: background-color 0.3s ease;
        }
        button:hover {
            background-color: #0056b3;
        }
        .back-btn {
            display: block;
            margin-top: 10px;
            text-align: center;
            color: #007bff;
            text-decoration: none;
            font-size: 14px;
        }
        .back-btn:hover {
            text-decoration: underline;
        }
        textarea {
            width: 100%;
            height: 150px;
            resize: vertical;
        }
        .file-input {
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #ccc;
            padding: 10px;
            border-radius: 5px;
            background-color: #f1f1f1;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Apply for <%= jobTitle %></h2>
        <form method="POST" action="ApplyJobServlet" enctype="multipart/form-data">
            <input type="hidden" name="job_id" value="<%= jobId %>">
            
            <label for="resume">Upload Resume (PDF/DOCX):</label>
            <input type="file" id="resume" name="resume" accept=".pdf,.doc,.docx" required>
            
            <label for="cover_letter">Cover Letter:</label>
            <textarea id="cover_letter" name="cover_letter" required></textarea>
            
            <button type="submit">Apply</button>
        </form>
        <a href="job_seeker_dashboard.jsp" class="back-btn">&#8592; Back to Dashboard</a>
    </div>
</body>
</html>