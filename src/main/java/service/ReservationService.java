package service;

import model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import repository.*;

import java.time.LocalDate;
import java.time.Period;

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
    
    @Transactional
    public String reserverExemplaire(String numExemplaire, Integer idAdherent, LocalDate dateReservation) throws Exception {
        // 1. Récupérer l'adhérent
        Adherent adherent = adherentRepository.findById(idAdherent)
            .orElseThrow(() -> new Exception("Adhérent introuvable"));
        
        // 2. Vérifier que l'adhérent n'est pas pénalisé
        if (adherentPenaliteRepository.hasPenaliteActive(idAdherent)) {
            throw new Exception("Impossible de réserver : vous avez une pénalité active");
        }
        
        // 3. Récupérer l'exemplaire
        Exemplaire exemplaire = exemplaireRepository.findByNumExemplaire(numExemplaire);
        if (exemplaire == null) {
            throw new Exception("Exemplaire introuvable");
        }
        
        // 4. Vérifier que l'exemplaire est disponible (ni emprunté ni réservé)
        if (adherentExemplaireRepository.existsByExemplaireAndDateRetourIsNull(exemplaire)) {
            throw new Exception("Cet exemplaire est actuellement emprunté");
        }
        
        // Vérifier qu'il n'y a pas déjà une réservation active pour cet exemplaire
        if (reservationRepository.existsByExemplaireAndDateFinAfter(exemplaire, LocalDate.now())) {
            throw new Exception("Cet exemplaire est déjà réservé");
        }
        
        // 5. Vérifier l'âge requis pour le livre
        if (exemplaire.getLivre().getAgesup() != null) {
            int ageAdherent = calculerAge(adherent.getDateNaissance());
            if (ageAdherent < exemplaire.getLivre().getAgesup()) {
                throw new Exception("Âge minimum requis pour ce livre : " + exemplaire.getLivre().getAgesup() + " ans. " +
                                  "Votre âge : " + ageAdherent + " ans.");
            }
        }
        
        // 6. Vérifier le quota (emprunts + réservations actives)
        Integer quotaMax = quotaRepository.findQuotaByProfil(adherent.getProfil().getIdProfil());
        if (quotaMax == null) {
            quotaMax = 1; // Quota par défaut
        }
        
        Integer empruntsActuels = adherentExemplaireRepository.countEmpruntsActifs(idAdherent);
        Integer reservationsActuelles = reservationRepository.countReservationsActives(idAdherent);
        
        if ((empruntsActuels + reservationsActuelles) >= quotaMax) {
            throw new Exception("Quota atteint (" + (empruntsActuels + reservationsActuelles) + "/" + quotaMax + 
                              "). Veuillez retourner des livres ou annuler des réservations avant de réserver.");
        }
        
        // 7. Vérifier que la date de réservation est valide
        if (dateReservation.isBefore(LocalDate.now())) {
            throw new Exception("La date de réservation ne peut pas être dans le passé");
        }
        
        // 8. Utiliser le type de prêt par défaut (à domicile = 1)
        Integer idTypePret = 1; 
        
        // 9. Calculer la date de fin selon la durée d'emprunt du profil
        Integer nbJours = dureeEmpruntRepository.findNbJoursByProfilAndTypePret(
            adherent.getProfil().getIdProfil(), 
            idTypePret
        );
        if (nbJours == null) {
            nbJours = 14; // Durée par défaut
        }
        
        LocalDate dateFin = dateReservation.plusDays(nbJours);
        
        // 10. Créer la réservation
        Reservation reservation = new Reservation();
        reservation.setAdherent(adherent);
        reservation.setExemplaire(exemplaire);
        reservation.setDateDebut(dateReservation);
        reservation.setDateFin(dateFin);
        
        reservation = reservationRepository.save(reservation);
        
        // 11. Créer l'état "en cours"
        Etat etatEnCours = etatRepository.findByLibelle("en cours");
        if (etatEnCours == null) {
            throw new Exception("État 'en cours' introuvable");
        }
        
        ReservationEtat reservationEtat = new ReservationEtat();
        reservationEtat.setReservation(reservation);
        reservationEtat.setEtat(etatEnCours);
        reservationEtat.setDateEtat(LocalDate.now());
        
        reservationEtatRepository.save(reservationEtat);
        
        return "Réservation effectuée avec succès ! Vous pouvez récupérer le livre le " + dateReservation + 
               " et le garder jusqu'au " + dateFin + " (" + nbJours + " jours d'emprunt à domicile).";
    }
    
    private int calculerAge(LocalDate dateNaissance) {
        if (dateNaissance == null) {
            return 0;
        }
        return Period.between(dateNaissance, LocalDate.now()).getYears();
    }
}