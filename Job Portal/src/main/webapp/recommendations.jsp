<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.portal.util.DBConnection" %>

<%
    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || sessionUser.getAttribute("user_id") == null) {
    	response.sendRedirect("login.jsp?message=Session expired. Please log in again.");
        return;
    }

    int userId = (int) sessionUser.getAttribute("user_id");

    Connection con = DBConnection.getConnection();

    // Get the most applied category by the user
    PreparedStatement psCategory = con.prepareStatement(
        "SELECT category FROM (SELECT j.category, COUNT(*) AS category_count FROM applications a JOIN jobs j ON a.job_id = j.job_id WHERE a.job_seeker_id = ? GROUP BY j.category ORDER BY category_count DESC) WHERE ROWNUM = 1"
    );
    psCategory.setInt(1, userId);
    ResultSet rsCategory = psCategory.executeQuery();

    String preferredCategory = "";
    if (rsCategory.next()) {
        preferredCategory = rsCategory.getString("category");
    }

    // Get job recommendations based on the preferred category
    PreparedStatement psJobs = con.prepareStatement(
        "SELECT * FROM jobs WHERE category = ? ORDER BY posted_date DESC"
    );
    psJobs.setString(1, preferredCategory);
    ResultSet rsJobs = psJobs.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Recommendations | Job Portal</title>
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
            margin-bottom: 15px;
            color: #333;
        }
        p {
            font-size: 16px;
            color: #555;
        }
        .job-list {
            list-style: none;
            padding: 0;
            margin-top: 20px;
        }
        .job-item {
            padding: 15px;
            margin: 10px 0;
            background-color: #f1f1f1;
            border-left: 5px solid #007bff;
            border-radius: 5px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .job-item a {
            text-decoration: none;
            color: #007bff;
            font-weight: bold;
        }
        .job-item a:hover {
            text-decoration: underline;
        }
        .no-recommendations {
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
        <h2>Job Recommendations</h2>

        <% if (!preferredCategory.isEmpty()) { %>
            <p>Based on your past applications, we recommend jobs in <strong><%= preferredCategory %></strong></p>

            <ul class="job-list">
                <% boolean hasJobs = false; %>
                <% while (rsJobs.next()) { hasJobs = true; %>
                    <li class="job-item">
                        <a href="job_details.jsp?job_id=<%= rsJobs.getInt("job_id") %>"><%= rsJobs.getString("title") %></a>
                        <span><%= rsJobs.getString("location") %></span>
                    </li>
                <% } %>
                <% if (!hasJobs) { %>
                    <p class="no-recommendations">No job recommendations available at the moment.</p>
                <% } %>
            </ul>
        <% } else { %>
            <p class="no-recommendations">No recommendations available yet. Apply for jobs to get personalized recommendations!</p>
        <% } %>

        <a href="dashboard.jsp" class="back-link">Back to Dashboard</a>
    </div>
</body>
</html>