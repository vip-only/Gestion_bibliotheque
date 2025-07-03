package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import repository.AdherentRepository;
import repository.AdherentAbonnementRepository;
import repository.AdherentPenaliteRepository;
import repository.ProfilRepository;
import model.Adherent;
import model.AdherentAbonnement;
import model.Profil;

import java.time.LocalDate;
import java.time.Period;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AdherentAdminService {
    
    @Autowired
    private AdherentRepository adherentRepository;
    
    @Autowired
    private AdherentAbonnementRepository adherentAbonnementRepository;
    
    @Autowired
    private AdherentPenaliteRepository adherentPenaliteRepository;
    
    @Autowired
    private ProfilRepository profilRepository;
    
    public List<Map<String, Object>> getAdherentsActifs() {
        return adherentRepository.findAdherentsActifs();
    }
    
    public List<Map<String, Object>> getAdherentsInactifs() {
        return adherentRepository.findAdherentsInactifs();
    }
    
    public List<Map<String, Object>> getAdherentsPenalises() {
        return adherentRepository.findAdherentsPenalises();
    }
    
    public Map<String, Object> getStatistiquesAdherents() {
        Map<String, Object> stats = new HashMap<>();
        
        Integer totalActifs = adherentRepository.countAdherentsActifs();
        Integer totalInactifs = adherentRepository.countAdherentsInactifs();
        Integer totalPenalises = adherentRepository.countAdherentsPenalises();
        Integer totalAdherents = adherentRepository.countTotalAdherents();
        
        stats.put("totalActifs", totalActifs != null ? totalActifs : 0);
        stats.put("totalInactifs", totalInactifs != null ? totalInactifs : 0);
        stats.put("totalPenalises", totalPenalises != null ? totalPenalises : 0);
        stats.put("totalAdherents", totalAdherents != null ? totalAdherents : 0);
        
        if (totalAdherents != null && totalAdherents > 0) {
            stats.put("pourcentageActifs", Math.round((totalActifs * 100.0) / totalAdherents));
            stats.put("pourcentageInactifs", Math.round((totalInactifs * 100.0) / totalAdherents));
            stats.put("pourcentagePenalises", Math.round((totalPenalises * 100.0) / totalAdherents));
        } else {
            stats.put("pourcentageActifs", 0);
            stats.put("pourcentageInactifs", 0);
            stats.put("pourcentagePenalises", 0);
        }
        
        return stats;
    }
    
    @Transactional
    public String creerNouvelAdherent(Map<String, Object> adherentData) throws Exception {
        try {
            String nom = (String) adherentData.get("nom");
            String email = (String) adherentData.get("email");
            String dateNaissanceStr = (String) adherentData.get("dateNaissance");
            String motdepasse = (String) adherentData.get("motdepasse");
            Integer idProfil = Integer.parseInt(adherentData.get("idProfil").toString());
            Integer dureeAbonnement = Integer.parseInt(adherentData.get("dureeAbonnement").toString());
            System.out.println("Nom: " + nom);
            System.out.println("Email: " + email);
            System.out.println("Date naissance: " + dateNaissanceStr);
            System.out.println("ID Profil: " + idProfil);
            System.out.println("Durée abonnement: " + dureeAbonnement);
            
            if (nom == null || nom.trim().isEmpty()) {
                throw new Exception("Le nom est requis");
            }
            if (email == null || email.trim().isEmpty()) {
                throw new Exception("L'email est requis");
            }
            if (motdepasse == null || motdepasse.length() < 6) {
                throw new Exception("Le mot de passe doit contenir au moins 6 caracteres");
            }
            
            // if (adherentRepository.existsByEmail(email)) {
            //     throw new Exception("Un adherent avec cet email existe dejà");
            // }
            
            Profil profil = profilRepository.findById(idProfil)
                    .orElseThrow(() -> new Exception("Profil introuvable"));
            
            Adherent adherent = new Adherent();
            adherent.setNom(nom.trim());
            adherent.setEmail(email.trim().toLowerCase());
            adherent.setMotdepasse(motdepasse);
            adherent.setProfil(profil);
            
            // Parser la date de naissance
            LocalDate dateNaissance = LocalDate.parse(dateNaissanceStr);
            adherent.setDateNaissance(dateNaissance);
            
            // Verifier l'âge (entre 10 et 100 ans)
            int age = Period.between(dateNaissance, LocalDate.now()).getYears();
            
            if (age > 100) {
                throw new Exception("Âge invalide");
            }
            
            adherent = adherentRepository.save(adherent);
            
            // Creer l'abonnement
            AdherentAbonnement abonnement = new AdherentAbonnement();
            abonnement.setAdherent(adherent);
            abonnement.setDateInscription(LocalDate.now());
            abonnement.setDateFin(LocalDate.now().plusDays(dureeAbonnement));
            
            adherentAbonnementRepository.save(abonnement);
            
            // Calculer la durée pour le message
            String dureeTexte = switch (dureeAbonnement) {
                case 30 -> "1 mois";
                case 90 -> "3 mois";
                case 180 -> "6 mois";
                case 365 -> "1 an";
                default -> dureeAbonnement + " jours";
            };
            System.out.println("=== ADHERENT CREE AVEC SUCCES ===");
            return String.format(
                "Adherent cree avec succes !\n\n" +
                "Nom: %s\n" +
                "Email: %s\n" +
                "Age: %d ans\n" +
                "Profil: %s\n" +
                "Abonnement: %s\n" +
                "Valable jusqu'au: %s\n\n" +
                "L'adherent peut maintenant se connecter avec son email et mot de passe.",
                nom, email, age, profil.getLibelle(), dureeTexte, abonnement.getDateFin()
            );
            
        } catch (NumberFormatException e) {
            throw new Exception("Donnees numeriques invalides");
        } catch (Exception e) {
            throw new Exception("Erreur lors de la creation: " + e.getMessage());
        }
    }
}