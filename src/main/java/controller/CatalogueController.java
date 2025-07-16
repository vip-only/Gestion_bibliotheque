package controller;

import jakarta.servlet.http.HttpSession;
import model.Adherent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import service.ExemplaireService;
import service.CatalogueService;

import java.util.Collections;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/adherent")
public class CatalogueController {
    
    @Autowired
    private ExemplaireService exemplaireService;
    
    @Autowired
    private CatalogueService catalogueService;
    
    @GetMapping("/catalogue")
    public String catalogue(Model model, HttpSession session) {
        Adherent adherent = (Adherent) session.getAttribute("adherent");
        if (adherent == null) {
            return "redirect:/";
        }
        
        try {
            List<Map<String, Object>> catalogue = exemplaireService.getExemplairesDisponiblesGroupByLivre();
            
            List<String> auteurs = catalogueService.getAllAuteurs();
            List<String> genres = catalogueService.getAllGenres();
            List<String> tags = catalogueService.getAllTags();
            List<String> maisonsEdition = catalogueService.getAllMaisonsEdition();
            
            model.addAttribute("adherent", adherent);
            model.addAttribute("catalogue", catalogue);
            model.addAttribute("auteurs", auteurs);
            model.addAttribute("genres", genres);
            model.addAttribute("tags", tags);
            model.addAttribute("maisonsEdition", maisonsEdition);
            
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement du catalogue : " + e.getMessage());
        }
        
        return "adherent/catalogue";
    }
    
    @GetMapping("/catalogue/search")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> rechercherLivres(
            @RequestParam(required = false) String titre,
            @RequestParam(required = false) String auteur,
            @RequestParam(required = false) String genre,
            @RequestParam(required = false) String tag,
            @RequestParam(required = false) String maisonEdition,
            @RequestParam(required = false) String disponibilite,
            HttpSession session) {
        
        // Vérifier que l'adhérent est connecté
        Adherent adherent = (Adherent) session.getAttribute("adherent");
        if (adherent == null) {
            // Retourner une liste vide au lieu d'unauthorized
            return ResponseEntity.ok(Collections.emptyList());
        }
        
        try {
            List<Map<String, Object>> resultats = catalogueService.searchCatalogue(
                titre, auteur, genre, tag, maisonEdition, disponibilite
            );
            
            return ResponseEntity.ok(resultats);
        } catch (Exception e) {
            // Log l'erreur et retourner une liste vide
            System.err.println("Erreur lors de la recherche: " + e.getMessage());
            return ResponseEntity.ok(Collections.emptyList());
        }
    }
}