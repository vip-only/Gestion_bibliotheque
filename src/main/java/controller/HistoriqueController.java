
package controller;

import model.Adherent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import service.HistoriqueService;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/adherent")
public class HistoriqueController {
    
    @Autowired
    private HistoriqueService historiqueService;
    
    @GetMapping("/historique")
    public String historique(Model model, HttpSession session) {
        Adherent adherent = (Adherent) session.getAttribute("adherent");
        if (adherent == null) {
            return "redirect:/";
        }
        
        try {
            // Récupérer l'historique complet de l'adhérent
            List<Map<String, Object>> historique = historiqueService.getHistoriqueAdherent(adherent.getIdAdherent());
            
            model.addAttribute("adherent", adherent);
            model.addAttribute("historique", historique);
            
            return "adherent/historique";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement de l'historique: " + e.getMessage());
            return "adherent/historique";
        }
    }
}

