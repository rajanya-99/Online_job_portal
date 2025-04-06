package com.portal.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Arrays;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.portal.util.DBConnection;
import com.portal.util.EmailUtil;

@WebServlet("/update_status")
public class UpdateStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Ensure employer is logged in
        if (session == null || session.getAttribute("user_id") == null || !"employer".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int employerId = (int) session.getAttribute("user_id"); // Employer's ID
        int applicationId;
        String newStatus;

        try {
            applicationId = Integer.parseInt(request.getParameter("application_id"));
            newStatus = request.getParameter("status");

            // Allowed statuses as per database constraint
            String[] allowedStatuses = {"Pending", "Accepted", "Rejected", "Processing"};

            // Validate status before updating the database
            if (!Arrays.asList(allowedStatuses).contains(newStatus)) {
                response.sendRedirect("error.jsp?message=Invalid%20Status");
                return;
            }

            Connection con = DBConnection.getConnection();

            // Fetch job seeker email, job title, and employer ID of the job
            PreparedStatement ps = con.prepareStatement(
                "SELECT a.job_seeker_id, u.email, j.title, j.employer_id, a.job_id FROM applications a " +
                "JOIN users u ON a.job_seeker_id = u.user_id " +
                "JOIN jobs j ON a.job_id = j.job_id WHERE a.application_id = ?"
            );
            ps.setInt(1, applicationId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int jobSeekerId = rs.getInt("job_seeker_id");
                String applicantEmail = rs.getString("email");
                String jobTitle = rs.getString("title");
                int jobEmployerId = rs.getInt("employer_id");
                int jobId = rs.getInt("job_id");

                // Ensure that only the correct employer can update the status
                if (employerId != jobEmployerId) {
                    response.sendRedirect("error.jsp?message=Unauthorized%20Action");
                    return;
                }

                // Update the application status
                ps = con.prepareStatement("UPDATE applications SET status = ? WHERE application_id = ?");
                ps.setString(1, newStatus);
                ps.setInt(2, applicationId);
                int updated = ps.executeUpdate();

                if (updated > 0) {
                    // Send email notification to the job seeker
                    EmailUtil.sendApplicationStatusUpdate(applicantEmail, jobTitle, newStatus);
                    response.sendRedirect("view-applications?job_id=" + jobId + "&message=Application%20Status%20Updated%20Successfully");
                } else {
                    response.sendRedirect("error.jsp?message=Status%20Update%20Failed");
                }
            } else {
                response.sendRedirect("error.jsp?message=Invalid%20Application%20ID");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Error%20Updating%20Application%20Status");
        }
    }
}