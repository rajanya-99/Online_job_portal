package com.portal.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DownloadResumeServlet")
public class DownloadResumeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Set the directory where resumes are stored
    private static final String UPLOAD_DIRECTORY = "C:/uploads/resumes/";  // Change if using different path

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fileName = request.getParameter("file");

        if (fileName == null || fileName.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid file name!");
            return;
        }

        // Decode URL-encoded file names (handles spaces, special characters)
        fileName = URLDecoder.decode(fileName, "UTF-8").trim();

        // Prevent directory traversal attacks
        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid file request!");
            return;
        }

        // Construct the full file path
        File file = new File(UPLOAD_DIRECTORY, fileName).getCanonicalFile();
        File uploadDir = new File(UPLOAD_DIRECTORY).getCanonicalFile();

        // Ensure the requested file is inside the allowed directory
        if (!file.getPath().startsWith(uploadDir.getPath())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied!");
            return;
        }

        // Check if file exists and is a file
        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found!");
            return;
        }

        // Set response headers for file download
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");

        // Stream file content to response
        try (FileInputStream fileInputStream = new FileInputStream(file);
             OutputStream outStream = response.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }
        }
    }
}