package repository;

import model.EtatProlongementExemplaire;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface EtatProlongementExemplaireRepository extends JpaRepository<EtatProlongementExemplaire, Integer> {
    @Query(value = """
        SELECT COUNT(*)
        FROM EtatProlongementExemplaire epe
        WHERE epe.idProlongementExemplaire = :idProlongementExemplaire 
        AND epe.idEtat = 1
        """, nativeQuery = true)
    Integer countByProlongementAndEtatEnCours(@Param("idProlongementExemplaire") Integer idProlongementExemplaire);
}