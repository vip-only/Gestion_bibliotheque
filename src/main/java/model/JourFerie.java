package model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "jourferie")
public class JourFerie {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idJourFerie")
    private Integer idJourFerie;
    
    @Column(name = "dateJourFerie", nullable = false, unique = true)
    private LocalDate dateJourFerie;
    
    @Column(name = "libelle", nullable = false, length = 100)
    private String libelle;
    
    @Column(name = "annuel")
    private Boolean annuel = false;

    public JourFerie() {
    }

    public JourFerie(LocalDate dateJourFerie, String libelle, Boolean annuel) {
        this.dateJourFerie = dateJourFerie;
        this.libelle = libelle;
        this.annuel = annuel;
    }

    public Integer getIdJourFerie() {
        return idJourFerie;
    }

    public void setIdJourFerie(Integer idJourFerie) {
        this.idJourFerie = idJourFerie;
    }

    public LocalDate getDateJourFerie() {
        return dateJourFerie;
    }

    public void setDateJourFerie(LocalDate dateJourFerie) {
        this.dateJourFerie = dateJourFerie;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public Boolean getAnnuel() {
        return annuel;
    }

    public void setAnnuel(Boolean annuel) {
        this.annuel = annuel;
    }

    @Override
    public String toString() {
        return "JourFerie{" +
                "idJourFerie=" + idJourFerie +
                ", dateJourFerie=" + dateJourFerie +
                ", libelle='" + libelle + '\'' +
                ", annuel=" + annuel +
                '}';
    }
}