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
            
            // 1. Récupérer l'adhérent
            Adherent adherent = adherentRepository.findById(idAdherent)
                .orElseThrow(() -> new Exception("❌ COMPTE INTROUVABLE : Votre compte adhérent est introuvable dans notre système. Veuillez vous reconnecter ou contacter la bibliothèque."));
            System.out.println("Adhérent trouvé: " + adherent.getNom());
            
            // 2. Vérifier l'abonnement actif
            verifierAbonnementActif(adherent);
            
            // 3. Vérifier les pénalités actives avec détails
            verifierPenalitesActives(adherent.getIdAdherent());
            
            // 4. Récupérer et vérifier l'exemplaire
            Exemplaire exemplaire = verifierExemplaire(numExemplaire);
            
            // 5. Vérifier l'âge requis pour le livre
            verifierAgeMinimum(adherent, exemplaire);
            
            // 6. Vérifier le quota avec détails
            verifierQuota(adherent);
            
            // 7. Vérifier que la date de réservation est valide
            verifierDateReservation(dateReservation);
            
            // 8. Créer la réservation
            Reservation reservation = creerReservation(adherent, exemplaire, dateReservation);
            
            System.out.println("=== RESERVATION REUSSIE ===");
            return "✅ RÉSERVATION CONFIRMÉE !\n" +
                   "📚 Livre : " + exemplaire.getLivre().getTitre() + "\n" +
                   "🏷️ Exemplaire : " + numExemplaire + "\n" +
                   "📅 À récupérer le : " + dateReservation + "\n" +
                   "⏰ À retourner avant le : " + reservation.getDateFin() + "\n" +
                   "📍 Rendez-vous à la bibliothèque pour récupérer votre livre !";
                   
        } catch (Exception e) {
            System.err.println("ERREUR lors de la réservation: " + e.getMessage());
            e.printStackTrace();
            throw e; // Relancer l'exception avec le message détaillé
        }
    }
    
    private void verifierAbonnementActif(Adherent adherent) throws Exception {
        // Vérifier si l'adhérent a un profil configuré
        if (adherent.getProfil() == null) {
            throw new Exception("❌ PROFIL MANQUANT : Votre profil adhérent n'est pas configuré correctement. Contactez la bibliothèque pour résoudre ce problème.");
        }
        
        // Utiliser la méthode isAbonnementActif qui retourne 1 si actif, 0 sinon
        Integer abonnementActif = adherentAbonnementRepository.isAbonnementActif(adherent.getIdAdherent());
        
        if (abonnementActif == null || abonnementActif == 0) {
            throw new Exception("❌ ABONNEMENT EXPIRÉ : Votre abonnement à la bibliothèque a expiré ou n'existe pas.\n\n" +
                              "💡 SOLUTIONS :\n" +
                              "• Renouvelez votre abonnement à la bibliothèque\n" +
                              "• Contactez la bibliothèque pour vérifier votre statut\n" +
                              "• Vérifiez que votre inscription est toujours valide\n\n" +
                              "📞 Contactez la bibliothèque pour plus d'informations.");
        }
        
        System.out.println("Abonnement actif vérifié pour l'adhérent: " + adherent.getNom());
    }
    
    private void verifierPenalitesActives(Integer idAdherent) throws Exception {
        boolean hasPenalite = adherentPenaliteRepository.hasPenaliteActive(idAdherent);
        if (hasPenalite) {
            List<AdherentPenalite> penalitesActives = adherentPenaliteRepository.findPenalitesActivesByAdherent(idAdherent);
            
            StringBuilder message = new StringBuilder("🚫 COMPTE SUSPENDU - PÉNALITÉ ACTIVE\n\n");
            message.append("Votre compte est temporairement suspendu en raison de retards de livres.\n\n");
            
            if (penalitesActives != null && !penalitesActives.isEmpty()) {
                message.append("📋 DÉTAILS DES PÉNALITÉS :\n");
                for (AdherentPenalite penalite : penalitesActives) {
                    long joursRestants = java.time.temporal.ChronoUnit.DAYS.between(LocalDate.now(), penalite.getDateFin());
                    message.append("• Période : du ").append(penalite.getDateDebut())
                           .append(" au ").append(penalite.getDateFin()).append("\n");
                    message.append("• Temps restant : ").append(joursRestants).append(" jour(s)\n");
                    message.append("• Motif : Retour en retard\n\n");
                }
            }
            
            message.append("💡 SOLUTIONS :\n");
            message.append("• Attendez la fin de la période de pénalité\n");
            message.append("• Contactez la bibliothèque si vous pensez qu'il y a une erreur\n");
            message.append("• Vérifiez si vous avez des livres en retard à retourner");
            
            throw new Exception(message.toString());
        }
    }
    
    private Exemplaire verifierExemplaire(String numExemplaire) throws Exception {
        Exemplaire exemplaire = exemplaireRepository.findByNumExemplaire(numExemplaire);
        if (exemplaire == null) {
            throw new Exception("❌ EXEMPLAIRE INTROUVABLE : L'exemplaire " + numExemplaire + " n'existe pas dans notre système.\n" +
                              "💡 Vérifiez le numéro d'exemplaire ou choisissez un autre exemplaire.");
        }
        
        // Vérifier que l'exemplaire n'est pas emprunté
        boolean estEmprunte = adherentExemplaireRepository.existsByExemplaireAndDateRetourIsNull(exemplaire);
        if (estEmprunte) {
            throw new Exception("📚 EXEMPLAIRE EMPRUNTÉ : L'exemplaire " + numExemplaire + " est actuellement emprunté par un autre adhérent.\n" +
                              "💡 Choisissez un autre exemplaire du même livre ou patientez jusqu'à son retour.");
        }
        
        // Vérifier qu'il n'y a pas déjà une réservation active
        boolean estReserve = reservationRepository.existsByExemplaireAndDateFinAfter(exemplaire, LocalDate.now());
        if (estReserve) {
            throw new Exception("📋 EXEMPLAIRE DÉJÀ RÉSERVÉ : L'exemplaire " + numExemplaire + " est déjà réservé par un autre adhérent.\n" +
                              "💡 Choisissez un autre exemplaire disponible du même livre.");
        }
        
        return exemplaire;
    }
    
    private void verifierAgeMinimum(Adherent adherent, Exemplaire exemplaire) throws Exception {
        if (exemplaire.getLivre().getAgesup() != null) {
            int ageAdherent = calculerAge(adherent.getDateNaissance());
            int ageMinimum = exemplaire.getLivre().getAgesup();
            
            if (ageAdherent < ageMinimum) {
                throw new Exception("🔞 ÂGE INSUFFISANT : Vous n'avez pas l'âge requis pour emprunter ce livre.\n\n" +
                                  "📚 Livre : " + exemplaire.getLivre().getTitre() + "\n" +
                                  "🎂 Votre âge : " + ageAdherent + " ans\n" +
                                  "⚠️ Âge minimum requis : " + ageMinimum + " ans\n\n" +
                                  "💡 Revenez quand vous aurez " + ageMinimum + " ans ou choisissez un autre livre adapté à votre âge.");
            }
        }
    }
    
    private void verifierQuota(Adherent adherent) throws Exception {
        Integer quotaMax = quotaRepository.findQuotaByProfil(adherent.getProfil().getIdProfil());
        if (quotaMax == null) {
            quotaMax = 3; // Quota par défaut
        }
        
        Integer empruntsActuels = adherentExemplaireRepository.countEmpruntsActifs(adherent.getIdAdherent());
        Integer reservationsActuelles = reservationRepository.countReservationsActives(adherent.getIdAdherent());
        
        if (empruntsActuels == null) empruntsActuels = 0;
        if (reservationsActuelles == null) reservationsActuelles = 0;
        
        int totalActuel = empruntsActuels + reservationsActuelles;
        
        if (totalActuel >= quotaMax) {
            String profilLibelle = adherent.getProfil().getLibelle();
            
            throw new Exception("📊 QUOTA DÉPASSÉ : Vous avez atteint votre limite d'emprunts et réservations.\n\n" +
                              "👤 Votre profil : " + profilLibelle + "\n" +
                              "📈 Quota autorisé : " + quotaMax + " livre(s)\n" +
                              "📚 Actuellement :\n" +
                              "   • " + empruntsActuels + " emprunt(s) en cours\n" +
                              "   • " + reservationsActuelles + " réservation(s) active(s)\n" +
                              "   • Total : " + totalActuel + "/" + quotaMax + "\n\n" +
                              "💡 SOLUTIONS :\n" +
                              "• Retournez des livres empruntés\n" +
                              "• Annulez des réservations non utilisées\n" +
                              "• Patientez que vos réservations arrivent à échéance");
        }
    }
    
    private void verifierDateReservation(LocalDate dateReservation) throws Exception {
        LocalDate aujourdhui = LocalDate.now();
        
        if (dateReservation.isBefore(aujourdhui)) {
            throw new Exception("📅 DATE INVALIDE : La date de récupération ne peut pas être dans le passé.\n\n" +
                              "🗓️ Date choisie : " + dateReservation + "\n" +
                              "📍 Date actuelle : " + aujourdhui + "\n\n" +
                              "💡 Choisissez une date à partir d'aujourd'hui.");
        }
        
        // Vérifier que la date n'est pas trop loin dans le futur (max 30 jours)
        LocalDate dateLimite = aujourdhui.plusDays(30);
        if (dateReservation.isAfter(dateLimite)) {
            throw new Exception("📅 DATE TROP LOINTAINE : La réservation ne peut pas être faite plus de 30 jours à l'avance.\n\n" +
                              "🗓️ Date choisie : " + dateReservation + "\n" +
                              "⏰ Date limite autorisée : " + dateLimite + "\n\n" +
                              "💡 Choisissez une date dans les 30 prochains jours.");
        }
    }
    
    private Reservation creerReservation(Adherent adherent, Exemplaire exemplaire, LocalDate dateReservation) throws Exception {
        try {
            // Utiliser le type de prêt par défaut (à domicile = 1)
            Integer idTypePret = 1;
            
            // Calculer la date de fin selon la durée d'emprunt du profil
            Integer nbJours = dureeEmpruntRepository.findNbJoursByProfilAndTypePret(
                adherent.getProfil().getIdProfil(), 
                idTypePret
            );
            if (nbJours == null) {
                // Valeurs par défaut selon le profil visible dans insert.sql
                switch (adherent.getProfil().getIdProfil()) {
                    case 1: nbJours = 14; break; // Étudiant
                    case 2: nbJours = 30; break; // Prof
                    case 3: nbJours = 20; break; // Pro
                    case 4: nbJours = 5; break;  // Anonyme
                    default: nbJours = 14; break;
                }
            }
            
            LocalDate dateFin = dateReservation.plusDays(nbJours);
            System.out.println("Date fin calculée: " + dateFin + " (+" + nbJours + " jours)");
            
            // Créer la réservation
            Reservation reservation = new Reservation();
            reservation.setAdherent(adherent);
            reservation.setExemplaire(exemplaire);
            reservation.setDateDebut(dateReservation);
            reservation.setDateFin(dateFin);
            
            try {
                reservation = reservationRepository.save(reservation);
                System.out.println("✅ Réservation créée avec ID: " + reservation.getIdReservation());
            } catch (Exception e) {
                System.err.println("❌ ERREUR lors de la sauvegarde de la réservation: " + e.getMessage());
                throw new Exception("Erreur lors de la création de la réservation: " + e.getMessage());
            }
            
            // Créer la liaison ReservationEtat avec idEtat = 1 directement
            try {
                System.out.println("📝 Création de ReservationEtat avec idEtat = 1...");
                System.out.println("   - Réservation ID: " + reservation.getIdReservation());
                System.out.println("   - État ID: 1 (en cours)");
                System.out.println("   - Date: " + LocalDate.now());
                
                // Récupérer l'état avec ID = 1
                Etat etatEnCours = etatRepository.findById(1)
                    .orElseThrow(() -> new Exception("État avec ID=1 introuvable"));
                
                ReservationEtat reservationEtat = new ReservationEtat();
                reservationEtat.setReservation(reservation);
                reservationEtat.setEtat(etatEnCours);
                reservationEtat.setDateEtat(LocalDate.now());
                
                reservationEtat = reservationEtatRepository.save(reservationEtat);
                System.out.println("✅ ReservationEtat créé avec ID: " + reservationEtat.getIdReservationEtat());
                
            } catch (Exception e) {
                System.err.println("❌ ERREUR lors de la création de ReservationEtat: " + e.getMessage());
                e.printStackTrace();
                
                // Même si ReservationEtat échoue, on garde la réservation
                System.out.println("⚠️ La réservation est créée mais sans suivi d'état");
            }
            
            return reservation;
            
        } catch (Exception e) {
            System.err.println("❌ ERREUR GLOBALE dans creerReservation: " + e.getMessage());
            e.printStackTrace();
            throw new Exception("❌ ERREUR TECHNIQUE : Une erreur est survenue lors de la création de votre réservation.\n" +
                          "💡 Veuillez réessayer ou contacter la bibliothèque si le problème persiste.\n" +
                          "🔧 Détail technique : " + e.getMessage());
        }
    }
    
    private int calculerAge(LocalDate dateNaissance) {
        if (dateNaissance == null) {
            return 0;
        }
        return Period.between(dateNaissance, LocalDate.now()).getYears();
    }
}