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
import com.portal.model.Application;

public class ViewApplicationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Ensure user is logged in and is an employer
        if (session == null || session.getAttribute("user_id") == null || !"employer".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String jobIdParam = request.getParameter("job_id");
        int jobId = 0;

        try {
            jobId = Integer.parseInt(jobIdParam);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid Job ID.");
            request.getRequestDispatcher("view_applications.jsp").forward(request, response);
            return;
        }

        ArrayList<Application> applications = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT a.application_id, a.job_id, u.name, a.resume, a.status " +
                         "FROM applications a " +
                         "JOIN users u ON a.job_seeker_id = u.user_id " +
                         "WHERE a.job_id = ?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, jobId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Application app = new Application(
                    rs.getInt("application_id"),
                    rs.getInt("job_id"),
                    rs.getString("name"),
                    rs.getString("resume") != null ? rs.getString("resume") : "",  // Handle null resume
                    rs.getString("status") != null ? rs.getString("status") : "Pending" // Default status
                );

                applications.add(app);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database Error: Unable to fetch applications.");
        }

        // Ensure applications list is never null
        if (applications.isEmpty()) {
            request.setAttribute("message", "No applicants for this job.");
        }

        request.setAttribute("applications", applications);
        request.setAttribute("jobId", jobId);
        request.getRequestDispatcher("view_applications.jsp").forward(request, response);
    }
}