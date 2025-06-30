package model;

import jakarta.persistence.*;

@Entity
@Table(name = "livre")
public class Livre {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idLivre")
    private Integer idLivre;
    
    @Column(name = "titre", nullable = false, length = 200)
    private String titre;
    
    @Column(name = "edition", length = 100)
    private String edition;
    
    @Column(name = "tag", length = 100)
    private String tag;
    
    @ManyToOne
    @JoinColumn(name = "idAuteur")
    private Auteur auteur;
    
    @ManyToOne
    @JoinColumn(name = "idMaison")
    private MaisonEdition maisonEdition;
    
    @ManyToOne
    @JoinColumn(name = "idGenre")
    private GenreLitteraire genreLitteraire;

    public Livre() {
    }

    public Livre(String titre, String edition, String tag, Auteur auteur, MaisonEdition maisonEdition, GenreLitteraire genreLitteraire) {
        this.titre = titre;
        this.edition = edition;
        this.tag = tag;
        this.auteur = auteur;
        this.maisonEdition = maisonEdition;
        this.genreLitteraire = genreLitteraire;
    }

    public Integer getIdLivre() {
        return idLivre;
    }

    public void setIdLivre(Integer idLivre) {
        this.idLivre = idLivre;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getEdition() {
        return edition;
    }

    public void setEdition(String edition) {
        this.edition = edition;
    }

    public String getTag() {
        return tag;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }

    public Auteur getAuteur() {
        return auteur;
    }

    public void setAuteur(Auteur auteur) {
        this.auteur = auteur;
    }

    public MaisonEdition getMaisonEdition() {
        return maisonEdition;
    }

    public void setMaisonEdition(MaisonEdition maisonEdition) {
        this.maisonEdition = maisonEdition;
    }

    public GenreLitteraire getGenreLitteraire() {
        return genreLitteraire;
    }

    public void setGenreLitteraire(GenreLitteraire genreLitteraire) {
        this.genreLitteraire = genreLitteraire;
    }

    @Override
    public String toString() {
        return "Livre{" +
                "idLivre=" + idLivre +
                ", titre='" + titre + '\'' +
                ", edition='" + edition + '\'' +
                ", tag='" + tag + '\'' +
                ", auteur=" + auteur +
                ", maisonEdition=" + maisonEdition +
                ", genreLitteraire=" + genreLitteraire +
                '}';
    }
}