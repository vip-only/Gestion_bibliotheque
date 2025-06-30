package model;

import jakarta.persistence.*;

@Entity
@Table(name = "exemplaire")
public class Exemplaire {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idExemplaire")
    private Integer idExemplaire;
    
    @Column(name = "numExemplaire", nullable = false, length = 50)
    private String numExemplaire;
    
    @ManyToOne
    @JoinColumn(name = "idLivre", nullable = false)
    private Livre livre;

    public Exemplaire() {
    }

    public Exemplaire(String numExemplaire, Livre livre) {
        this.numExemplaire = numExemplaire;
        this.livre = livre;
    }

    public Integer getIdExemplaire() {
        return idExemplaire;
    }

    public void setIdExemplaire(Integer idExemplaire) {
        this.idExemplaire = idExemplaire;
    }

    public String getNumExemplaire() {
        return numExemplaire;
    }

    public void setNumExemplaire(String numExemplaire) {
        this.numExemplaire = numExemplaire;
    }

    public Livre getLivre() {
        return livre;
    }

    public void setLivre(Livre livre) {
        this.livre = livre;
    }

    @Override
    public String toString() {
        return "Exemplaire{" +
                "idExemplaire=" + idExemplaire +
                ", numExemplaire='" + numExemplaire + '\'' +
                ", livre=" + livre +
                '}';
    }
}