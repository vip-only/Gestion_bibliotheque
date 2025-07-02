package repository;

import model.EtatProlongementExemplaire;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EtatProlongementExemplaireRepository extends JpaRepository<EtatProlongementExemplaire, Integer> {
    
}