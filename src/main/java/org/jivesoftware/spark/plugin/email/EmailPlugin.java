package org.jivesoftware.spark.plugin.email;

import org.jivesoftware.spark.SparkManager;
import org.jivesoftware.spark.plugin.Plugin;
import org.jivesoftware.spark.ui.ChatRoom;
import org.jivesoftware.spark.ui.ChatRoomListener;
import org.jivesoftware.spark.ui.MessageListener;
import org.jivesoftware.spark.util.log.Log;
import org.jivesoftware.smack.packet.Message;
import javax.swing.SwingUtilities;

/**
 * Email Plugin for Spark - Sends chat messages via email
 */
public class EmailPlugin implements Plugin {
    
    private EmailPreference emailPreference;
    
    @Override
    public void initialize() {
        Log.warning("Email Integration Plugin: Initializing...");
        
        // Initialize preferences on EDT to avoid threading issues
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run() {
                try {
                    emailPreference = new EmailPreference();
                    SparkManager.getPreferenceManager().addPreference(emailPreference);
                    Log.warning("Email Integration Plugin: Preferences loaded");
                } catch (Exception e) {
                    Log.error("Error loading Email Integration preferences", e);
                }
            }
        });
        
        // Add listener for new chat rooms
        SparkManager.getChatManager().addChatRoomListener(new ChatRoomListener() {
            @Override
            public void chatRoomOpened(final ChatRoom room) {
                // Add message listener to this chat room
                MessageListener messageListener = new MessageListener() {
                    @Override
                    public void messageReceived(ChatRoom chatRoom, Message message) {
                        handleMessage(chatRoom, message, true);
                    }
                    
                    @Override
                    public void messageSent(ChatRoom chatRoom, Message message) {
                        handleMessage(chatRoom, message, false);
                    }
                };
                
                room.addMessageListener(messageListener);
                Log.warning("Email Integration Plugin: Listening to chat room: " + room.getRoomname());
            }
            
            @Override
            public void chatRoomClosed(ChatRoom room) {
                // Listener will be removed automatically
            }
            
            @Override
            public void chatRoomActivated(ChatRoom room) {
                // Not needed
            }
            
            @Override
            public void chatRoomLeft(ChatRoom room) {
                // Not needed
            }
            
            @Override
            public void userHasJoined(ChatRoom room, String userid) {
                // Not needed
            }
            
            @Override
            public void userHasLeft(ChatRoom room, String userid) {
                // Not needed
            }
        });
        
        Log.warning("Email Integration Plugin: Initialized successfully");
    }
    
    private void handleMessage(ChatRoom room, Message message, boolean isReceived) {
        try {
            if (message == null || message.getBody() == null || message.getBody().trim().isEmpty()) {
                return;
            }
            
            EmailMessageListener listener = new EmailMessageListener();
            if (isReceived) {
                listener.messageReceived(room, message);
            } else {
                listener.messageSent(room, message);
            }
        } catch (Exception e) {
            Log.error("Error handling message", e);
        }
    }
    
    @Override
    public void shutdown() {
        // Cleanup preferences
        if (emailPreference != null) {
            try {
                SparkManager.getPreferenceManager().removePreference(emailPreference);
            } catch (Exception e) {
                Log.error("Error during plugin shutdown", e);
            }
        }
    }
    
    @Override
    public boolean canShutDown() {
        return true;
    }
    
    @Override
    public void uninstall() {
        // Remove all plugin data
        shutdown();
    }
}
