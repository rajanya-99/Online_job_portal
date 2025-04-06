<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, com.portal.model.Job" %>

<%
    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || sessionUser.getAttribute("user_id") == null) {
    	response.sendRedirect("login.jsp?message=Session expired. Please log in again.");
        return;
    }

    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Jobs | Job Portal</title>
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
            text-align: center;
            width: 80%;
            max-width: 600px;
        }
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        label {
            font-weight: bold;
            text-align: left;
        }
        select, input, button {
            padding: 10px;
            width: 100%;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            background-color: #007bff;
            color: white;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background-color: #0056b3;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        .no-jobs {
            text-align: center;
            font-weight: bold;
            color: #777;
            padding: 15px;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 15px;
            background-color: #28a745;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .back-link:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Search for Jobs</h2>

        <!-- Search Form -->
        <form action="search-job" method="get">
            <label>Category:</label>
            <select name="category">
                <option value="">All</option>
                <option value="Software">Software</option>
                <option value="Marketing">Marketing</option>
                <option value="Finance">Finance</option>
                <option value="Education">Education</option>
            </select>

            <label>Location:</label>
            <input type="text" name="location" placeholder="Enter Location">

            <label>Job Type:</label>
            <select name="job_type">
                <option value="">All</option>
                <option value="Full-Time">Full-Time</option>
                <option value="Part-Time">Part-Time</option>
                <option value="Remote">Remote</option>
            </select>

            <button type="submit">Search</button>
        </form>

        <!-- Job Listings -->
        <table>
            <tr>
                <th>Title</th>
                <th>Category</th>
                <th>Location</th>
                <th>Salary</th>
                <th>Experience</th>
                <th>Action</th>
            </tr>
            <% if (jobs != null && !jobs.isEmpty()) { 
                for (Job job : jobs) { %>
            <tr>
                <td><%= job.getTitle() %></td>
                <td><%= job.getCategory() %></td>
                <td><%= job.getLocation() %></td>
                <td><%= job.getSalary() %></td>
                <td><%= job.getExperience() %> years</td>
                <td><a href="apply.jsp?job_id=<%= job.getJobId() %>" class="btn-primary">Apply</a></td>
            </tr>
            <% } } else { %>
            <tr>
                <td colspan="6" class="no-jobs">No jobs found.</td>
            </tr>
            <% } %>
        </table>

        <a href="dashboard.jsp" class="back-link">Back to Dashboard</a>
    </div>
</body>
</html>