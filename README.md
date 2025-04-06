# 💼 Online Job Portal

A complete **Online Job Portal** web application where Job Seekers can apply for jobs, Employers can post jobs and review applicants, and Admins can manage users and job listings. Built with **Java (Servlet + JSP)**, **Oracle XE**, and deployed on **Apache Tomcat**.

---

## 📌 Features

### 👤 User Roles
- **Job Seeker**: Register, login, search/apply for jobs, track applications, receive notifications.
- **Employer**: Post jobs, view applicants, update application status, receive notifications.
- **Admin**: Manage users and job listings via the admin dashboard.

### 🔔 Notifications (Email)
- Job application confirmation
- Employer notification of new applicant
- Applicant status updates
- Job posting confirmations

### 🎯 Core Modules
- User Registration & Login (with Role-based Access)
- Job Search with Filters (by category, location, etc.)
- Job Posting & Management (for Employers)
- Application Management (Apply, Track, Update Status)
- Admin Panel (Manage Jobs & Users)
- Email Notification Integration using JavaMail API

---

## 🧱 Tech Stack

| Layer        | Technology                        |
|--------------|-----------------------------------|
| Frontend     | HTML, CSS, JSP                    |
| Backend      | Java Servlets, JSP                |
| Database     | Oracle XE (10G)                   |
| Server       | Apache Tomcat 9                   |
| IDE          | Eclipse IDE for Enterprise Java   |
| Email API    | JavaMail API                      |

---

## 🛠️ Setup Instructions

### 🔧 Prerequisites
- [Java JDK 8+](https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html)
- [Apache Tomcat 9](https://tomcat.apache.org/download-90.cgi)
- [Oracle XE](https://www.oracle.com/database/technologies/xe-downloads.html)
- [Eclipse IDE for Enterprise Java](https://www.eclipse.org/downloads/packages/)

### 📦 Required JARs
Place the following JARs in your `WEB-INF/lib/` folder:
- `ojdbc8.jar` (Oracle JDBC Driver)
- `mail.jar` (JavaMail API)
- `activation.jar` (JavaMail dependency)

### 🧪 Database Configuration
1. Create a user in Oracle XE (Example: `system/admin`)
2. Import the required tables:
   - 'user', 'job', 'application' and  'notification'.
3. Configure database credentials in your DAO files.

### 📨 Email Setup
1. Enable 2-Step Verification in your Gmail.
2. Generate an App Password and use it in `EmailUtil.java`
3. Allow access to less secure apps (if needed).

### 🚀 Run the Project
1. Import project in Eclipse (as Dynamic Web Project).
2. Deploy to Apache Tomcat.
3. Start server and go to: `http://localhost:8080/JobPortal`

---

## 🙌 Acknowledgements

- JavaMail API Documentation
- Oracle XE Tutorials
- Stack Overflow & Open Source Community ❤️

