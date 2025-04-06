package com.portal.model;

import java.sql.Timestamp;

public class Notification {
    private int notificationId;
    private int userId;
    private String message;
    private String status;
    private Timestamp createdAt;

    public Notification(int notificationId, int userId, String message, String status, Timestamp createdAt) {
        this.notificationId = notificationId;
        this.userId = userId;
        this.message = message;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getNotificationId() { return notificationId; }
    public int getUserId() { return userId; }
    public String getMessage() { return message; }
    public String getStatus() { return status; }
    public Timestamp getCreatedAt() { return createdAt; }
}