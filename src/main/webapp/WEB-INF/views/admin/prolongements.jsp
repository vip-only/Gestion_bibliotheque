<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion des Prolongements - Bibliothèque</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <span class="navbar-brand">🏛️ Admin - Gestion des Prolongements</span>
            <div class="navbar-nav ms-auto">
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-outline-light btn-sm me-2">📚 Emprunts</a>
                <a href="<%= request.getContextPath() %>/admin/reservations" class="btn btn-outline-light btn-sm me-2">📋 Réservations</a>
                <a href="<%= request.getContextPath() %>/admin/prolongements" class="btn btn-outline-light btn-sm me-2">⏱️ Prolongements</a>
                <a href="<%= request.getContextPath() %>/admin/retours" class="btn btn-outline-light btn-sm me-2">🔄 Retours</a>
                <a href="<%= request.getContextPath() %>/admin/adherents" class="btn btn-outline-light btn-sm me-2">👥 Adhérents</a>
                <span class="navbar-text me-3">Bonjour, ${bibliothecaire.nom}</span>
                <a href="<%= request.getContextPath() %>/auth/logoutAdmin" class="btn btn-outline-light btn-sm">Déconnexion</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
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
        
        <!-- Filtres de recherche -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h6 class="card-title mb-0">🔍 Filtres de recherche</h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4">
                                <label for="filterAdherent" class="form-label">Rechercher par adhérent:</label>
                                <select class="form-select" id="filterAdherent">
                                    <option value="">Tous les adhérents</option>
                                    <% 
                                    List<Map<String, Object>> adherents = (List<Map<String, Object>>) request.getAttribute("adherents");
                                    if (adherents != null) {
                                        for (Map<String, Object> adherent : adherents) { 
                                    %>
                                    <option value="<%= adherent.get("nom") %>">
                                        <%= adherent.get("nom") %> (<%= adherent.get("email") %>)
                                    </option>
                                    <% 
                                        }
                                    } 
                                    %>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="filterExemplaire" class="form-label">Rechercher par numéro d'exemplaire:</label>
                                <input type="text" class="form-control" id="filterExemplaire" placeholder="Ex: EXP001">
                            </div>
                            <div class="col-md-4">
                                <label for="filterStatut" class="form-label">Filtrer par statut:</label>
                                <select class="form-select" id="filterStatut">
                                    <option value="">Tous les statuts</option>
                                    <option value="Emprunt en retard">Emprunt en retard</option>
                                    <option value="Proche échéance">Proche échéance</option>
                                    <option value="Normal">Normal</option>
                                </select>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-12">
                                <button type="button" class="btn btn-primary" onclick="filtrerProlongements()">
                                    <i class="bi bi-search"></i> Filtrer
                                </button>
                                <button type="button" class="btn btn-secondary" onclick="resetFiltres()">
                                    <i class="bi bi-arrow-clockwise"></i> Reset
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Liste des prolongements en cours -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">⏱️ Demandes de Prolongement en cours</h5>
                        <small class="text-muted">Prolongements en attente de validation</small>
                    </div>
                    <div class="card-body">
                        <% 
                        List<Map<String, Object>> prolongements = (List<Map<String, Object>>) request.getAttribute("prolongementsEnCours");
                        if (prolongements != null && !prolongements.isEmpty()) {
                        %>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover" id="tableProlongements">
                                <thead class="table-primary">
                                    <tr>
                                        <th>Adhérent</th>
                                        <th>Profil</th>
                                        <th>Exemplaire</th>
                                        <th>Livre</th>
                                        <th>Auteur</th>
                                        <th>Type prêt</th>
                                        <th>Date emprunt</th>
                                        <th>Date limite actuelle</th>
                                        <th>Prolongement demandé</th>
                                        <th>Date demande</th>
                                        <th>Retard (jours)</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Map<String, Object> prolongement : prolongements) { 
                                        String statut = (String) prolongement.get("statut");
                                        String badgeClass = "bg-success";
                                        String rowClass = "";
                                        
                                        if ("Emprunt en retard".equals(statut)) {
                                            badgeClass = "bg-danger";
                                            rowClass = "table-danger";
                                        } else if ("Proche échéance".equals(statut)) {
                                            badgeClass = "bg-warning";
                                            rowClass = "table-warning";
                                        }
                                        
                                        Object joursRetardObj = prolongement.get("joursRetard");
                                        Integer joursRetard = 0;
                                        if (joursRetardObj != null) {
                                            if (joursRetardObj instanceof Number) {
                                                joursRetard = ((Number) joursRetardObj).intValue();
                                            }
                                        }
                                        
                                        Object prolongementJoursObj = prolongement.get("prolongement");
                                        Integer prolongementJours = 0;
                                        if (prolongementJoursObj != null) {
                                            if (prolongementJoursObj instanceof Number) {
                                                prolongementJours = ((Number) prolongementJoursObj).intValue();
                                            }
                                        }
                                    %>
                                    <tr class="<%= rowClass %>" 
                                        data-adherent="<%= prolongement.get("nomAdherent") %>" 
                                        data-exemplaire="<%= prolongement.get("numExemplaire") %>" 
                                        data-statut="<%= statut %>">
                                        <td>
                                            <strong><%= prolongement.get("nomAdherent") %></strong><br>
                                            <small class="text-muted"><%= prolongement.get("emailAdherent") %></small>
                                        </td>
                                        <td><%= prolongement.get("profilAdherent") %></td>
                                        <td><code><%= prolongement.get("numExemplaire") %></code></td>
                                        <td>
                                            <strong><%= prolongement.get("titreLivre") %></strong>
                                            <% if (prolongement.get("edition") != null) { %>
                                                <br><small class="text-muted"><%= prolongement.get("edition") %></small>
                                            <% } %>
                                        </td>
                                        <td><%= prolongement.get("auteur") != null ? prolongement.get("auteur") : "N/A" %></td>
                                        <td><%= prolongement.get("typePret") %></td>
                                        <td><%= prolongement.get("dateEmprunt") %></td>
                                        <td><%= prolongement.get("dateLimite") %></td>
                                        <td>
                                            <span class="badge bg-info"><%= prolongementJours %> jours</span>
                                        </td>
                                        <td><%= prolongement.get("dateEtat") %></td>
                                        <td>
                                            <% if (joursRetard > 0) { %>
                                                <span class="badge bg-danger">+<%= joursRetard %></span>
                                            <% } else if (joursRetard < 0) { %>
                                                <span class="badge bg-success"><%= joursRetard %></span>
                                            <% } else { %>
                                                <span class="badge bg-warning">0</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <span class="badge <%= badgeClass %>"><%= statut %></span>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-success btn-sm" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#approuverProlongementModal"
                                                    data-prolongement-id="<%= prolongement.get("idProlongementExemplaire") %>"
                                                    data-adherent="<%= prolongement.get("nomAdherent") %>"
                                                    data-livre="<%= prolongement.get("titreLivre") %>"
                                                    data-exemplaire="<%= prolongement.get("numExemplaire") %>"
                                                    data-prolongement-jours="<%= prolongementJours %>"
                                                    title="Approuver le prolongement">
                                                <i class="bi bi-check-circle"></i> Approuver
                                            </button>
                                            <button type="button" class="btn btn-danger btn-sm" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#rejeterProlongementModal"
                                                    data-prolongement-id="<%= prolongement.get("idProlongementExemplaire") %>"
                                                    data-adherent="<%= prolongement.get("nomAdherent") %>"
                                                    data-livre="<%= prolongement.get("titreLivre") %>"
                                                    data-exemplaire="<%= prolongement.get("numExemplaire") %>"
                                                    data-prolongement-jours="<%= prolongementJours %>"
                                                    title="Rejeter le prolongement">
                                                <i class="bi bi-x-circle"></i> Rejeter
                                            </button>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                        <div class="alert alert-info" role="alert">
                            <i class="bi bi-info-circle"></i> Aucune demande de prolongement en cours.
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Modal d'approbation de prolongement -->
    <div class="modal fade" id="approuverProlongementModal" tabindex="-1" aria-labelledby="approuverProlongementModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="approuverProlongementModalLabel">✅ Approuver le prolongement</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="<%= request.getContextPath() %>/admin/approuver-prolongement" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="idProlongementApprouver" name="idProlongementExemplaire">
                        
                        <div class="mb-3">
                            <h6>Informations du prolongement :</h6>
                            <ul class="list-unstyled">
                                <li><strong>Adhérent :</strong> <span id="modalAdherentApprouver"></span></li>
                                <li><strong>Livre :</strong> <span id="modalLivreApprouver"></span></li>
                                <li><strong>Exemplaire :</strong> <span id="modalExemplaireApprouver"></span></li>
                                <li><strong>Prolongement :</strong> <span id="modalProlongementJoursApprouver"></span> jours</li>
                            </ul>
                        </div>
                        
                        <div class="alert alert-success">
                            <i class="bi bi-check-circle"></i>
                            Cette action va prolonger la date limite d'emprunt de la durée demandée.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-check-circle"></i> Approuver le prolongement
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Modal de rejet de prolongement -->
    <div class="modal fade" id="rejeterProlongementModal" tabindex="-1" aria-labelledby="rejeterProlongementModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="rejeterProlongementModalLabel">❌ Rejeter le prolongement</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="<%= request.getContextPath() %>/admin/rejeter-prolongement" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="idProlongementRejeter" name="idProlongementExemplaire">
                        
                        <div class="mb-3">
                            <h6>Informations du prolongement :</h6>
                            <ul class="list-unstyled">
                                <li><strong>Adhérent :</strong> <span id="modalAdherentRejeter"></span></li>
                                <li><strong>Livre :</strong> <span id="modalLivreRejeter"></span></li>
                                <li><strong>Exemplaire :</strong> <span id="modalExemplaireRejeter"></span></li>
                                <li><strong>Prolongement :</strong> <span id="modalProlongementJoursRejeter"></span> jours</li>
                            </ul>
                        </div>
                        
                        <div class="alert alert-warning">
                            <i class="bi bi-exclamation-triangle"></i>
                            <strong>Attention :</strong> Cette action va rejeter la demande de prolongement. L'adhérent devra retourner le livre à la date limite initiale.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Retour</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="bi bi-x-circle"></i> Confirmer le rejet
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Gestion du modal d'approbation
        document.getElementById('approuverProlongementModal').addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var prolongementId = button.getAttribute('data-prolongement-id');
            var adherent = button.getAttribute('data-adherent');
            var livre = button.getAttribute('data-livre');
            var exemplaire = button.getAttribute('data-exemplaire');
            var prolongementJours = button.getAttribute('data-prolongement-jours');
            
            document.getElementById('idProlongementApprouver').value = prolongementId;
            document.getElementById('modalAdherentApprouver').textContent = adherent;
            document.getElementById('modalLivreApprouver').textContent = livre;
            document.getElementById('modalExemplaireApprouver').textContent = exemplaire;
            document.getElementById('modalProlongementJoursApprouver').textContent = prolongementJours;
        });
        
        // Gestion du modal de rejet
        document.getElementById('rejeterProlongementModal').addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var prolongementId = button.getAttribute('data-prolongement-id');
            var adherent = button.getAttribute('data-adherent');
            var livre = button.getAttribute('data-livre');
            var exemplaire = button.getAttribute('data-exemplaire');
            var prolongementJours = button.getAttribute('data-prolongement-jours');
            
            document.getElementById('idProlongementRejeter').value = prolongementId;
            document.getElementById('modalAdherentRejeter').textContent = adherent;
            document.getElementById('modalLivreRejeter').textContent = livre;
            document.getElementById('modalExemplaireRejeter').textContent = exemplaire;
            document.getElementById('modalProlongementJoursRejeter').textContent = prolongementJours;
        });
        
        // Fonctions de filtrage
        function filtrerProlongements() {
            var filterAdherent = document.getElementById('filterAdherent').value.toLowerCase();
            var filterExemplaire = document.getElementById('filterExemplaire').value.toLowerCase();
            var filterStatut = document.getElementById('filterStatut').value;
            
            var table = document.getElementById('tableProlongements');
            var rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
            
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                var adherent = row.getAttribute('data-adherent').toLowerCase();
                var exemplaire = row.getAttribute('data-exemplaire').toLowerCase();
                var statut = row.getAttribute('data-statut');
                
                var showRow = true;
                
                if (filterAdherent && !adherent.includes(filterAdherent)) {
                    showRow = false;
                }
                
                if (filterExemplaire && !exemplaire.includes(filterExemplaire)) {
                    showRow = false;
                }
                
                if (filterStatut && statut !== filterStatut) {
                    showRow = false;
                }
                
                row.style.display = showRow ? '' : 'none';
            }
        }
        
        function resetFiltres() {
            document.getElementById('filterAdherent').value = '';
            document.getElementById('filterExemplaire').value = '';
            document.getElementById('filterStatut').value = '';
            
            var table = document.getElementById('tableProlongements');
            var rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
            
            for (var i = 0; i < rows.length; i++) {
                rows[i].style.display = '';
            }
        }
        
        // Filtrage en temps réel pour l'exemplaire
        document.getElementById('filterExemplaire').addEventListener('input', function() {
            if (this.value.length > 2) {
                filtrerProlongements();
            } else if (this.value.length === 0) {
                resetFiltres();
            }
        });
        
        document.getElementById('filterAdherent').addEventListener('change', filtrerProlongements);
        document.getElementById('filterStatut').addEventListener('change', filtrerProlongements);
    </script>
</body>
</html>