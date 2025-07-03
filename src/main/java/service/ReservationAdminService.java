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
public class ReservationAdminService {
    
    @Autowired
    private ReservationRepository reservationRepository;
    
    @Autowired
    private ReservationEtatRepository reservationEtatRepository;
    
    @Autowired
    private AdherentRepository adherentRepository;
    
    @Autowired
    private EtatRepository etatRepository;
    
    public List<Map<String, Object>> getReservationsEnCours() {
        return reservationRepository.findReservationsEnCours();
    }
    
    public List<Map<String, Object>> getAllAdherents() {
        return adherentRepository.findAllAdherentsForSelect();
    }
    
    @Transactional
    public String confirmerReservation(Integer idReservation) throws Exception {
        // Recuperer la reservation
        Reservation reservation = reservationRepository.findById(idReservation)
                .orElseThrow(() -> new Exception("Reservation introuvable"));
        
        Integer countEnCours = reservationEtatRepository.countByReservationAndEtatEnCours(idReservation);
        if (countEnCours == null || countEnCours == 0) {
            throw new Exception("Cette reservation n'est pas en cours de traitement");
        }
        
        Etat etatAccepte = etatRepository.findById(2)
                .orElseThrow(() -> new Exception("etat 'accepte' introuvable"));
        
        ReservationEtat reservationEtatAccepte = new ReservationEtat();
        reservationEtatAccepte.setReservation(reservation);
        reservationEtatAccepte.setEtat(etatAccepte);
        reservationEtatAccepte.setDateEtat(LocalDate.now());
        
        reservationEtatRepository.save(reservationEtatAccepte);
        
        String titreLivre = reservation.getExemplaire().getLivre().getTitre();
        String numExemplaire = reservation.getExemplaire().getNumExemplaire();
        String nomAdherent = reservation.getAdherent().getNom();
        
        return String.format(
            "Reservation confirmee avec succes !\n\n" +
            "Adherent: %s\n" +
            "Livre: %s\n" +
            "Exemplaire: %s\n" +
            "Date de confirmation: %s\n\n" +
            "La reservation est maintenant acceptee. L'adherent peut venir recuperer le livre.",
            nomAdherent, titreLivre, numExemplaire, LocalDate.now()
        );
    }
    
    @Transactional
    public String annulerReservation(Integer idReservation) throws Exception {
        // Recuperer la reservation
        Reservation reservation = reservationRepository.findById(idReservation)
                .orElseThrow(() -> new Exception("Reservation introuvable"));
        
        Integer countEnCours = reservationEtatRepository.countByReservationAndEtatEnCours(idReservation);
        if (countEnCours == null || countEnCours == 0) {
            throw new Exception("Cette reservation n'est pas en cours de traitement");
        }
        
        // Creer le nouvel etat "refuse" (idEtat = 3)
        Etat etatRefuse = etatRepository.findById(3)
                .orElseThrow(() -> new Exception("etat 'refuse' introuvable"));
        
        ReservationEtat reservationEtatRefuse = new ReservationEtat();
        reservationEtatRefuse.setReservation(reservation);
        reservationEtatRefuse.setEtat(etatRefuse);
        reservationEtatRefuse.setDateEtat(LocalDate.now());
        
        reservationEtatRepository.save(reservationEtatRefuse);
        
        String titreLivre = reservation.getExemplaire().getLivre().getTitre();
        String numExemplaire = reservation.getExemplaire().getNumExemplaire();
        String nomAdherent = reservation.getAdherent().getNom();
        
        return String.format(
            "Reservation annulee avec succes !\n\n" +
            "Adherent: %s\n" +
            "Livre: %s\n" +
            "Exemplaire: %s\n" +
            "Date d'annulation: %s\n\n" +
            "L'exemplaire est maintenant disponible pour d'autres reservations.",
            nomAdherent, titreLivre, numExemplaire, LocalDate.now()
        );
    }
}