package service;

import model.Adherent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.AdherentRepository;

@Service
public class AdherentService {

    @Autowired
    private AdherentRepository adherentRepository;

    public Adherent authenticate(String email, String motdepasse) {
        try {
            System.out.println("Recherche adherent avec email: " + email); // Debug
            
            if (email == null || email.trim().isEmpty()) {
                System.out.println("Email vide ou null"); // Debug
                return null;
            }
            
            if (motdepasse == null || motdepasse.trim().isEmpty()) {
                System.out.println("Mot de passe vide ou null"); // Debug
                return null;
            }
            
            Adherent adherent = adherentRepository.findByEmail(email.trim());
            System.out.println("Adherent trouvé: " + (adherent != null ? adherent.getNom() : "null")); // Debug
            
            if (adherent != null) {
                System.out.println("Comparaison mot de passe: [" + motdepasse + "] vs [" + adherent.getMotdepasse() + "]"); // Debug
                if (adherent.getMotdepasse() != null && adherent.getMotdepasse().equals(motdepasse)) {
                    System.out.println("Authentification réussie"); // Debug
                    return adherent;
                } else {
                    System.out.println("Mot de passe incorrect"); // Debug
                }
            } else {
                System.out.println("Aucun adherent trouvé avec cet email"); // Debug
            }
            
            return null;
        } catch (Exception e) {
            System.err.println("Erreur dans authenticate: " + e.getMessage());
            e.printStackTrace();
            throw e; // Relancer l'exception pour la gérer dans le contrôleur
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