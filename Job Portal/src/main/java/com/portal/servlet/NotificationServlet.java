package com.portal.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.portal.util.DBConnection;
import com.portal.model.Notification;


public class NotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("user_id");

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            ArrayList<Notification> notificationsList = new ArrayList<>();
            while (rs.next()) {
                Notification notification = new Notification(
                    rs.getInt("notification_id"),
                    rs.getInt("user_id"),
                    rs.getString("message"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at")
                );
                notificationsList.add(notification);
            }

            request.setAttribute("notificationsList", notificationsList);
            request.getRequestDispatcher("notifications.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}