package repository;

import model.Exemplaire;
import model.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

import java.time.LocalDate;

@Repository
public interface ReservationRepository extends JpaRepository<Reservation, Integer> {
    
    @Query("SELECT CASE WHEN COUNT(r) > 0 THEN true ELSE false END FROM Reservation r WHERE r.exemplaire = :exemplaire AND r.dateFin >= :date")
    boolean existsByExemplaireAndDateFinAfter(@Param("exemplaire") Exemplaire exemplaire, @Param("date") LocalDate date);
    
    @Query("SELECT COUNT(r) FROM Reservation r WHERE r.adherent.idAdherent = :idAdherent AND r.dateFin >= CURRENT_DATE")
    Integer countReservationsActives(@Param("idAdherent") Integer idAdherent);

    @Query(value = """
        SELECT 
            r.idReservation,
            r.dateDebut,
            r.dateFin,
            a.nom as nomAdherent,
            a.email as emailAdherent,
            p.libelle as profilAdherent,
            e.numExemplaire,
            l.titre as titreLivre,
            l.edition,
            aut.nom as auteur,
            re_recent.dateEtat,
            et.libelle as etatLibelle,
            CASE 
                WHEN r.dateDebut < CURDATE() THEN 'En retard de recuperation'
                WHEN DATEDIFF(r.dateDebut, CURDATE()) <= 2 THEN 'A recuperer bientot'
                ELSE 'En attente'
            END as statut,
            DATEDIFF(CURDATE(), r.dateDebut) as joursRetard
        FROM Reservation r
        INNER JOIN (
            SELECT 
                re1.idReservation,
                re1.idEtat,
                re1.dateEtat,
                re1.idReservationEtat
            FROM ReservationEtat re1
            INNER JOIN (
                SELECT 
                    idReservation,
                    MAX(dateEtat) as maxDateEtat
                FROM ReservationEtat
                GROUP BY idReservation
            ) re_max ON re1.idReservation = re_max.idReservation 
                     AND re1.dateEtat = re_max.maxDateEtat
            WHERE re1.idEtat = 2
        ) re_recent ON r.idReservation = re_recent.idReservation
        INNER JOIN Etat et ON re_recent.idEtat = et.idEtat
        INNER JOIN Adherent a ON r.idAdherent = a.idAdherent
        INNER JOIN Profil p ON a.idProfil = p.idProfil
        INNER JOIN Exemplaire e ON r.idExemplaire = e.idExemplaire
        INNER JOIN Livre l ON e.idLivre = l.idLivre
        LEFT JOIN Auteur aut ON l.idAuteur = aut.idAuteur
        ORDER BY r.dateDebut ASC
        """, nativeQuery = true)
    List<Map<String, Object>> findReservationsAccepte();

    @Query(value = """
        SELECT 
            r.idReservation,
            r.dateDebut,
            r.dateFin,
            a.nom as nomAdherent,
            a.email as emailAdherent,
            p.libelle as profilAdherent,
            e.numExemplaire,
            l.titre as titreLivre,
            l.edition,
            aut.nom as auteur,
            re_recent.dateEtat,
            et.libelle as etatLibelle,
            CASE 
                WHEN r.dateDebut < CURDATE() THEN 'En retard de recuperation'
                WHEN DATEDIFF(r.dateDebut, CURDATE()) <= 2 THEN 'A recuperer bientot'
                ELSE 'En attente'
            END as statut,
            DATEDIFF(CURDATE(), r.dateDebut) as joursRetard
        FROM Reservation r
        INNER JOIN (
            SELECT 
                re1.idReservation,
                re1.idEtat,
                re1.dateEtat,
                re1.idReservationEtat
            FROM ReservationEtat re1
            INNER JOIN (
                SELECT 
                    idReservation,
                    MAX(dateEtat) as maxDateEtat
                FROM ReservationEtat
                GROUP BY idReservation
            ) re_max ON re1.idReservation = re_max.idReservation 
                     AND re1.dateEtat = re_max.maxDateEtat
            WHERE re1.idEtat = 1
        ) re_recent ON r.idReservation = re_recent.idReservation
        INNER JOIN Etat et ON re_recent.idEtat = et.idEtat
        INNER JOIN Adherent a ON r.idAdherent = a.idAdherent
        INNER JOIN Profil p ON a.idProfil = p.idProfil
        INNER JOIN Exemplaire e ON r.idExemplaire = e.idExemplaire
        INNER JOIN Livre l ON e.idLivre = l.idLivre
        LEFT JOIN Auteur aut ON l.idAuteur = aut.idAuteur
        ORDER BY r.dateDebut ASC
        """, nativeQuery = true)
    List<Map<String, Object>> findReservationsEnCours();

    @Query(value = """
        SELECT 
            r.idReservation,
            r.dateDebut,
            r.dateFin,
            a.nom as nomAdherent,
            a.email as emailAdherent,
            a.idAdherent
        FROM Reservation r
        INNER JOIN (
            SELECT 
                re1.idReservation,
                re1.idEtat,
                re1.dateEtat
            FROM ReservationEtat re1
            INNER JOIN (
                SELECT 
                    idReservation,
                    MAX(dateEtat) as maxDateEtat
                FROM ReservationEtat
                GROUP BY idReservation
            ) re_max ON re1.idReservation = re_max.idReservation 
                     AND re1.dateEtat = re_max.maxDateEtat
            WHERE re1.idEtat = 2
        ) re_recent ON r.idReservation = re_recent.idReservation
        INNER JOIN Adherent a ON r.idAdherent = a.idAdherent
        WHERE r.idExemplaire = :idExemplaire
        AND r.idAdherent != :idAdherentDemandeur
        AND CURDATE() < r.dateDebut
        ORDER BY r.dateDebut ASC
        LIMIT 1
        """, nativeQuery = true)
    Map<String, Object> findReservationAccepteeProche(@Param("idExemplaire") Integer idExemplaire,
                                                       @Param("idAdherentDemandeur") Integer idAdherentDemandeur);

// ...existing code...
    /**
     * Trouve une réservation acceptée qui entrerait en conflit avec une nouvelle date limite
     * (si la nouvelle date limite empiète sur la date de début de la réservation)
     */
    @Query(value = """
        SELECT 
            r.idReservation,
            r.dateDebut,
            r.dateFin,
            a.nom as nomAdherent,
            a.email as emailAdherent
        FROM Reservation r
        INNER JOIN (
            SELECT 
                re1.idReservation,
                re1.idEtat,
                re1.dateEtat
            FROM ReservationEtat re1
            INNER JOIN (
                SELECT 
                    idReservation,
                    MAX(dateEtat) as maxDateEtat
                FROM ReservationEtat
                GROUP BY idReservation
            ) re_max ON re1.idReservation = re_max.idReservation 
                     AND re1.dateEtat = re_max.maxDateEtat
            WHERE re1.idEtat = 2
        ) re_recent ON r.idReservation = re_recent.idReservation
        INNER JOIN Adherent a ON r.idAdherent = a.idAdherent
        WHERE r.idExemplaire = :idExemplaire
        AND :nouvelleDateLimite >= r.dateDebut
        ORDER BY r.dateDebut ASC
        LIMIT 1
        """, nativeQuery = true)
    Map<String, Object> findReservationAccepteeConflictuelle(@Param("idExemplaire") Integer idExemplaire,
                                                              @Param("nouvelleDateLimite") LocalDate nouvelleDateLimite);

}