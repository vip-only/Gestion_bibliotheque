package repository;

import model.ProlongementExemplaire;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ProlongementExemplaireRepository extends JpaRepository<ProlongementExemplaire, Integer> {
    
    @Query(value = """
        SELECT COUNT(*)
        FROM ProlongementExemplaire pe 
        INNER JOIN EtatProlongementExemplaire epe ON pe.idProlongementExemplaire = epe.idProlongementExemplaire
        WHERE pe.idAdherentExemplaire = :idAdherentExemplaire 
        AND epe.idEtat = 1
        """, nativeQuery = true)
    Integer countByAdherentExemplaireAndEtatEnCours(@Param("idAdherentExemplaire") Integer idAdherentExemplaire);
}