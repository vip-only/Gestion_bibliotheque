package repository;

import model.Livre;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

@Repository
public interface LivreRepository extends JpaRepository<Livre, Integer> {
    
    @Query(value = """
        SELECT 
            l.idLivre,
            l.titre,
            aut.nom as auteur,
            gl.libelle as genre,
            l.tag,
            me.nom as maisonEdition,
            l.edition,
            l.agesup,
            COUNT(e.idExemplaire) as totalExemplaires,
            COUNT(CASE WHEN ae.dateRetour IS NULL THEN 1 END) as exemplairesEmpruntes,
            COUNT(CASE WHEN r.dateFin IS NULL OR r.dateFin >= CURDATE() THEN 1 END) as exemplairesReserves,
            (COUNT(e.idExemplaire) - 
             COUNT(CASE WHEN ae.dateRetour IS NULL THEN 1 END) - 
             COUNT(CASE WHEN r.dateFin IS NULL OR r.dateFin >= CURDATE() THEN 1 END)) as exemplairesDisponibles,
            CASE 
                WHEN (COUNT(e.idExemplaire) - 
                      COUNT(CASE WHEN ae.dateRetour IS NULL THEN 1 END) - 
                      COUNT(CASE WHEN r.dateFin IS NULL OR r.dateFin >= CURDATE() THEN 1 END)) > 0 
                THEN 'Disponible' 
                ELSE 'Non disponible' 
            END as statut
        FROM Livre l
        LEFT JOIN Exemplaire e ON l.idLivre = e.idLivre
        LEFT JOIN AdherentExemplaire ae ON e.idExemplaire = ae.idExemplaire AND ae.dateRetour IS NULL
        LEFT JOIN Reservation r ON e.idExemplaire = r.idExemplaire AND (r.dateFin IS NULL OR r.dateFin >= CURDATE())
        LEFT JOIN Auteur aut ON l.idAuteur = aut.idAuteur
        LEFT JOIN GenreLitteraire gl ON l.idGenre = gl.idGenre
        LEFT JOIN MaisonEdition me ON l.idMaison = me.idMaison
        GROUP BY l.idLivre, l.titre, aut.nom, gl.libelle, l.tag, me.nom, l.edition, l.agesup
        ORDER BY l.titre ASC
        """, nativeQuery = true)
    List<Map<String, Object>> findCatalogueWithDisponibilite();

    @Query(value = """
        SELECT 
            l.idLivre,
            l.titre,
            aut.nom as auteur,
            gl.libelle as genre,
            l.tag,
            me.nom as maisonEdition,
            l.edition,
            l.agesup,
            COUNT(e.idExemplaire) as totalExemplaires,
            COUNT(CASE WHEN ae.dateRetour IS NULL THEN 1 END) as exemplairesEmpruntes,
            COUNT(CASE WHEN r.dateFin IS NULL OR r.dateFin >= CURDATE() THEN 1 END) as exemplairesReserves,
            (COUNT(e.idExemplaire) - 
             COUNT(CASE WHEN ae.dateRetour IS NULL THEN 1 END) - 
             COUNT(CASE WHEN r.dateFin IS NULL OR r.dateFin >= CURDATE() THEN 1 END)) as exemplairesDisponibles,
            CASE 
                WHEN (COUNT(e.idExemplaire) - 
                      COUNT(CASE WHEN ae.dateRetour IS NULL THEN 1 END) - 
                      COUNT(CASE WHEN r.dateFin IS NULL OR r.dateFin >= CURDATE() THEN 1 END)) > 0 
                THEN 'Disponible' 
                ELSE 'Non disponible' 
            END as statut
        FROM Livre l
        LEFT JOIN Exemplaire e ON l.idLivre = e.idLivre
        LEFT JOIN AdherentExemplaire ae ON e.idExemplaire = ae.idExemplaire AND ae.dateRetour IS NULL
        LEFT JOIN Reservation r ON e.idExemplaire = r.idExemplaire AND (r.dateFin IS NULL OR r.dateFin >= CURDATE())
        LEFT JOIN Auteur aut ON l.idAuteur = aut.idAuteur
        LEFT JOIN GenreLitteraire gl ON l.idGenre = gl.idGenre
        LEFT JOIN MaisonEdition me ON l.idMaison = me.idMaison
        WHERE (:titre IS NULL OR l.titre LIKE CONCAT('%', :titre, '%'))
        AND (:auteur IS NULL OR aut.nom LIKE CONCAT('%', :auteur, '%'))
        AND (:genre IS NULL OR gl.libelle LIKE CONCAT('%', :genre, '%'))
        AND (:tag IS NULL OR l.tag LIKE CONCAT('%', :tag, '%'))
        AND (:maisonEdition IS NULL OR me.nom LIKE CONCAT('%', :maisonEdition, '%'))
        AND (:disponibilite IS NULL OR 
             (:disponibilite = 'Disponible' AND (COUNT(e.idExemplaire) - COUNT(CASE WHEN ae.dateRetour IS NULL THEN 1 END) - COUNT(CASE WHEN r.dateFin IS NULL OR r.dateFin >= CURDATE() THEN 1 END)) > 0) OR
             (:disponibilite = 'Non disponible' AND (COUNT(e.idExemplaire) - COUNT(CASE WHEN ae.dateRetour IS NULL THEN 1 END) - COUNT(CASE WHEN r.dateFin IS NULL OR r.dateFin >= CURDATE() THEN 1 END)) = 0))
        GROUP BY l.idLivre, l.titre, aut.nom, gl.libelle, l.tag, me.nom, l.edition, l.agesup
        ORDER BY l.titre ASC
        """, nativeQuery = true)
    List<Map<String, Object>> searchCatalogue(@Param("titre") String titre,
                                             @Param("auteur") String auteur,
                                             @Param("genre") String genre,
                                             @Param("tag") String tag,
                                             @Param("maisonEdition") String maisonEdition,
                                             @Param("disponibilite") String disponibilite);

    @Query("SELECT DISTINCT gl.libelle FROM GenreLitteraire gl ORDER BY gl.libelle")
    List<String> findAllGenres();

    @Query("SELECT DISTINCT l.tag FROM Livre l WHERE l.tag IS NOT NULL ORDER BY l.tag")
    List<String> findAllTags();

    @Query("SELECT DISTINCT me.nom FROM MaisonEdition me ORDER BY me.nom")
    List<String> findAllMaisonsEdition();

    @Query("SELECT DISTINCT aut.nom FROM Auteur aut ORDER BY aut.nom")
    List<String> findAllAuteurs();
}