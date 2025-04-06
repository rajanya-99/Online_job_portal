<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.portal.model.User" %>

<%
    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || sessionUser.getAttribute("user_id") == null || !"admin".equals(sessionUser.getAttribute("role"))) {
    	response.sendRedirect("login.jsp?message=Session expired. Please log in again.");
        return;
    }

    List<User> usersList = (List<User>) request.getAttribute("usersList");
    if (usersList == null) {
        response.sendRedirect("ManageUsersServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Users</title>
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
        <h2>Manage Users</h2>

        <% if (usersList == null || usersList.isEmpty()) { %>
            <p class="no-data">No users available.</p>
        <% } else { %>
            <table>
                <tr>
                    <th>User ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Action</th>
                </tr>
                <% for (User user : usersList) { %>
                    <tr>
                        <td><%= user.getUserId() %></td>
                        <td><%= user.getName() %></td>
                        <td><%= user.getEmail() %></td>
                        <td><%= user.getRole() %></td>
                        <td>
                            <form action="ManageUsersServlet" method="post" onsubmit="return confirm('Are you sure you want to delete this user?')">
                                <input type="hidden" name="user_id" value="<%= user.getUserId() %>">
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