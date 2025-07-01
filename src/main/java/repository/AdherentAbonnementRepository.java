package repository;

import model.AdherentAbonnement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

@Repository
public interface AdherentAbonnementRepository extends JpaRepository<AdherentAbonnement, Integer> {
    
    @Query(value = """
        SELECT 
            a.idAdherent, 
            a.nom, 
            a.email, 
            p.libelle as profil,
            q.nbExemplaires as quotaMax,
            COALESCE(emprunts.nbEmprunts, 0) as empruntsActuels,
            CASE 
                WHEN pen.idAdherent IS NOT NULL THEN CONCAT('Pénalisé jusqu''au ', pen.dateFin)
                ELSE 'Actif'
            END as statut
        FROM Adherent a
        INNER JOIN Profil p ON a.idProfil = p.idProfil
        INNER JOIN AdherentAbonnement aa ON a.idAdherent = aa.idAdherent
        LEFT JOIN Quota q ON p.idProfil = q.idProfil
        LEFT JOIN (
            SELECT 
                ae.idAdherent, 
                COUNT(*) as nbEmprunts 
            FROM AdherentExemplaire ae 
            WHERE ae.dateRetour IS NULL 
            GROUP BY ae.idAdherent
        ) emprunts ON a.idAdherent = emprunts.idAdherent
        LEFT JOIN (
            SELECT 
                ap.idAdherent,
                ap.dateFin
            FROM AdherentPenalite ap 
            WHERE ap.dateFin >= CURDATE()
        ) pen ON a.idAdherent = pen.idAdherent
        WHERE aa.dateFin >= CURDATE()
        ORDER BY a.nom
        """, nativeQuery = true)
    List<Map<String, Object>> findAdherentsActifs();
    
    @Query("SELECT aa FROM AdherentAbonnement aa WHERE aa.adherent.idAdherent = :idAdherent ORDER BY aa.dateInscription DESC")
    List<AdherentAbonnement> findByAdherentIdOrderByDateInscriptionDesc(@Param("idAdherent") Integer idAdherent);
    
    @Query(value = """
        SELECT 
            CASE 
                WHEN aa.dateFin >= CURDATE() THEN 1 
                ELSE 0 
            END as abonnementActif
        FROM AdherentAbonnement aa
        WHERE aa.idAdherent = :idAdherent
        ORDER BY aa.dateInscription DESC
        LIMIT 1
        """, nativeQuery = true)
    Integer isAbonnementActif(@Param("idAdherent") Integer idAdherent);
}