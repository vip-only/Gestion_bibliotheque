package repository;

import model.ReservationEtat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ReservationEtatRepository extends JpaRepository<ReservationEtat, Integer> {
    
    @Query(value = """
        SELECT COUNT(*)
        FROM ReservationEtat re
        WHERE re.idReservation = :idReservation 
        AND re.idEtat = 1
        """, nativeQuery = true)
    Integer countByReservationAndEtatEnCours(@Param("idReservation") Integer idReservation);
}