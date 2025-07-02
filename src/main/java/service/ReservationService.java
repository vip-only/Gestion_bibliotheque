package service;

import model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import repository.*;

import java.time.LocalDate;
import java.time.Period;
import java.util.List;

@Service
public class ReservationService {
    
    @Autowired
    private ReservationRepository reservationRepository;
    
    @Autowired
    private ReservationEtatRepository reservationEtatRepository;
    
    @Autowired
    private AdherentRepository adherentRepository;
    
    @Autowired
    private ExemplaireRepository exemplaireRepository;
    
    @Autowired
    private EtatRepository etatRepository;
    
    @Autowired
    private AdherentExemplaireRepository adherentExemplaireRepository;
    
    @Autowired
    private AdherentPenaliteRepository adherentPenaliteRepository;
    
    @Autowired
    private QuotaRepository quotaRepository;
    
    @Autowired
    private DureeEmpruntRepository dureeEmpruntRepository;
    
    @Autowired
    private AdherentAbonnementRepository adherentAbonnementRepository;
    
    @Transactional
    public String reserverExemplaire(String numExemplaire, Integer idAdherent, LocalDate dateReservation) throws Exception {
        try {
            System.out.println("=== DEBUT RESERVATION ===");
            System.out.println("Exemplaire: " + numExemplaire + ", Adherent: " + idAdherent + ", Date: " + dateReservation);
            
            // 1. Recuperer l'adherent
            Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new Exception("COMPTE INTROUVABLE : Votre compte adherent est introuvable dans notre systeme. Veuillez vous reconnecter ou contacter la bibliotheque."));
            System.out.println("Adherent trouve: " + adherent.getNom());
            
            // 2. Verifier l'abonnement actif
            verifierAbonnementActif(adherent);
            
            // 3. Verifier les penalites actives avec details
            verifierPenalitesActives(adherent.getIdAdherent());
            
            // 4. Recuperer et verifier l'exemplaire
            Exemplaire exemplaire = verifierExemplaire(numExemplaire);
            
            // 5. Verifier l'age requis pour le livre
            verifierAgeMinimum(adherent, exemplaire);
            
            // 6. Verifier le quota avec details
            verifierQuota(adherent);
            
            // 7. Verifier que la date de reservation est valide
            verifierDateReservation(dateReservation);
            
            // 8. Creer la reservation
            Reservation reservation = creerReservation(adherent, exemplaire, dateReservation);
            
            System.out.println("=== RESERVATION REUSSIE ===");
            return "RESERVATION CONFIRMEE !\n" +
                   "Livre : " + exemplaire.getLivre().getTitre() + "\n" +
                   "Exemplaire : " + numExemplaire + "\n" +
                   "A recuperer le : " + dateReservation + "\n" +
                   "A retourner avant le : " + reservation.getDateFin() + "\n" +
                   "Rendez-vous a la bibliotheque pour recuperer votre livre !";
                   
        } catch (Exception e) {
            System.err.println("ERREUR lors de la reservation: " + e.getMessage());
            e.printStackTrace();
            throw e; // Relancer l'exception avec le message detaille
        }
    }
    
    private void verifierAbonnementActif(Adherent adherent) throws Exception {
        // Verifier si l'adherent a un profil configure
        if (adherent.getProfil() == null) {
            throw new Exception("PROFIL MANQUANT : Votre profil adherent n'est pas configure correctement. Contactez la bibliotheque pour resoudre ce probleme.");
        }
        
        // Utiliser la methode isAbonnementActif qui retourne 1 si actif, 0 sinon
        Integer abonnementActif = adherentAbonnementRepository.isAbonnementActif(adherent.getIdAdherent());
        
        if (abonnementActif == null || abonnementActif == 0) {
            throw new Exception("ABONNEMENT EXPIRE : Votre abonnement a la bibliotheque a expire ou n'existe pas.\n\n" +
                              "SOLUTIONS :\n" +
                              "- Renouvelez votre abonnement a la bibliotheque\n" +
                              "- Contactez la bibliotheque pour verifier votre statut\n" +
                              "- Verifiez que votre inscription est toujours valide\n\n" +
                              "Contactez la bibliotheque pour plus d'informations.");
        }
        
        System.out.println("Abonnement actif verifie pour l'adherent: " + adherent.getNom());
    }
    
    private void verifierPenalitesActives(Integer idAdherent) throws Exception {
        boolean hasPenalite = adherentPenaliteRepository.hasPenaliteActive(idAdherent);
        if (hasPenalite) {
            List<AdherentPenalite> penalitesActives = adherentPenaliteRepository.findPenalitesActivesByAdherent(idAdherent);
            
            StringBuilder message = new StringBuilder("COMPTE SUSPENDU - PENALITE ACTIVE\n\n");
            message.append("Votre compte est temporairement suspendu en raison de retards de livres.\n\n");
            
            if (penalitesActives != null && !penalitesActives.isEmpty()) {
                message.append("DETAILS DES PENALITES :\n");
                for (AdherentPenalite penalite : penalitesActives) {
                    long joursRestants = java.time.temporal.ChronoUnit.DAYS.between(LocalDate.now(), penalite.getDateFin());
                    message.append("- Periode : du ").append(penalite.getDateDebut())
                           .append(" au ").append(penalite.getDateFin()).append("\n");
                    message.append("- Temps restant : ").append(joursRestants).append(" jour(s)\n");
                    message.append("- Motif : Retour en retard\n\n");
                }
            }
            
            message.append("SOLUTIONS :\n");
            message.append("- Attendez la fin de la periode de penalite\n");
            message.append("- Contactez la bibliotheque si vous pensez qu'il y a une erreur\n");
            message.append("- Verifiez si vous avez des livres en retard a retourner");
            
            throw new Exception(message.toString());
        }
    }
    
    private Exemplaire verifierExemplaire(String numExemplaire) throws Exception {
        Exemplaire exemplaire = exemplaireRepository.findByNumExemplaire(numExemplaire);
        if (exemplaire == null) {
            throw new Exception("EXEMPLAIRE INTROUVABLE : L'exemplaire " + numExemplaire + " n'existe pas dans notre systeme.\n" +
                              "Verifiez le numero d'exemplaire ou choisissez un autre exemplaire.");
        }
        
        // Verifier que l'exemplaire n'est pas emprunte
        boolean estEmprunte = adherentExemplaireRepository.existsByExemplaireAndDateRetourIsNull(exemplaire);
        if (estEmprunte) {
            throw new Exception("EXEMPLAIRE EMPRUNTE : L'exemplaire " + numExemplaire + " est actuellement emprunte par un autre adherent.\n" +
                              "Choisissez un autre exemplaire du meme livre ou patientez jusqu'a son retour.");
        }
        
        // Verifier qu'il n'y a pas deja une reservation active
        boolean estReserve = reservationRepository.existsByExemplaireAndDateFinAfter(exemplaire, LocalDate.now());
        if (estReserve) {
            throw new Exception("EXEMPLAIRE DEJA RESERVE : L'exemplaire " + numExemplaire + " est deja reserve par un autre adherent.\n" +
                              "Choisissez un autre exemplaire disponible du meme livre.");
        }
        
        return exemplaire;
    }
    
    private void verifierAgeMinimum(Adherent adherent, Exemplaire exemplaire) throws Exception {
        if (exemplaire.getLivre().getAgesup() != null) {
            int ageAdherent = calculerAge(adherent.getDateNaissance());
            int ageMinimum = exemplaire.getLivre().getAgesup();
            
            if (ageAdherent < ageMinimum) {
                throw new Exception("AGE INSUFFISANT : Vous n'avez pas l'age requis pour emprunter ce livre.\n\n" +
                                  "Livre : " + exemplaire.getLivre().getTitre() + "\n" +
                                  "Votre age : " + ageAdherent + " ans\n" +
                                  "Age minimum requis : " + ageMinimum + " ans\n\n" +
                                  "Revenez quand vous aurez " + ageMinimum + " ans ou choisissez un autre livre adapte a votre age.");
            }
        }
    }
    
    private void verifierQuota(Adherent adherent) throws Exception {
        Integer quotaMax = quotaRepository.findQuotaByProfil(adherent.getProfil().getIdProfil());
        if (quotaMax == null) {
            quotaMax = 3; // Quota par defaut
        }
        
        Integer empruntsActuels = adherentExemplaireRepository.countEmpruntsActifs(adherent.getIdAdherent());
        Integer reservationsActuelles = reservationRepository.countReservationsActives(adherent.getIdAdherent());
        
        if (empruntsActuels == null) empruntsActuels = 0;
        if (reservationsActuelles == null) reservationsActuelles = 0;
        
        int totalActuel = empruntsActuels + reservationsActuelles;
        
        if (totalActuel >= quotaMax) {
            String profilLibelle = adherent.getProfil().getLibelle();
            
            throw new Exception("QUOTA DEPASSE : Vous avez atteint votre limite d'emprunts et reservations.\n\n" +
                              "Votre profil : " + profilLibelle + "\n" +
                              "Quota autorise : " + quotaMax + " livre(s)\n" +
                              "Actuellement :\n" +
                              "   - " + empruntsActuels + " emprunt(s) en cours\n" +
                              "   - " + reservationsActuelles + " reservation(s) active(s)\n" +
                              "   - Total : " + totalActuel + "/" + quotaMax + "\n\n" +
                              "SOLUTIONS :\n" +
                              "- Retournez des livres empruntes\n" +
                              "- Annulez des reservations non utilisees\n" +
                              "- Patientez que vos reservations arrivent a echeance");
        }
    }
    
    private void verifierDateReservation(LocalDate dateReservation) throws Exception {
        LocalDate aujourdhui = LocalDate.now();
        
        if (dateReservation.isBefore(aujourdhui)) {
            throw new Exception("DATE INVALIDE : La date de recuperation ne peut pas etre dans le passe.\n\n" +
                              "Date choisie : " + dateReservation + "\n" +
                              "Date actuelle : " + aujourdhui + "\n\n" +
                              "Choisissez une date a partir d'aujourd'hui.");
        }
        
        // Verifier que la date n'est pas trop loin dans le futur (max 30 jours)
        LocalDate dateLimite = aujourdhui.plusDays(30);
        if (dateReservation.isAfter(dateLimite)) {
            throw new Exception("DATE TROP LOINTAINE : La reservation ne peut pas etre faite plus de 30 jours a l'avance.\n\n" +
                              "Date choisie : " + dateReservation + "\n" +
                              "Date limite autorisee : " + dateLimite + "\n\n" +
                              "Choisissez une date dans les 30 prochains jours.");
        }
    }
    
    private Reservation creerReservation(Adherent adherent, Exemplaire exemplaire, LocalDate dateReservation) throws Exception {
        try {
            // Utiliser le type de pret par defaut (a domicile = 1)
            Integer idTypePret = 1;
            
            // Calculer la date de fin selon la duree d'emprunt du profil
            Integer nbJours = dureeEmpruntRepository.findNbJoursByProfilAndTypePret(
                adherent.getProfil().getIdProfil(), 
                idTypePret
            );
            if (nbJours == null) {
                // Valeurs par defaut selon le profil visible dans insert.sql
                switch (adherent.getProfil().getIdProfil()) {
                    case 1: nbJours = 14; break; // Etudiant
                    case 2: nbJours = 30; break; // Prof
                    case 3: nbJours = 20; break; // Pro
                    case 4: nbJours = 5; break;  // Anonyme
                    default: nbJours = 14; break;
                }
            }
            
            LocalDate dateFin = dateReservation.plusDays(nbJours);
            System.out.println("Date fin calculee: " + dateFin + " (+" + nbJours + " jours)");
            
            // Creer la reservation
            Reservation reservation = new Reservation();
            reservation.setAdherent(adherent);
            reservation.setExemplaire(exemplaire);
            reservation.setDateDebut(dateReservation);
            reservation.setDateFin(dateFin);
            
            try {
                reservation = reservationRepository.save(reservation);
                System.out.println("Reservation creee avec ID: " + reservation.getIdReservation());
            } catch (Exception e) {
                System.err.println("ERREUR lors de la sauvegarde de la reservation: " + e.getMessage());
                throw new Exception("Erreur lors de la creation de la reservation: " + e.getMessage());
            }
            
            // Creer la liaison ReservationEtat avec idEtat = 1 directement
            try {
                System.out.println("Creation de ReservationEtat avec idEtat = 1...");
                System.out.println("   - Reservation ID: " + reservation.getIdReservation());
                System.out.println("   - Etat ID: 1 (en cours)");
                System.out.println("   - Date: " + LocalDate.now());
                
                // Recuperer l'etat avec ID = 1
                Etat etatEnCours = etatRepository.findById(1)
                    .orElseThrow(() -> new Exception("Etat avec ID=1 introuvable"));
                
                ReservationEtat reservationEtat = new ReservationEtat();
                reservationEtat.setReservation(reservation);
                reservationEtat.setEtat(etatEnCours);
                reservationEtat.setDateEtat(LocalDate.now());
                
                reservationEtat = reservationEtatRepository.save(reservationEtat);
                System.out.println("ReservationEtat cree avec ID: " + reservationEtat.getIdReservationEtat());
                
            } catch (Exception e) {
                System.err.println("ERREUR lors de la creation de ReservationEtat: " + e.getMessage());
                e.printStackTrace();
                
                System.out.println("La reservation est creee mais sans suivi d'etat");
            }
            
            return reservation;
            
        } catch (Exception e) {
            System.err.println("ERREUR GLOBALE dans creerReservation: " + e.getMessage());
            e.printStackTrace();
            throw new Exception("ERREUR TECHNIQUE : Une erreur est survenue lors de la creation de votre reservation.\n" +
                          "Veuillez reessayer ou contacter la bibliotheque si le probleme persiste.\n" +
                          "Detail technique : " + e.getMessage());
        }
    }
    
    private int calculerAge(LocalDate dateNaissance) {
        if (dateNaissance == null) {
            return 0;
        }
        return Period.between(dateNaissance, LocalDate.now()).getYears();
    }
}