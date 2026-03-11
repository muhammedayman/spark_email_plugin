package org.jivesoftware.spark.plugin.email;

import org.jivesoftware.spark.plugin.Plugin;

/**
 * Minimal Email Plugin for testing
 */
public class EmailPluginMinimal implements Plugin {
    
    @Override
    public void initialize() {
        System.out.println("EmailPlugin initialized!");
    }
    
    @Override
    public void shutdown() {
        System.out.println("EmailPlugin shutdown!");
    }
    
    @Override
    public boolean canShutDown() {
        return true;
    }
    
    @Override
    public void uninstall() {
        shutdown();
    }
}
