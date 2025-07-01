package repository;

import model.Quota;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface QuotaRepository extends JpaRepository<Quota, Integer> {
    
    @Query("SELECT q.nbExemplaires FROM Quota q WHERE q.profil.idProfil = :idProfil")
    Integer findQuotaByProfil(@Param("idProfil") Integer idProfil);
}