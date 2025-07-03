<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion des Adhérents - Bibliothèque</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .stat-card {
            border-left: 4px solid;
            transition: transform 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-2px);
        }
        .stat-card.actif {
            border-left-color: #28a745;
        }
        .stat-card.inactif {
            border-left-color: #ffc107;
        }
        .stat-card.penalise {
            border-left-color: #dc3545;
        }
        .adherent-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            color: white;
        }
    </style>
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <span class="navbar-brand">🏛️ Admin - Gestion des Adhérents</span>
            <div class="navbar-nav ms-auto">
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-outline-light btn-sm me-2">📚 Emprunts</a>
                <a href="<%= request.getContextPath() %>/admin/reservations" class="btn btn-outline-light btn-sm me-2">📋 Réservations</a>
                <a href="<%= request.getContextPath() %>/admin/prolongements" class="btn btn-outline-light btn-sm me-2">⏱️ Prolongements</a>
                <a href="<%= request.getContextPath() %>/admin/retours" class="btn btn-outline-light btn-sm me-2">🔄 Retours</a>
                <span class="navbar-text me-3">Bonjour, ${bibliothecaire.nom}</span>
                <a href="<%= request.getContextPath() %>/auth/logoutAdmin" class="btn btn-outline-light btn-sm">Déconnexion</a>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-4">
        <!-- Messages d'alerte -->
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle"></i> <%= request.getAttribute("success") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle"></i> <%= request.getAttribute("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <!-- Statistiques -->
        <div class="row mb-4">
            <div class="col-12">
                <h2 class="mb-3">📊 Vue d'ensemble des adhérents</h2>
            </div>
            
            <%
            Map<String, Object> stats = (Map<String, Object>) request.getAttribute("statistiques");
            if (stats != null) {
            %>
            <div class="col-md-3">
                <div class="card stat-card actif h-100">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h3 class="text-success mb-1"><%= stats.get("totalActifs") %></h3>
                                <p class="text-muted mb-0">Adhérents actifs</p>
                                <small class="text-success"><%= stats.get("pourcentageActifs") %>% du total</small>
                            </div>
                            <i class="bi bi-people-fill text-success" style="font-size: 2rem;"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card stat-card inactif h-100">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h3 class="text-warning mb-1"><%= stats.get("totalInactifs") %></h3>
                                <p class="text-muted mb-0">Abonnements expirés</p>
                                <small class="text-warning"><%= stats.get("pourcentageInactifs") %>% du total</small>
                            </div>
                            <i class="bi bi-person-x-fill text-warning" style="font-size: 2rem;"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card stat-card penalise h-100">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h3 class="text-danger mb-1"><%= stats.get("totalPenalises") %></h3>
                                <p class="text-muted mb-0">Adhérents pénalisés</p>
                                <small class="text-danger"><%= stats.get("pourcentagePenalises") %>% du total</small>
                            </div>
                            <i class="bi bi-person-slash text-danger" style="font-size: 2rem;"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card stat-card h-100" style="border-left-color: #6c757d;">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h3 class="text-dark mb-1"><%= stats.get("totalAdherents") %></h3>
                                <p class="text-muted mb-0">Total adhérents</p>
                                <small class="text-muted">Base complète</small>
                            </div>
                            <i class="bi bi-people text-dark" style="font-size: 2rem;"></i>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        
        <!-- Onglets pour les différents statuts -->
        <div class="row">
            <div class="col-12">
                <ul class="nav nav-tabs" id="adherentsTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="actifs-tab" data-bs-toggle="tab" data-bs-target="#actifs" type="button" role="tab">
                            <i class="bi bi-people-fill text-success"></i> Adhérents actifs
                            <span class="badge bg-success ms-1"><%= stats != null ? stats.get("totalActifs") : 0 %></span>
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="inactifs-tab" data-bs-toggle="tab" data-bs-target="#inactifs" type="button" role="tab">
                            <i class="bi bi-person-x-fill text-warning"></i> Abonnements expirés
                            <span class="badge bg-warning ms-1"><%= stats != null ? stats.get("totalInactifs") : 0 %></span>
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="penalises-tab" data-bs-toggle="tab" data-bs-target="#penalises" type="button" role="tab">
                            <i class="bi bi-person-slash text-danger"></i> Adhérents pénalisés
                            <span class="badge bg-danger ms-1"><%= stats != null ? stats.get("totalPenalises") : 0 %></span>
                        </button>
                    </li>
                </ul>
                
                <div class="tab-content" id="adherentsTabsContent">
                    <!-- Adhérents actifs -->
                    <div class="tab-pane fade show active" id="actifs" role="tabpanel">
                        <div class="card mt-3">
                            <div class="card-header bg-success text-white">
                                <h5 class="mb-0"><i class="bi bi-people-fill"></i> Adhérents actifs</h5>
                                <small>Abonnement à jour et aucune pénalité</small>
                            </div>
                            <div class="card-body">
                                <%
                                List<Map<String, Object>> adherentsActifs = (List<Map<String, Object>>) request.getAttribute("adherentsActifs");
                                if (adherentsActifs != null && !adherentsActifs.isEmpty()) {
                                %>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Adhérent</th>
                                                <th>Profil</th>
                                                <th>Date naissance</th>
                                                <th>Abonnement</th>
                                                <th>Emprunts</th>
                                                <th>Statut</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (Map<String, Object> adherent : adherentsActifs) { 
                                                String initiales = adherent.get("nom").toString().substring(0, Math.min(2, adherent.get("nom").toString().length())).toUpperCase();
                                                Object empruntsObj = adherent.get("empruntsActuels");
                                                Object quotaObj = adherent.get("quotaMax");
                                                Object joursRestantsObj = adherent.get("joursRestantsAbonnement");
                                                
                                                int emprunts = empruntsObj != null ? ((Number) empruntsObj).intValue() : 0;
                                                int quota = quotaObj != null ? ((Number) quotaObj).intValue() : 1;
                                                int joursRestants = joursRestantsObj != null ? ((Number) joursRestantsObj).intValue() : 0;
                                            %>
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="adherent-avatar bg-success me-3">
                                                            <%= initiales %>
                                                        </div>
                                                        <div>
                                                            <strong><%= adherent.get("nom") %></strong><br>
                                                            <small class="text-muted"><%= adherent.get("email") %></small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td><%= adherent.get("profil") %></td>
                                                <td><%= adherent.get("dateNaissance") %></td>
                                                <td>
                                                    <small>Expire le <%= adherent.get("dateFinAbonnement") %></small><br>
                                                    <span class="badge bg-success">
                                                        <i class="bi bi-calendar-check"></i> <%= joursRestants %> jours restants
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge bg-primary"><%= emprunts %>/<%= quota %></span>
                                                    <% if (emprunts >= quota) { %>
                                                        <br><small class="text-warning">Quota atteint</small>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <span class="badge bg-success">
                                                        <i class="bi bi-check-circle"></i> Actif
                                                    </span>
                                                </td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                                <% } else { %>
                                <div class="alert alert-info">
                                    <i class="bi bi-info-circle"></i> Aucun adhérent actif trouvé.
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Adhérents inactifs -->
                    <div class="tab-pane fade" id="inactifs" role="tabpanel">
                        <div class="card mt-3">
                            <div class="card-header bg-warning text-dark">
                                <h5 class="mb-0"><i class="bi bi-person-x-fill"></i> Abonnements expirés</h5>
                                <small>Adhérents dont l'abonnement a expiré</small>
                            </div>
                            <div class="card-body">
                                <%
                                List<Map<String, Object>> adherentsInactifs = (List<Map<String, Object>>) request.getAttribute("adherentsInactifs");
                                if (adherentsInactifs != null && !adherentsInactifs.isEmpty()) {
                                %>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Adhérent</th>
                                                <th>Profil</th>
                                                <th>Date naissance</th>
                                                <th>Abonnement expiré</th>
                                                <th>Emprunts en cours</th>
                                                <th>Statut</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (Map<String, Object> adherent : adherentsInactifs) { 
                                                String initiales = adherent.get("nom").toString().substring(0, Math.min(2, adherent.get("nom").toString().length())).toUpperCase();
                                                Object empruntsObj = adherent.get("empruntsActuels");
                                                Object joursExpiresObj = adherent.get("joursExpires");
                                                
                                                int emprunts = empruntsObj != null ? ((Number) empruntsObj).intValue() : 0;
                                                int joursExpires = joursExpiresObj != null ? ((Number) joursExpiresObj).intValue() : 0;
                                            %>
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="adherent-avatar bg-warning me-3">
                                                            <%= initiales %>
                                                        </div>
                                                        <div>
                                                            <strong><%= adherent.get("nom") %></strong><br>
                                                            <small class="text-muted"><%= adherent.get("email") %></small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td><%= adherent.get("profil") %></td>
                                                <td><%= adherent.get("dateNaissance") %></td>
                                                <td>
                                                    <small>Expiré le <%= adherent.get("dateFinAbonnement") %></small><br>
                                                    <span class="badge bg-warning text-dark">
                                                        <i class="bi bi-calendar-x"></i> Depuis <%= joursExpires %> jours
                                                    </span>
                                                </td>
                                                <td>
                                                    <% if (emprunts > 0) { %>
                                                        <span class="badge bg-danger"><%= emprunts %> emprunt(s)</span>
                                                        <br><small class="text-danger">⚠️ Retours requis</small>
                                                    <% } else { %>
                                                        <span class="badge bg-secondary">Aucun</span>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <span class="badge bg-warning text-dark">
                                                        <i class="bi bi-exclamation-triangle"></i> Inactif
                                                    </span>
                                                </td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                                <% } else { %>
                                <div class="alert alert-info">
                                    <i class="bi bi-info-circle"></i> Aucun abonnement expiré.
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Adhérents pénalisés -->
                    <div class="tab-pane fade" id="penalises" role="tabpanel">
                        <div class="card mt-3">
                            <div class="card-header bg-danger text-white">
                                <h5 class="mb-0"><i class="bi bi-person-slash"></i> Adhérents pénalisés</h5>
                                <small>Adhérents avec restrictions actives</small>
                            </div>
                            <div class="card-body">
                                <%
                                List<Map<String, Object>> adherentsPenalises = (List<Map<String, Object>>) request.getAttribute("adherentsPenalises");
                                if (adherentsPenalises != null && !adherentsPenalises.isEmpty()) {
                                %>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Adhérent</th>
                                                <th>Profil</th>
                                                <th>Pénalité</th>
                                                <th>Abonnement</th>
                                                <th>Emprunts</th>
                                                <th>Statut</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (Map<String, Object> adherent : adherentsPenalises) { 
                                                String initiales = adherent.get("nom").toString().substring(0, Math.min(2, adherent.get("nom").toString().length())).toUpperCase();
                                                Object empruntsObj = adherent.get("empruntsActuels");
                                                Object joursRestantsObj = adherent.get("joursRestantsPenalite");
                                                Object joursRestrictionObj = adherent.get("joursRestriction");
                                                
                                                int emprunts = empruntsObj != null ? ((Number) empruntsObj).intValue() : 0;
                                                int joursRestants = joursRestantsObj != null ? ((Number) joursRestantsObj).intValue() : 0;
                                                int joursRestriction = joursRestrictionObj != null ? ((Number) joursRestrictionObj).intValue() : 0;
                                            %>
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="adherent-avatar bg-danger me-3">
                                                            <%= initiales %>
                                                        </div>
                                                        <div>
                                                            <strong><%= adherent.get("nom") %></strong><br>
                                                            <small class="text-muted"><%= adherent.get("email") %></small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td><%= adherent.get("profil") %></td>
                                                <td>
                                                    <small>Du <%= adherent.get("dateDebutPenalite") %> au <%= adherent.get("dateFinPenalite") %></small><br>
                                                    <span class="badge bg-danger">
                                                        <i class="bi bi-clock"></i> <%= joursRestants %> jours restants
                                                    </span><br>
                                                    <small class="text-muted">Restriction: <%= joursRestriction %> jours</small>
                                                </td>
                                                <td>
                                                    <span class="badge <%= "Abonnement actif".equals(adherent.get("statutAbonnement")) ? "bg-success" : "bg-warning text-dark" %>">
                                                        <%= adherent.get("statutAbonnement") %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <% if (emprunts > 0) { %>
                                                        <span class="badge bg-info"><%= emprunts %> emprunt(s)</span>
                                                    <% } else { %>
                                                        <span class="badge bg-secondary">Aucun</span>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <span class="badge bg-danger">
                                                        <i class="bi bi-person-slash"></i> Pénalisé
                                                    </span>
                                                </td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                                <% } else { %>
                                <div class="alert alert-info">
                                    <i class="bi bi-info-circle"></i> Aucun adhérent pénalisé.
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Bouton pour ajouter un nouvel adhérent -->
        <div class="row mb-4">
            <div class="col-12 d-flex justify-content-between align-items-center">
                <h2 class="mb-0">📊 Vue d'ensemble des adhérents</h2>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#nouvelAdherentModal">
                    <i class="bi bi-person-plus"></i> Nouvel adhérent
                </button>
            </div>
        </div>
    </div>
    
    <!-- Modal de création d'adhérent -->
    <div class="modal fade" id="nouvelAdherentModal" tabindex="-1" aria-labelledby="nouvelAdherentModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="nouvelAdherentModalLabel">👤 Créer un nouvel adhérent</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="formNouvelAdherent">
                    <div class="modal-body">
                        <div id="messageAdherent"></div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="nomAdherent" class="form-label">Nom complet <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="nomAdherent" name="nom" required>
                                    <div class="invalid-feedback">Le nom est requis</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="emailAdherent" class="form-label">Email <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="emailAdherent" name="email" required>
                                    <div class="invalid-feedback">Un email valide est requis</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="dateNaissanceAdherent" class="form-label">Date de naissance <span class="text-danger">*</span></label>
                                    <input type="date" class="form-control" id="dateNaissanceAdherent" name="dateNaissance" required>
                                    <div class="invalid-feedback">La date de naissance est requise</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="profilAdherent" class="form-label">Profil <span class="text-danger">*</span></label>
                                    <select class="form-select" id="profilAdherent" name="idProfil" required>
                                        <option value="">Sélectionner un profil</option>
                                        <option value="1">Étudiant</option>
                                        <option value="2">Professeur</option>
                                        <option value="3">Professionnel</option>
                                        <option value="4">Anonyme</option>
                                    </select>
                                    <div class="invalid-feedback">Le profil est requis</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="motdepasseAdherent" class="form-label">Mot de passe <span class="text-danger">*</span></label>
                                    <input type="password" class="form-control" id="motdepasseAdherent" name="motdepasse" required minlength="6">
                                    <div class="invalid-feedback">Le mot de passe doit contenir au moins 6 caractères</div>
                                    <div class="form-text">Minimum 6 caractères</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="confirmMotdepasse" class="form-label">Confirmer le mot de passe <span class="text-danger">*</span></label>
                                    <input type="password" class="form-control" id="confirmMotdepasse" name="confirmMotdepasse" required>
                                    <div class="invalid-feedback">La confirmation ne correspond pas</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="dureeAbonnement" class="form-label">Durée d'abonnement <span class="text-danger">*</span></label>
                                    <select class="form-select" id="dureeAbonnement" name="dureeAbonnement" required>
                                        <option value="">Sélectionner la durée</option>
                                        <option value="30">1 mois</option>
                                        <option value="90">3 mois</option>
                                        <option value="180">6 mois</option>
                                        <option value="365" selected>1 an</option>
                                    </select>
                                    <div class="invalid-feedback">La durée d'abonnement est requise</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="dateFinAbonnement" class="form-label">Date de fin d'abonnement</label>
                                    <input type="date" class="form-control" id="dateFinAbonnement" name="dateFinAbonnement" readonly>
                                    <div class="form-text">Calculée automatiquement</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i>
                            <strong>Informations sur les profils :</strong>
                            <ul class="mb-0 mt-2">
                                <li><strong>Étudiant :</strong> Quota de 3 livres, emprunt 14 jours</li>
                                <li><strong>Professeur :</strong> Quota de 5 livres, emprunt 30 jours</li>
                                <li><strong>Professionnel :</strong> Quota de 4 livres, emprunt 20 jours</li>
                                <li><strong>Anonyme :</strong> Quota de 1 livre, emprunt 5 jours</li>
                            </ul>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-primary" id="btnCreerAdherent">
                            <i class="bi bi-person-plus"></i> Créer l'adhérent
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
console.log('=== SCRIPT CHARGÉ ===');

// Calcul automatique de la date de fin d'abonnement
document.getElementById('dureeAbonnement').addEventListener('change', function() {
    const duree = parseInt(this.value);
    if (duree) {
        const aujourdhui = new Date(); 
        const dateFin = new Date(aujourdhui.getTime() + (duree * 24 * 60 * 60 * 1000));
        document.getElementById('dateFinAbonnement').value = dateFin.toISOString().split('T')[0];
    } else {
        document.getElementById('dateFinAbonnement').value = '';
    }
});

// Validation du mot de passe
document.getElementById('confirmMotdepasse').addEventListener('input', function() {
    const motdepasse = document.getElementById('motdepasseAdherent').value;
    const confirm = this.value;
    
    if (confirm && motdepasse !== confirm) {
        this.setCustomValidity('Les mots de passe ne correspondent pas');
        this.classList.add('is-invalid');
    } else {
        this.setCustomValidity('');
        this.classList.remove('is-invalid');
    }
});

// Initialisation
document.addEventListener('DOMContentLoaded', function() {
    console.log('=== DOM READY ===');
    
    // Initialiser la date de fin d'abonnement par défaut (1 an)
    const dureeSelect = document.getElementById('dureeAbonnement');
    if (dureeSelect) {
        dureeSelect.dispatchEvent(new Event('change'));
    }
    
    // Définir les limites de date de naissance
    const dateNaissanceInput = document.getElementById('dateNaissanceAdherent');
    if (dateNaissanceInput) {
        const maxDate = new Date();
        maxDate.setFullYear(maxDate.getFullYear() - 10);
        dateNaissanceInput.setAttribute('max', maxDate.toISOString().split('T')[0]);
        
        const minDate = new Date();
        minDate.setFullYear(minDate.getFullYear() - 100);
        dateNaissanceInput.setAttribute('min', minDate.toISOString().split('T')[0]);
    }
});

// Gestion du formulaire de création d'adhérent
document.getElementById('formNouvelAdherent').addEventListener('submit', function(e) {
    console.log('=== FORMULAIRE SOUMIS ===');
    e.preventDefault();
    
    const btnCreer = document.getElementById('btnCreerAdherent');
    const messageDiv = document.getElementById('messageAdherent');
    
    console.log('Prévention de la soumission normale réussie');
    
    // Validation des champs
    if (!this.checkValidity()) {
        console.log('Formulaire invalide');
        e.stopPropagation();
        this.classList.add('was-validated');
        return;
    }
    
    // Vérification des mots de passe
    const motdepasse = document.getElementById('motdepasseAdherent').value;
    const confirm = document.getElementById('confirmMotdepasse').value;
    if (motdepasse !== confirm) {
        console.log('Mots de passe ne correspondent pas');
        messageDiv.innerHTML = 
            '<div class="alert alert-danger">' +
                '<i class="bi bi-exclamation-triangle"></i> Les mots de passe ne correspondent pas.' +
            '</div>';
        return;
    }
    
    // Désactiver le bouton et afficher le loader
    btnCreer.disabled = true;
    btnCreer.innerHTML = '<i class="bi bi-hourglass-split"></i> Création en cours...';
    
    // Préparer les données
    const formData = new FormData(this);
    const data = {};
    formData.forEach((value, key) => {
        if (key !== 'confirmMotdepasse' && key !== 'dateFinAbonnement') {
            data[key] = value;
        }
    });
    
    console.log('Données préparées:', data);
    
    const url = '<%= request.getContextPath() %>/admin/creer-adherent';
    console.log('URL de la requête:', url);
    
    // Envoyer la requête AJAX
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        },
        body: JSON.stringify(data)
    })
    .then(response => {
        console.log('Response status:', response.status);
        console.log('Response headers:', Object.fromEntries(response.headers.entries()));
        
        if (!response.ok) {
            throw new Error('Erreur HTTP ' + response.status);
        }
        
        return response.text();
    })
    .then(text => {
        console.log('Réponse brute:', text);
        
        try {
            const responseData = JSON.parse(text);
            console.log('Réponse JSON:', responseData);
            
            if (responseData.success) {
                // ⬇️ CORRECTION: Utiliser JavaScript pour remplacer les \n
                const messageFormatted = responseData.message.replace(/\n/g, '<br>');
                messageDiv.innerHTML = 
                    '<div class="alert alert-success">' +
                        '<i class="bi bi-check-circle"></i> ' + messageFormatted +
                    '</div>';
                
                // Réinitialiser le formulaire
                document.getElementById('formNouvelAdherent').reset();
                document.getElementById('formNouvelAdherent').classList.remove('was-validated');
                
                // Fermer le modal après 3 secondes et recharger la page
                setTimeout(() => {
                    const modal = bootstrap.Modal.getInstance(document.getElementById('nouvelAdherentModal'));
                    if (modal) {
                        modal.hide();
                    }
                    location.reload();
                }, 3000);
            } else {
                // ⬇️ CORRECTION: Gérer aussi les messages d'erreur
                const errorFormatted = responseData.message.replace(/\n/g, '<br>');
                messageDiv.innerHTML = 
                    '<div class="alert alert-danger">' +
                        '<i class="bi bi-exclamation-triangle"></i> ' + errorFormatted +
                    '</div>';
            }
        } catch (e) {
            console.error('Erreur de parsing JSON:', e);
            messageDiv.innerHTML = 
                '<div class="alert alert-danger">' +
                    '<i class="bi bi-exclamation-triangle"></i> Réponse invalide du serveur: ' + text +
                '</div>';
        }
    })
    .catch(error => {
        console.error('Erreur fetch:', error);
        messageDiv.innerHTML = 
            '<div class="alert alert-danger">' +
                '<i class="bi bi-exclamation-triangle"></i> Erreur: ' + error.message +
            '</div>';
    })
    .finally(() => {
        // Réactiver le bouton
        btnCreer.disabled = false;
        btnCreer.innerHTML = '<i class="bi bi-person-plus"></i> Créer l\'adhérent';
        console.log('Traitement terminé');
    });
});

// Réinitialiser le formulaire à l'ouverture du modal
document.getElementById('nouvelAdherentModal').addEventListener('show.bs.modal', function() {
    console.log('Modal ouvert');
    const form = document.getElementById('formNouvelAdherent');
    if (form) {
        form.reset();
        form.classList.remove('was-validated');
    }
    
    const messageDiv = document.getElementById('messageAdherent');
    if (messageDiv) {
        messageDiv.innerHTML = '';
    }
    
    // Recalculer la date de fin d'abonnement
    setTimeout(() => {
        const dureeSelect = document.getElementById('dureeAbonnement');
        if (dureeSelect) {
            dureeSelect.dispatchEvent(new Event('change'));
        }
    }, 100);
});

console.log('=== SCRIPT TERMINÉ ===');
    </script>
</body>
</html>