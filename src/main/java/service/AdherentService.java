package service;

import model.Adherent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.AdherentRepository;
import repository.AdherentAbonnementRepository;
import repository.AdherentPenaliteRepository;
import java.util.List;
import java.util.Map;

@Service
public class AdherentService {

    @Autowired
    private AdherentRepository adherentRepository;
    
    @Autowired
    private AdherentAbonnementRepository adherentAbonnementRepository;
    
    @Autowired
    private AdherentPenaliteRepository adherentPenaliteRepository;

    public List<Map<String, Object>> getAllAdherents() {
        // Retourne tous les adhérents avec abonnement actif avec leurs informations de quota et pénalités
        return adherentAbonnementRepository.findAdherentsActifs();
    }
    
    public boolean isAbonnementActif(Integer idAdherent) {
        Integer result = adherentAbonnementRepository.isAbonnementActif(idAdherent);
        return result != null && result == 1;
    }
    
    public boolean hasPenaliteActive(Integer idAdherent) {
        return adherentPenaliteRepository.hasPenaliteActive(idAdherent);
    }

    public Adherent authenticate(String email, String motdepasse) {
        try {
            System.out.println("Recherche adherent avec email: " + email);
            
            if (email == null || email.trim().isEmpty()) {
                System.out.println("Email vide ou null");
                return null;
            }
            
            if (motdepasse == null || motdepasse.trim().isEmpty()) {
                System.out.println("Mot de passe vide ou null");
                return null;
            }
            
            Adherent adherent = adherentRepository.findByEmail(email.trim());
            System.out.println("Adherent trouvé: " + (adherent != null ? adherent.getNom() : "null"));
            
            if (adherent != null) {
                System.out.println("Comparaison mot de passe: [" + motdepasse + "] vs [" + adherent.getMotdepasse() + "]");
                if (adherent.getMotdepasse() != null && adherent.getMotdepasse().equals(motdepasse)) {
                    System.out.println("Authentification réussie");
                    return adherent;
                } else {
                    System.out.println("Mot de passe incorrect");
                }
            } else {
                System.out.println("Aucun adherent trouvé avec cet email");
            }
            
            return null;
        } catch (Exception e) {
            System.err.println("Erreur dans authenticate: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public Adherent findByEmail(String email) {
        try {
            return adherentRepository.findByEmail(email);
        } catch (Exception e) {
            System.err.println("Erreur dans findByEmail: " + e.getMessage());
            throw e;
        }
    }

    public Adherent save(Adherent adherent) {
        try {
            return adherentRepository.save(adherent);
        } catch (Exception e) {
            System.err.println("Erreur dans save: " + e.getMessage());
            throw e;
        }
    }

    public Adherent findById(Integer id) {
        try {
            return adherentRepository.findById(id).orElse(null);
        } catch (Exception e) {
            System.err.println("Erreur dans findById: " + e.getMessage());
            throw e;
        }
    }
}