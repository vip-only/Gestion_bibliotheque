package model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "abonnement")
public class Abonnement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idAbonnement")
    private Integer idAbonnement;
    
    @Column(name = "duree", nullable = false)
    private Integer duree; // durée en jours
    
    @Column(name = "montant", nullable = false, precision = 10, scale = 2)
    private BigDecimal montant;
    
    @ManyToOne
    @JoinColumn(name = "idProfil")
    private Profil profil;

    public Abonnement() {
    }

    public Abonnement(Integer duree, BigDecimal montant, Profil profil) {
        this.duree = duree;
        this.montant = montant;
        this.profil = profil;
    }

    public Integer getIdAbonnement() {
        return idAbonnement;
    }

    public void setIdAbonnement(Integer idAbonnement) {
        this.idAbonnement = idAbonnement;
    }

    public Integer getDuree() {
        return duree;
    }

    public void setDuree(Integer duree) {
        this.duree = duree;
    }

    public BigDecimal getMontant() {
        return montant;
    }

    public void setMontant(BigDecimal montant) {
        this.montant = montant;
    }

    public Profil getProfil() {
        return profil;
    }

    public void setProfil(Profil profil) {
        this.profil = profil;
    }

    @Override
    public String toString() {
        return "Abonnement{" +
                "idAbonnement=" + idAbonnement +
                ", duree=" + duree +
                ", montant=" + montant +
                ", profil=" + profil +
                '}';
    }
}