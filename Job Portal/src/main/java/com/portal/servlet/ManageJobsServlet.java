package com.portal.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.portal.util.DBConnection;
import com.portal.model.Job;


public class ManageJobsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Ensure only admin can access
        if (session == null || session.getAttribute("user_id") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM jobs ORDER BY posted_date DESC");
            ResultSet rs = ps.executeQuery();

            ArrayList<Job> jobsList = new ArrayList<>();
            while (rs.next()) {
                Job job = new Job(
                    rs.getInt("job_id"),
                    rs.getInt("employer_id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getString("category"),
                    rs.getInt("salary"),
                    rs.getString("location"),
                    rs.getInt("experience"),
                    rs.getString("job_type"),
                    rs.getDate("posted_date")
                );
                jobsList.add(job);
            }

            // Debugging
            System.out.println("Jobs Found: " + jobsList.size());
            for (Job job : jobsList) {
                System.out.println("Job ID: " + job.getJobId() + " | Title: " + job.getTitle());
            }

            request.setAttribute("jobsList", jobsList);
            request.getRequestDispatcher("manage_jobs.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int jobId = Integer.parseInt(request.getParameter("job_id"));

        try {
            Connection con = DBConnection.getConnection();
            
            // Delete applications related to the job
            PreparedStatement psDeleteApps = con.prepareStatement("DELETE FROM applications WHERE job_id = ?");
            psDeleteApps.setInt(1, jobId);
            psDeleteApps.executeUpdate();
            
            // Delete the job
            PreparedStatement psDeleteJob = con.prepareStatement("DELETE FROM jobs WHERE job_id = ?");
            psDeleteJob.setInt(1, jobId);
            psDeleteJob.executeUpdate();
            
            System.out.println("Job deleted successfully: ID " + jobId);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect back to refresh job list
        response.sendRedirect("ManageJobsServlet");
    }
}