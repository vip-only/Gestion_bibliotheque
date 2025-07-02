package repository;

import model.Exemplaire;
import model.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;

@Repository
public interface ReservationRepository extends JpaRepository<Reservation, Integer> {
    
    @Query("SELECT CASE WHEN COUNT(r) > 0 THEN true ELSE false END FROM Reservation r WHERE r.exemplaire = :exemplaire AND r.dateFin >= :date")
    boolean existsByExemplaireAndDateFinAfter(@Param("exemplaire") Exemplaire exemplaire, @Param("date") LocalDate date);
    
    @Query("SELECT COUNT(r) FROM Reservation r WHERE r.adherent.idAdherent = :idAdherent AND r.dateFin >= CURRENT_DATE")
    Integer countReservationsActives(@Param("idAdherent") Integer idAdherent);
}