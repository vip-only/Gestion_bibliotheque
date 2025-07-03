package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import service.ProlongementAdminService;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class ProlongementAdminController {
    
    @Autowired
    private ProlongementAdminService prolongementAdminService;
    
    @GetMapping("/prolongements")
    public String prolongements(Model model, HttpSession session) {
        if (session.getAttribute("bibliothecaire") == null) {
            return "redirect:/";
        }
        
        try {
            List<Map<String, Object>> prolongementsEnCours = prolongementAdminService.getProlongementsEnCours();
            List<Map<String, Object>> adherents = prolongementAdminService.getAllAdherents();
            
            model.addAttribute("prolongementsEnCours", prolongementsEnCours);
            model.addAttribute("adherents", adherents);
            
            return "admin/prolongements";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement des prolongements: " + e.getMessage());
            return "admin/prolongements";
        }
    }
    
    @PostMapping("/approuver-prolongement")
    public String approuverProlongement(@RequestParam("idProlongementExemplaire") Integer idProlongementExemplaire,
                                       RedirectAttributes redirectAttributes,
                                       HttpSession session) {
        if (session.getAttribute("bibliothecaire") == null) {
            return "redirect:/";
        }
        
        try {
            String message = prolongementAdminService.approuverProlongement(idProlongementExemplaire);
            redirectAttributes.addFlashAttribute("success", message);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'approbation: " + e.getMessage());
        }
        
        return "redirect:/admin/prolongements";
    }
    
    @PostMapping("/rejeter-prolongement")
    public String rejeterProlongement(@RequestParam("idProlongementExemplaire") Integer idProlongementExemplaire,
                                     RedirectAttributes redirectAttributes,
                                     HttpSession session) {
        if (session.getAttribute("bibliothecaire") == null) {
            return "redirect:/";
        }
        
        try {
            String message = prolongementAdminService.rejeterProlongement(idProlongementExemplaire);
            redirectAttributes.addFlashAttribute("success", message);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors du rejet: " + e.getMessage());
        }
        
        return "redirect:/admin/prolongements";
    }
}