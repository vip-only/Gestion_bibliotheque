package model;

import jakarta.persistence.*;

@Entity
@Table(name = "dureeemprunt")
public class DureeEmprunt {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idDureeEmprunt")
    private Integer idDureeEmprunt;
    
    @ManyToOne
    @JoinColumn(name = "idProfil")
    private Profil profil;
    
    @ManyToOne
    @JoinColumn(name = "idTypePret")
    private TypePret typePret;
    
    @Column(name = "nbJour", nullable = false)
    private Integer nbJour;

    public DureeEmprunt() {
    }

    public DureeEmprunt(Profil profil, TypePret typePret, Integer nbJour) {
        this.profil = profil;
        this.typePret = typePret;
        this.nbJour = nbJour;
    }

    public Integer getIdDureeEmprunt() {
        return idDureeEmprunt;
    }

    public void setIdDureeEmprunt(Integer idDureeEmprunt) {
        this.idDureeEmprunt = idDureeEmprunt;
    }

    public Profil getProfil() {
        return profil;
    }

    public void setProfil(Profil profil) {
        this.profil = profil;
    }

    public TypePret getTypePret() {
        return typePret;
    }

    public void setTypePret(TypePret typePret) {
        this.typePret = typePret;
    }

    public Integer getNbJour() {
        return nbJour;
    }

    public void setNbJour(Integer nbJour) {
        this.nbJour = nbJour;
    }

    @Override
    public String toString() {
        return "DureeEmprunt{" +
                "idDureeEmprunt=" + idDureeEmprunt +
                ", profil=" + profil +
                ", typePret=" + typePret +
                ", nbJour=" + nbJour +
                '}';
    }
}