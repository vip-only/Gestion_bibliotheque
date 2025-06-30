package model;

import jakarta.persistence.*;

@Entity
@Table(name = "auteur")
public class Auteur {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idAuteur")
    private Integer idAuteur;
    
    @Column(name = "nom", nullable = false, length = 100)
    private String nom;

    public Auteur() {
    }

    public Auteur(String nom) {
        this.nom = nom;
    }

    public Auteur(Integer idAuteur, String nom) {
        this.idAuteur = idAuteur;
        this.nom = nom;
    }

    public Integer getIdAuteur() {
        return idAuteur;
    }

    public void setIdAuteur(Integer idAuteur) {
        this.idAuteur = idAuteur;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    @Override
    public String toString() {
        return "Auteur{" +
                "idAuteur=" + idAuteur +
                ", nom='" + nom + '\'' +
                '}';
    }
}