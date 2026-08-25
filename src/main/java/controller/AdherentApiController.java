package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import service.AdherentAdminService;

import java.util.Map;

@RestController
@RequestMapping("/api/adherents")
public class AdherentApiController {

    @Autowired
    private AdherentAdminService adherentAdminService;

    @GetMapping("/{idAdherent}")
    public Map<String, Object> getAdherentById(@PathVariable Integer idAdherent) {
        return adherentAdminService.getAdherentById(idAdherent);
    }
}