package controller;

import model.Adherent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import service.ProlongementService;

import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/adherent")
public class ProlongementController {
    
    @Autowired
    private ProlongementService prolongementService;
    
    @PostMapping(value = "/prolongement", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> demanderProlongement(
            @RequestParam("idAdherentExemplaire") Integer idAdherentExemplaire,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Vérifier que l'adhérent est connecté
            Adherent adherent = (Adherent) session.getAttribute("adherent");
            if (adherent == null) {
                response.put("success", false);
                response.put("message", "Session expirée. Veuillez vous reconnecter.");
                return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response);
            }
            
            // Créer la demande de prolongement
            String message = prolongementService.creerDemandeProlongement(
                idAdherentExemplaire, 
                adherent.getIdAdherent()
            );
            
            response.put("success", true);
            response.put("message", message);
            
            return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .body(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            
            return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .body(response);
        }
    }
}