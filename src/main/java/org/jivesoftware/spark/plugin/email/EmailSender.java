package org.jivesoftware.spark.plugin.email;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

/**
 * Handles sending emails using JavaMail API with threading support
 */
public class EmailSender {
    
    private Properties emailConfig;
    
    public EmailSender(Properties emailConfig) {
        this.emailConfig = emailConfig;
    }
    
    public void sendEmail(String subject, String body) throws MessagingException {
        sendEmail(subject, body, null, null);
    }
    
    public void sendEmail(String subject, String body, String threadId, String inReplyTo) throws MessagingException {
        String host = emailConfig.getProperty("host");
        String port = emailConfig.getProperty("port", "587");
        String username = emailConfig.getProperty("username");
        String password = emailConfig.getProperty("password");
        String recipient = emailConfig.getProperty("recipient");
        boolean useSSL = Boolean.parseBoolean(emailConfig.getProperty("ssl", "true"));
        
        // Setup mail server properties
        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.auth", "true");
        
        if (useSSL) {
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        }
        
        // Create session with authentication
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
        
        // Create message
        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(username));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
        message.setSubject(subject);
        message.setText(body);
        
        // Add threading headers if provided
        if (threadId != null && !threadId.isEmpty()) {
            // Set Message-ID for this email
            String messageId = "<" + threadId + "@spark-email-plugin>";
            message.setHeader("Message-ID", messageId);
            
            // If this is a reply, set In-Reply-To and References
            if (inReplyTo != null && !inReplyTo.isEmpty()) {
                String replyToId = "<" + inReplyTo + "@spark-email-plugin>";
                message.setHeader("In-Reply-To", replyToId);
                message.setHeader("References", replyToId);
            }
        }
        
        // Send message
        Transport.send(message);
    }
}
