<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.portal.util.DBConnection" %>

<%
    // Prevent Back Button After Logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");

    // Validate Employer Session
    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || sessionUser.getAttribute("user_id") == null || !"employer".equals(sessionUser.getAttribute("role"))) {
        response.sendRedirect("login.jsp?message=Session expired. Please log in again.");
        return;
    }

    int employerId = (Integer) sessionUser.getAttribute("user_id");
    String employerName = (String) sessionUser.getAttribute("username");

    Connection con = null;
    PreparedStatement psJobs = null;
    ResultSet rsJobs = null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employer Dashboard | Job Portal</title>
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
            width: 90%;
            max-width: 900px;
        }
        h2 {
            color: #333;
            margin-bottom: 10px;
        }
        p {
            font-size: 14px;
            color: #555;
        }
        .btn-primary {
            display: inline-block;
            margin: 10px;
            padding: 10px 15px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: 0.3s;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .job-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .job-table th, .job-table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        .job-table th {
            background-color: #007bff;
            color: white;
        }
        .job-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .job-table tr:hover {
            background-color: #f1f1f1;
        }
        .no-jobs {
            text-align: center;
            color: red;
            font-weight: bold;
            padding: 15px;
        }
        .logout-btn {
            margin-top: 20px;
            padding: 10px 15px;
            background-color: #dc3545;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: 0.3s;
        }
        .logout-btn:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Welcome, <%= employerName %>!</h2>
        <p>Manage your job postings, track applicants, and explore opportunities.</p>

        <a href="post_job.jsp" class="btn-primary">➕ Post a New Job</a>
        <a href="view_jobs.jsp" class="btn-primary">📂 View All Jobs Posted By Me</a>

        <h3>My Job Listings</h3>

        <table class="job-table">
            <tr>
                <th>Title</th>
                <th>Location</th>
                <th>Posted Date</th>
                <th>Applicants</th>
            </tr>
            <%
                try {
                    con = DBConnection.getConnection();
                    if (con != null) {
                        String sql = "SELECT job_id, title, location, posted_date FROM jobs WHERE employer_id = ?";
                        psJobs = con.prepareStatement(sql);
                        psJobs.setInt(1, employerId);
                        rsJobs = psJobs.executeQuery();

                        boolean hasJobs = false;
                        while (rsJobs.next()) {
                            hasJobs = true;
                            int jobId = rsJobs.getInt("job_id");
            %>
            <tr>
                <td><%= rsJobs.getString("title") %></td>
                <td><%= rsJobs.getString("location") %></td>
                <td><%= rsJobs.getDate("posted_date") %></td>
                <td>
                    <a href="view-applications?job_id=<%= jobId %>" class="btn-primary">👥 View Applicants</a>
                </td>
            </tr>
            <%
                        }
                        if (!hasJobs) {
            %>
            <tr>
                <td colspan="4" class="no-jobs">No jobs posted yet.</td>
            </tr>
            <%
                        }
                    } else {
            %>
            <tr>
                <td colspan="4" class="no-jobs">Database connection failed. Please try again later.</td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
            <tr>
                <td colspan="4" class="no-jobs">Error loading jobs. Please try again later.</td>
            </tr>
            <%
                } finally {
                    try {
                        if (rsJobs != null) rsJobs.close();
                        if (psJobs != null) psJobs.close();
                        if (con != null) con.close();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                }
            %>
        </table>
<br>
        <a href="logout" class="logout-btn">🚪 Logout</a>
    </div>
</body>
</html>