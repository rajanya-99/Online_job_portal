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

    int userId = (Integer) sessionUser.getAttribute("user_id");
    String userRole = (String) sessionUser.getAttribute("role");
    String userName = (String) sessionUser.getAttribute("username");

    // If username is null, fetch it from the database
    if (userName == null) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT name FROM users WHERE user_id=?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                userName = rs.getString("name");
                sessionUser.setAttribute("username", userName); // Store username in session
            }
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Job Portal</title>
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
        .dashboard-container {
            background: white;
            padding: 30px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            text-align: center;
            width: 450px;
        }
        h2 {
            margin-bottom: 10px;
            color: #333;
        }
        p {
            font-size: 14px;
            color: #555;
        }
        nav {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-top: 20px;
        }
        a {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 12px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }
        a:hover {
            background-color: #0056b3;
        }
        .icon {
            font-size: 18px;
        }
        .logout {
            background-color: #dc3545;
        }
        .logout:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <h2>Welcome, <%= userName != null ? userName : "User" %>!</h2>
        <p>Manage your job applications, explore new opportunities, and track your progress.</p>
        
        <nav>
            <% if ("job_seeker".equals(userRole)) { %>
                <a href="job_seeker_dashboard.jsp"><span class="icon">👤</span> Job Seeker Dashboard</a>
                <a href="search.jsp"><span class="icon">🔎</span> Search Jobs</a>
                <a href="applications.jsp"><span class="icon">📄</span> My Applications</a>
                <a href="recommendations.jsp"><span class="icon">⭐</span> View Recommended Jobs</a>
                <a href="NotificationServlet"><span class="icon">🔔</span> Job Notifications</a>
            <% } else if ("employer".equals(userRole)) { %>
                <a href="employer_dashboard.jsp"><span class="icon">🏢</span> Employer Dashboard</a>
                <a href="post_job.jsp"><span class="icon">➕</span> Post a Job</a>
                <a href="manage_jobs.jsp"><span class="icon">📂</span> Manage Jobs</a>
                <a href="view_applicants.jsp"><span class="icon">👥</span> View Applicants</a>
            <% } else if ("admin".equals(userRole)) { %>
                <a href="admin_dashboard.jsp"><span class="icon">⚙</span> Admin Dashboard</a>
                <a href="manage_users.jsp"><span class="icon">👤</span> Manage Users</a>
                <a href="manage_jobs.jsp"><span class="icon">📂</span> Manage Job Listings</a>
                <a href="site_settings.jsp"><span class="icon">🔧</span> Site Settings</a>
            <% } %>
            
            <a href="logout" class="logout"><span class="icon">🚪</span> Logout</a>
        </nav>
    </div>
</body>
</html>