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
    @JoinColumn(name = "idAdherentExemplaire")
    private AdherentExemplaire adherentExemplaire;
    
    @Column(name = "prolongement", nullable = false)
    private Integer prolongement;

    public ProlongementExemplaire() {
    }

    public ProlongementExemplaire(AdherentExemplaire adherentExemplaire, Integer prolongement) {
        this.adherentExemplaire = adherentExemplaire;
        this.prolongement = prolongement;
    }

    public Integer getIdProlongementExemplaire() {
        return idProlongementExemplaire;
    }

    public void setIdProlongementExemplaire(Integer idProlongementExemplaire) {
        this.idProlongementExemplaire = idProlongementExemplaire;
    }

    public AdherentExemplaire getAdherentExemplaire() {
        return adherentExemplaire;
    }

    public void setAdherentExemplaire(AdherentExemplaire adherentExemplaire) {
        this.adherentExemplaire = adherentExemplaire;
    }

    public Integer getProlongement() {
        return prolongement;
    }

    public void setProlongement(Integer prolongement) {
        this.prolongement = prolongement;
    }

    @Override
    public String toString() {
        return "ProlongementExemplaire{" +
                "idProlongementExemplaire=" + idProlongementExemplaire +
                ", prolongement=" + prolongement +
                '}';
    }
}