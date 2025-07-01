package repository;

import model.AdherentPenalite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface AdherentPenaliteRepository extends JpaRepository<AdherentPenalite, Integer> {
    
    @Query(value = """
        SELECT CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
        FROM AdherentPenalite ap 
        WHERE ap.idAdherent = :idAdherent 
        AND ap.dateFin >= CURDATE()
        """, nativeQuery = true)
    Integer hasPenaliteActiveAsInteger(@Param("idAdherent") Integer idAdherent);
    
    @Query(value = """
        SELECT ap.dateFin 
        FROM AdherentPenalite ap 
        WHERE ap.idAdherent = :idAdherent 
        AND ap.dateFin >= CURDATE()
        ORDER BY ap.dateFin DESC 
        LIMIT 1
        """, nativeQuery = true)
    String getDateFinPenalite(@Param("idAdherent") Integer idAdherent);
    
    // Méthode helper pour convertir Integer en Boolean
    default boolean hasPenaliteActive(Integer idAdherent) {
        Integer result = hasPenaliteActiveAsInteger(idAdherent);
        return result != null && result == 1;
    }
}