package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import service.AdherentAdminService;

import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdherentAdminController {
    
    @Autowired
    private AdherentAdminService adherentAdminService;
    
    @GetMapping("/adherents")
    public String adherents(Model model, HttpSession session) {
        if (session.getAttribute("bibliothecaire") == null) {
            return "redirect:/";
        }
        
        try {
            List<Map<String, Object>> adherentsActifs = adherentAdminService.getAdherentsActifs();
            List<Map<String, Object>> adherentsInactifs = adherentAdminService.getAdherentsInactifs();
            List<Map<String, Object>> adherentsPenalises = adherentAdminService.getAdherentsPenalises();
            
            // Statistiques générales
            Map<String, Object> statistiques = adherentAdminService.getStatistiquesAdherents();
            
            model.addAttribute("adherentsActifs", adherentsActifs);
            model.addAttribute("adherentsInactifs", adherentsInactifs);
            model.addAttribute("adherentsPenalises", adherentsPenalises);
            model.addAttribute("statistiques", statistiques);
            
            return "admin/adherents";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement des adhérents: " + e.getMessage());
            return "admin/adherents";
        }
    }

    // Ajouter cette méthode dans AdherentAdminController.java
    @PostMapping("/creer-adherent")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> creerAdherent(@RequestBody Map<String, Object> adherentData, 
                                                             HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            System.out.println("=== DEBUT CREATION ADHERENT CONTROLLER ===");
            System.out.println("Données reçues dans le contrôleur: " + adherentData);
            
            // Vérifier que le bibliothécaire est connecté
            if (session.getAttribute("bibliothecaire") == null) {
                response.put("success", false);
                response.put("message", "Session expirée. Veuillez vous reconnecter.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }
            
            String message = adherentAdminService.creerNouvelAdherent(adherentData);
            response.put("success", true);
            response.put("message", message);
            
            System.out.println("Succès - message: " + message);
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            System.err.println("ERREUR dans le contrôleur: " + e.getMessage());
            e.printStackTrace();
            
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}