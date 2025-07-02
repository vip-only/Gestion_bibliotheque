package model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "ReservationEtat")
public class ReservationEtat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idReservationEtat")
    private Integer idReservationEtat;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idReservation")
    private Reservation reservation;
    
    @ManyToOne
    @JoinColumn(name = "idEtat")
    private Etat etat;
    
    @Column(name = "dateEtat")
    private LocalDate dateEtat;

    public ReservationEtat() {
    }

    public ReservationEtat(Reservation reservation, Etat etat, LocalDate dateEtat) {
        this.reservation = reservation;
        this.etat = etat;
        this.dateEtat = dateEtat;
    }

    public Integer getIdReservationEtat() {
        return idReservationEtat;
    }

    public void setIdReservationEtat(Integer idReservationEtat) {
        this.idReservationEtat = idReservationEtat;
    }

    public Reservation getReservation() {
        return reservation;
    }

    public void setReservation(Reservation reservation) {
        this.reservation = reservation;
    }

    public Etat getEtat() {
        return etat;
    }

    public void setEtat(Etat etat) {
        this.etat = etat;
    }

    public LocalDate getDateEtat() {
        return dateEtat;
    }

    public void setDateEtat(LocalDate dateEtat) {
        this.dateEtat = dateEtat;
    }

    @Override
    public String toString() {
        return "ReservationEtat{" +
                "idReservationEtat=" + idReservationEtat +
                ", dateEtat=" + dateEtat +
                '}';
    }
}