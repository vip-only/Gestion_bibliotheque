package model;

import jakarta.persistence.*;

@Entity
@Table(name = "penalite")
public class Penalite {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idPenalite")
    private Integer idPenalite;
    
    @ManyToOne
    @JoinColumn(name = "idProfil")
    private Profil profil;
    
    @Column(name = "restriction", nullable = false)
    private Integer restriction; // nombre de jours de restriction

    public Penalite() {
    }

    public Penalite(Profil profil, Integer restriction) {
        this.profil = profil;
        this.restriction = restriction;
    }

    public Integer getIdPenalite() {
        return idPenalite;
    }

    public void setIdPenalite(Integer idPenalite) {
        this.idPenalite = idPenalite;
    }

    public Profil getProfil() {
        return profil;
    }

    public void setProfil(Profil profil) {
        this.profil = profil;
    }

    public Integer getRestriction() {
        return restriction;
    }

    public void setRestriction(Integer restriction) {
        this.restriction = restriction;
    }

    @Override
    public String toString() {
        return "Penalite{" +
                "idPenalite=" + idPenalite +
                ", profil=" + profil +
                ", restriction=" + restriction +
                '}';
    }
}