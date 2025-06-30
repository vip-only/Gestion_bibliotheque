package model;

import jakarta.persistence.*;

@Entity
@Table(name = "genrelitteraire")
public class GenreLitteraire {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idGenre")
    private Integer idGenre;
    
    @Column(name = "libelle", nullable = false, length = 100)
    private String libelle;

    public GenreLitteraire() {
    }

    public GenreLitteraire(String libelle) {
        this.libelle = libelle;
    }

    public GenreLitteraire(Integer idGenre, String libelle) {
        this.idGenre = idGenre;
        this.libelle = libelle;
    }

    public Integer getIdGenre() {
        return idGenre;
    }

    public void setIdGenre(Integer idGenre) {
        this.idGenre = idGenre;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    @Override
    public String toString() {
        return "GenreLitteraire{" +
                "idGenre=" + idGenre +
                ", libelle='" + libelle + '\'' +
                '}';
    }
}