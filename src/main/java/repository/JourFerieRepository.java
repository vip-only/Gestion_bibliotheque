package repository;

import model.JourFerie;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;

@Repository
public interface JourFerieRepository extends JpaRepository<JourFerie, Integer> {
    
    @Query(value = """
        SELECT CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
        FROM JourFerie jf 
        WHERE jf.dateJourFerie = :date 
        OR (jf.annuel = TRUE AND MONTH(jf.dateJourFerie) = MONTH(:date) AND DAY(jf.dateJourFerie) = DAY(:date))
        """, nativeQuery = true)
    Integer isJourFerieAsInteger(@Param("date") LocalDate date);
    
    default boolean isJourFerie(LocalDate date) {
        Integer result = isJourFerieAsInteger(date);
        return result != null && result == 1;
    }
}