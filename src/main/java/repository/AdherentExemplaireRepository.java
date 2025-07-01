package repository;

import model.AdherentExemplaire;
import model.Exemplaire;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface AdherentExemplaireRepository extends JpaRepository<AdherentExemplaire, Integer> {
    
    boolean existsByExemplaireAndDateRetourIsNull(Exemplaire exemplaire);
    
    @Query("SELECT COUNT(ae) FROM AdherentExemplaire ae WHERE ae.adherent.idAdherent = :idAdherent AND ae.dateRetour IS NULL")
    Integer countEmpruntsActifs(@Param("idAdherent") Integer idAdherent);

}