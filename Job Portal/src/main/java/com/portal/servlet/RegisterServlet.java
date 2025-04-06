package com.portal.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.portal.util.DBConnection;


public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");  // Storing as plain text (not recommended)
        String role = request.getParameter("role");

        try {
            Connection con = DBConnection.getConnection();

            // Check if the email is already registered
            PreparedStatement checkEmail = con.prepareStatement("SELECT email FROM users WHERE email = ?");
            checkEmail.setString(1, email);
            ResultSet rs = checkEmail.executeQuery();
            
            if (rs.next()) {
                // Email already exists, redirect with error message
                response.sendRedirect("register.jsp?message=Email+already+registered.");
                return;
            }

            // Insert new user
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO users (user_id, name, email, password, role) VALUES (user_seq.NEXTVAL, ?, ?, ?, ?)"
            );
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, role);
            ps.executeUpdate();

            // Redirect to login with success message
            response.sendRedirect("login.jsp?message=Registration+successful,+please+login.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?message=Error+registering+user.");
        }
    }
}