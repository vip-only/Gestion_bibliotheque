package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.ExemplaireRepository;
import java.util.List;
import java.util.Map;

@Service
public class ExemplaireService {
    
    @Autowired
    private ExemplaireRepository exemplaireRepository;
    
    public List<Map<String, Object>> getExemplairesDisponiblesGroupByLivre() {
        return exemplaireRepository.findExemplairesDisponiblesGroupByLivre();
    }
}