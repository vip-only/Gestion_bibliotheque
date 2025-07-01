package model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "adherentabonnement")
public class AdherentAbonnement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idAdherentAbonnement")
    private Integer idAdherentAbonnement;
    
    @ManyToOne
    @JoinColumn(name = "idAdherent")
    private Adherent adherent;
    
    @ManyToOne
    @JoinColumn(name = "idAbonnement")
    private Abonnement abonnement;
    
    @Column(name = "prixPaiement", nullable = false, precision = 10, scale = 2)
    private BigDecimal prixPaiement;
    
    @Column(name = "datePaiement", nullable = false)
    private LocalDate datePaiement;

    public AdherentAbonnement() {
    }

    public AdherentAbonnement(Adherent adherent, Abonnement abonnement, BigDecimal prixPaiement, LocalDate datePaiement) {
        this.adherent = adherent;
        this.abonnement = abonnement;
        this.prixPaiement = prixPaiement;
        this.datePaiement = datePaiement;
    }

    public Integer getIdAdherentAbonnement() {
        return idAdherentAbonnement;
    }

    public void setIdAdherentAbonnement(Integer idAdherentAbonnement) {
        this.idAdherentAbonnement = idAdherentAbonnement;
    }

    public Adherent getAdherent() {
        return adherent;
    }

    public void setAdherent(Adherent adherent) {
        this.adherent = adherent;
    }

    public Abonnement getAbonnement() {
        return abonnement;
    }

    public void setAbonnement(Abonnement abonnement) {
        this.abonnement = abonnement;
    }

    public BigDecimal getPrixPaiement() {
        return prixPaiement;
    }

    public void setPrixPaiement(BigDecimal prixPaiement) {
        this.prixPaiement = prixPaiement;
    }

    public LocalDate getDatePaiement() {
        return datePaiement;
    }

    public void setDatePaiement(LocalDate datePaiement) {
        this.datePaiement = datePaiement;
    }

    @Override
    public String toString() {
        return "AdherentAbonnement{" +
                "idAdherentAbonnement=" + idAdherentAbonnement +
                ", prixPaiement=" + prixPaiement +
                ", datePaiement=" + datePaiement +
                '}';
    }
}