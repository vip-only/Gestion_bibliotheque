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

    public Quota() {
    }

    public Quota(Profil profil, Integer nbExemplaires) {
        this.profil = profil;
        this.nbExemplaires = nbExemplaires;
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

    @Override
    public String toString() {
        return "Quota{" +
                "idQuota=" + idQuota +
                ", profil=" + profil +
                ", nbExemplaires=" + nbExemplaires +
                '}';
    }
}