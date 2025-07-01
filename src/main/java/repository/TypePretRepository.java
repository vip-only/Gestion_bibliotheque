package repository;

import model.TypePret;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

@Repository
public interface TypePretRepository extends JpaRepository<TypePret, Integer> {
    
    @Query(value = "SELECT idTypePret, libelle FROM TypePret ORDER BY libelle", nativeQuery = true)
    List<Map<String, Object>> findAllTypesPretForSelect();
}