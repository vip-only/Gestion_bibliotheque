<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>Mon Historique - Bibliothèque</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <span class="navbar-brand">📚 Mon Historique</span>
            <div class="navbar-nav ms-auto">
                <a href="<%= request.getContextPath() %>/adherent/catalogue" class="btn btn-outline-light btn-sm me-2">📖 Catalogue</a>
                <span class="navbar-text me-3">Bonjour, ${adherent.nom}</span>
                <a href="<%= request.getContextPath() %>/auth/logout" class="btn btn-outline-light btn-sm">Déconnexion</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- Messages d'alerte -->
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
                                <label for="filterTitre" class="form-label">Rechercher par titre:</label>
                                <input type="text" class="form-control" id="filterTitre" placeholder="Titre du livre...">
                            </div>
                            <div class="col-md-4">
                                <label for="filterExemplaire" class="form-label">Rechercher par numéro d'exemplaire:</label>
                                <input type="text" class="form-control" id="filterExemplaire" placeholder="Ex: EXP001">
                            </div>
                            <div class="col-md-4">
                                <label for="filterStatut" class="form-label">Filtrer par statut:</label>
                                <select class="form-select" id="filterStatut">
                                    <option value="">Tous les statuts</option>
                                    <option value="En cours">En cours</option>
                                    <option value="En retard">En retard</option>
                                    <option value="Bientôt échéance">Bientôt échéance</option>
                                    <option value="Retourné à temps">Retourné à temps</option>
                                    <option value="Retourné en retard">Retourné en retard</option>
                                </select>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-12">
                                <button type="button" class="btn btn-primary" onclick="filtrerHistorique()">
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
        
        <!-- Historique des emprunts -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">📖 Mon Historique d'Emprunts</h5>
                        <small class="text-muted">Tous vos emprunts passés et actuels</small>
                    </div>
                    <div class="card-body">
                        <% 
                        List<Map<String, Object>> historique = (List<Map<String, Object>>) request.getAttribute("historique");
                        if (historique != null && !historique.isEmpty()) {
                        %>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover" id="tableHistorique">
                                <thead class="table-primary">
                                    <tr>
                                        <th>Exemplaire</th>
                                        <th>Livre</th>
                                        <th>Auteur</th>
                                        <th>Type prêt</th>
                                        <th>Date emprunt</th>
                                        <th>Date limite</th>
                                        <th>Date retour</th>
                                        <th>Retard (jours)</th>
                                        <th>Statut</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Map<String, Object> emprunt : historique) { 
                                        String statut = (String) emprunt.get("statut");
                                        String badgeClass = "bg-success";
                                        String rowClass = "";
                                        
                                        // Déterminer les couleurs selon le statut
                                        if ("En retard".equals(statut)) {
                                            badgeClass = "bg-danger";
                                            rowClass = "table-danger";
                                        } else if ("Bientôt échéance".equals(statut)) {
                                            badgeClass = "bg-warning";
                                            rowClass = "table-warning";
                                        } else if ("En cours".equals(statut)) {
                                            badgeClass = "bg-info";
                                            rowClass = "table-info";
                                        } else if ("Retourné en retard".equals(statut)) {
                                            badgeClass = "bg-secondary";
                                        }
                                        
                                        Object joursRetardObj = emprunt.get("joursRetard");
                                        Integer joursRetard = 0;
                                        if (joursRetardObj != null) {
                                            if (joursRetardObj instanceof Number) {
                                                joursRetard = ((Number) joursRetardObj).intValue();
                                            }
                                        }
                                        
                                        Object enCoursObj = emprunt.get("enCours");
                                        boolean enCours = enCoursObj != null && ((Number) enCoursObj).intValue() == 1;
                                    %>
                                    <tr class="<%= rowClass %>" 
                                        data-titre="<%= emprunt.get("titreLivre") != null ? emprunt.get("titreLivre").toString().toLowerCase() : "" %>"
                                        data-exemplaire="<%= emprunt.get("numExemplaire") != null ? emprunt.get("numExemplaire").toString().toLowerCase() : "" %>" 
                                        data-statut="<%= statut %>">
                                        <td>
                                            <code><%= emprunt.get("numExemplaire") %></code>
                                            <% if (enCours) { %>
                                                <br><small class="badge bg-primary">EN COURS</small>
                                            <% } %>
                                        </td>
                                        <td>
                                            <strong><%= emprunt.get("titreLivre") %></strong>
                                            <% if (emprunt.get("edition") != null) { %>
                                                <br><small class="text-muted"><%= emprunt.get("edition") %></small>
                                            <% } %>
                                        </td>
                                        <td><%= emprunt.get("auteur") != null ? emprunt.get("auteur") : "N/A" %></td>
                                        <td><%= emprunt.get("typePret") %></td>
                                        <td><%= emprunt.get("dateEmprunt") %></td>
                                        <td><%= emprunt.get("dateLimite") %></td>
                                        <td>
                                            <% if (emprunt.get("dateRetour") != null) { %>
                                                <%= emprunt.get("dateRetour") %>
                                            <% } else { %>
                                                <span class="text-muted">Non retourné</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if (joursRetard > 0) { %>
                                                <span class="badge bg-danger">+<%= joursRetard %></span>
                                            <% } else if (joursRetard < 0) { %>
                                                <span class="badge bg-success"><%= joursRetard %></span>
                                            <% } else { %>
                                                <span class="badge bg-secondary">0</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <span class="badge <%= badgeClass %>"><%= statut %></span>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                        <div class="alert alert-info" role="alert">
                            <i class="bi bi-info-circle"></i> Aucun emprunt dans votre historique.
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Fonctions de filtrage
        function filtrerHistorique() {
            var filterTitre = document.getElementById('filterTitre').value.toLowerCase();
            var filterExemplaire = document.getElementById('filterExemplaire').value.toLowerCase();
            var filterStatut = document.getElementById('filterStatut').value;
            
            var table = document.getElementById('tableHistorique');
            var rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
            
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                var titre = row.getAttribute('data-titre');
                var exemplaire = row.getAttribute('data-exemplaire');
                var statut = row.getAttribute('data-statut');
                
                var showRow = true;
                
                if (filterTitre && !titre.includes(filterTitre)) {
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
            document.getElementById('filterTitre').value = '';
            document.getElementById('filterExemplaire').value = '';
            document.getElementById('filterStatut').value = '';
            
            var table = document.getElementById('tableHistorique');
            var rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
            
            for (var i = 0; i < rows.length; i++) {
                rows[i].style.display = '';
            }
        }
        
        document.getElementById('filterTitre').addEventListener('input', function() {
            if (this.value.length > 2) {
                filtrerHistorique();
            } else if (this.value.length === 0) {
                resetFiltres();
            }
        });
        
        document.getElementById('filterExemplaire').addEventListener('input', function() {
            if (this.value.length > 2) {
                filtrerHistorique();
            } else if (this.value.length === 0) {
                resetFiltres();
            }
        });
        
        document.getElementById('filterStatut').addEventListener('change', filtrerHistorique);
    </script>
</body>
</html>