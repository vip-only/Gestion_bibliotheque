package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.LivreRepository;
import repository.ExemplaireRepository;

import java.util.List;
import java.util.Map;

@Service
public class CatalogueService {
    
    @Autowired
    private LivreRepository livreRepository;
    
    @Autowired
    private ExemplaireRepository exemplaireRepository;
    
    /**
     * Récupère tous les livres avec leur disponibilité
     */
    public List<Map<String, Object>> getCatalogueWithDisponibilite() {
        return livreRepository.findCatalogueWithDisponibilite();
    }
    public Map<String, Object> getLivreDetailsWithExemplaires(Integer idLivre) {
        Map<String, Object> livreRaw = livreRepository.findLivreById(idLivre);
        if (livreRaw == null) return null;
        Map<String, Object> livre = new java.util.HashMap<>(livreRaw); // <-- copie modifiable
        List<Map<String, Object>> exemplaires = exemplaireRepository.findExemplairesByLivre(idLivre);
        livre.put("exemplaires", exemplaires);
        return livre;
    }
    /**
     * Recherche dans le catalogue avec critères
     */
    public List<Map<String, Object>> searchCatalogue(String titre, String auteur, String genre, 
                                                   String tag, String maisonEdition, String disponibilite) {
        return livreRepository.searchCatalogue(titre, auteur, genre, tag, maisonEdition, disponibilite);
    }
    
    public List<String> getAllGenres() {
        return livreRepository.findAllGenres();
    }
    
    public List<String> getAllTags() {
        return livreRepository.findAllTags();
    }
    
    public List<String> getAllMaisonsEdition() {
        return livreRepository.findAllMaisonsEdition();
    }
    
    public List<String> getAllAuteurs() {
        return livreRepository.findAllAuteurs();
    }
}