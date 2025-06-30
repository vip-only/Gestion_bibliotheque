package controller;

import jakarta.servlet.http.HttpSession;
import model.Adherent;
import model.Bibliothecaire;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import service.AdherentService;
import service.BibliothecaireService;

@Controller
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AdherentService adherentService;
    
    @Autowired
    private BibliothecaireService bibliothecaireService;

    @PostMapping("/login")
    public String login(@RequestParam String email, 
                       @RequestParam String motdepasse,
                       HttpSession session, 
                       Model model) {
        
        System.out.println("Tentative de connexion pour: " + email); 
        
        try {
            Adherent adherent = adherentService.authenticate(email, motdepasse);
            System.out.println("Résultat authentification: " + (adherent != null ? "Succès" : "Échec")); 
            
            if (adherent != null) {
                session.setAttribute("adherent", adherent);
                System.out.println("Session créée pour: " + adherent.getNom()); 
                return "redirect:/dashboard"; 
            } else {
                model.addAttribute("error", "Email ou mot de passe incorrect");
                return "connexion";
            }
        } catch (Exception e) {
            System.err.println("Erreur lors de l'authentification: " + e.getMessage()); 
            e.printStackTrace(); 
            model.addAttribute("error", "Erreur lors de la connexion: " + e.getMessage());
            return "connexion";
        }
    }
    
    @GetMapping("/authAdmin")
    public String authAdmin() {
        return "authAdmin";
    }
    
    @PostMapping("/loginAdmin")
    public String loginAdmin(@RequestParam String nom, 
                           @RequestParam String motdepasse,
                           HttpSession session, 
                           Model model) {
        
        System.out.println("Tentative de connexion admin pour: " + nom); 
        
        try {
            Bibliothecaire bibliothecaire = bibliothecaireService.authenticate(nom, motdepasse);
            System.out.println("Résultat authentification admin: " + (bibliothecaire != null ? "Succès" : "Échec")); 
            
            if (bibliothecaire != null) {
                session.setAttribute("bibliothecaire", bibliothecaire);
                System.out.println("Session admin créée pour: " + bibliothecaire.getNom()); 
                return "redirect:/admin/dashboard"; 
            } else {
                model.addAttribute("error", "Nom ou mot de passe incorrect");
                return "authAdmin";
            }
        } catch (Exception e) {
            System.err.println("Erreur lors de l'authentification admin: " + e.getMessage()); 
            e.printStackTrace(); 
            model.addAttribute("error", "Erreur lors de la connexion: " + e.getMessage());
            return "authAdmin";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/"; 
    }
    
    @GetMapping("/logoutAdmin")
    public String logoutAdmin(HttpSession session) {
        session.invalidate();
        return "redirect:/auth/authAdmin"; 
    }
}