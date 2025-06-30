package model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "adherentpenalite")
public class AdherentPenalite {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idAdherentPenalite")
    private Integer idAdherentPenalite;
    
    @ManyToOne
    @JoinColumn(name = "idAdherent")
    private Adherent adherent;
    
    @ManyToOne
    @JoinColumn(name = "idPenalite")
    private Penalite penalite;
    
    @Column(name = "dateDebut")
    private LocalDate dateDebut;
    
    @Column(name = "dateFin")
    private LocalDate dateFin;

    public AdherentPenalite() {
    }

    public AdherentPenalite(Adherent adherent, Penalite penalite, LocalDate dateDebut, LocalDate dateFin) {
        this.adherent = adherent;
        this.penalite = penalite;
        this.dateDebut = dateDebut;
        this.dateFin = dateFin;
    }

    public Integer getIdAdherentPenalite() {
        return idAdherentPenalite;
    }

    public void setIdAdherentPenalite(Integer idAdherentPenalite) {
        this.idAdherentPenalite = idAdherentPenalite;
    }

    public Adherent getAdherent() {
        return adherent;
    }

    public void setAdherent(Adherent adherent) {
        this.adherent = adherent;
    }

    public Penalite getPenalite() {
        return penalite;
    }

    public void setPenalite(Penalite penalite) {
        this.penalite = penalite;
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
        return "AdherentPenalite{" +
                "idAdherentPenalite=" + idAdherentPenalite +
                ", dateDebut=" + dateDebut +
                ", dateFin=" + dateFin +
                '}';
    }
}