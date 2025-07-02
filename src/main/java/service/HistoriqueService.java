package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.AdherentExemplaireRepository;

import java.util.List;
import java.util.Map;

@Service
public class HistoriqueService {
    
    @Autowired
    private AdherentExemplaireRepository adherentExemplaireRepository;
    
    public List<Map<String, Object>> getHistoriqueAdherent(Integer idAdherent) {
        return adherentExemplaireRepository.findHistoriqueByAdherent(idAdherent);
    }
}