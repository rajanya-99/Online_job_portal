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
import com.portal.model.User;


public class ManageUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check if admin is logged in
        if (session == null || session.getAttribute("user_id") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT user_id, name, email, role FROM users");
            rs = ps.executeQuery();

            ArrayList<User> usersList = new ArrayList<>();
            while (rs.next()) {
                User user = new User(
                    rs.getInt("user_id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("role")
                );
                usersList.add(user);
            }

            request.setAttribute("usersList", usersList);
            request.getRequestDispatcher("manage_users.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Error%20Loading%20Users");
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("user_id"));
        Connection con = null;
        PreparedStatement psDeleteNotifications = null;
        PreparedStatement psDeleteApps = null;
        PreparedStatement psDeleteJobs = null;
        PreparedStatement psDeleteUser = null;
        PreparedStatement psGetRole = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            // 🔥 Step 1: Delete all notifications related to this user
            psDeleteNotifications = con.prepareStatement("DELETE FROM notifications WHERE user_id = ?");
            psDeleteNotifications.setInt(1, userId);
            psDeleteNotifications.executeUpdate();

            // Step 2: Get user role
            psGetRole = con.prepareStatement("SELECT role FROM users WHERE user_id = ?");
            psGetRole.setInt(1, userId);
            rs = psGetRole.executeQuery();

            if (rs.next()) {
                String role = rs.getString("role");

                if ("job_seeker".equals(role)) {
                    // Step 3: Delete job applications for job seekers
                    psDeleteApps = con.prepareStatement("DELETE FROM applications WHERE job_seeker_id = ?");
                    psDeleteApps.setInt(1, userId);
                    psDeleteApps.executeUpdate();
                } else if ("employer".equals(role)) {
                    // Step 4: Delete applications related to employer's jobs
                    psDeleteApps = con.prepareStatement("DELETE FROM applications WHERE job_id IN (SELECT job_id FROM jobs WHERE employer_id = ?)");
                    psDeleteApps.setInt(1, userId);
                    psDeleteApps.executeUpdate();

                    // Step 5: Delete employer's jobs
                    psDeleteJobs = con.prepareStatement("DELETE FROM jobs WHERE employer_id = ?");
                    psDeleteJobs.setInt(1, userId);
                    psDeleteJobs.executeUpdate();
                }

                // Step 6: Delete the user
                psDeleteUser = con.prepareStatement("DELETE FROM users WHERE user_id = ?");
                psDeleteUser.setInt(1, userId);
                int rowsDeleted = psDeleteUser.executeUpdate();

                if (rowsDeleted > 0) {
                    response.sendRedirect("ManageUsersServlet?message=User%20Deleted%20Successfully");
                } else {
                    response.sendRedirect("error.jsp?message=User%20Not%20Found");
                }
            } else {
                response.sendRedirect("error.jsp?message=User%20Not%20Found");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Error%20Deleting%20User");
        } finally {
            try {
                if (rs != null) rs.close();
                if (psGetRole != null) psGetRole.close();
                if (psDeleteNotifications != null) psDeleteNotifications.close();
                if (psDeleteApps != null) psDeleteApps.close();
                if (psDeleteJobs != null) psDeleteJobs.close();
                if (psDeleteUser != null) psDeleteUser.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}