package listener;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class CleanupListener implements ServletContextListener {
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            AbandonedConnectionCleanupThread.checkedShutdown();
            System.out.println("MySQL connection cleanup thread stopped");
        } catch (Exception e) {
            System.err.println("Error stopping MySQL cleanup thread: " + e.getMessage());
        }
    }
}