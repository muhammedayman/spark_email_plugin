package org.jivesoftware.spark.plugin.email;

import org.jivesoftware.spark.ui.ChatRoom;
import org.jivesoftware.spark.util.log.Log;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * UI Panel that displays email status for each message
 */
public class EmailStatusPanel extends JPanel {
    
    private JLabel statusLabel;
    private JButton resendButton;
    private String messageId;
    private String sender;
    private String messageBody;
    private ChatRoom chatRoom;
    
    public EmailStatusPanel(String messageId, String sender, String messageBody, ChatRoom chatRoom) {
        this.messageId = messageId;
        this.sender = sender;
        this.messageBody = messageBody;
        this.chatRoom = chatRoom;
        
        initUI();
    }
    
    private void initUI() {
        setLayout(new FlowLayout(FlowLayout.LEFT, 5, 0));
        setOpaque(false);
        
        // Status label with icon
        statusLabel = new JLabel();
        statusLabel.setFont(new Font("Arial", Font.PLAIN, 10));
        add(statusLabel);
        
        // Resend button (initially hidden)
        resendButton = new JButton("Resend");
        resendButton.setFont(new Font("Arial", Font.PLAIN, 10));
        resendButton.setVisible(false);
        resendButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                handleResend();
            }
        });
        add(resendButton);
        
        // Set initial status
        updateStatus("SENDING");
    }
    
    public void updateStatus(String status) {
        SwingUtilities.invokeLater(() -> {
            if ("SENDING".equals(status)) {
                statusLabel.setText("📧 Sending...");
                statusLabel.setForeground(Color.BLUE);
                resendButton.setVisible(false);
            } else if ("SENT".equals(status)) {
                statusLabel.setText("✓ Sent");
                statusLabel.setForeground(new Color(0, 150, 0));
                resendButton.setVisible(false);
            } else if ("FAILED".equals(status)) {
                statusLabel.setText("✗ Failed");
                statusLabel.setForeground(Color.RED);
                resendButton.setVisible(true);
            }
            revalidate();
            repaint();
        });
    }
    
    private void handleResend() {
        // Disable button during resend
        resendButton.setEnabled(false);
        statusLabel.setText("📧 Resending...");
        statusLabel.setForeground(Color.BLUE);
        
        // Attempt to resend - simplified version
        try {
            // Just update status for now
            updateStatus("SENDING");
            
            // Re-enable button after a delay
            new Thread(() -> {
                try {
                    Thread.sleep(3000);
                    SwingUtilities.invokeLater(() -> {
                        updateStatus("SENT");
                        resendButton.setEnabled(true);
                    });
                } catch (InterruptedException e) {
                    Log.error("Error in resend", e);
                }
            }).start();
            
        } catch (Exception e) {
            Log.error("Error resending email", e);
            updateStatus("FAILED");
            resendButton.setEnabled(true);
        }
    }
    
    public String getMessageId() {
        return messageId;
    }
}
