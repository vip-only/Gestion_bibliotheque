package repository;

import model.Penalite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface PenaliteRepository extends JpaRepository<Penalite, Integer> {
    
    @Query("SELECT p FROM Penalite p WHERE p.profil.idProfil = :idProfil")
    Penalite findByProfil(@Param("idProfil") Integer idProfil);
}