package service;

import model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.*;
import java.time.LocalDate;
import java.time.Period;
import java.util.List;
import java.util.Map;
import jakarta.transaction.Transactional;

@Service
public class EmpruntService {
    
    @Autowired
    private AdherentRepository adherentRepository;
    
    @Autowired
    private ExemplaireRepository exemplaireRepository;
    
    @Autowired
    private AdherentExemplaireRepository adherentExemplaireRepository;
    
    @Autowired
    private TypePretRepository typePretRepository;
    
    @Autowired
    private DureeEmpruntRepository dureeEmpruntRepository;
    
    @Autowired
    private QuotaRepository quotaRepository;
    
    @Autowired
    private AdherentPenaliteRepository adherentPenaliteRepository;
    
    @Autowired
    private ReservationRepository reservationRepository;
    
    public List<Map<String, Object>> getAllTypesPret() {
        return typePretRepository.findAllTypesPretForSelect();
    }
    
    @Transactional
    public String emprunterLivre(Integer idLivre, String numExemplaire, Integer idAdherent, Integer idTypePret, LocalDate dateEmprunt) throws Exception {
        Adherent adherent = adherentRepository.findById(idAdherent)
            .orElseThrow(() -> new Exception("Adherent introuvable"));

        if (adherentPenaliteRepository.hasPenaliteActive(idAdherent, dateEmprunt)) {
            throw new Exception("Impossible d'emprunter : vous avez une penalite active à la date " + dateEmprunt);
        }

        if (idTypePret == 1) { 
            Integer quotaMax = quotaRepository.findQuotaByProfil(adherent.getProfil().getIdProfil()).getNbExemplaires();
            if (quotaMax == null) {
                quotaMax = 1; 
            }

            Integer empruntsActuelsADomicile = adherentExemplaireRepository.countEmpruntsActifsADomicile(idAdherent, dateEmprunt);
            if (empruntsActuelsADomicile != null && empruntsActuelsADomicile >= quotaMax) {
                throw new Exception("Quota d'emprunts à domicile atteint (" + empruntsActuelsADomicile + "/" + quotaMax + "). Veuillez retourner des livres avant d'emprunter.");
            }
        }

        Exemplaire exemplaire = exemplaireRepository.findByNumExemplaire(numExemplaire);
        if (exemplaire == null) {
            throw new Exception("Exemplaire introuvable");
        }

        if (exemplaire.getLivre().getAgesup() != null) {
            int ageAdherent = calculerAge(adherent.getDateNaissance());
            if (ageAdherent < exemplaire.getLivre().getAgesup()) {
                throw new Exception("Âge minimum requis pour ce livre : " + exemplaire.getLivre().getAgesup() + " ans. " +
                                  "Âge de l'adherent : " + ageAdherent + " ans.");
            }
        }
       
        if (adherentExemplaireRepository.existsByExemplaireAndDateRetourIsNull(exemplaire)) {
            throw new Exception("Cet exemplaire est dejà emprunte");
        }

        // Vérifier s'il y a une réservation acceptée par un autre adhérent à la date d'emprunt
        verifierReservationAcceptee(exemplaire, idAdherent, dateEmprunt);

        TypePret typePret = typePretRepository.findById(idTypePret)
            .orElseThrow(() -> new Exception("Type de pret introuvable"));

        AdherentExemplaire adherentExemplaire = new AdherentExemplaire();
        adherentExemplaire.setAdherent(adherent);
        adherentExemplaire.setExemplaire(exemplaire);
        adherentExemplaire.setTypePret(typePret);
        adherentExemplaire.setDateEmprunt(dateEmprunt);
        adherentExemplaire.setDateLimite(calculerDateLimite(dateEmprunt, idAdherent, idTypePret));

        if (idTypePret == 2) {
            adherentExemplaire.setDateRetour(dateEmprunt); 
        }

        adherentExemplaireRepository.save(adherentExemplaire);

        return "Emprunt effectué avec succès";
    }

    private void verifierReservationAcceptee(Exemplaire exemplaire, Integer idAdherentDemandeur, LocalDate dateEmprunt) throws Exception {
        Map<String, Object> reservationProche = reservationRepository.findReservationAccepteeProche(
            exemplaire.getIdExemplaire(), 
            idAdherentDemandeur,
            dateEmprunt
        );
        System.out.println("Reservation proche trouvée : " + reservationProche);
        
        if (reservationProche != null && reservationProche.get("nomAdherent") != null && reservationProche.get("dateDebut") != null) {
            String nomAdherentReservation = (String) reservationProche.get("nomAdherent");
            String emailAdherentReservation = (String) reservationProche.get("emailAdherent");

            // Conversion robuste des dates
            LocalDate dateDebut = null;
            LocalDate dateFin = null;
            Object dateDebutObj = reservationProche.get("dateDebut");
            Object dateFinObj = reservationProche.get("dateFin");

            if (dateDebutObj instanceof LocalDate) {
                dateDebut = (LocalDate) dateDebutObj;
            } else if (dateDebutObj instanceof java.sql.Date) {
                dateDebut = ((java.sql.Date) dateDebutObj).toLocalDate();
            } else if (dateDebutObj instanceof String) {
                dateDebut = LocalDate.parse((String) dateDebutObj);
            }

            if (dateFinObj instanceof LocalDate) {
                dateFin = (LocalDate) dateFinObj;
            } else if (dateFinObj instanceof java.sql.Date) {
                dateFin = ((java.sql.Date) dateFinObj).toLocalDate();
            } else if (dateFinObj instanceof String) {
                dateFin = LocalDate.parse((String) dateFinObj);
            }

            throw new Exception(String.format(
                "EXEMPLAIRE RESERVE : Cet exemplaire est reserve par un autre adherent.\n\n" +
                "DETAILS DE LA RESERVATION :\n" +
                "Adherent : %s (%s)\n" +
                "Periode de recuperation : du %s au %s\n" +
                "Exemplaire : %s\n" +
                "Livre : %s\n\n" +
                "SOLUTIONS :\n" +
                "Choisissez un autre exemplaire du meme livre\n" +
                "Attendez que la reservation expire (après le %s)\n" +
                "Verifiez la disponibilite d'autres livres similaires",
                nomAdherentReservation,
                emailAdherentReservation,
                dateDebut,
                dateFin,
                exemplaire.getNumExemplaire(),
                exemplaire.getLivre().getTitre(),
                dateFin
            ));
        } else {
            // Pas de réservation conflictuelle, ne rien faire
            return;
        }
    }
    
    private int calculerAge(LocalDate dateNaissance) {
        if (dateNaissance == null) {
            return 0; 
        }
        return Period.between(dateNaissance, LocalDate.now()).getYears();
    }
    
    private LocalDate calculerDateLimite(LocalDate dateEmprunt, Integer idAdherent, Integer idTypePret) {
        Adherent adherent = adherentRepository.findById(idAdherent)
            .orElseThrow(() -> new IllegalArgumentException("Adherent introuvable"));
        
        Integer idProfil = adherent.getProfil().getIdProfil();
        
        if (idTypePret == 2) {
            return dateEmprunt; // Date limite = date d'emprunt (meme jour)
        }
        Integer nbJours = dureeEmpruntRepository.findNbJoursByProfilAndTypePret(idProfil, idTypePret);
        if (nbJours == null) {
            nbJours = 14; // valeur par defaut
        }
        return dateEmprunt.plusDays(nbJours);
    }
}