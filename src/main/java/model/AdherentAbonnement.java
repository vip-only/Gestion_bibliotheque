package model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "adherentabonnement")
public class AdherentAbonnement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idAdherentInscription")
    private Integer idAdherentInscription;
    
    @ManyToOne
    @JoinColumn(name = "idAdherent")
    private Adherent adherent;
    
    @Column(name = "dateInscription", nullable = false)
    private LocalDate dateInscription;
    
    @Column(name = "dateFin", nullable = false)
    private LocalDate dateFin;

    public AdherentAbonnement() {
    }

    public AdherentAbonnement(Adherent adherent, LocalDate dateInscription, LocalDate dateFin) {
        this.adherent = adherent;
        this.dateInscription = dateInscription;
        this.dateFin = dateFin;
    }

    public Integer getIdAdherentInscription() {
        return idAdherentInscription;
    }

    public void setIdAdherentInscription(Integer idAdherentInscription) {
        this.idAdherentInscription = idAdherentInscription;
    }

    public Adherent getAdherent() {
        return adherent;
    }

    public void setAdherent(Adherent adherent) {
        this.adherent = adherent;
    }

    public LocalDate getDateInscription() {
        return dateInscription;
    }

    public void setDateInscription(LocalDate dateInscription) {
        this.dateInscription = dateInscription;
    }

    public LocalDate getDateFin() {
        return dateFin;
    }

    public void setDateFin(LocalDate dateFin) {
        this.dateFin = dateFin;
    }

    @Override
    public String toString() {
        return "AdherentAbonnement{" +
                "idAdherentInscription=" + idAdherentInscription +
                ", dateInscription=" + dateInscription +
                ", dateFin=" + dateFin +
                '}';
    }
}