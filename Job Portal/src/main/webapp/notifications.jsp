<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.portal.model.Notification" %>

<%
    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || sessionUser.getAttribute("user_id") == null) {
    	response.sendRedirect("login.jsp?message=Session expired. Please log in again.");
        return;
    }

    List<Notification> notificationsList = (List<Notification>) request.getAttribute("notificationsList");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Notifications</title>
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
            width: 60%;
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
        .notification-card {
            border: 1px solid #ddd;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 10px;
            background: #fff;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: 0.3s;
        }
        .notification-card.unread {
            background: #e9f5ff;
            border-left: 5px solid #007bff;
        }
        .notification-card.read {
            background: #f0f0f0;
            border-left: 5px solid #6c757d;
        }
        .notification-text {
            flex: 1;
        }
        .btn-mark-read {
            background: #28a745;
            color: white;
            padding: 5px 10px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }
        .btn-mark-read:hover {
            background: #218838;
        }
        .no-notifications {
            text-align: center;
            font-size: 16px;
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
        <a href="dashboard.jsp">Dashboard</a>
        <a href="logout">Logout</a>
    </div>

    <div class="container">
        <h2>Notifications</h2>

        <% if (notificationsList != null && !notificationsList.isEmpty()) { 
            for (Notification notification : notificationsList) { 
                boolean isRead = "read".equalsIgnoreCase(notification.getStatus());
        %>
            <div class="notification-card <%= isRead ? "read" : "unread" %>">
                <div class="notification-text">
                    <strong><%= notification.getMessage() %></strong>
                </div>
                <% if (!isRead) { %>
                    <form action="MarkNotificationServlet" method="post">
                        <input type="hidden" name="notification_id" value="<%= notification.getNotificationId() %>">
                        <input type="submit" class="btn-mark-read" value="Mark as Read">
                    </form>
                <% } %>
            </div>
        <% } } else { %>
            <p class="no-notifications">No notifications found.</p>
        <% } %>

        <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
    </div>

</body>
</html>