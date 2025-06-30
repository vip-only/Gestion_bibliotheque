package service;

import model.Bibliothecaire;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.BibliothecaireRepository;

@Service
public class BibliothecaireService {
    
    @Autowired
    private BibliothecaireRepository bibliothecaireRepository;
    
    public Bibliothecaire authenticate(String nom, String motdepasse) {
        try {
            Bibliothecaire bibliothecaire = bibliothecaireRepository.findByNomAndMotdepasse(nom, motdepasse);
            
            if (bibliothecaire != null) {
                System.out.println("Authentification réussie pour le bibliothécaire: " + bibliothecaire.getNom());
                return bibliothecaire;
            }
            
            System.out.println("Échec de l'authentification pour: " + nom);
            return null;
        } catch (Exception e) {
            System.err.println("Erreur lors de l'authentification du bibliothécaire: " + e.getMessage());
            throw e;
        }
    }
    
    public Bibliothecaire findByNom(String nom) {
        return bibliothecaireRepository.findByNom(nom);
    }
    
    public Bibliothecaire save(Bibliothecaire bibliothecaire) {
        return bibliothecaireRepository.save(bibliothecaire);
    }
    
    public Bibliothecaire findById(int id) {
        return bibliothecaireRepository.findById(id).orElse(null);
    }
}