package model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "adherentexemplaire")
public class AdherentExemplaire {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idAdherentExemplaire")
    private Integer idAdherentExemplaire;
    
    @ManyToOne
    @JoinColumn(name = "idAdherent")
    private Adherent adherent;
    
    @ManyToOne
    @JoinColumn(name = "idExemplaire")
    private Exemplaire exemplaire;
    
    @ManyToOne
    @JoinColumn(name = "idTypePret")
    private TypePret typePret;
    
    @Column(name = "dateEmprunt", nullable = false)
    private LocalDate dateEmprunt;
    
    @Column(name = "dateRetour")
    private LocalDate dateRetour;
    
    @Column(name = "dateLimite")
    private LocalDate dateLimite;

    public AdherentExemplaire() {
    }

    public AdherentExemplaire(Adherent adherent, Exemplaire exemplaire, TypePret typePret, 
                             LocalDate dateEmprunt, LocalDate dateRetour, LocalDate dateLimite) {
        this.adherent = adherent;
        this.exemplaire = exemplaire;
        this.typePret = typePret;
        this.dateEmprunt = dateEmprunt;
        this.dateRetour = dateRetour;
        this.dateLimite = dateLimite;
    }

    public Integer getIdAdherentExemplaire() {
        return idAdherentExemplaire;
    }

    public void setIdAdherentExemplaire(Integer idAdherentExemplaire) {
        this.idAdherentExemplaire = idAdherentExemplaire;
    }

    public Adherent getAdherent() {
        return adherent;
    }

    public void setAdherent(Adherent adherent) {
        this.adherent = adherent;
    }

    public Exemplaire getExemplaire() {
        return exemplaire;
    }

    public void setExemplaire(Exemplaire exemplaire) {
        this.exemplaire = exemplaire;
    }

    public TypePret getTypePret() {
        return typePret;
    }

    public void setTypePret(TypePret typePret) {
        this.typePret = typePret;
    }

    public LocalDate getDateEmprunt() {
        return dateEmprunt;
    }

    public void setDateEmprunt(LocalDate dateEmprunt) {
        this.dateEmprunt = dateEmprunt;
    }

    public LocalDate getDateRetour() {
        return dateRetour;
    }

    public void setDateRetour(LocalDate dateRetour) {
        this.dateRetour = dateRetour;
    }

    public LocalDate getDateLimite() {
        return dateLimite;
    }

    public void setDateLimite(LocalDate dateLimite) {
        this.dateLimite = dateLimite;
    }

    @Override
    public String toString() {
        return "AdherentExemplaire{" +
                "idAdherentExemplaire=" + idAdherentExemplaire +
                ", dateEmprunt=" + dateEmprunt +
                ", dateRetour=" + dateRetour +
                ", dateLimite=" + dateLimite +
                '}';
    }
}