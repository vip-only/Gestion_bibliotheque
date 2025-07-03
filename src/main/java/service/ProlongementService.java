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
    
    @Autowired
    private ReservationRepository reservationRepository;
    
    @Transactional
    public String creerDemandeProlongement(Integer idAdherentExemplaire, Integer idAdherent) throws Exception {
        try {
            System.out.println("=== DEBUT CREATION DEMANDE PROLONGEMENT ===");
            System.out.println("idAdherentExemplaire: " + idAdherentExemplaire);
            System.out.println("idAdherent: " + idAdherent);
            
            AdherentExemplaire adherentExemplaire = adherentExemplaireRepository.findById(idAdherentExemplaire)
                    .orElseThrow(() -> new Exception("Emprunt introuvable"));
            
            System.out.println("Emprunt trouvE: " + adherentExemplaire.getIdAdherentExemplaire());
            
            if (!adherentExemplaire.getAdherent().getIdAdherent().equals(idAdherent)) {
                throw new Exception("Vous n'êtes pas autorisE à prolonger cet emprunt");
            }
            
            // VErifier qu'il n'y a pas dEjà une demande en cours
            Integer countDemandesEnCours = prolongementExemplaireRepository.countByAdherentExemplaireAndEtatEnCours(idAdherentExemplaire);
            if (countDemandesEnCours != null && countDemandesEnCours > 0) {
                throw new Exception("Une demande de prolongement est dEjà en cours pour cet emprunt");
            }
            
            // VErifier que l'emprunt est toujours en cours
            if (adherentExemplaire.getDateRetour() != null) {
                throw new Exception("Impossible de prolonger un emprunt dEjà retournE");
            }
            
            // Calculer la durEe de prolongement
            Integer dureeEmprunt = null;
            try {
                dureeEmprunt = dureeEmpruntRepository.findNbJoursByProfilAndTypePret(
                    adherentExemplaire.getAdherent().getProfil().getIdProfil(),
                    adherentExemplaire.getTypePret().getIdTypePret()
                );
            } catch (Exception e) {
                System.out.println("Erreur lors de la rEcupEration de la durEe d'emprunt: " + e.getMessage());
            }
            
            if (dureeEmprunt == null) {
                Integer idProfil = adherentExemplaire.getAdherent().getProfil().getIdProfil();
                switch (idProfil) {
                    case 1: dureeEmprunt = 14; break; // Etudiant
                    case 2: dureeEmprunt = 30; break; // Prof
                    case 3: dureeEmprunt = 20; break; // Pro
                    case 4: dureeEmprunt = 5; break;  // Anonyme
                    default: dureeEmprunt = 14; break;
                }
                System.out.println("DurEe par dEfaut utilisEe: " + dureeEmprunt + " jours pour profil " + idProfil);
            } else {
                System.out.println("DurEe trouvEe dans la base: " + dureeEmprunt + " jours");
            }
            
            // **NOUVELLE VERIFICATION** : VErifier qu'il n'y a pas de conflit avec une rEservation acceptEe
            verifierConflitReservationAcceptee(adherentExemplaire, dureeEmprunt);
            
            ProlongementExemplaire prolongementExemplaire = new ProlongementExemplaire();
            prolongementExemplaire.setAdherentExemplaire(adherentExemplaire);
            prolongementExemplaire.setProlongement(dureeEmprunt);
            
            prolongementExemplaire = prolongementExemplaireRepository.save(prolongementExemplaire);
            System.out.println("ProlongementExemplaire crEE avec ID: " + prolongementExemplaire.getIdProlongementExemplaire());
            
            Etat etatEnCours = etatRepository.findById(1)
                    .orElseThrow(() -> new Exception("Etat avec ID=1 introuvable"));
            
            System.out.println("Etat trouvE: " + etatEnCours.getLibelle());
            
            // CrEer l'EtatProlongementExemplaire
            EtatProlongementExemplaire etatProlongementExemplaire = new EtatProlongementExemplaire();
            etatProlongementExemplaire.setProlongementExemplaire(prolongementExemplaire);
            etatProlongementExemplaire.setEtat(etatEnCours);
            etatProlongementExemplaire.setDateEtat(LocalDate.now());
            
            etatProlongementExemplaire = etatProlongementExemplaireRepository.save(etatProlongementExemplaire);
            System.out.println("EtatProlongementExemplaire crEE avec ID: " + etatProlongementExemplaire.getIdEtatProlongementExemplaire());
            
            // REcupErer les informations du livre pour le message
            String titreLivre = adherentExemplaire.getExemplaire().getLivre().getTitre();
            String numExemplaire = adherentExemplaire.getExemplaire().getNumExemplaire();
            
            String message = String.format(
                "Demande de prolongement crEEe avec succes !\n\n" +
                "Livre: %s\n" +
                "Exemplaire: %s\n" +
                "DurEe demandEe: %d jours\n" +
                "Statut: En attente de validation\n\n" +
                "%s",
                titreLivre, numExemplaire, dureeEmprunt,
                "tre demande sera traitEe par la bibliotheque."
            );
            
            System.out.println("=== PROLONGEMENT CREE AVEC SUCCeS ===");
            return message;
            
        } catch (Exception e) {
            System.err.println("ERREUR lors de la crEation du prolongement: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
    
    /**
     * VErifie qu'un prolongement ne rentre pas en conflit avec une rEservation acceptEe
     */
    private void verifierConflitReservationAcceptee(AdherentExemplaire adherentExemplaire, Integer dureeEmprunt) throws Exception {
        // Calculer la nouvelle date limite si le prolongement Etait accordE
        LocalDate nouvelleDateLimite = adherentExemplaire.getDateLimite().plusDays(dureeEmprunt);
        
        // Chercher les rEservations acceptEes pour cet exemplaire
        Map<String, Object> reservationConflictuelle = reservationRepository.findReservationAccepteeConflictuelle(
            adherentExemplaire.getExemplaire().getIdExemplaire(),
            nouvelleDateLimite
        );
        
        if (reservationConflictuelle != null) {
            String nomAdherentReservation = (String) reservationConflictuelle.get("nomAdherent");
            String emailAdherentReservation = (String) reservationConflictuelle.get("emailAdherent");
            LocalDate dateDebutReservation = (LocalDate) reservationConflictuelle.get("dateDebut");
            LocalDate dateFinReservation = (LocalDate) reservationConflictuelle.get("dateFin");
            
            // Calculer le nombre de jours de conflit
            long joursConflit = java.time.temporal.ChronoUnit.DAYS.between(dateDebutReservation, nouvelleDateLimite) + 1;
            
            throw new Exception(String.format(
                "PROLONGEMENT IMPOSSIBLE - CONFLIT DE RESERVATION\n\n" +
                "DETAILS DU CONFLIT :\n" +
                "Votre date limite actuelle : %s\n" +
                "Nouvelle date limite (avec prolongement) : %s\n" +
                "Date de rEcupEration de la rEservation : %s\n" +
                "Conflit de %d jour(s)\n\n" +
                "RESERVATION CONCERNEE :\n" +
                "AdhErent : %s (%s)\n" +
                "PEriode rEservEe : du %s au %s\n" +
                "Exemplaire : %s\n" +
                "Livre : %s\n\n" +
                "SOLUTIONS :\n" +
                dureeEmprunt,
                adherentExemplaire.getDateLimite(),
                nouvelleDateLimite,
                dateDebutReservation,
                joursConflit,
                nomAdherentReservation,
                emailAdherentReservation,
                dateDebutReservation,
                dateFinReservation,
                adherentExemplaire.getExemplaire().getNumExemplaire(),
                adherentExemplaire.getExemplaire().getLivre().getTitre(),
                adherentExemplaire.getDateLimite()
            ));
        }
    }
}