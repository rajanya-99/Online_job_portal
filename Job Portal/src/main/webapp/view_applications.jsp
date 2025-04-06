<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.ArrayList, com.portal.model.Application, java.net.URLEncoder" %>

<%
    // Retrieve jobId safely
    Integer jobIdObj = (Integer) request.getAttribute("jobId");
    int jobId = (jobIdObj != null) ? jobIdObj : 0;

    // Retrieve applications list safely
    ArrayList<Application> applications = (ArrayList<Application>) request.getAttribute("applications");
    if (applications == null) {
        applications = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Applications</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }
        .container {
            width: 80%;
            margin: 20px auto;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #007BFF;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        a {
            text-decoration: none;
            color: #007BFF;
        }
        a:hover {
            text-decoration: underline;
        }
        button {
            padding: 5px 10px;
            border: none;
            background: #28a745;
            color: white;
            cursor: pointer;
            border-radius: 5px;
        }
        button:hover {
            background: #218838;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Applicants for Job ID: <%= jobId %></h2>

        <% if (applications.isEmpty()) { %>
            <p>No applicants for this job.</p>
        <% } else { %>
            <table>
                <tr>
                    <th>Application ID</th>
                    <th>Job Seeker Name</th>
                    <th>Resume</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
                <% for (Application app : applications) { %>
                    <tr>
                        <td><%= app.getApplicationId() %></td>
                        <td><%= app.getApplicantName() %></td>
                        <td>
                            <% 
                                String resumePath = app.getResume(); 
                                if (resumePath != null && !resumePath.isEmpty()) {
                                    // Fix: Ensure proper encoding for secure file retrieval
                                    String encodedResumePath = URLEncoder.encode(resumePath.replace("\\", "/"), "UTF-8");
                            %>
                                <a href="DownloadResumeServlet?file=<%= encodedResumePath %>">Download Resume</a>
                            <% } else { %>
                                No Resume Uploaded
                            <% } %>
                        </td>
                        <td><%= app.getStatus() %></td>
                        <td>
                            <form action="update_status" method="post">
                                <input type="hidden" name="application_id" value="<%= app.getApplicationId() %>">
                                
                                <select name="status">
                                    <option value="Pending" <%= "Pending".equals(app.getStatus()) ? "selected" : "" %>>Pending</option>
                                    <option value="Accepted" <%= "Accepted".equals(app.getStatus()) ? "selected" : "" %>>Accepted</option>
                                    <option value="Rejected" <%= "Rejected".equals(app.getStatus()) ? "selected" : "" %>>Rejected</option>
                                    <option value="Processing" <%= "Processing".equals(app.getStatus()) ? "selected" : "" %>>Processing</option>
                                </select>

                                <br><br><button type="submit">Update</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
            </table>
        <% } %>

        <br>
        <a href="employer_dashboard.jsp">Back to Dashboard</a>
    </div>
</body>
</html>