package org.jivesoftware.spark.plugin.email;

import org.jivesoftware.spark.preference.Preference;
import org.jivesoftware.spark.util.log.Log;

import javax.swing.*;
import java.awt.*;
import java.util.Properties;
import java.io.*;

/**
 * Email configuration preference panel
 */
public class EmailPreference implements Preference {
    
    private JPanel mainPanel;
    private JTextField emailHostField;
    private JTextField emailPortField;
    private JTextField emailUsernameField;
    private JPasswordField emailPasswordField;
    private JTextField recipientEmailField;
    private JCheckBox enableSSLCheckBox;
    private JCheckBox enableEmailCheckBox;
    
    private static final String PROPERTIES_FILE = "email-plugin.properties";
    private Properties properties;
    
    public EmailPreference() {
        properties = new Properties();
        loadSettings();
        initUI();
    }
    
    private void initUI() {
        mainPanel = new JPanel();
        mainPanel.setLayout(new GridBagLayout());
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 5, 5, 5);
        gbc.anchor = GridBagConstraints.WEST;
        gbc.fill = GridBagConstraints.HORIZONTAL;
        
        // Enable Email Checkbox
        enableEmailCheckBox = new JCheckBox("Enable Email Integration");
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.gridwidth = 2;
        mainPanel.add(enableEmailCheckBox, gbc);
        gbc.gridwidth = 1;
        
        // Email Host
        gbc.gridy++;
        gbc.gridx = 0;
        mainPanel.add(new JLabel("Email Host (SMTP):"), gbc);
        gbc.gridx = 1;
        emailHostField = new JTextField(20);
        mainPanel.add(emailHostField, gbc);
        
        // Email Port
        gbc.gridy++;
        gbc.gridx = 0;
        mainPanel.add(new JLabel("Port:"), gbc);
        gbc.gridx = 1;
        emailPortField = new JTextField(20);
        mainPanel.add(emailPortField, gbc);
        
        // Email Username
        gbc.gridy++;
        gbc.gridx = 0;
        mainPanel.add(new JLabel("Username:"), gbc);
        gbc.gridx = 1;
        emailUsernameField = new JTextField(20);
        mainPanel.add(emailUsernameField, gbc);
        
        // Email Password
        gbc.gridy++;
        gbc.gridx = 0;
        mainPanel.add(new JLabel("Password:"), gbc);
        gbc.gridx = 1;
        emailPasswordField = new JPasswordField(20);
        mainPanel.add(emailPasswordField, gbc);
        
        // Recipient Email
        gbc.gridy++;
        gbc.gridx = 0;
        mainPanel.add(new JLabel("Recipient Email:"), gbc);
        gbc.gridx = 1;
        recipientEmailField = new JTextField(20);
        mainPanel.add(recipientEmailField, gbc);
        
        // Enable SSL
        gbc.gridy++;
        gbc.gridx = 0;
        gbc.gridwidth = 2;
        enableSSLCheckBox = new JCheckBox("Enable SSL/TLS");
        mainPanel.add(enableSSLCheckBox, gbc);
        
