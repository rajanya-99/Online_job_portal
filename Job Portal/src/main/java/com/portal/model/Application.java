package com.portal.model;

public class Application {
    private int applicationId;
    private int jobId;
    private String applicantName;
    private String resume;
    private String status;

    public Application(int applicationId, int jobId, String applicantName, String resume, String status) {
        this.applicationId = applicationId;
        this.jobId = jobId;
        this.applicantName = applicantName;
        this.resume = resume;
        this.status = status;
    }

    public int getApplicationId() { return applicationId; }
    public int getJobId() { return jobId; }
    public String getApplicantName() { return applicantName; }
    public String getResume() { return resume; }
    public String getStatus() { return status; }
}