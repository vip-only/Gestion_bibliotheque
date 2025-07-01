package model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "etatprolongementexemplaire")
public class EtatProlongementExemplaire {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idEtatProlongementExemplaire")
    private Integer idEtatProlongementExemplaire;
    
    @ManyToOne
    @JoinColumn(name = "idProlongementExemplaire")
    private ProlongementExemplaire prolongementExemplaire;
    
    @ManyToOne
    @JoinColumn(name = "idEtat")
    private Etat etat;
    
    @Column(name = "dateEtat")
    private LocalDate dateEtat;

    public EtatProlongementExemplaire() {
    }

    public EtatProlongementExemplaire(ProlongementExemplaire prolongementExemplaire, Etat etat, LocalDate dateEtat) {
        this.prolongementExemplaire = prolongementExemplaire;
        this.etat = etat;
        this.dateEtat = dateEtat;
    }

    public Integer getIdEtatProlongementExemplaire() {
        return idEtatProlongementExemplaire;
    }

    public void setIdEtatProlongementExemplaire(Integer idEtatProlongementExemplaire) {
        this.idEtatProlongementExemplaire = idEtatProlongementExemplaire;
    }

    public ProlongementExemplaire getProlongementExemplaire() {
        return prolongementExemplaire;
    }

    public void setProlongementExemplaire(ProlongementExemplaire prolongementExemplaire) {
        this.prolongementExemplaire = prolongementExemplaire;
    }

    public Etat getEtat() {
        return etat;
    }

    public void setEtat(Etat etat) {
        this.etat = etat;
    }

    public LocalDate getDateEtat() {
        return dateEtat;
    }

    public void setDateEtat(LocalDate dateEtat) {
        this.dateEtat = dateEtat;
    }

    @Override
    public String toString() {
        return "EtatProlongementExemplaire{" +
                "idEtatProlongementExemplaire=" + idEtatProlongementExemplaire +
                ", dateEtat=" + dateEtat +
                '}';
    }
}