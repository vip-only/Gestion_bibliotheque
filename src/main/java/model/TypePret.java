package model;

import jakarta.persistence.*;

@Entity
@Table(name = "typepret")
public class TypePret {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idTypePret")
    private Integer idTypePret;
    
    @Column(name = "libelle", nullable = false, length = 50)
    private String libelle;

    public TypePret() {
    }

    public TypePret(String libelle) {
        this.libelle = libelle;
    }

    public Integer getIdTypePret() {
        return idTypePret;
    }

    public void setIdTypePret(Integer idTypePret) {
        this.idTypePret = idTypePret;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    @Override
    public String toString() {
        return "TypePret{" +
                "idTypePret=" + idTypePret +
                ", libelle='" + libelle + '\'' +
                '}';
    }
}