package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import service.ExemplaireService;
import service.AdherentService;
import service.EmpruntService;
import service.RetourService;
import jakarta.servlet.http.HttpSession;
import model.Bibliothecaire;
import java.util.List;
import java.util.Map;
import java.time.LocalDate;

@Controller
@RequestMapping("/admin")
public class PretController {
    
    @Autowired
    private ExemplaireService exemplaireService;
    
    @Autowired
    private AdherentService adherentService;
    
    @Autowired
    private EmpruntService empruntService;
    
    @Autowired
    private RetourService retourService;
    
    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        Bibliothecaire bibliothecaire = (Bibliothecaire) session.getAttribute("bibliothecaire");
        if (bibliothecaire == null) {
            return "redirect:/auth/authAdmin";
        }
        
        List<Map<String, Object>> exemplairesDisponibles = exemplaireService.getExemplairesDisponiblesGroupByLivre();
        List<Map<String, Object>> adherents = adherentService.getAllAdherents();
        List<Map<String, Object>> typesPret = empruntService.getAllTypesPret();
        
        model.addAttribute("bibliothecaire", bibliothecaire);
        model.addAttribute("exemplairesDisponibles", exemplairesDisponibles);
        model.addAttribute("adherents", adherents);
        model.addAttribute("typesPret", typesPret);
        
        return "admin/dashboard";
    }
    
    @GetMapping("/retours")
    public String gestionRetours(Model model, HttpSession session) {
        Bibliothecaire bibliothecaire = (Bibliothecaire) session.getAttribute("bibliothecaire");
        if (bibliothecaire == null) {
            return "redirect:/auth/authAdmin";
        }
        
        List<Map<String, Object>> empruntsEnCours = retourService.getEmpruntsEnCours();
        List<Map<String, Object>> adherents = adherentService.getAllAdherents();
        
        model.addAttribute("bibliothecaire", bibliothecaire);
        model.addAttribute("empruntsEnCours", empruntsEnCours);
        model.addAttribute("adherents", adherents);
        
        return "admin/retours";
    }
    
    @GetMapping("/retours/adherent/{idAdherent}")
    @ResponseBody
    public List<Map<String, Object>> getEmpruntsParAdherent(@PathVariable Integer idAdherent) {
        return retourService.getEmpruntsParAdherent(idAdherent);
    }
    
    @GetMapping("/retours/exemplaire/{numExemplaire}")
    @ResponseBody
    public List<Map<String, Object>> getEmpruntParNumExemplaire(@PathVariable String numExemplaire) {
        return retourService.getEmpruntParNumExemplaire(numExemplaire);
    }
    
    @PostMapping("/retourner")
    public String retournerLivre(@RequestParam Integer idAdherentExemplaire,
                           @RequestParam String dateRetour,
                           HttpSession session,
                           Model model) {
    
        Bibliothecaire bibliothecaire = (Bibliothecaire) session.getAttribute("bibliothecaire");
        if (bibliothecaire == null) {
            return "redirect:/auth/authAdmin";
        }
        
        try {
            // Convertir la date string en LocalDate
            LocalDate dateRetourLocal = LocalDate.parse(dateRetour);
            String message = retourService.retournerLivre(idAdherentExemplaire, dateRetourLocal);
            model.addAttribute("success", message);
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du retour: " + e.getMessage());
        }
        
        return gestionRetours(model, session);
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