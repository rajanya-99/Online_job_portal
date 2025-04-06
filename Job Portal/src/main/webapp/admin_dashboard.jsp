<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.portal.util.DBConnection" %>

<%
    // Prevent Back Button After Logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");

    // Validate Admin Session
    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || sessionUser.getAttribute("user_id") == null || !"admin".equals(sessionUser.getAttribute("role"))) {
        response.sendRedirect("login.jsp?message=Session expired. Please log in again.");
        return;
    }

    Connection con = DBConnection.getConnection();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
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
        h2, h3 {
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
    </style>
</head>
<body>

    <div class="navbar">
        <a href="admin_dashboard.jsp">Dashboard</a>
        <a href="logout">Logout</a>
    </div>

    <div class="container">
        <h2>Admin Dashboard</h2>

        <h3>Manage Users</h3>
        <table>
            <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Role</th>
                <th>Actions</th>
            </tr>
            <%
                try (PreparedStatement psUsers = con.prepareStatement("SELECT user_id, name, email, role FROM users WHERE role != 'admin'")) {
                    try (ResultSet rsUsers = psUsers.executeQuery()) {
                        while (rsUsers.next()) {
            %>
            <tr>
                <td><%= rsUsers.getString("name") %></td>
                <td><%= rsUsers.getString("email") %></td>
                <td><%= rsUsers.getString("role") %></td>
                <td>
                    <form action="ManageUsersServlet" method="post">
                        <input type="hidden" name="user_id" value="<%= rsUsers.getInt("user_id") %>">
                        <input type="submit" class="btn-danger" value="Delete" onclick="return confirm('Are you sure?')">
                    </form>
                </td>
            </tr>
            <%
                        }
                    }
                }
            %>
        </table>

        <h3>Manage Jobs</h3>
        <table>
            <tr>
                <th>Title</th>
                <th>Employer</th>
                <th>Location</th>
                <th>Posted Date</th>
                <th>Actions</th>
            </tr>
            <%
                try (PreparedStatement psJobs = con.prepareStatement(
                    "SELECT j.job_id, j.title, j.location, j.posted_date, u.name AS employer_name " +
                    "FROM jobs j JOIN users u ON j.employer_id = u.user_id")) {
                    try (ResultSet rsJobs = psJobs.executeQuery()) {
                        while (rsJobs.next()) {
            %>
            <tr>
                <td><%= rsJobs.getString("title") %></td>
                <td><%= rsJobs.getString("employer_name") %></td>
                <td><%= rsJobs.getString("location") %></td>
                <td><%= rsJobs.getDate("posted_date") %></td>
                <td>
                    <form action="ManageJobsServlet" method="post">
                        <input type="hidden" name="job_id" value="<%= rsJobs.getInt("job_id") %>">
                        <input type="submit" class="btn-danger" value="Delete" onclick="return confirm('Are you sure?')">
                    </form>
                </td>
            </tr>
            <%
                        }
                    }
                }
            %>
        </table>
    </div>

</body>
</html>