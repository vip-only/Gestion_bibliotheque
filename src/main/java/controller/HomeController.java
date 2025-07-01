package controller;

import jakarta.servlet.http.HttpSession;
import model.Adherent;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home(HttpSession session) {
        Adherent adherent = (Adherent) session.getAttribute("adherent");
        if (adherent != null) {
            return "redirect:/adherent/catalogue";
        }
        
       return "connexion";
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