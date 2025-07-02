package repository;

import model.Etat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface EtatRepository extends JpaRepository<Etat, Integer> {
    
    @Query("SELECT e FROM Etat e WHERE e.libelle = :libelle")
    Etat findByLibelle(@Param("libelle") String libelle);
}