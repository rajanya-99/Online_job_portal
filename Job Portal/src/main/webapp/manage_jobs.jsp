<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.portal.model.Job" %>

<%
    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || sessionUser.getAttribute("user_id") == null || !"admin".equals(sessionUser.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Job> jobsList = (List<Job>) request.getAttribute("jobsList");
    if (jobsList == null) {
        response.sendRedirect("ManageJobsServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Jobs</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        .navbar {
            background: #007bff;
            padding: 10px;
            text-align: center;
        }
        .navbar a {
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            font-size: 16px;
        }
        .navbar a:hover {
            background: #0056b3;
            border-radius: 5px;
        }
        .container {
            width: 80%;
            margin: auto;
            background: #ffffff;
            padding: 20px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            margin-top: 50px;
            border-radius: 8px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            background: white;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background: #007bff;
            color: white;
        }
        tr:nth-child(even) {
            background: #f2f2f2;
        }
        .btn-danger {
            color: white;
            background: #dc3545;
            padding: 5px 10px;
            border: none;
            text-decoration: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-danger:hover {
            background: #c82333;
        }
        .no-data {
            text-align: center;
            font-weight: bold;
            color: #555;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            font-size: 16px;
            color: #007bff;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="navbar">
        <a href="admin_dashboard.jsp">Dashboard</a>
        <a href="logout">Logout</a>
    </div>

    <div class="container">
        <h2>Manage Jobs</h2>

        <% if (jobsList == null || jobsList.isEmpty()) { %>
            <p class="no-data">No jobs available to display.</p>
        <% } else { %>
            <table>
                <tr>
                    <th>Job ID</th>
                    <th>Title</th>
                    <th>Category</th>
                    <th>Salary</th>
                    <th>Location</th>
                    <th>Experience</th>
                    <th>Job Type</th>
                    <th>Posted Date</th>
                    <th>Action</th>
                </tr>
                <% for (Job job : jobsList) { %>
                    <tr>
                        <td><%= job.getJobId() %></td>
                        <td><%= job.getTitle() %></td>
                        <td><%= job.getCategory() %></td>
                        <td><%= job.getSalary() %></td>
                        <td><%= job.getLocation() %></td>
                        <td><%= job.getExperience() %> years</td>
                        <td><%= job.getJobType() %></td>
                        <td><%= job.getPostedDate() %></td>
                        <td>
                            <form action="ManageJobsServlet" method="post" onsubmit="return confirm('Are you sure you want to delete this job?')">
                                <input type="hidden" name="job_id" value="<%= job.getJobId() %>">
                                <input type="submit" value="Delete" class="btn-danger">
                            </form>
                        </td>
                    </tr>
                <% } %>
            </table>
        <% } %>

        <a href="admin_dashboard.jsp" class="back-link">Back to Dashboard</a>
    </div>

</body>
</html>