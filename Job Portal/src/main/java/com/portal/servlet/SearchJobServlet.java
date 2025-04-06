package com.portal.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.portal.util.DBConnection;
import com.portal.model.Job;

@WebServlet("/search-job")
public class SearchJobServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String category = request.getParameter("category");
        String location = request.getParameter("location");
        String jobType = request.getParameter("job_type");

        ArrayList<Job> jobs = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM jobs WHERE 1=1";

            // Dynamically adding conditions
            if (category != null && !category.isEmpty()) sql += " AND category = ?";
            if (location != null && !location.isEmpty()) sql += " AND location LIKE ?";
            if (jobType != null && !jobType.isEmpty()) sql += " AND job_type = ?";

            PreparedStatement ps = con.prepareStatement(sql);

            int index = 1;
            if (category != null && !category.isEmpty()) ps.setString(index++, category);
            if (location != null && !location.isEmpty()) ps.setString(index++, "%" + location + "%");
            if (jobType != null && !jobType.isEmpty()) ps.setString(index++, jobType);

            ResultSet rs = ps.executeQuery();
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
                    rs.getDate("posted_date") // Fetching Date from database
                );
                jobs.add(job);
            }

            request.setAttribute("jobs", jobs);
            request.getRequestDispatcher("search.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}