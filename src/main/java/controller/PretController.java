package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import service.ExemplaireService;
import service.AdherentService;
import service.EmpruntService;
import jakarta.servlet.http.HttpSession;
import model.Bibliothecaire;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class PretController {
    
    @Autowired
    private ExemplaireService exemplaireService;
    
    @Autowired
    private AdherentService adherentService;
    
    @Autowired
    private EmpruntService empruntService;
    
    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        Bibliothecaire bibliothecaire = (Bibliothecaire) session.getAttribute("bibliothecaire");
        if (bibliothecaire == null) {
            return "redirect:/auth/authAdmin";
        }
        
        List<Map<String, Object>> exemplairesDisponibles = exemplaireService.getExemplairesDisponiblesGroupByLivre();
        List<Map<String, Object>> adherents = adherentService.getAllAdherents(); // Seulement les adhérents actifs
        List<Map<String, Object>> typesPret = empruntService.getAllTypesPret();
        
        model.addAttribute("bibliothecaire", bibliothecaire);
        model.addAttribute("exemplairesDisponibles", exemplairesDisponibles);
        model.addAttribute("adherents", adherents);
        model.addAttribute("typesPret", typesPret);
        
        return "admin/dashboard";
    }
    
    @PostMapping("/emprunter")
    public String emprunter(@RequestParam String numExemplaire,
                           @RequestParam Integer idAdherent,
                           @RequestParam Integer idTypePret,
                           HttpSession session,
                           Model model) {
        
        Bibliothecaire bibliothecaire = (Bibliothecaire) session.getAttribute("bibliothecaire");
        if (bibliothecaire == null) {
            return "redirect:/auth/authAdmin";
        }
        
        try {
            if (!adherentService.isAbonnementActif(idAdherent)) {
                model.addAttribute("error", "L'abonnement de cet adhérent n'est pas actif");
                return dashboard(model, session);
            }
            
            empruntService.creerEmprunt(numExemplaire, idAdherent, idTypePret);
            model.addAttribute("success", "Emprunt créé avec succès!");
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors de la création de l'emprunt: " + e.getMessage());
        }
        
        return dashboard(model, session);
    }
}