package model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "inscription")
public class Inscription {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idInscription")
    private Integer idInscription;
    
    @Column(name = "duree", nullable = false)
    private Integer duree;
    
    @Column(name = "montant", nullable = false, precision = 10, scale = 2)
    private BigDecimal montant;
    
    @ManyToOne
    @JoinColumn(name = "idProfil")
    private Profil profil;

    public Inscription() {
    }

    public Inscription(Integer duree, BigDecimal montant, Profil profil) {
        this.duree = duree;
        this.montant = montant;
        this.profil = profil;
    }

    public Integer getIdInscription() {
        return idInscription;
    }

    public void setIdInscription(Integer idInscription) {
        this.idInscription = idInscription;
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
        return "Inscription{" +
                "idInscription=" + idInscription +
                ", duree=" + duree +
                ", montant=" + montant +
                ", profil=" + profil +
                '}';
    }
}