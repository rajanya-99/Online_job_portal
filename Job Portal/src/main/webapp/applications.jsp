<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.portal.util.DBConnection" %>

<%
    // Prevent Back Button After Logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");

    // Validate User Session
    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || sessionUser.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp?message=Session expired. Please log in again.");
        return;
    }

    int userId = (int) sessionUser.getAttribute("user_id");

    // Fetch user applications
    Connection con = DBConnection.getConnection();
    boolean hasApplications = false;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications | Job Portal</title>
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
            max-width: 800px;
        }
        h2 {
            margin-bottom: 20px;
            color: #333;
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
        .no-applications {
            text-align: center;
            font-weight: bold;
            color: #777;
            padding: 15px;
        }
        .status {
            font-weight: bold;
            padding: 5px;
            border-radius: 5px;
        }
        .status.Pending {
            color: #856404;
            background-color: #fff3cd;
        }
        .status.Accepted {
            color: #155724;
            background-color: #d4edda;
        }
        .status.Rejected {
            color: #721c24;
            background-color: #f8d7da;
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
        <h2>My Job Applications</h2>

        <table>
            <tr>
                <th>Job Title</th>
                <th>Category</th>
                <th>Location</th>
                <th>Status</th>
                <th>Applied Date</th>
            </tr>

            <%
                try (PreparedStatement ps = con.prepareStatement(
                    "SELECT a.application_id, j.title, j.category, j.location, a.status, a.applied_date " +
                    "FROM applications a " +
                    "JOIN jobs j ON a.job_id = j.job_id " +
                    "WHERE a.job_seeker_id = ? ORDER BY a.applied_date DESC")) {
                    
                    ps.setInt(1, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            hasApplications = true;
            %>
            <tr>
                <td><%= rs.getString("title") %></td>
                <td><%= rs.getString("category") %></td>
                <td><%= rs.getString("location") %></td>
                <td><span class="status <%= rs.getString("status") %>"><%= rs.getString("status") %></span></td>
                <td><%= rs.getDate("applied_date") %></td>
            </tr>
            <%  
                        }
                    }
                }
            %>

            <% if (!hasApplications) { %>
            <tr>
                <td colspan="5" class="no-applications">No applications found.</td>
            </tr>
            <% } %>
        </table>

        <a href="dashboard.jsp" class="back-link">Back to Dashboard</a>
    </div>
</body>
</html>