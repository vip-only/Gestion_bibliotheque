package controller;

import jakarta.servlet.http.HttpSession;
import model.Adherent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import service.ReservationService;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/adherent")
public class ReservationController {
    
    @Autowired
    private ReservationService reservationService;
    
    @PostMapping("/reserver")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> reserverExemplaire(
            @RequestParam String numExemplaire,
            @RequestParam String dateReservation,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        // Vérifier que l'adhérent est connecté
        Adherent adherent = (Adherent) session.getAttribute("adherent");
        if (adherent == null) {
            response.put("success", false);
            response.put("message", "Vous devez être connecté pour réserver un livre");
            return ResponseEntity.ok(response);
        }
        
        try {
            // Parser la date
            LocalDate dateRes = LocalDate.parse(dateReservation);
            
            String message = reservationService.reserverExemplaire(
                numExemplaire, 
                adherent.getIdAdherent(), 
                dateRes
            );
            response.put("success", true);
            response.put("message", message);
            return ResponseEntity.ok(response);
        } catch (DateTimeParseException e) {
            response.put("success", false);
            response.put("message", "Format de date invalide");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            // Préserver le message d'erreur détaillé du service
            String errorMessage = e.getMessage();
            if (errorMessage == null || errorMessage.trim().isEmpty()) {
                errorMessage = "Une erreur inattendue s'est produite lors de la réservation.";
            }
            response.put("message", errorMessage);
            return ResponseEntity.ok(response);
        }
    }
}