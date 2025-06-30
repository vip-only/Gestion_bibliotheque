package model;

import jakarta.persistence.*;

@Entity
@Table(name = "maisonedition")
public class MaisonEdition {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idMaison")
    private Integer idMaison;
    
    @Column(name = "nom", nullable = false, length = 100)
    private String nom;

    public MaisonEdition() {
    }

    public MaisonEdition(String nom) {
        this.nom = nom;
    }

    public MaisonEdition(Integer idMaison, String nom) {
        this.idMaison = idMaison;
        this.nom = nom;
    }

    public Integer getIdMaison() {
        return idMaison;
    }

    public void setIdMaison(Integer idMaison) {
        this.idMaison = idMaison;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    @Override
    public String toString() {
        return "MaisonEdition{" +
                "idMaison=" + idMaison +
                ", nom='" + nom + '\'' +
                '}';
    }
}