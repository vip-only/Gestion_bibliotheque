package repository;

import model.Quota;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface QuotaRepository extends JpaRepository<Quota, Integer> {
    
    @Query("SELECT q FROM Quota q WHERE q.profil.idProfil = :idProfil")
    Quota findQuotaByProfil(@Param("idProfil") Integer idProfil);
}