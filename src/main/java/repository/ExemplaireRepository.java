package repository;

import model.Exemplaire;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

@Repository
public interface ExemplaireRepository extends JpaRepository<Exemplaire, Integer> {
    
    @Query(value = """
        SELECT 
            l.idLivre as idLivre,
            l.titre as titre,
            l.edition as edition,
            l.tag as tag,
            l.agesup as ageMinimum,
            a.nom AS auteur,
            me.nom AS maisonEdition,
            gl.libelle AS genre,
            COUNT(e.idExemplaire) AS nombreExemplaires,
            GROUP_CONCAT(e.numExemplaire SEPARATOR ', ') AS listeExemplaires
        FROM Livre l
        INNER JOIN Exemplaire e ON l.idLivre = e.idLivre
        LEFT JOIN Auteur a ON l.idAuteur = a.idAuteur
        LEFT JOIN MaisonEdition me ON l.idMaison = me.idMaison
        LEFT JOIN GenreLitteraire gl ON l.idGenre = gl.idGenre
        WHERE e.idExemplaire NOT IN (
            SELECT ae.idExemplaire 
            FROM AdherentExemplaire ae 
            WHERE ae.dateRetour IS NULL
            
            UNION
            
            SELECT r.idExemplaire 
            FROM Reservation r 
            INNER JOIN ReservationEtat re ON r.idReservation = re.idReservation
            INNER JOIN Etat et ON re.idEtat = et.idEtat
            WHERE et.libelle = 'en cours' AND r.dateFin >= CURDATE()
        )
        GROUP BY l.idLivre, l.titre, l.edition, l.tag, l.agesup, a.nom, me.nom, gl.libelle
        ORDER BY l.titre
        """, nativeQuery = true)
    List<Map<String, Object>> findExemplairesDisponiblesGroupByLivre();
    
    @Query("SELECT e FROM Exemplaire e WHERE e.numExemplaire = :numExemplaire")
    Exemplaire findByNumExemplaire(@Param("numExemplaire") String numExemplaire);

    @Query(value = """
        SELECT 
            e.idExemplaire,
            e.numExemplaire,
            CASE 
                WHEN ae.dateRetour IS NULL THEN 'Emprunté'
                WHEN r.idReservation IS NOT NULL AND r.dateFin >= CURDATE() THEN 'Réservé'
                ELSE 'Disponible'
            END as statut
        FROM Exemplaire e
        LEFT JOIN AdherentExemplaire ae ON e.idExemplaire = ae.idExemplaire AND ae.dateRetour IS NULL
        LEFT JOIN Reservation r ON e.idExemplaire = r.idExemplaire AND r.dateFin >= CURDATE()
        WHERE e.idLivre = :idLivre
        """, nativeQuery = true)
    List<Map<String, Object>> findExemplairesByLivre(@Param("idLivre") Integer idLivre);
}