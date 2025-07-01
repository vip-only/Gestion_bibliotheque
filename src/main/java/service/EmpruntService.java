package service;

import model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.*;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Service
public class EmpruntService {
    
    @Autowired
    private AdherentRepository adherentRepository;
    
    @Autowired
    private ExemplaireRepository exemplaireRepository;
    
    @Autowired
    private AdherentExemplaireRepository adherentExemplaireRepository;
    
    @Autowired
    private TypePretRepository typePretRepository;
    
    @Autowired
    private DureeEmpruntRepository dureeEmpruntRepository;
    
    @Autowired
    private QuotaRepository quotaRepository;
    
    @Autowired
    private AdherentPenaliteRepository adherentPenaliteRepository;
    
    @Autowired
    private JourFerieService jourFerieService;
    
    public List<Map<String, Object>> getAllTypesPret() {
        return typePretRepository.findAllTypesPretForSelect();
    }
    
    public void creerEmprunt(String numExemplaire, Integer idAdherent, Integer idTypePret) throws Exception {
        // Récupérer l'adhérent
        Adherent adherent = adherentRepository.findById(idAdherent)
            .orElseThrow(() -> new Exception("Adhérent introuvable"));
        
        // Vérifier si l'adhérent a une pénalité active
        if (adherentPenaliteRepository.hasPenaliteActive(idAdherent)) {
            throw new Exception("Impossible d'emprunter : vous avez une pénalité active");
        }
        
        // Vérifier le quota d'emprunts
        Integer quotaMax = quotaRepository.findQuotaByProfil(adherent.getProfil().getIdProfil());
        if (quotaMax == null) {
            quotaMax = 1; // quota par défaut
        }
        
        Integer empruntsActuels = adherentExemplaireRepository.countEmpruntsActifs(idAdherent);
        if (empruntsActuels != null && empruntsActuels >= quotaMax) {
            throw new Exception("Quota d'emprunts atteint (" + empruntsActuels + "/" + quotaMax + "). Veuillez retourner des livres avant d'emprunter.");
        }
        
        // Récupérer l'exemplaire
        Exemplaire exemplaire = exemplaireRepository.findByNumExemplaire(numExemplaire);
        if (exemplaire == null) {
            throw new Exception("Exemplaire introuvable");
        }
        
        // Vérifier que l'exemplaire est disponible
        if (adherentExemplaireRepository.existsByExemplaireAndDateRetourIsNull(exemplaire)) {
            throw new Exception("Cet exemplaire est déjà emprunté");
        }
        
        // Récupérer le type de prêt
        TypePret typePret = typePretRepository.findById(idTypePret)
            .orElseThrow(() -> new Exception("Type de prêt introuvable"));
        
        // Calculer la date limite avec gestion des jours fériés
        LocalDate dateEmprunt = LocalDate.now();
        LocalDate dateLimite = calculerDateLimiteAvecJoursFeries(adherent.getProfil().getIdProfil(), idTypePret, dateEmprunt);
        
        // Créer l'emprunt
        AdherentExemplaire emprunt = new AdherentExemplaire();
        emprunt.setAdherent(adherent);
        emprunt.setExemplaire(exemplaire);
        emprunt.setTypePret(typePret);
        emprunt.setDateEmprunt(dateEmprunt);
        emprunt.setDateLimite(dateLimite);
        
        adherentExemplaireRepository.save(emprunt);
    }
    
    private LocalDate calculerDateLimiteAvecJoursFeries(Integer idProfil, Integer idTypePret, LocalDate dateEmprunt) {
        Integer nbJours = dureeEmpruntRepository.findNbJoursByProfilAndTypePret(idProfil, idTypePret);
        if (nbJours == null) {
            nbJours = 14; // valeur par défaut
        }
        
        LocalDate dateLimiteBase = dateEmprunt.plusDays(nbJours);
        LocalDate dateLimiteAjustee = jourFerieService.ajusterDateLimite(dateLimiteBase);
        
        return dateLimiteAjustee;
    }
    
    private LocalDate calculerDateLimiteJoursOuvrables(Integer idProfil, Integer idTypePret, LocalDate dateEmprunt) {
        Integer nbJours = dureeEmpruntRepository.findNbJoursByProfilAndTypePret(idProfil, idTypePret);
        if (nbJours == null) {
            nbJours = 14; // valeur par défaut
        }
        
        return jourFerieService.calculerDateLimiteAvecJoursOuvrables(dateEmprunt, nbJours);
    }
    
    public String getInfoDateLimite(Integer idProfil, Integer idTypePret, LocalDate dateEmprunt) {
        Integer nbJours = dureeEmpruntRepository.findNbJoursByProfilAndTypePret(idProfil, idTypePret);
        if (nbJours == null) {
            nbJours = 14;
        }
        
        LocalDate dateLimiteBase = dateEmprunt.plusDays(nbJours);
        LocalDate dateLimiteAjustee = jourFerieService.ajusterDateLimite(dateLimiteBase);
        
        if (dateLimiteBase.equals(dateLimiteAjustee)) {
            return "Date limite: " + dateLimiteBase + " (" + nbJours + " jours)";
        } else {
            return "Date limite: " + dateLimiteAjustee + " (" + nbJours + " jours + ajustement jour non ouvrable)";
        }
    }
}