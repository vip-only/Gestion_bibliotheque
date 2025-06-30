package model;

import jakarta.persistence.*;

@Entity
@Table(name = "prolongementexemplaire")
public class ProlongementExemplaire {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idProlongementExemplaire")
    private Integer idProlongementExemplaire;
    
    @ManyToOne
    @JoinColumn(name = "idExemplaire")
    private Exemplaire exemplaire;
    
    @ManyToOne
    @JoinColumn(name = "idEtat")
    private Etat etat;

    public ProlongementExemplaire() {
    }

    public ProlongementExemplaire(Exemplaire exemplaire, Etat etat) {
        this.exemplaire = exemplaire;
        this.etat = etat;
    }

    public Integer getIdProlongementExemplaire() {
        return idProlongementExemplaire;
    }

    public void setIdProlongementExemplaire(Integer idProlongementExemplaire) {
        this.idProlongementExemplaire = idProlongementExemplaire;
    }

    public Exemplaire getExemplaire() {
        return exemplaire;
    }

    public void setExemplaire(Exemplaire exemplaire) {
        this.exemplaire = exemplaire;
    }

    public Etat getEtat() {
        return etat;
    }

    public void setEtat(Etat etat) {
        this.etat = etat;
    }

    @Override
    public String toString() {
        return "ProlongementExemplaire{" +
                "idProlongementExemplaire=" + idProlongementExemplaire +
                ", exemplaire=" + exemplaire +
                ", etat=" + etat +
                '}';
    }
}