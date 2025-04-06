package com.portal.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.portal.util.DBConnection;
import com.portal.util.EmailUtil;

public class PostJobServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession sessionUser = request.getSession(false);

        // Ensure employer is logged in
        if (sessionUser == null || sessionUser.getAttribute("user_id") == null || !"employer".equals(sessionUser.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int employerId = (int) sessionUser.getAttribute("user_id");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        int salary = Integer.parseInt(request.getParameter("salary"));
        String location = request.getParameter("location");
        int experience = Integer.parseInt(request.getParameter("experience"));
        String jobType = request.getParameter("job_type");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();

            // Insert job into database
            String insertQuery = "INSERT INTO jobs (job_id, employer_id, title, description, category, salary, location, experience, job_type, posted_date) " +
                                 "VALUES (job_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE)";
            ps = con.prepareStatement(insertQuery);
            ps.setInt(1, employerId);
            ps.setString(2, title);
            ps.setString(3, description);
            ps.setString(4, category);
            ps.setInt(5, salary);
            ps.setString(6, location);
            ps.setInt(7, experience);
            ps.setString(8, jobType);

            int rowsInserted = ps.executeUpdate();

            if (rowsInserted > 0) {
                // Notify job seekers via in-app notification & email
                notifyJobSeekers(con, title, category, location);

                response.sendRedirect("post_job.jsp?message=Job+posted+successfully+and+notifications+sent!");
            } else {
                response.sendRedirect("error.jsp?message=Job+Posting+Failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=" + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void notifyJobSeekers(Connection con, String jobTitle, String category, String location) {
        List<String> jobSeekerEmails = new ArrayList<>();

        try {
            // Get all job seekers' user_id and email
            String query = "SELECT user_id, email FROM users WHERE role='job_seeker'";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int jobSeekerId = rs.getInt("user_id");
                String email = rs.getString("email");
                jobSeekerEmails.add(email);

                // Insert notification in database
                PreparedStatement psNotify = con.prepareStatement(
                    "INSERT INTO notifications (notification_id, user_id, message, status) VALUES (notification_seq.NEXTVAL, ?, ?, 'Unread')"
                );
                psNotify.setInt(1, jobSeekerId);
                psNotify.setString(2, "New job posted: " + jobTitle);
                psNotify.executeUpdate();
            }

            rs.close();
            ps.close();

            // Send email notifications
            for (String email : jobSeekerEmails) {
                String subject = "New Job Alert: " + jobTitle;
                String message = "A new job has been posted on our job portal.\n\n" +
                                 "Job Title: " + jobTitle + "\n" +
                                 "Category: " + category + "\n" +
                                 "Location: " + location + "\n\n" +
                                 "Visit the job portal to apply now!";
                EmailUtil.sendEmail(email, subject, message);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}