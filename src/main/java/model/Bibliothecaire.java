package model;

import jakarta.persistence.*;

@Entity
@Table(name = "bibliothecaire")
public class Bibliothecaire {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idBibliothecaire")
    private int idBibliothecaire;
    
    @Column(name = "nom", nullable = false, length = 100)
    private String nom;
    
    @Column(name = "motdepasse", nullable = false, length = 100)
    private String motdepasse;
    
    @Column(name = "adresse", nullable = false, length = 255)
    private String adresse;
    
    @Column(name = "telephone", length = 20)
    private String telephone;
    
    @Column(name = "email", length = 100)
    private String email;

    public Bibliothecaire() {}

    public Bibliothecaire(String nom, String motdepasse, String adresse, String telephone, String email) {
        this.nom = nom;
        this.motdepasse = motdepasse;
        this.adresse = adresse;
        this.telephone = telephone;
        this.email = email;
    }

    public Bibliothecaire(int idBibliothecaire, String nom, String motdepasse, String adresse, String telephone, String email) {
        this.idBibliothecaire = idBibliothecaire;
        this.nom = nom;
        this.motdepasse = motdepasse;
        this.adresse = adresse;
        this.telephone = telephone;
        this.email = email;
    }

    // Getters
    public int getIdBibliothecaire() {
        return idBibliothecaire;
    }

    public String getNom() {
        return nom;
    }

    public String getMotdepasse() {
        return motdepasse;
    }

    public String getAdresse() {
        return adresse;
    }

    public String getTelephone() {
        return telephone;
    }

    public String getEmail() {
        return email;
    }

    // Setters
    public void setIdBibliothecaire(int idBibliothecaire) {
        this.idBibliothecaire = idBibliothecaire;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public void setMotdepasse(String motdepasse) {
        this.motdepasse = motdepasse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public String toString() {
        return "Bibliothecaire{" +
                "idBibliothecaire=" + idBibliothecaire +
                ", nom='" + nom + '\'' +
                ", adresse='" + adresse + '\'' +
                ", telephone='" + telephone + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}