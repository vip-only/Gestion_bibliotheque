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
public class ProlongementAdminService {
    
    @Autowired
    private ProlongementExemplaireRepository prolongementExemplaireRepository;
    
    @Autowired
    private EtatProlongementExemplaireRepository etatProlongementExemplaireRepository;
    
    @Autowired
    private AdherentExemplaireRepository adherentExemplaireRepository;
    
    @Autowired
    private AdherentRepository adherentRepository;
    
    @Autowired
    private EtatRepository etatRepository;
    
    /**
     * Recupere tous les prolongements en cours (idEtat = 1)
     */
    public List<Map<String, Object>> getProlongementsEnCours() {
        return prolongementExemplaireRepository.findProlongementsEnCours();
    }
    public List<Map<String, Object>> getAllAdherents() {
        return adherentRepository.findAllAdherentsForSelect();
    }

    @Transactional
    public String approuverProlongement(Integer idProlongementExemplaire) throws Exception {
        ProlongementExemplaire prolongement = prolongementExemplaireRepository.findById(idProlongementExemplaire)
                .orElseThrow(() -> new Exception("Prolongement introuvable"));
        
        Integer countEnCours = etatProlongementExemplaireRepository.countByProlongementAndEtatEnCours(idProlongementExemplaire);
        if (countEnCours == null || countEnCours == 0) {
            throw new Exception("Ce prolongement n'est pas en cours de traitement");
        }
        
        Etat etatAccepte = etatRepository.findById(2)
                .orElseThrow(() -> new Exception("etat 'accepte' introuvable"));
        
        EtatProlongementExemplaire etatProlongementAccepte = new EtatProlongementExemplaire();
        etatProlongementAccepte.setProlongementExemplaire(prolongement);
        etatProlongementAccepte.setEtat(etatAccepte);
        etatProlongementAccepte.setDateEtat(LocalDate.now());
        
        etatProlongementExemplaireRepository.save(etatProlongementAccepte);
        
        AdherentExemplaire emprunt = prolongement.getAdherentExemplaire();
        LocalDate nouvelleDateLimite = emprunt.getDateLimite().plusDays(prolongement.getProlongement());
        emprunt.setDateLimite(nouvelleDateLimite);
        adherentExemplaireRepository.save(emprunt);
        
        String titreLivre = emprunt.getExemplaire().getLivre().getTitre();
        String numExemplaire = emprunt.getExemplaire().getNumExemplaire();
        String nomAdherent = emprunt.getAdherent().getNom();
        
        return String.format(
            "Prolongement approuve avec succes !\n\n" +
            "Adherent: %s\n" +
            "Livre: %s\n" +
            "Exemplaire: %s\n" +
            "Prolongement: %d jours\n" +
            "Nouvelle date limite: %s\n" +
            "Date d'approbation: %s",
            nomAdherent, titreLivre, numExemplaire, 
            prolongement.getProlongement(), nouvelleDateLimite, LocalDate.now()
        );
    }
    
    @Transactional
    public String rejeterProlongement(Integer idProlongementExemplaire) throws Exception {
        ProlongementExemplaire prolongement = prolongementExemplaireRepository.findById(idProlongementExemplaire)
                .orElseThrow(() -> new Exception("Prolongement introuvable"));
        
        Integer countEnCours = etatProlongementExemplaireRepository.countByProlongementAndEtatEnCours(idProlongementExemplaire);
        if (countEnCours == null || countEnCours == 0) {
            throw new Exception("Ce prolongement n'est pas en cours de traitement");
        }
        
        Etat etatRefuse = etatRepository.findById(3)
                .orElseThrow(() -> new Exception("etat 'refuse' introuvable"));
        
        EtatProlongementExemplaire etatProlongementRefuse = new EtatProlongementExemplaire();
        etatProlongementRefuse.setProlongementExemplaire(prolongement);
        etatProlongementRefuse.setEtat(etatRefuse);
        etatProlongementRefuse.setDateEtat(LocalDate.now());
        
        etatProlongementExemplaireRepository.save(etatProlongementRefuse);
        
        AdherentExemplaire emprunt = prolongement.getAdherentExemplaire();
        String titreLivre = emprunt.getExemplaire().getLivre().getTitre();
        String numExemplaire = emprunt.getExemplaire().getNumExemplaire();
        String nomAdherent = emprunt.getAdherent().getNom();
        
        return String.format(
            "Prolongement rejete !\n\n" +
            "Adherent: %s\n" +
            "Livre: %s\n" +
            "Exemplaire: %s\n" +
            "Prolongement demande: %d jours\n" +
            "Date de rejet: %s\n\n" +
            "L'adherent devra retourner le livre à la date limite initiale.",
            nomAdherent, titreLivre, numExemplaire, 
            prolongement.getProlongement(), LocalDate.now()
        );
    }
}