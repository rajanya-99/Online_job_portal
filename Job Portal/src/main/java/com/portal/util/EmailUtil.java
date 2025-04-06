package com.portal.util;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailUtil {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_USERNAME = "onlinejobportal6b@gmail.com";  // Replace with your email
    private static final String EMAIL_PASSWORD = "bxpm juts fuvu ibzu";     // Replace with App Password

    public static void sendEmail(String recipient, String subject, String content) {
        Properties properties = new Properties();
        properties.put("mail.smtp.host", SMTP_HOST);
        properties.put("mail.smtp.port", SMTP_PORT);
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.ssl.protocols", "TLSv1.2");  // Force TLS 1.2

        // Enable Debugging to see errors
        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });
        session.setDebug(true); // Enable debug logs for troubleshooting

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
            message.setSubject(subject);
            message.setText(content);
            
            Transport.send(message);
            System.out.println("✅ Email sent successfully to: " + recipient);
        } catch (MessagingException e) {
            e.printStackTrace();
            System.err.println("❌ Email sending failed: " + e.getMessage());
        }
    }

    // Job Application Confirmation Email
    public static void sendApplicationConfirmation(String applicantEmail, String jobTitle) {
        String subject = "Application Submitted Successfully!";
        String content = "Dear Applicant,\n\n"
                + "You have successfully applied for the job: " + jobTitle + ".\n"
                + "We will notify you once the employer reviews your application.\n\n"
                + "Best Regards,\nJob Portal Team";
        sendEmail(applicantEmail, subject, content);
    }

    // Notify Employer of New Application
    public static void sendNewApplicationNotification(String employerEmail, String jobTitle) {
        String subject = "New Job Application Received";
        String content = "Dear Employer,\n\n"
                + "A new applicant has applied for the job: " + jobTitle + ".\n"
                + "Login to your employer dashboard to review applications.\n\n"
                + "Best Regards,\nJob Portal Team";
        sendEmail(employerEmail, subject, content);
    }

    // Notify Applicant About Application Status Update
    public static void sendApplicationStatusUpdate(String applicantEmail, String jobTitle, String status) {
        String subject = "Application Status Updated";
        String content = "Dear Applicant,\n\n"
                + "Your application for the job: " + jobTitle + " has been updated.\n"
                + "New Status: " + status + "\n\n"
                + "Best Regards,\nJob Portal Team";
        sendEmail(applicantEmail, subject, content);
    }

    // Job Posting Confirmation Email
    public static void sendJobPostingConfirmation(String employerEmail, String jobTitle) {
        String subject = "Job Successfully Posted!";
        String content = "Dear Employer,\n\n"
                + "Your job posting for " + jobTitle + " has been successfully published on our platform.\n"
                + "Applicants can now apply for this job.\n\n"
                + "Best Regards,\nJob Portal Team";
        sendEmail(employerEmail, subject, content);
    }
}