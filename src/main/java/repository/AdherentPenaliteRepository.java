package repository;

import model.AdherentPenalite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface AdherentPenaliteRepository extends JpaRepository<AdherentPenalite, Integer> {
    
    @Query("SELECT CASE WHEN COUNT(ap) > 0 THEN true ELSE false END FROM AdherentPenalite ap WHERE ap.adherent.idAdherent = :idAdherent AND ap.dateFin >= CURRENT_DATE")
    boolean hasPenaliteActive(@Param("idAdherent") Integer idAdherent);

    @Query("SELECT CASE WHEN COUNT(ap) > 0 THEN true ELSE false END FROM AdherentPenalite ap WHERE ap.adherent.idAdherent = :idAdherent AND ap.dateFin >= :dateReference")
    boolean hasPenaliteActive(@Param("idAdherent") Integer idAdherent, @Param("dateReference") LocalDate dateReference);
    
    @Query("SELECT ap FROM AdherentPenalite ap WHERE ap.adherent.idAdherent = :idAdherent ORDER BY ap.dateFin DESC LIMIT 1")
    AdherentPenalite findDernierePenaliteByAdherent(@Param("idAdherent") Integer idAdherent);
    
    @Query("SELECT ap FROM AdherentPenalite ap WHERE ap.adherent.idAdherent = :idAdherent AND ap.dateFin >= CURRENT_DATE ORDER BY ap.dateFin DESC")
    List<AdherentPenalite> findPenalitesActivesByAdherent(@Param("idAdherent") Integer idAdherent);
    
    @Query(value = """
        SELECT 
            a.nom as nomAdherent,
            a.email as emailAdherent,
            p.libelle as typePenalite,
            ap.dateDebut,
            ap.dateFin,
            DATEDIFF(ap.dateFin, CURDATE()) as joursRestants
        FROM AdherentPenalite ap
        INNER JOIN Adherent a ON ap.idAdherent = a.idAdherent
        INNER JOIN Penalite p ON ap.idPenalite = p.idPenalite
        WHERE ap.dateFin >= CURDATE()
        ORDER BY ap.dateFin ASC
        """, nativeQuery = true)
    List<Object[]> findAllPenalitesActives();
}