package org.jivesoftware.spark.plugin.email;

import org.jivesoftware.spark.ui.ChatRoom;
import org.jivesoftware.spark.ui.GlobalMessageListener;
import org.jivesoftware.spark.util.log.Log;
import org.jivesoftware.smack.packet.Message;
import java.io.File;
import java.io.FileInputStream;
import java.util.Properties;
import java.util.concurrent.ConcurrentHashMap;

public class EmailMessageListener implements GlobalMessageListener {
    
    private ConcurrentHashMap<String, EmailStatus> messageStatusMap;
    private ConcurrentHashMap<String, String> conversationThreadMap; // Maps room name to thread ID
    private ConcurrentHashMap<String, String> lastMessageIdMap; // Maps room name to last message ID
    private Properties emailConfig;
    private static final String PROPERTIES_FILE = "email-plugin.properties";
    
    public EmailMessageListener() {
        messageStatusMap = new ConcurrentHashMap<String, EmailStatus>();
        conversationThreadMap = new ConcurrentHashMap<String, String>();
        lastMessageIdMap = new ConcurrentHashMap<String, String>();
        loadEmailConfig();
    }
    
    public void messageReceived(ChatRoom room, Message message) {
        try {
            if (!isEmailEnabled() || message == null || message.getBody() == null || message.getBody().trim().isEmpty()) {
                return;
            }
            
            String messageId = "msg-" + System.currentTimeMillis();
            try {
                String stanzaId = message.getStanzaId();
                if (stanzaId != null && !stanzaId.isEmpty()) {
                    messageId = stanzaId;
                }
            } catch (Throwable t) {
                // Use generated ID
            }
            
            String sender = room != null ? room.getRoomname() : "Unknown";
            try {
                if (message.getFrom() != null) {
                    sender = message.getFrom().toString();
                }
            } catch (Throwable t) {
                // Use room name as fallback
            }
            
            String body = message.getBody();
            
            Log.warning("Sending email for incoming message from: " + sender);
            String roomName = room != null ? room.getRoomname() : "unknown";
            sendEmailAsync(messageId, sender, body, roomName);
            
        } catch (Throwable t) {
            Log.error("Error in messageReceived", t);
        }
    }
    
    public void messageSent(ChatRoom room, Message message) {
        try {
            if (!isEmailEnabled() || message == null || message.getBody() == null || message.getBody().trim().isEmpty()) {
                return;
            }
            
            String messageId = "msg-" + System.currentTimeMillis();
            try {
                String stanzaId = message.getStanzaId();
                if (stanzaId != null && !stanzaId.isEmpty()) {
                    messageId = stanzaId;
                }
            } catch (Throwable t) {
                // Use generated ID
            }
            
            String recipient = room != null ? room.getRoomname() : "Unknown";
            try {
                if (message.getTo() != null) {
                    recipient = message.getTo().toString();
                }
            } catch (Throwable t) {
                // Use room name as fallback
            }
            
            String body = message.getBody();
            
            Log.warning("Sending email for outgoing message to: " + recipient);
            String roomName = room != null ? room.getRoomname() : "unknown";
            sendEmailAsync(messageId, "You (to " + extractUsername(recipient) + ")", body, roomName);
            
        } catch (Throwable t) {
            Log.error("Error in messageSent", t);
        }
    }
    
    private void sendEmailAsync(final String messageId, final String sender, final String body, final String roomName) {
        EmailStatus status = new EmailStatus(messageId, EmailStatus.Status.SENDING);
        messageStatusMap.put(messageId, status);
        
        new Thread(new Runnable() {
            public void run() {
                try {
                    EmailSender emailSender = new EmailSender(emailConfig);
                    String subject = "Chat message from: " + extractUsername(sender);
                    
                    // Get or create thread ID for this conversation
                    String threadId = conversationThreadMap.get(roomName);
                    if (threadId == null) {
                        // First message in this conversation - create new thread
                        threadId = "chat-" + roomName.replaceAll("[^a-zA-Z0-9]", "-") + "-" + System.currentTimeMillis();
                        conversationThreadMap.put(roomName, threadId);
                    }
                    
                    // Get the last message ID for In-Reply-To header
                    String inReplyTo = lastMessageIdMap.get(roomName);
                    
                    // Generate unique message ID for this email
                    String currentMessageId = threadId + "-" + System.currentTimeMillis();
                    
                    // Send email with threading headers
                    emailSender.sendEmail(subject, body, currentMessageId, inReplyTo);
                    
                    // Update last message ID for this conversation
                    lastMessageIdMap.put(roomName, currentMessageId);
                    
                    EmailStatus s = messageStatusMap.get(messageId);
                    if (s != null) {
                        s.setStatus(EmailStatus.Status.SENT);
                    }
                    Log.warning("Email sent successfully for message from: " + extractUsername(sender) + " (threaded)");
                    
                } catch (Exception e) {
                    Log.error("Failed to send email", e);
                    EmailStatus s = messageStatusMap.get(messageId);
                    if (s != null) {
                        s.setStatus(EmailStatus.Status.FAILED);
                        s.setErrorMessage(e.getMessage());
                    }
                }
            }
        }).start();
    }
    
    private String extractUsername(String jid) {
        if (jid == null) return "Unknown";
        int atIndex = jid.indexOf("@");
        if (atIndex > 0) return jid.substring(0, atIndex);
        int slashIndex = jid.indexOf("/");
        if (slashIndex > 0) return jid.substring(0, slashIndex);
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
            try {
                FileInputStream fis = new FileInputStream(configFile);
                emailConfig.load(fis);
                fis.close();
            } catch (Exception e) {
                Log.error("Error loading email configuration", e);
            }
        }
    }
    
    private File getConfigDirectory() {
        File userDir = new File(System.getProperty("user.home"), ".spark");
        if (!userDir.exists()) userDir.mkdirs();
        return userDir;
    }
    
    public static class EmailStatus {
        public enum Status { SENDING, SENT, FAILED }
        
        private String messageId;
        private Status status;
        private String errorMessage;
        
        public EmailStatus(String messageId, Status status) {
            this.messageId = messageId;
            this.status = status;
        }
        
        public Status getStatus() { return status; }
        public void setStatus(Status status) { this.status = status; }
        public String getErrorMessage() { return errorMessage; }
        public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
    }
}
