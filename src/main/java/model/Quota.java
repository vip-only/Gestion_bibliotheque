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
    
    @Column(name = "nombreLivre", nullable = false)
    private Integer nombreLivre;

    public Quota() {
    }

    public Quota(Profil profil, Integer nombreLivre) {
        this.profil = profil;
        this.nombreLivre = nombreLivre;
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

    public Integer getNombreLivre() {
        return nombreLivre;
    }

    public void setNombreLivre(Integer nombreLivre) {
        this.nombreLivre = nombreLivre;
    }

    @Override
    public String toString() {
        return "Quota{" +
                "idQuota=" + idQuota +
                ", profil=" + profil +
                ", nombreLivre=" + nombreLivre +
                '}';
    }
}