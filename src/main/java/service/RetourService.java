package service;

import model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import repository.*;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Service
public class RetourService {
    
    @Autowired
    private AdherentExemplaireRepository adherentExemplaireRepository;
    
    @Autowired
    private AdherentPenaliteRepository adherentPenaliteRepository;
    
    @Autowired
    private PenaliteRepository penaliteRepository;
    
    @Autowired
    private JourFerieService jourFerieService;
    
    public List<Map<String, Object>> getEmpruntsEnCours() {
        return adherentExemplaireRepository.findEmpruntsEnCours();
    }
    
    public List<Map<String, Object>> getEmpruntsParAdherent(Integer idAdherent) {
        return adherentExemplaireRepository.findEmpruntsEnCoursByAdherent(idAdherent);
    }
    
    public List<Map<String, Object>> getEmpruntParNumExemplaire(String numExemplaire) {
        return adherentExemplaireRepository.findEmpruntByNumExemplaire(numExemplaire);
    }
    
    @Transactional
    public String retournerLivre(Integer idAdherentExemplaire, LocalDate dateRetour) throws Exception {
 
        AdherentExemplaire emprunt = adherentExemplaireRepository.findById(idAdherentExemplaire)
            .orElseThrow(() -> new Exception("Emprunt introuvable"));
        
        if (emprunt.getDateRetour() != null) {
            throw new Exception("Ce livre a déjà été retourné");
        }
        
        dateRetour = jourFerieService.ajusterDateLimite(dateRetour);
        
        emprunt.setDateRetour(dateRetour);
        adherentExemplaireRepository.save(emprunt);
        
        String messageRetard = verifierEtAppliquerPenalite(emprunt, dateRetour);
        
        String message = "Livre retourné avec succès le " + dateRetour;
        if (messageRetard != null) {
            message += ". " + messageRetard;
        }
        
        return message;
    }
    
    @Transactional
    public String retournerLivre(Integer idAdherentExemplaire) throws Exception {
        return retournerLivre(idAdherentExemplaire, LocalDate.now());
    }
    
    private String verifierEtAppliquerPenalite(AdherentExemplaire emprunt, LocalDate dateRetour) {
        LocalDate dateLimite = emprunt.getDateLimite();
        
        if (dateLimite != null && dateRetour.isAfter(dateLimite)) {
            long joursRetard = java.time.temporal.ChronoUnit.DAYS.between(dateLimite, dateRetour);
            
            Penalite penalite = penaliteRepository.findByProfil(emprunt.getAdherent().getProfil().getIdProfil());
            
            if (penalite != null) {
                int joursRestriction = (int) penalite.getRestriction();
                
                LocalDate dateDebutPenalite = dateRetour;
                AdherentPenalite dernierePenalite = adherentPenaliteRepository.findDernierePenaliteByAdherent(emprunt.getAdherent().getIdAdherent());
                
                if (dernierePenalite != null && dernierePenalite.getDateFin().isAfter(dateRetour)) {
                    dateDebutPenalite = dernierePenalite.getDateFin().plusDays(1);
                }
                
                LocalDate dateFinPenalite = dateDebutPenalite.plusDays(joursRestriction);
                
                AdherentPenalite adherentPenalite = new AdherentPenalite();
                adherentPenalite.setAdherent(emprunt.getAdherent());
                adherentPenalite.setPenalite(penalite);
                adherentPenalite.setDateDebut(dateDebutPenalite);
                adherentPenalite.setDateFin(dateFinPenalite);
                
                adherentPenaliteRepository.save(adherentPenalite);
                
                String messagePenalite = "ATTENTION: Retour en retard de " + joursRetard + " jour(s). ";
                
                if (dateDebutPenalite.equals(dateRetour)) {
                    messagePenalite += "Pénalité appliquée du " + dateDebutPenalite + " au " + dateFinPenalite + 
                                    " (" + joursRestriction + " jours de restriction)";
                } else {
                    messagePenalite += "Pénalité programmée du " + dateDebutPenalite + " au " + dateFinPenalite + 
                                    " (" + joursRestriction + " jours de restriction). " +
                                    "Report dû à une pénalité existante.";
                }
                
                return messagePenalite;
            }
        }
        
        return null;
    }
    
    public Map<String, Object> getInfoEmprunt(Integer idAdherentExemplaire) {
        return adherentExemplaireRepository.findEmpruntDetails(idAdherentExemplaire);
    }
}