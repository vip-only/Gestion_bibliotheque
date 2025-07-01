package model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "reservation")
public class Reservation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idReservation")
    private Integer idReservation;
    
    @ManyToOne
    @JoinColumn(name = "idAdherent")
    private Adherent adherent;
    
    @ManyToOne
    @JoinColumn(name = "idExemplaire")
    private Exemplaire exemplaire;
    
    @Column(name = "dateDebut")
    private LocalDate dateDebut;
    
    @Column(name = "dateFin")
    private LocalDate dateFin;

    public Reservation() {
    }

    public Reservation(Adherent adherent, Exemplaire exemplaire, LocalDate dateDebut, LocalDate dateFin) {
        this.adherent = adherent;
        this.exemplaire = exemplaire;
        this.dateDebut = dateDebut;
        this.dateFin = dateFin;
    }

    public Integer getIdReservation() {
        return idReservation;
    }

    public void setIdReservation(Integer idReservation) {
        this.idReservation = idReservation;
    }

    public Adherent getAdherent() {
        return adherent;
    }

    public void setAdherent(Adherent adherent) {
        this.adherent = adherent;
    }

    public Exemplaire getExemplaire() {
        return exemplaire;
    }

    public void setExemplaire(Exemplaire exemplaire) {
        this.exemplaire = exemplaire;
    }

    public LocalDate getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(LocalDate dateDebut) {
        this.dateDebut = dateDebut;
    }

    public LocalDate getDateFin() {
        return dateFin;
    }

    public void setDateFin(LocalDate dateFin) {
        this.dateFin = dateFin;
    }

    @Override
    public String toString() {
        return "Reservation{" +
                "idReservation=" + idReservation +
                ", dateDebut=" + dateDebut +
                ", dateFin=" + dateFin +
                '}';
    }
}