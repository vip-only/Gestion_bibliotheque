package repository;

import model.Adherent;
import model.Bibliothecaire;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface BibliothecaireRepository extends JpaRepository<Bibliothecaire, Integer> {
    
    @Query("SELECT b FROM Bibliothecaire b WHERE b.nom = :nom AND b.motdepasse = :motdepasse")
    Bibliothecaire findByNomAndMotdepasse(@Param("nom") String nom, @Param("motdepasse") String motdepasse);
    
    @Query("SELECT b FROM Bibliothecaire b WHERE b.nom = :nom")
    Bibliothecaire findByNom(@Param("nom") String nom);
}