package service;

import model.JourFerie;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.JourFerieRepository;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;

@Service
public class JourFerieService {
    
    @Autowired
    private JourFerieRepository jourFerieRepository;
    
    public LocalDate ajusterDateLimite(LocalDate dateLimite) {
        LocalDate dateAjustee = dateLimite;
        
        while (isJourNonOuvrable(dateAjustee)) {
            dateAjustee = dateAjustee.plusDays(1);
        }
        
        return dateAjustee;
    }
    
    public LocalDate calculerDateLimiteAvecJoursOuvrables(LocalDate dateDebut, Integer nbJoursOuvrables) {
        LocalDate date = dateDebut;
        int joursAjoutes = 0;
        
        while (joursAjoutes < nbJoursOuvrables) {
            date = date.plusDays(1);
            if (!isJourNonOuvrable(date)) {
                joursAjoutes++;
            }
        }
        
        return date;
    }
    
    private boolean isJourNonOuvrable(LocalDate date) {
        // Vérifier si c'est un weekend
        if (date.getDayOfWeek() == DayOfWeek.SATURDAY || date.getDayOfWeek() == DayOfWeek.SUNDAY) {
            return true;
        }
        
        // Vérifier si c'est un jour férié
        return jourFerieRepository.isJourFerie(date);
    }
}