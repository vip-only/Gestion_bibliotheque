package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import service.ReservationAdminService;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class ReservationAdminController {
    
    @Autowired
    private ReservationAdminService reservationAdminService;
    
    @GetMapping("/reservations")
    public String reservations(Model model, HttpSession session) {
        // Vérifier que le bibliothécaire est connecté
        if (session.getAttribute("bibliothecaire") == null) {
            return "redirect:/";
        }
        
        try {
            // Récupérer les réservations en cours (idReservationEtat = 1)
            List<Map<String, Object>> reservationsEnCours = reservationAdminService.getReservationsEnCours();
            List<Map<String, Object>> adherents = reservationAdminService.getAllAdherents();
            
            model.addAttribute("reservationsEnCours", reservationsEnCours);
            model.addAttribute("adherents", adherents);
            
            return "admin/reservations";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement des réservations: " + e.getMessage());
            return "admin/reservations";
        }
    }
    
    @PostMapping("/confirmer-reservation")
    public String confirmerReservation(@RequestParam("idReservation") Integer idReservation,
                                     RedirectAttributes redirectAttributes,
                                     HttpSession session) {
        // Vérifier que le bibliothécaire est connecté
        if (session.getAttribute("bibliothecaire") == null) {
            return "redirect:/";
        }
        
        try {
            String message = reservationAdminService.confirmerReservation(idReservation);
            redirectAttributes.addFlashAttribute("success", message);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la confirmation: " + e.getMessage());
        }
        
        return "redirect:/admin/reservations";
    }
    
    @PostMapping("/annuler-reservation")
    public String annulerReservation(@RequestParam("idReservation") Integer idReservation,
                                   RedirectAttributes redirectAttributes,
                                   HttpSession session) {
        if (session.getAttribute("bibliothecaire") == null) {
            return "redirect:/";
        }
        
        try {
            String message = reservationAdminService.annulerReservation(idReservation);
            redirectAttributes.addFlashAttribute("success", message);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'annulation: " + e.getMessage());
        }
        
        return "redirect:/admin/reservations";
    }
}