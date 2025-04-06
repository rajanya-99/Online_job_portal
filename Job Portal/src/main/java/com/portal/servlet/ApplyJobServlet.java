package com.portal.servlet;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.Date;
import com.portal.util.DBConnection;
import com.portal.util.EmailUtil;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10, // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class ApplyJobServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIRECTORY = "C:/uploads/resumes/";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user_id") == null || !"job_seeker".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        int jobId;
        String coverLetter = request.getParameter("cover_letter");

        if (coverLetter == null || coverLetter.trim().isEmpty()) {
            session.setAttribute("errorMessage", "❌ Cover Letter cannot be empty.");
            response.sendRedirect("job_seeker_dashboard.jsp");
            return;
        }

        try {
            jobId = Integer.parseInt(request.getParameter("job_id"));
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "❌ Invalid Job ID.");
            response.sendRedirect("job_seeker_dashboard.jsp");
            return;
        }

        // Handle file upload
        Part filePart = request.getPart("resume");
        String originalFileName = getFileName(filePart);

        if (originalFileName == null || originalFileName.isEmpty()) {
            session.setAttribute("errorMessage", "❌ Resume file is required.");
            response.sendRedirect("job_seeker_dashboard.jsp");
            return;
        }

        // Ensure unique filename using timestamp
        String timestamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        String fileName = timestamp + "_" + originalFileName;

        // Ensure the directory exists
        File uploadDir = new File(UPLOAD_DIRECTORY);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String filePath = UPLOAD_DIRECTORY + fileName;
        Files.copy(filePart.getInputStream(), new File(filePath).toPath(), StandardCopyOption.REPLACE_EXISTING);

        Connection con = null;
        PreparedStatement ps = null;
        PreparedStatement checkPs = null;
        PreparedStatement jobPs = null;
        PreparedStatement empPs = null;
        ResultSet rs = null;
        ResultSet jobRs = null;
        ResultSet empRs = null;

        try {
            con = DBConnection.getConnection();

            // Check if user has already applied for this job
            checkPs = con.prepareStatement("SELECT COUNT(*) FROM applications WHERE job_id = ? AND job_seeker_id = ?");
            checkPs.setInt(1, jobId);
            checkPs.setInt(2, userId);
            rs = checkPs.executeQuery();
            rs.next();
            if (rs.getInt(1) > 0) {
                session.setAttribute("errorMessage", "❌ You have already applied for this job.");
                response.sendRedirect("job_seeker_dashboard.jsp");
                return;
            }

            // Fetch job title & employer ID
            jobPs = con.prepareStatement("SELECT title, employer_id FROM jobs WHERE job_id = ?");
            jobPs.setInt(1, jobId);
            jobRs = jobPs.executeQuery();
            String jobTitle = "";
            int employerId = -1;
            if (jobRs.next()) {
                jobTitle = jobRs.getString("title");
                employerId = jobRs.getInt("employer_id");
            }

            if (employerId == -1) {
                session.setAttribute("errorMessage", "❌ Invalid job posting.");
                response.sendRedirect("job_seeker_dashboard.jsp");
                return;
            }

            // Fetch employer email
            String employerEmail = "";
            empPs = con.prepareStatement("SELECT email FROM users WHERE user_id = ?");
            empPs.setInt(1, employerId);
            empRs = empPs.executeQuery();
            if (empRs.next()) {
                employerEmail = empRs.getString("email");
            }

            // Insert application
            ps = con.prepareStatement("INSERT INTO applications (job_id, job_seeker_id, resume, cover_letter, status, applied_date) VALUES (?, ?, ?, ?, 'Pending', SYSDATE)");
            ps.setInt(1, jobId);
            ps.setInt(2, userId);
            ps.setString(3, fileName);
            ps.setString(4, coverLetter);
            int rowsInserted = ps.executeUpdate();

            if (rowsInserted > 0) {
                // ✅ Send email to employer
                if (!employerEmail.isEmpty()) {
                    String subject = "New Job Application for " + jobTitle;
                    String message = "Dear Employer,\n\nA new job application has been received for your job posting: " + jobTitle + ".\n\nPlease check the employer dashboard for details.\n\nBest Regards,\nJob Portal Team";
                    EmailUtil.sendEmail(employerEmail, subject, message);
                    System.out.println("✅ Email sent to employer: " + employerEmail);
                } else {
                    System.out.println("⚠️ Employer email not found, skipping email notification.");
                }

                // ✅ Set success message
                session.setAttribute("successMessage", "✅ Successfully applied for '" + jobTitle + "'!");
                response.sendRedirect("job_seeker_dashboard.jsp");
            } else {
                session.setAttribute("errorMessage", "❌ Application failed.");
                response.sendRedirect("job_seeker_dashboard.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "❌ An error occurred: " + e.getMessage());
            response.sendRedirect("job_seeker_dashboard.jsp");
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (jobRs != null) jobRs.close();
                if (empRs != null) empRs.close();
                if (checkPs != null) checkPs.close();
                if (jobPs != null) jobPs.close();
                if (empPs != null) empPs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // Helper method to extract file name
    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return null;
    }
}
