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

    @Query(value = """
        SELECT 
            a.idAdherent,
            a.nom,
            a.email,
            a.dateNaissance,
            p.libelle as profil,
            aa.dateInscription,
            aa.dateFin as dateFinAbonnement,
            q.nbExemplaires as quotaMax,
            COALESCE(ae.nbEmprunts, 0) as empruntsActuels,
            DATEDIFF(aa.dateFin, CURDATE()) as joursRestantsAbonnement
        FROM Adherent a
        INNER JOIN Profil p ON a.idProfil = p.idProfil
        INNER JOIN AdherentAbonnement aa ON a.idAdherent = aa.idAdherent
        LEFT JOIN Quota q ON p.idProfil = q.idProfil
        LEFT JOIN (
            SELECT 
                idAdherent,
                COUNT(*) as nbEmprunts
            FROM AdherentExemplaire
            WHERE dateRetour IS NULL
            GROUP BY idAdherent
        ) ae ON a.idAdherent = ae.idAdherent
        WHERE aa.dateFin >= CURDATE()
        AND a.idAdherent NOT IN (
            SELECT DISTINCT ap.idAdherent 
            FROM AdherentPenalite ap 
            WHERE ap.dateFin >= CURDATE()
        )
        ORDER BY a.nom
        """, nativeQuery = true)
    List<Map<String, Object>> findAdherentsActifs();
    
  
    @Query(value = """
        SELECT 
            a.idAdherent,
            a.nom,
            a.email,
            a.dateNaissance,
            p.libelle as profil,
            aa.dateInscription,
            aa.dateFin as dateFinAbonnement,
            DATEDIFF(CURDATE(), aa.dateFin) as joursExpires,
            COALESCE(ae.nbEmprunts, 0) as empruntsActuels
        FROM Adherent a
        INNER JOIN Profil p ON a.idProfil = p.idProfil
        INNER JOIN (
            SELECT 
                idAdherent,
                MAX(dateFin) as dateFin,
                MAX(dateInscription) as dateInscription
            FROM AdherentAbonnement
            GROUP BY idAdherent
        ) aa ON a.idAdherent = aa.idAdherent
        LEFT JOIN (
            SELECT 
                idAdherent,
                COUNT(*) as nbEmprunts
            FROM AdherentExemplaire
            WHERE dateRetour IS NULL
            GROUP BY idAdherent
        ) ae ON a.idAdherent = ae.idAdherent
        WHERE aa.dateFin < CURDATE()
        ORDER BY aa.dateFin DESC, a.nom
        """, nativeQuery = true)
    List<Map<String, Object>> findAdherentsInactifs();
    
  
    @Query(value = """
        SELECT 
            a.idAdherent,
            a.nom,
            a.email,
            a.dateNaissance,
            p.libelle as profil,
            aa.dateFin as dateFinAbonnement,
            ap.dateDebut as dateDebutPenalite,
            ap.dateFin as dateFinPenalite,
            pen.restriction as joursRestriction,
            DATEDIFF(ap.dateFin, CURDATE()) as joursRestantsPenalite,
            COALESCE(ae.nbEmprunts, 0) as empruntsActuels,
            CASE 
                WHEN aa.dateFin >= CURDATE() THEN 'Abonnement actif'
                ELSE 'Abonnement expiré'
            END as statutAbonnement
        FROM Adherent a
        INNER JOIN Profil p ON a.idProfil = p.idProfil
        INNER JOIN AdherentPenalite ap ON a.idAdherent = ap.idAdherent
        INNER JOIN Penalite pen ON ap.idPenalite = pen.idPenalite
        LEFT JOIN AdherentAbonnement aa ON a.idAdherent = aa.idAdherent
        LEFT JOIN (
            SELECT 
                idAdherent,
                COUNT(*) as nbEmprunts
            FROM AdherentExemplaire
            WHERE dateRetour IS NULL
            GROUP BY idAdherent
        ) ae ON a.idAdherent = ae.idAdherent
        WHERE ap.dateFin >= CURDATE()
        ORDER BY ap.dateFin ASC, a.nom
        """, nativeQuery = true)
    List<Map<String, Object>> findAdherentsPenalises();
    
    
    @Query(value = """
        SELECT COUNT(DISTINCT a.idAdherent)
        FROM Adherent a
        INNER JOIN AdherentAbonnement aa ON a.idAdherent = aa.idAdherent
        WHERE aa.dateFin >= CURDATE()
        AND a.idAdherent NOT IN (
            SELECT DISTINCT ap.idAdherent 
            FROM AdherentPenalite ap 
            WHERE ap.dateFin >= CURDATE()
        )
        """, nativeQuery = true)
    Integer countAdherentsActifs();
    
  
    @Query(value = """
        SELECT COUNT(DISTINCT a.idAdherent)
        FROM Adherent a
        INNER JOIN (
            SELECT 
                idAdherent,
                MAX(dateFin) as dateFin
            FROM AdherentAbonnement
            GROUP BY idAdherent
        ) aa ON a.idAdherent = aa.idAdherent
        WHERE aa.dateFin < CURDATE()
        """, nativeQuery = true)
    Integer countAdherentsInactifs();
    
    
    @Query(value = """
        SELECT COUNT(DISTINCT a.idAdherent)
        FROM Adherent a
        INNER JOIN AdherentPenalite ap ON a.idAdherent = ap.idAdherent
        WHERE ap.dateFin >= CURDATE()
        """, nativeQuery = true)
    Integer countAdherentsPenalises();
    
    
    @Query(value = "SELECT COUNT(*) FROM Adherent", nativeQuery = true)
    Integer countTotalAdherents();

    @Query(value = "SELECT COUNT(*) > 0 FROM Adherent WHERE email = :email", nativeQuery = true)
    boolean existsByEmail(@Param("email") String email);
    
    @Query(value = """
        SELECT 
            a.idAdherent,
            a.nom,
            a.email,
            a.dateNaissance,
            p.libelle as profil,
            aa.dateFin as dateFinAbonnement,
            CASE WHEN aa.dateFin >= CURDATE() THEN true ELSE false END as actif,
            q.nbExemplaires as quotaMax,
            COALESCE(ae.nbEmprunts, 0) as quotaActuel,
            (q.nbExemplaires - COALESCE(ae.nbEmprunts, 0)) as quotaRestant,
            CASE 
                WHEN EXISTS (
                    SELECT 1 FROM AdherentPenalite ap 
                    WHERE ap.idAdherent = a.idAdherent AND ap.dateFin >= CURDATE()
                ) THEN true ELSE false
            END as penaliseActif
        FROM Adherent a
        LEFT JOIN Profil p ON a.idProfil = p.idProfil
        LEFT JOIN (
            SELECT idAdherent, MAX(dateFin) as dateFin
            FROM AdherentAbonnement
            GROUP BY idAdherent
        ) aa ON a.idAdherent = aa.idAdherent
        LEFT JOIN Quota q ON p.idProfil = q.idProfil
        LEFT JOIN (
            SELECT idAdherent, COUNT(*) as nbEmprunts
            FROM AdherentExemplaire
            WHERE dateRetour IS NULL
            GROUP BY idAdherent
        ) ae ON a.idAdherent = ae.idAdherent
        WHERE a.idAdherent = :idAdherent
        """, nativeQuery = true)
    Map<String, Object> findAdherentById(@Param("idAdherent") Integer idAdherent);
}