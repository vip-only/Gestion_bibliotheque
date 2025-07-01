package service;

import model.AdherentPenalite;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.AdherentPenaliteRepository;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Service
public class PenaliteService {
    
    @Autowired
    private AdherentPenaliteRepository adherentPenaliteRepository;
    
    public List<AdherentPenalite> getPenalitesActivesByAdherent(Integer idAdherent) {
        return adherentPenaliteRepository.findPenalitesActivesByAdherent(idAdherent);
    }
    
    public List<Map<String, Object>> getAllPenalitesActives() {
        List<Object[]> results = adherentPenaliteRepository.findAllPenalitesActives();
        return results.stream().map(row -> {
            Map<String, Object> penalite = new HashMap<>();
            penalite.put("nomAdherent", row[0]);
            penalite.put("emailAdherent", row[1]);
            penalite.put("typePenalite", row[2]);
            penalite.put("dateDebut", row[3]);
            penalite.put("dateFin", row[4]);
            penalite.put("joursRestants", row[5]);
            return penalite;
        }).toList();
    }
    
    public boolean hasActivePenalty(Integer idAdherent) {
        return adherentPenaliteRepository.hasPenaliteActive(idAdherent);
    }
   
    public LocalDate getProchaineDateDisponiblePenalite(Integer idAdherent, LocalDate dateRetour) {
        AdherentPenalite dernierePenalite = adherentPenaliteRepository.findDernierePenaliteByAdherent(idAdherent);
        
        if (dernierePenalite != null && dernierePenalite.getDateFin().isAfter(dateRetour)) {
            return dernierePenalite.getDateFin().plusDays(1);
        }
        
        return dateRetour;
    }
}