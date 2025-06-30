package model;

import jakarta.persistence.*;

@Entity
@Table(name = "profil")
public class Profil {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idProfil")
    private Integer idProfil;
    
    @Column(name = "libelle", nullable = false, length = 50)
    private String libelle;

    public Profil() {
    }

    public Profil(String libelle) {
        this.libelle = libelle;
    }

    public Profil(Integer idProfil, String libelle) {
        this.idProfil = idProfil;
        this.libelle = libelle;
    }

    public Integer getIdProfil() {
        return idProfil;
    }

    public void setIdProfil(Integer idProfil) {
        this.idProfil = idProfil;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    @Override
    public String toString() {
        return "Profil{" +
                "idProfil=" + idProfil +
                ", libelle='" + libelle + '\'' +
                '}';
    }
}