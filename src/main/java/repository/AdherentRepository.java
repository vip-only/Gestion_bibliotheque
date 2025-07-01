package repository;

import model.Adherent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

@Repository
public interface AdherentRepository extends JpaRepository<Adherent, Integer> {
    
    @Query("SELECT a FROM Adherent a WHERE a.email = :email")
    Adherent findByEmail(@Param("email") String email);
    
    @Query(value = "SELECT idAdherent, nom, email FROM Adherent ORDER BY nom", nativeQuery = true)
    List<Map<String, Object>> findAllAdherentsForSelect();
}