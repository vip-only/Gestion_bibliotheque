package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import service.CatalogueService;

import java.util.Map;

@RestController
@RequestMapping("/api/livres")
public class LivreController {

    @Autowired
    private CatalogueService catalogueService;

    @GetMapping("/{idLivre}")
    public ResponseEntity<Map<String, Object>> getLivreDetails(@PathVariable Integer idLivre) {
        Map<String, Object> details = catalogueService.getLivreDetailsWithExemplaires(idLivre);
        if (details == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(details);
    }
}