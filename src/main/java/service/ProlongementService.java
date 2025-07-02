package service;

import model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import repository.*;

import java.time.LocalDate;

@Service
public class ProlongementService {
    
    @Autowired
    private AdherentExemplaireRepository adherentExemplaireRepository;
    
    @Autowired
    private ProlongementExemplaireRepository prolongementExemplaireRepository;
    
    @Autowired
    private EtatProlongementExemplaireRepository etatProlongementExemplaireRepository;
    
    @Autowired
    private EtatRepository etatRepository;
    
    @Autowired
    private DureeEmpruntRepository dureeEmpruntRepository;
    
    @Transactional
    public String creerDemandeProlongement(Integer idAdherentExemplaire, Integer idAdherent) throws Exception {
        try {
            System.out.println("=== DEBUT CREATION DEMANDE PROLONGEMENT ===");
            System.out.println("idAdherentExemplaire: " + idAdherentExemplaire);
            System.out.println("idAdherent: " + idAdherent);
            
            // Recuperer l'emprunt
            AdherentExemplaire adherentExemplaire = adherentExemplaireRepository.findById(idAdherentExemplaire)
                    .orElseThrow(() -> new Exception("Emprunt introuvable"));
            
            System.out.println("Emprunt trouve: " + adherentExemplaire.getIdAdherentExemplaire());
            
            // Verifier que l'emprunt appartient a l'adherent connecte
            if (!adherentExemplaire.getAdherent().getIdAdherent().equals(idAdherent)) {
                throw new Exception("Vous n'etes pas autorise a prolonger cet emprunt");
            }
            
            // Verifier que l'emprunt est toujours en cours
            if (adherentExemplaire.getDateRetour() != null) {
                throw new Exception("Impossible de prolonger un emprunt deja retourne");
            }
            
            // Verifier qu'il n'y a pas deja une demande de prolongement en cours
            Integer countDemandesEnCours = prolongementExemplaireRepository.countByAdherentExemplaireAndEtatEnCours(idAdherentExemplaire);
            if (countDemandesEnCours != null && countDemandesEnCours > 0) {
                throw new Exception("Une demande de prolongement est déjà en cours pour cet emprunt");
            }
            
            System.out.println("Aucune demande en cours trouvée, création du prolongement...");
            
            // Calculer la duree de prolongement selon le profil et le type de pret
            Integer dureeEmprunt = null;
            try {
                dureeEmprunt = dureeEmpruntRepository.findNbJoursByProfilAndTypePret(
                    adherentExemplaire.getAdherent().getProfil().getIdProfil(),
                    adherentExemplaire.getTypePret().getIdTypePret()
                );
            } catch (Exception e) {
                System.out.println("Erreur lors de la recuperation de la duree d'emprunt: " + e.getMessage());
            }
            
            if (dureeEmprunt == null) {
                // Valeurs par defaut selon le profil
                Integer idProfil = adherentExemplaire.getAdherent().getProfil().getIdProfil();
                switch (idProfil) {
                    case 1: dureeEmprunt = 14; break; // Etudiant
                    case 2: dureeEmprunt = 30; break; // Prof
                    case 3: dureeEmprunt = 20; break; // Pro
                    case 4: dureeEmprunt = 5; break;  // Anonyme
                    default: dureeEmprunt = 14; break;
                }
                System.out.println("Duree par defaut utilisee: " + dureeEmprunt + " jours pour profil " + idProfil);
            } else {
                System.out.println("Duree trouvee dans la base: " + dureeEmprunt + " jours");
            }
            
            // Creer le ProlongementExemplaire
            ProlongementExemplaire prolongementExemplaire = new ProlongementExemplaire();
            prolongementExemplaire.setAdherentExemplaire(adherentExemplaire);
            prolongementExemplaire.setProlongement(dureeEmprunt);
            
            prolongementExemplaire = prolongementExemplaireRepository.save(prolongementExemplaire);
            System.out.println("ProlongementExemplaire cree avec ID: " + prolongementExemplaire.getIdProlongementExemplaire());
            
            // Recuperer l'etat "en cours" (idEtat = 1)
            Etat etatEnCours = etatRepository.findById(1)
                    .orElseThrow(() -> new Exception("Etat avec ID=1 introuvable"));
            
            System.out.println("Etat trouve: " + etatEnCours.getLibelle());
            
            // Creer l'EtatProlongementExemplaire
            EtatProlongementExemplaire etatProlongementExemplaire = new EtatProlongementExemplaire();
            etatProlongementExemplaire.setProlongementExemplaire(prolongementExemplaire);
            etatProlongementExemplaire.setEtat(etatEnCours);
            etatProlongementExemplaire.setDateEtat(LocalDate.now());
            
            etatProlongementExemplaire = etatProlongementExemplaireRepository.save(etatProlongementExemplaire);
            System.out.println("EtatProlongementExemplaire cree avec ID: " + etatProlongementExemplaire.getIdEtatProlongementExemplaire());
            
            // Recuperer les informations du livre pour le message
            String titreLivre = adherentExemplaire.getExemplaire().getLivre().getTitre();
            String numExemplaire = adherentExemplaire.getExemplaire().getNumExemplaire();
            
            String message = String.format(
                "Demande de prolongement creee avec succes !\n\n" +
                "Livre: %s\n" +
                "Exemplaire: %s\n" +
                "Duree demandee: %d jours\n" +
                "Statut: En attente de validation\n\n" +
                "Votre demande sera traitee par la bibliotheque.",
                titreLivre, numExemplaire, dureeEmprunt
            );
            
            System.out.println("=== PROLONGEMENT CREE AVEC SUCCES ===");
            return message;
            
        } catch (Exception e) {
            System.err.println("ERREUR lors de la creation du prolongement: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
}