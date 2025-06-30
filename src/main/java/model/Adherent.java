package model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "adherent")
public class Adherent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idAdherent")
    private Integer idAdherent;
    
    @Column(name = "nom", nullable = false, length = 100)
    private String nom;
    
    @Column(name = "email", length = 100)
    private String email;
    
    @Column(name = "dateNaissance")
    private LocalDate dateNaissance;
    
    @Column(name = "motdepasse", nullable = false, length = 100)
    private String motdepasse;
    
    @ManyToOne
    @JoinColumn(name = "idProfil")
    private Profil profil;

    public Adherent() {
    }

    public Adherent(String nom, String email, LocalDate dateNaissance, String motdepasse, Profil profil) {
        this.nom = nom;
        this.email = email;
        this.dateNaissance = dateNaissance;
        this.motdepasse = motdepasse;
        this.profil = profil;
    }

    public Integer getIdAdherent() {
        return idAdherent;
    }

    public void setIdAdherent(Integer idAdherent) {
        this.idAdherent = idAdherent;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public LocalDate getDateNaissance() {
        return dateNaissance;
    }

    public void setDateNaissance(LocalDate dateNaissance) {
        this.dateNaissance = dateNaissance;
    }

    public String getMotdepasse() {
        return motdepasse;
    }

    public void setMotdepasse(String motdepasse) {
        this.motdepasse = motdepasse;
    }

    public Profil getProfil() {
        return profil;
    }

    public void setProfil(Profil profil) {
        this.profil = profil;
    }

    @Override
    public String toString() {
        return "Adherent{" +
                "idAdherent=" + idAdherent +
                ", nom='" + nom + '\'' +
                ", email='" + email + '\'' +
                ", dateNaissance=" + dateNaissance +
                ", profil=" + profil +
                '}';
    }
}