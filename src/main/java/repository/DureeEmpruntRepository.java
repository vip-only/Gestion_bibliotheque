package repository;

import model.DureeEmprunt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface DureeEmpruntRepository extends JpaRepository<DureeEmprunt, Integer> {
    
    @Query("SELECT d.nbJour FROM DureeEmprunt d WHERE d.profil.idProfil = :idProfil AND d.typePret.idTypePret = :idTypePret")
    Integer findNbJoursByProfilAndTypePret(@Param("idProfil") Integer idProfil, @Param("idTypePret") Integer idTypePret);
}