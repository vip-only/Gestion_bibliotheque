package repository;

import model.ProlongementExemplaire;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

@Repository
public interface ProlongementExemplaireRepository extends JpaRepository<ProlongementExemplaire, Integer> {
    
    @Query(value = """
        SELECT 
            pe.idProlongementExemplaire,
            pe.prolongement,
            epe_recent.dateEtat,
            et.libelle as etatLibelle,
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
            CASE 
                WHEN DATEDIFF(ae.dateLimite, CURDATE()) < 0 THEN 'Emprunt en retard'
                WHEN DATEDIFF(ae.dateLimite, CURDATE()) <= 3 THEN 'Proche échéance'
                ELSE 'Normal'
            END as statut,
            DATEDIFF(CURDATE(), ae.dateLimite) as joursRetard
        FROM ProlongementExemplaire pe
        INNER JOIN (
            SELECT 
                epe1.idProlongementExemplaire,
                epe1.idEtat,
                epe1.dateEtat,
                epe1.idEtatProlongementExemplaire
            FROM EtatProlongementExemplaire epe1
            INNER JOIN (
                SELECT 
                    idProlongementExemplaire,
                    MAX(dateEtat) as maxDateEtat
                FROM EtatProlongementExemplaire
                GROUP BY idProlongementExemplaire
            ) epe_max ON epe1.idProlongementExemplaire = epe_max.idProlongementExemplaire 
                      AND epe1.dateEtat = epe_max.maxDateEtat
            WHERE epe1.idEtat = 1
        ) epe_recent ON pe.idProlongementExemplaire = epe_recent.idProlongementExemplaire
        INNER JOIN Etat et ON epe_recent.idEtat = et.idEtat
        INNER JOIN AdherentExemplaire ae ON pe.idAdherentExemplaire = ae.idAdherentExemplaire
        INNER JOIN Adherent a ON ae.idAdherent = a.idAdherent
        INNER JOIN Profil p ON a.idProfil = p.idProfil
        INNER JOIN Exemplaire e ON ae.idExemplaire = e.idExemplaire
        INNER JOIN Livre l ON e.idLivre = l.idLivre
        LEFT JOIN Auteur aut ON l.idAuteur = aut.idAuteur
        INNER JOIN TypePret tp ON ae.idTypePret = tp.idTypePret
        WHERE ae.dateRetour IS NULL
        ORDER BY epe_recent.dateEtat ASC
        """, nativeQuery = true)
    List<Map<String, Object>> findProlongementsEnCours();
}