        // Test Email Button
        gbc.gridy++;
        gbc.gridx = 0;
        gbc.gridwidth = 2;
        gbc.insets = new Insets(15, 5, 5, 5);
        JButton testButton = new JButton("Test Email Configuration");
        testButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent e) {
                testEmailConfiguration();
            }
        });
        mainPanel.add(testButton, gbc);
        
        loadUIFromSettings();
    }
    
    private void testEmailConfiguration() {
        // Save current settings first
        Properties testProps = new Properties();
        testProps.setProperty("host", emailHostField.getText().trim());
        testProps.setProperty("port", emailPortField.getText().trim());
        testProps.setProperty("username", emailUsernameField.getText().trim());
        testProps.setProperty("password", new String(emailPasswordField.getPassword()));
        testProps.setProperty("recipient", recipientEmailField.getText().trim());
        testProps.setProperty("ssl", String.valueOf(enableSSLCheckBox.isSelected()));
        
        // Validate fields
        if (emailHostField.getText().trim().isEmpty() || 
            emailUsernameField.getText().trim().isEmpty() ||
            emailPasswordField.getPassword().length == 0 ||
            recipientEmailField.getText().trim().isEmpty()) {
            JOptionPane.showMessageDialog(mainPanel, 
                "Please fill in all fields before testing", 
                "Missing Information", 
                JOptionPane.WARNING_MESSAGE);
            return;
        }
        
        // Show progress
        final JDialog progressDialog = new JDialog((Frame)null, "Testing Email", true);
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        panel.add(new JLabel("Sending test email..."), BorderLayout.CENTER);
        JProgressBar progressBar = new JProgressBar();
        progressBar.setIndeterminate(true);
        panel.add(progressBar, BorderLayout.SOUTH);
        progressDialog.add(panel);
        progressDialog.setSize(300, 120);
        progressDialog.setLocationRelativeTo(mainPanel);
        
        // Send email in background thread
        new Thread(new Runnable() {
            public void run() {
                try {
                    System.out.println("Testing email configuration...");
                    EmailSender sender = new EmailSender(testProps);
                    sender.sendEmail(
                        "Spark Email Plugin Test", 
                        "This is a test email from Spark Email Integration Plugin.\n\n" +
                        "If you received this email, your configuration is working correctly!\n\n" +
                        "Timestamp: " + new java.util.Date()
                    );
                    
                    SwingUtilities.invokeLater(new Runnable() {
                        public void run() {
                            progressDialog.dispose();
                            JOptionPane.showMessageDialog(mainPanel,
                                "Test email sent successfully!\nCheck your inbox at: " + 
                                recipientEmailField.getText(),
                                "Success",
                                JOptionPane.INFORMATION_MESSAGE);
                        }
                    });
                    System.out.println("Test email sent successfully!");
                    
                } catch (final Exception ex) {
                    SwingUtilities.invokeLater(new Runnable() {
                        public void run() {
                            progressDialog.dispose();
                            JOptionPane.showMessageDialog(mainPanel,
                                "Failed to send test email:\n" + ex.getMessage(),
                                "Error",
                                JOptionPane.ERROR_MESSAGE);
                        }
                    });
                    System.err.println("Test email failed: " + ex.getMessage());
                    ex.printStackTrace();
                }
            }
        }).start();
        
        // Show progress dialog (blocks until email is sent)
        progressDialog.setVisible(true);
    }
    
    @Override
    public String getTitle() {
        return "Email Integration";
    }
    
    @Override
    public Icon getIcon() {
        return null;
    }
    
    @Override
    public String getTooltip() {
        return "Configure email settings for message forwarding";
    }
    
    @Override
    public String getListName() {
        return "Email";
    }
    
    @Override
    public String getNamespace() {
        return "email-plugin";
    }
    
    @Override
    public JComponent getGUI() {
        return mainPanel;
    }
    
    @Override
    public void load() {
        loadSettings();
        loadUIFromSettings();
    }
    
    @Override
    public void commit() {
        saveSettings();
    }
    
    @Override
    public boolean isDataValid() {
        if (!enableEmailCheckBox.isSelected()) {
            return true;
        }
        
        if (emailHostField.getText().trim().isEmpty()) {
            JOptionPane.showMessageDialog(mainPanel, "Email host is required");
            return false;
        }
        
        if (emailUsernameField.getText().trim().isEmpty()) {
            JOptionPane.showMessageDialog(mainPanel, "Username is required");
            return false;
        }
        
        if (emailPasswordField.getPassword().length == 0) {
            JOptionPane.showMessageDialog(mainPanel, "Password is required");
            return false;
        }
        
        if (recipientEmailField.getText().trim().isEmpty()) {
            JOptionPane.showMessageDialog(mainPanel, "Recipient email is required");
            return false;
        }
        
        return true;
    }
    
    @Override
    public String getErrorMessage() {
        return "Please fill in all required email fields";
    }
    
    @Override
    public Object getData() {
        return properties;
    }
    
    @Override
    public void shutdown() {
        saveSettings();
    }
    
    private void loadSettings() {
        File configFile = new File(getConfigDirectory(), PROPERTIES_FILE);
        if (configFile.exists()) {
            try (FileInputStream fis = new FileInputStream(configFile)) {
                properties.load(fis);
            } catch (IOException e) {
                Log.error("Error loading email settings", e);
            }
        }
    }
    
    private void saveSettings() {
        properties.setProperty("enabled", String.valueOf(enableEmailCheckBox.isSelected()));
        properties.setProperty("host", emailHostField.getText().trim());
        properties.setProperty("port", emailPortField.getText().trim());
        properties.setProperty("username", emailUsernameField.getText().trim());
        properties.setProperty("password", new String(emailPasswordField.getPassword()));
        properties.setProperty("recipient", recipientEmailField.getText().trim());
        properties.setProperty("ssl", String.valueOf(enableSSLCheckBox.isSelected()));
        
        File configFile = new File(getConfigDirectory(), PROPERTIES_FILE);
        try (FileOutputStream fos = new FileOutputStream(configFile)) {
            properties.store(fos, "Email Plugin Configuration");
        } catch (IOException e) {
            Log.error("Error saving email settings", e);
        }
    }
    
    private void loadUIFromSettings() {
        enableEmailCheckBox.setSelected(Boolean.parseBoolean(properties.getProperty("enabled", "false")));
        emailHostField.setText(properties.getProperty("host", ""));
        emailPortField.setText(properties.getProperty("port", "587"));
        emailUsernameField.setText(properties.getProperty("username", ""));
        emailPasswordField.setText(properties.getProperty("password", ""));
        recipientEmailField.setText(properties.getProperty("recipient", ""));
        enableSSLCheckBox.setSelected(Boolean.parseBoolean(properties.getProperty("ssl", "true")));
    }
    
    private File getConfigDirectory() {
        File userDir = new File(System.getProperty("user.home"), ".spark");
        if (!userDir.exists()) {
            userDir.mkdirs();
        }
        return userDir;
    }
    
    public Properties getProperties() {
        return properties;
    }
}
