package model;

import jakarta.persistence.*;

@Entity
@Table(name = "quota")
public class Quota {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idQuota")
    private Integer idQuota;

    @ManyToOne
    @JoinColumn(name = "idProfil")
    private Profil profil;

    @Column(name = "nbExemplaires", nullable = false)
    private Integer nbExemplaires; // nombre d'exemplaires autorisés

    @Column(name = "nbResa", nullable = false)
    private Integer nbResa;

    @Column(name = "nbProlong", nullable = false)
    private Integer nbProlong;

    public Quota() {
    }

    public Quota(Profil profil, Integer nbExemplaires, Integer nbResa, Integer nbProlong) {
        this.profil = profil;
        this.nbExemplaires = nbExemplaires;
        this.nbResa = nbResa;
        this.nbProlong = nbProlong;
    }

    public Integer getIdQuota() {
        return idQuota;
    }

    public void setIdQuota(Integer idQuota) {
        this.idQuota = idQuota;
    }

    public Profil getProfil() {
        return profil;
    }

    public void setProfil(Profil profil) {
        this.profil = profil;
    }

    public Integer getNbExemplaires() {
        return nbExemplaires;
    }

    public void setNbExemplaires(Integer nbExemplaires) {
        this.nbExemplaires = nbExemplaires;
    }

    public Integer getNbResa() {
        return nbResa;
    }

    public void setNbResa(Integer nbResa) {
        this.nbResa = nbResa;
    }

    public Integer getNbProlong() {
        return nbProlong;
    }

    public void setNbProlong(Integer nbProlong) {
        this.nbProlong = nbProlong;
    }

    @Override
    public String toString() {
        return "Quota{" +
                "idQuota=" + idQuota +
                ", profil=" + profil +
                ", nbExemplaires=" + nbExemplaires +
                ", nbResa=" + nbResa +
                ", nbProlong=" + nbProlong +
                '}';
    }
}