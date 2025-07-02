package repository;

import model.ReservationEtat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ReservationEtatRepository extends JpaRepository<ReservationEtat, Integer> {
}