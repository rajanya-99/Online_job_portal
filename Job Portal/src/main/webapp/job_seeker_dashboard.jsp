<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> 
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.portal.util.DBConnection" %>

<%
    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || sessionUser.getAttribute("user_id") == null || !"job_seeker".equals(sessionUser.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (Integer) sessionUser.getAttribute("user_id");
    Connection con = DBConnection.getConnection();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Seeker Dashboard | Job Portal</title>
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
        .dashboard-container {
            width: 90%;
            max-width: 900px;
            background: white;
            padding: 30px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border-radius: 10px;
            text-align: center;
            position: relative;
        }
        .top-buttons {
            position: absolute;
            top: 15px;
            right: 15px;
        }
        .btn {
            display: inline-block;
            margin: 5px;
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 5px;
            transition: 0.3s;
            font-size: 14px;
        }
        .btn-dashboard {
            background-color: #6c757d;
            color: white;
        }
        .btn-dashboard:hover {
            background-color: #5a6268;
        }
        .btn-logout {
            background-color: #dc3545;
            color: white;
        }
        .btn-logout:hover {
            background-color: #c82333;
        }
        .job-table, .app-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .job-table th, .job-table td, .app-table th, .app-table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        .job-table th, .app-table th {
            background-color: #007bff;
            color: white;
        }
        .job-table tr:nth-child(even), .app-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .job-table tr:hover, .app-table tr:hover {
            background-color: #f1f1f1;
        }
        .no-data {
            text-align: center;
            color: red;
            font-weight: bold;
            padding: 15px;
        }
        .alert {
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 10px;
            font-weight: bold;
            text-align: center;
        }
        .alert-success {
            background-color: #D4EDDA;
            color: #155724;
            border: 1px solid #C3E6CB;
        }
        .alert-danger {
            background-color: #F8D7DA;
            color: #721C24;
            border: 1px solid #F5C6CB;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- ✅ "Back to Dashboard" & "Logout" Buttons -->
        <div class="top-buttons">
            <a href="dashboard.jsp" class="btn btn-dashboard">🔙 Dashboard</a>
            <a href="logout" class="btn btn-logout">🚪 Logout</a>
        </div>

        <h2>Job Seeker Dashboard</h2>

        <!-- ✅ Success/Error Messages -->
        <%
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");

            if (successMessage != null) {
        %>
            <div id="successMsg" class="alert alert-success"><%= successMessage %></div>
        <%
                session.removeAttribute("successMessage"); 
            }
            if (errorMessage != null) {
        %>
            <div id="errorMsg" class="alert alert-danger"><%= errorMessage %></div>
        <%
                session.removeAttribute("errorMessage"); 
            }
        %>

        <div>
            <h3>Available Jobs</h3>
            <table class="job-table">
                <tr>
                    <th>Title</th>
                    <th>Category</th>
                    <th>Location</th>
                    <th>Salary</th>
                    <th>Experience</th>
                    <th>Action</th>
                </tr>
                <%
                    String sql = "SELECT * FROM jobs";
                    PreparedStatement psJobs = con.prepareStatement(sql);
                    ResultSet rsJobs = psJobs.executeQuery();

                    boolean hasJobs = false;
                    while (rsJobs.next()) {
                        hasJobs = true;
                %>
                <tr>
                    <td><%= rsJobs.getString("title") %></td>
                    <td><%= rsJobs.getString("category") %></td>
                    <td><%= rsJobs.getString("location") %></td>
                    <td><%= rsJobs.getInt("salary") %></td>
                    <td><%= rsJobs.getInt("experience") %> years</td>
                    <td><a href="apply.jsp?job_id=<%= rsJobs.getInt("job_id") %>" class="btn btn-dashboard">Apply</a></td>
                </tr>
                <% } if (!hasJobs) { %>
                <tr>
                    <td colspan="6" class="no-data">No jobs available.</td>
                </tr>
                <% } %>
            </table>
        </div>

        <div>
            <h3>My Applications</h3>
            <table class="app-table">
                <tr>
                    <th>Job Title</th>
                    <th>Employer</th>
                    <th>Status</th>
                    <th>Applied Date</th>
                </tr>
                <%
                    PreparedStatement psApps = con.prepareStatement(
                        "SELECT a.status, a.applied_date, j.title, u.name AS employer_name " +
                        "FROM applications a " +
                        "JOIN jobs j ON a.job_id = j.job_id " +
                        "JOIN users u ON j.employer_id = u.user_id " +
                        "WHERE a.job_seeker_id = ?"
                    );
                    psApps.setInt(1, userId);
                    ResultSet rsApps = psApps.executeQuery();

                    boolean hasApplications = false;
                    while (rsApps.next()) {
                        hasApplications = true;
                %>
                <tr>
                    <td><%= rsApps.getString("title") %></td>
                    <td><%= rsApps.getString("employer_name") %></td>
                    <td><%= rsApps.getString("status") %></td>
                    <td><%= rsApps.getDate("applied_date") %></td>
                </tr>
                <% } if (!hasApplications) { %>
                <tr>
                    <td colspan="4" class="no-data">No applications submitted yet.</td>
                </tr>
                <% } %>
            </table>
        </div>
    </div>

    <script>
        setTimeout(() => {
            document.getElementById("successMsg")?.remove();
            document.getElementById("errorMsg")?.remove();
        }, 3000);
    </script>
</body>
</html>