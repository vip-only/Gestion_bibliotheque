package service;

import model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.*;
import java.time.LocalDate;
import java.time.Period;
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
    
    public List<Map<String, Object>> getAllTypesPret() {
        return typePretRepository.findAllTypesPretForSelect();
    }
    
    public void creerEmprunt(String numExemplaire, Integer idAdherent, Integer idTypePret) throws Exception {
        // Récupérer l'adhérent
        Adherent adherent = adherentRepository.findById(idAdherent)
            .orElseThrow(() -> new Exception("Adhérent introuvable"));
        
        if (adherentPenaliteRepository.hasPenaliteActive(idAdherent)) {
            throw new Exception("Impossible d'emprunter : vous avez une pénalité active");
        }
        
        if (idTypePret == 1) { 
            Integer quotaMax = quotaRepository.findQuotaByProfil(adherent.getProfil().getIdProfil());
            if (quotaMax == null) {
                quotaMax = 1; 
            }
            
            Integer empruntsActuelsADomicile = adherentExemplaireRepository.countEmpruntsActifsADomicile(idAdherent);
            if (empruntsActuelsADomicile != null && empruntsActuelsADomicile >= quotaMax) {
                throw new Exception("Quota d'emprunts à domicile atteint (" + empruntsActuelsADomicile + "/" + quotaMax + "). Veuillez retourner des livres avant d'emprunter.");
            }
        }
        
        Exemplaire exemplaire = exemplaireRepository.findByNumExemplaire(numExemplaire);
        if (exemplaire == null) {
            throw new Exception("Exemplaire introuvable");
        }
        
        // Vérifier l'âge requis pour le livre
        if (exemplaire.getLivre().getAgesup() != null) {
            int ageAdherent = calculerAge(adherent.getDateNaissance());
            if (ageAdherent < exemplaire.getLivre().getAgesup()) {
                throw new Exception("Âge minimum requis pour ce livre : " + exemplaire.getLivre().getAgesup() + " ans. " +
                                  "Âge de l'adhérent : " + ageAdherent + " ans.");
            }
        }
       
        if (adherentExemplaireRepository.existsByExemplaireAndDateRetourIsNull(exemplaire)) {
            throw new Exception("Cet exemplaire est déjà emprunté");
        }
        
        TypePret typePret = typePretRepository.findById(idTypePret)
            .orElseThrow(() -> new Exception("Type de prêt introuvable"));
        
        LocalDate dateEmprunt = LocalDate.now();
        LocalDate dateLimite = calculerDateLimite(adherent.getProfil().getIdProfil(), idTypePret, dateEmprunt);
        
        AdherentExemplaire emprunt = new AdherentExemplaire();
        emprunt.setAdherent(adherent);
        emprunt.setExemplaire(exemplaire);
        emprunt.setTypePret(typePret);
        emprunt.setDateEmprunt(dateEmprunt);
        emprunt.setDateLimite(dateLimite);
        
        if (idTypePret == 2) {
            emprunt.setDateRetour(dateEmprunt); 
        }
        
        adherentExemplaireRepository.save(emprunt);
    }
    
    private int calculerAge(LocalDate dateNaissance) {
        if (dateNaissance == null) {
            return 0; 
        }
        return Period.between(dateNaissance, LocalDate.now()).getYears();
    }
    
    private LocalDate calculerDateLimite(Integer idProfil, Integer idTypePret, LocalDate dateEmprunt) {
        // Pour les prêts "sur place" (idTypePret = 2), la date limite est le même jour
        if (idTypePret == 2) {
            return dateEmprunt; // Date limite = date d'emprunt (même jour)
        }
        
        // Pour les autres types de prêt, utiliser la durée configurée
        Integer nbJours = dureeEmpruntRepository.findNbJoursByProfilAndTypePret(idProfil, idTypePret);
        if (nbJours == null) {
            nbJours = 14; // valeur par défaut
        }
        return dateEmprunt.plusDays(nbJours);
    }
}