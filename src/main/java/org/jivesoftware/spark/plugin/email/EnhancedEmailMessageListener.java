package org.jivesoftware.spark.plugin.email;

import org.jivesoftware.spark.ui.ChatRoom;
import org.jivesoftware.spark.ui.MessageListener;
import org.jivesoftware.spark.ui.TranscriptWindow;
import org.jivesoftware.spark.util.log.Log;
import org.jivesoftware.smack.packet.Message;

import javax.swing.*;
import java.awt.*;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.lang.reflect.Method;
import java.util.Properties;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Enhanced message listener with UI integration for email status
 */
public class EnhancedEmailMessageListener implements MessageListener {
    
    private ConcurrentHashMap<String, EmailStatus> messageStatusMap;
    private ConcurrentHashMap<String, EmailStatusPanel> statusPanelMap;
    private Properties emailConfig;
    private static final String PROPERTIES_FILE = "email-plugin.properties";
    
    public EnhancedEmailMessageListener() {
        messageStatusMap = new ConcurrentHashMap<>();
        statusPanelMap = new ConcurrentHashMap<>();
        loadEmailConfig();
    }
    
    @Override
    public void messageReceived(ChatRoom room, Message message) {
        if (isEmailEnabled() && message.getBody() != null && !message.getBody().trim().isEmpty()) {
            String messageId = message.getStanzaId();
            String sender = message.getFrom() != null ? message.getFrom().toString() : "Unknown";
            String body = message.getBody();
            
            // Create and add status panel to the chat room
            EmailStatusPanel statusPanel = new EmailStatusPanel(messageId, sender, body, room);
            statusPanelMap.put(messageId, statusPanel);
            
            // Try to add the status panel to the transcript window
            addStatusPanelToTranscript(room, statusPanel);
            
            // Send email in background thread
            sendEmailAsync(room, messageId, sender, body);
        }
    }
    
    @Override
    public void messageSent(ChatRoom room, Message message) {
        // Not sending emails for outgoing messages
    }
    
    private void sendEmailAsync(ChatRoom room, String messageId, String sender, String body) {
        EmailStatus status = new EmailStatus(messageId, EmailStatus.Status.SENDING);
        messageStatusMap.put(messageId, status);
        
        updateMessageStatus(messageId, EmailStatus.Status.SENDING);
        
        new Thread(() -> {
            try {
                EmailSender emailSender = new EmailSender(emailConfig);
                String subject = "Chat message from: " + extractUsername(sender);
                emailSender.sendEmail(subject, body);
                
                status.setStatus(EmailStatus.Status.SENT);
                updateMessageStatus(messageId, EmailStatus.Status.SENT);
                
            } catch (Exception e) {
                Log.error("Failed to send email for message: " + messageId, e);
                status.setStatus(EmailStatus.Status.FAILED);
                status.setErrorMessage(e.getMessage());
                updateMessageStatus(messageId, EmailStatus.Status.FAILED);
            }
        }).start();
    }
    
    public void resendEmail(ChatRoom room, String messageId, String sender, String body) {
        sendEmailAsync(room, messageId, sender, body);
    }
    
    private void updateMessageStatus(String messageId, EmailStatus.Status status) {
        EmailStatusPanel panel = statusPanelMap.get(messageId);
        if (panel != null) {
            panel.updateStatus(status.toString());
        }
    }
    
    private void addStatusPanelToTranscript(ChatRoom room, EmailStatusPanel statusPanel) {
        try {
            // Get the transcript window from the chat room
            Method getTranscriptMethod = room.getClass().getMethod("getTranscriptWindow");
            TranscriptWindow transcript = (TranscriptWindow) getTranscriptMethod.invoke(room);
            
            if (transcript != null) {
                SwingUtilities.invokeLater(() -> {
                    try {
                        // Add the status panel to the transcript
                        JPanel messagePanel = new JPanel(new BorderLayout());
                        messagePanel.setOpaque(false);
                        messagePanel.add(statusPanel, BorderLayout.EAST);
                        
                        // Insert into transcript
                        transcript.insertComponent(messagePanel);
                        
                    } catch (Exception e) {
                        Log.error("Error adding status panel to transcript", e);
                    }
                });
            }
        } catch (Exception e) {
            Log.error("Error accessing transcript window", e);
        }
    }
    
    private String extractUsername(String jid) {
        if (jid == null) return "Unknown";
        int atIndex = jid.indexOf("@");
        if (atIndex > 0) {
            return jid.substring(0, atIndex);
        }
        return jid;
    }
    
    private boolean isEmailEnabled() {
        loadEmailConfig();
        return Boolean.parseBoolean(emailConfig.getProperty("enabled", "false"));
    }
    
    private void loadEmailConfig() {
        emailConfig = new Properties();
        File configFile = new File(getConfigDirectory(), PROPERTIES_FILE);
        if (configFile.exists()) {
            try (FileInputStream fis = new FileInputStream(configFile)) {
                emailConfig.load(fis);
            } catch (IOException e) {
                Log.error("Error loading email configuration", e);
            }
        }
    }
    
    private File getConfigDirectory() {
        File userDir = new File(System.getProperty("user.home"), ".spark");
        if (!userDir.exists()) {
            userDir.mkdirs();
        }
        return userDir;
    }
    
    public EmailStatus getMessageStatus(String messageId) {
        return messageStatusMap.get(messageId);
    }
    
    public static class EmailStatus {
        public enum Status {
            SENDING,
            SENT,
            FAILED
        }
        
        private String messageId;
        private Status status;
        private String errorMessage;
        
        public EmailStatus(String messageId, Status status) {
            this.messageId = messageId;
            this.status = status;
        }
        
        public String getMessageId() {
            return messageId;
        }
        
        public Status getStatus() {
            return status;
        }
        
        public void setStatus(Status status) {
            this.status = status;
        }
        
        public String getErrorMessage() {
            return errorMessage;
        }
        
        public void setErrorMessage(String errorMessage) {
            this.errorMessage = errorMessage;
        }
    }
}
