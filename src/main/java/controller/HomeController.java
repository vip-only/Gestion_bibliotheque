package controller;

import jakarta.servlet.http.HttpSession;
import model.Adherent;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home(HttpSession session, Model model) {
        try {
            // Always show login page first - don't redirect automatically
            return "connexion";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur de démarrage: " + e.getMessage());
            return "connexion";
        }
    }
    
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session) {
        Adherent adherent = (Adherent) session.getAttribute("adherent");
        if (adherent == null) {
            return "redirect:/";
        }
        
        return "redirect:/adherent/catalogue";
    }
}