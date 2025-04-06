<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.portal.util.DBConnection" %>

<%
    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || sessionUser.getAttribute("user_id") == null || 
        !"employer".equals(sessionUser.getAttribute("role"))) {
    	response.sendRedirect("login.jsp?message=Session expired. Please log in again.");
        return;
    }

    int employerId = (int) sessionUser.getAttribute("user_id");

    Connection con = DBConnection.getConnection();
    PreparedStatement ps = con.prepareStatement(
        "SELECT job_id, title, category, salary, location, experience, job_type, posted_date FROM jobs WHERE employer_id = ? ORDER BY posted_date DESC"
    );
    ps.setInt(1, employerId);
    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Posted Jobs | Job Portal</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            flex-direction: column;
        }
        .container {
            background: white;
            padding: 30px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            width: 90%;
            max-width: 900px;
            text-align: center;
        }
        h2 {
            color: #333;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        .btn-primary {
            display: inline-block;
            margin-top: 15px;
            padding: 10px;
            background-color: #007bff;
            color: white;
            font-size: 16px;
            text-decoration: none;
            border-radius: 5px;
            transition: 0.3s;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .no-jobs {
            color: red;
            font-weight: bold;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>My Posted Jobs</h2>

        <% boolean hasJobs = false; %>
        <table>
            <tr>
                <th>Job Title</th>
                <th>Category</th>
                <th>Salary</th>
                <th>Location</th>
                <th>Experience</th>
                <th>Job Type</th>
                <th>Posted Date</th>
            </tr>
            <% while (rs.next()) { 
                hasJobs = true;
            %>
            <tr>
                <td><%= rs.getString("title") %></td>
                <td><%= rs.getString("category") %></td>
                <td>₹<%= rs.getInt("salary") %></td>
                <td><%= rs.getString("location") %></td>
                <td><%= rs.getInt("experience") %> years</td>
                <td><%= rs.getString("job_type") %></td>
                <td><%= rs.getDate("posted_date") %></td>
            </tr>
            <% } %>
        </table>

        <% if (!hasJobs) { %>
            <p class="no-jobs">No jobs posted yet.</p>
        <% } %>

        <a href="employer_dashboard.jsp" class="btn-primary">Back to Dashboard</a>
    </div>
</body>
</html>