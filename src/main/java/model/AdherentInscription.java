package model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "adherentinscription")
public class AdherentInscription {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idAdherentInscription")
    private Integer idAdherentInscription;
    
    @ManyToOne
    @JoinColumn(name = "idAdherent")
    private Adherent adherent;
    
    @ManyToOne
    @JoinColumn(name = "idInscription")
    private Inscription inscription;
    
    @Column(name = "montant", nullable = false, precision = 10, scale = 2)
    private BigDecimal montant;
    
    @Column(name = "dateInscription", nullable = false)
    private LocalDate dateInscription;

    public AdherentInscription() {
    }

    public AdherentInscription(Adherent adherent, Inscription inscription, BigDecimal montant, LocalDate dateInscription) {
        this.adherent = adherent;
        this.inscription = inscription;
        this.montant = montant;
        this.dateInscription = dateInscription;
    }

    // Getters and setters
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

    public Inscription getInscription() {
        return inscription;
    }

    public void setInscription(Inscription inscription) {
        this.inscription = inscription;
    }

    public BigDecimal getMontant() {
        return montant;
    }

    public void setMontant(BigDecimal montant) {
        this.montant = montant;
    }

    public LocalDate getDateInscription() {
        return dateInscription;
    }

    public void setDateInscription(LocalDate dateInscription) {
        this.dateInscription = dateInscription;
    }

    @Override
    public String toString() {
        return "AdherentInscription{" +
                "idAdherentInscription=" + idAdherentInscription +
                ", montant=" + montant +
                ", dateInscription=" + dateInscription +
                '}';
    }
}