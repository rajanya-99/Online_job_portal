package com.portal.model;

import java.util.Date;

public class Job {
    private int jobId;
    private int employerId;
    private String title;
    private String description;
    private String category;
    private int salary;
    private String location;
    private int experience;
    private String jobType;
    private Date postedDate;
    
 // Constructor for search results (without employerId, description, and postedDate)
    

    public Job(int jobId, int employerId, String title, String description, String category, int salary, 
               String location, int experience, String jobType, Date postedDate) {
        this.jobId = jobId;
        this.employerId = employerId;
        this.title = title;
        this.description = description;
        this.category = category;
        this.salary = salary;
        this.location = location;
        this.experience = experience;
        this.jobType = jobType;
        this.postedDate = postedDate;
    }

    public int getJobId() { return jobId; }
    public int getEmployerId() { return employerId; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public String getCategory() { return category; }
    public int getSalary() { return salary; }
    public String getLocation() { return location; }
    
    
    public int getExperience() { return experience; }

    public String getJobType() { return jobType; }
    public Date getPostedDate() { return postedDate; }
}