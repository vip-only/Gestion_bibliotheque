package listener;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;

@WebListener
public class CleanupListener implements ServletContextListener {
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Application started - CleanupListener initialized");
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Application shutting down - Starting cleanup process...");
        
        // 1. Nettoyer le thread MySQL en premier
        try {
            AbandonedConnectionCleanupThread.checkedShutdown();
            System.out.println("[OK] MySQL connection cleanup thread stopped successfully");
        } catch (Exception e) {
            System.err.println("[WARNING] Warning during MySQL cleanup thread shutdown: " + e.getMessage());
        }
        
        // 2. Deregistrer tous les drivers JDBC
        ClassLoader cl = Thread.currentThread().getContextClassLoader();
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            try {
                if (driver.getClass().getClassLoader() == cl) {
                    DriverManager.deregisterDriver(driver);
                    System.out.println("[OK] JDBC Driver deregistered: " + driver.getClass().getName());
                }
            } catch (SQLException e) {
                System.err.println("[WARNING] Error deregistering JDBC driver: " + e.getMessage());
            }
        }
        
        // 3. Forcer le garbage collection
        try {
            Thread.sleep(100); // Petit delai pour laisser le temps aux threads de s'arreter
            System.gc();
            System.out.println("[OK] Garbage collection triggered");
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        System.out.println("[COMPLETED] Application cleanup completed");
    }
}