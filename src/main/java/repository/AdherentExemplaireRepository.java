package repository;

import model.AdherentExemplaire;
import model.Exemplaire;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

@Repository
public interface AdherentExemplaireRepository extends JpaRepository<AdherentExemplaire, Integer> {
    
    @Query("SELECT COUNT(ae) FROM AdherentExemplaire ae WHERE ae.adherent.idAdherent = :idAdherent AND ae.dateRetour IS NULL")
    Integer countEmpruntsActifs(@Param("idAdherent") Integer idAdherent);
    
    @Query("SELECT COUNT(ae) FROM AdherentExemplaire ae WHERE ae.adherent.idAdherent = :idAdherent AND ae.dateRetour IS NULL AND ae.typePret.idTypePret = 1")
    Integer countEmpruntsActifsADomicile(@Param("idAdherent") Integer idAdherent);
    
    @Query("SELECT CASE WHEN COUNT(ae) > 0 THEN true ELSE false END FROM AdherentExemplaire ae WHERE ae.exemplaire = :exemplaire AND ae.dateRetour IS NULL")
    boolean existsByExemplaireAndDateRetourIsNull(@Param("exemplaire") Exemplaire exemplaire);
    
    @Query(value = """
        SELECT 
            ae.idAdherentExemplaire,
            a.nom as nomAdherent,
            a.email as emailAdherent,
            p.libelle as profilAdherent,
            e.numExemplaire,
            l.titre as titreLivre,
            l.edition,
            aut.nom as auteur,
            tp.libelle as typePret,
            ae.dateEmprunt,
            ae.dateLimite,
            DATEDIFF(CURDATE(), ae.dateLimite) as joursRetard,
            CASE
                WHEN DATEDIFF(CURDATE(), ae.dateLimite) > 0 THEN 'En retard'
                WHEN DATEDIFF(CURDATE(), ae.dateLimite) >= -2 THEN 'Bientôt échéance'
                ELSE 'Normal'
            END as statut
        FROM AdherentExemplaire ae
        INNER JOIN Adherent a ON ae.idAdherent = a.idAdherent
        INNER JOIN Profil p ON a.idProfil = p.idProfil
        INNER JOIN Exemplaire e ON ae.idExemplaire = e.idExemplaire
        INNER JOIN Livre l ON e.idLivre = l.idLivre
        LEFT JOIN Auteur aut ON l.idAuteur = aut.idAuteur
        INNER JOIN TypePret tp ON ae.idTypePret = tp.idTypePret
        WHERE ae.dateRetour IS NULL
        ORDER BY ae.dateLimite ASC, a.nom ASC
        """, nativeQuery = true)
    List<Map<String, Object>> findEmpruntsEnCours();
    
    @Query(value = """
        SELECT 
            ae.idAdherentExemplaire,
            a.nom as nomAdherent,
            a.email as emailAdherent,
            p.libelle as profilAdherent,
            e.numExemplaire,
            l.titre as titreLivre,
            l.edition,
            aut.nom as auteur,
            tp.libelle as typePret,
            ae.dateEmprunt,
            ae.dateLimite,
            DATEDIFF(CURDATE(), ae.dateLimite) as joursRetard,
            CASE
                WHEN DATEDIFF(CURDATE(), ae.dateLimite) > 0 THEN 'En retard'
                WHEN DATEDIFF(CURDATE(), ae.dateLimite) >= -2 THEN 'Bientôt échéance'
                ELSE 'Normal'
            END as statut
        FROM AdherentExemplaire ae
        INNER JOIN Adherent a ON ae.idAdherent = a.idAdherent
        INNER JOIN Profil p ON a.idProfil = p.idProfil
        INNER JOIN Exemplaire e ON ae.idExemplaire = e.idExemplaire
        INNER JOIN Livre l ON e.idLivre = l.idLivre
        LEFT JOIN Auteur aut ON l.idAuteur = aut.idAuteur
        INNER JOIN TypePret tp ON ae.idTypePret = tp.idTypePret
        WHERE ae.dateRetour IS NULL AND ae.idAdherent = :idAdherent
        ORDER BY ae.dateLimite ASC
        """, nativeQuery = true)
    List<Map<String, Object>> findEmpruntsEnCoursByAdherent(@Param("idAdherent") Integer idAdherent);
    
    @Query(value = """
        SELECT 
            ae.idAdherentExemplaire,
            a.nom as nomAdherent,
            a.email as emailAdherent,
            p.libelle as profilAdherent,
            e.numExemplaire,
            l.titre as titreLivre,
            l.edition,
            aut.nom as auteur,
            tp.libelle as typePret,
            ae.dateEmprunt,
            ae.dateLimite,
            DATEDIFF(CURDATE(), ae.dateLimite) as joursRetard,
            CASE
                WHEN DATEDIFF(CURDATE(), ae.dateLimite) > 0 THEN 'En retard'
                WHEN DATEDIFF(CURDATE(), ae.dateLimite) >= -2 THEN 'Bientôt échéance'
                ELSE 'Normal'
            END as statut
        FROM AdherentExemplaire ae
        INNER JOIN Adherent a ON ae.idAdherent = a.idAdherent
        INNER JOIN Profil p ON a.idProfil = p.idProfil
        INNER JOIN Exemplaire e ON ae.idExemplaire = e.idExemplaire
        INNER JOIN Livre l ON e.idLivre = l.idLivre
        LEFT JOIN Auteur aut ON l.idAuteur = aut.idAuteur
        INNER JOIN TypePret tp ON ae.idTypePret = tp.idTypePret
        WHERE ae.dateRetour IS NULL AND e.numExemplaire = :numExemplaire
        ORDER BY ae.dateLimite ASC
        """, nativeQuery = true)
    List<Map<String, Object>> findEmpruntByNumExemplaire(@Param("numExemplaire") String numExemplaire);
    
    @Query(value = """
        SELECT 
            ae.idAdherentExemplaire,
            a.nom as nomAdherent,
            a.email as emailAdherent,
            p.libelle as profilAdherent,
            e.numExemplaire,
            l.titre as titreLivre,
            l.edition,
            aut.nom as auteur,
            tp.libelle as typePret,
            ae.dateEmprunt,
            ae.dateLimite,
            ae.dateRetour,
            CASE 
                WHEN ae.dateRetour IS NULL THEN DATEDIFF(CURDATE(), ae.dateLimite)
                ELSE DATEDIFF(ae.dateRetour, ae.dateLimite)
            END as joursRetard
        FROM AdherentExemplaire ae
        INNER JOIN Adherent a ON ae.idAdherent = a.idAdherent
        INNER JOIN Profil p ON a.idProfil = p.idProfil
        INNER JOIN Exemplaire e ON ae.idExemplaire = e.idExemplaire
        INNER JOIN Livre l ON e.idLivre = l.idLivre
        LEFT JOIN Auteur aut ON l.idAuteur = aut.idAuteur
        INNER JOIN TypePret tp ON ae.idTypePret = tp.idTypePret
        WHERE ae.idAdherentExemplaire = :idAdherentExemplaire
        """, nativeQuery = true)
    Map<String, Object> findEmpruntDetails(@Param("idAdherentExemplaire") Integer idAdherentExemplaire);
}