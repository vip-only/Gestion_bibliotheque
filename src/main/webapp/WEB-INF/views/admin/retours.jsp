<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion des Retours - Bibliothèque</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <span class="navbar-brand">🏛️ Admin - Gestion des Retours</span>
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
                                    <option value="<%= adherent.get("idAdherent") %>">
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
                                    <option value="En retard">En retard</option>
                                    <option value="Bientôt échéance">Bientôt échéance</option>
                                    <option value="Normal">Normal</option>
                                </select>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-12">
                                <button type="button" class="btn btn-primary" onclick="filtrerEmprunts()">
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
        
        <!-- Liste des emprunts en cours -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">📖 Emprunts en cours</h5>
                        <small class="text-muted">Livres à retourner</small>
                    </div>
                    <div class="card-body">
                        <% 
                        List<Map<String, Object>> emprunts = (List<Map<String, Object>>) request.getAttribute("empruntsEnCours");
                        if (emprunts != null && !emprunts.isEmpty()) {
                        %>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover" id="tableEmprunts">
                                <thead class="table-primary">
                                    <tr>
                                        <th>Adhérent</th>
                                        <th>Profil</th>
                                        <th>Exemplaire</th>
                                        <th>Livre</th>
                                        <th>Auteur</th>
                                        <th>Type prêt</th>
                                        <th>Date emprunt</th>
                                        <th>Date limite</th>
                                        <th>Retard (jours)</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Map<String, Object> emprunt : emprunts) { 
                                        String statut = (String) emprunt.get("statut");
                                        String badgeClass = "bg-success";
                                        if ("En retard".equals(statut)) {
                                            badgeClass = "bg-danger";
                                        } else if ("Bientôt échéance".equals(statut)) {
                                            badgeClass = "bg-warning";
                                        }
                                        
                                        Object joursRetardObj = emprunt.get("joursRetard");
                                        Integer joursRetard = 0;
                                        if (joursRetardObj != null) {
                                            if (joursRetardObj instanceof Number) {
                                                joursRetard = ((Number) joursRetardObj).intValue();
                                            }
                                        }
                                    %>
                                    <tr data-adherent="<%= emprunt.get("nomAdherent") %>" 
                                        data-exemplaire="<%= emprunt.get("numExemplaire") %>" 
                                        data-statut="<%= statut %>">
                                        <td>
                                            <strong><%= emprunt.get("nomAdherent") %></strong><br>
                                            <small class="text-muted"><%= emprunt.get("emailAdherent") %></small>
                                        </td>
                                        <td><%= emprunt.get("profilAdherent") %></td>
                                        <td><code><%= emprunt.get("numExemplaire") %></code></td>
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
                                                    data-bs-target="#retourModal"
                                                    data-emprunt-id="<%= emprunt.get("idAdherentExemplaire") %>"
                                                    data-adherent="<%= emprunt.get("nomAdherent") %>"
                                                    data-livre="<%= emprunt.get("titreLivre") %>"
                                                    data-exemplaire="<%= emprunt.get("numExemplaire") %>"
                                                    data-retard="<%= joursRetard %>">
                                                <i class="bi bi-check-circle"></i> Retourner
                                            </button>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                        <div class="alert alert-info" role="alert">
                            <i class="bi bi-info-circle"></i> Aucun emprunt en cours.
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Modal de confirmation de retour -->
    <div class="modal fade" id="retourModal" tabindex="-1" aria-labelledby="retourModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="retourModalLabel">📖 Confirmer le retour</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="<%= request.getContextPath() %>/admin/retourner" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="idAdherentExemplaire" name="idAdherentExemplaire">
                        
                        <div class="mb-3">
                            <h6>Informations de l'emprunt :</h6>
                            <ul class="list-unstyled">
                                <li><strong>Adhérent :</strong> <span id="modalAdherent"></span></li>
                                <li><strong>Livre :</strong> <span id="modalLivre"></span></li>
                                <li><strong>Exemplaire :</strong> <span id="modalExemplaire"></span></li>
                                <li><strong>Retard :</strong> <span id="modalRetard"></span></li>
                            </ul>
                        </div>
                        
                        <div id="alerteRetard" class="alert alert-warning" style="display: none;">
                            <i class="bi bi-exclamation-triangle"></i>
                            <strong>Attention :</strong> Ce retour est en retard. Une pénalité sera automatiquement appliquée.
                        </div>
                        
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i>
                            La date de retour sera ajustée automatiquement si aujourd'hui est un jour férié.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-check-circle"></i> Confirmer le retour
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Gestion du modal de retour
        document.getElementById('retourModal').addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var empruntId = button.getAttribute('data-emprunt-id');
            var adherent = button.getAttribute('data-adherent');
            var livre = button.getAttribute('data-livre');
            var exemplaire = button.getAttribute('data-exemplaire');
            var retard = parseInt(button.getAttribute('data-retard'));
            
            document.getElementById('idAdherentExemplaire').value = empruntId;
            document.getElementById('modalAdherent').textContent = adherent;
            document.getElementById('modalLivre').textContent = livre;
            document.getElementById('modalExemplaire').textContent = exemplaire;
            
            var modalRetard = document.getElementById('modalRetard');
            var alerteRetard = document.getElementById('alerteRetard');
            
            if (retard > 0) {
                modalRetard.innerHTML = '<span class="badge bg-danger">+' + retard + ' jour(s)</span>';
                alerteRetard.style.display = 'block';
            } else if (retard < 0) {
                modalRetard.innerHTML = '<span class="badge bg-success">' + retard + ' jour(s)</span>';
                alerteRetard.style.display = 'none';
            } else {
                modalRetard.innerHTML = '<span class="badge bg-success">Aucun retard</span>';
                alerteRetard.style.display = 'none';
            }
        });
        
        // Fonctions de filtrage
        function filtrerEmprunts() {
            var filterAdherent = document.getElementById('filterAdherent').value.toLowerCase();
            var filterExemplaire = document.getElementById('filterExemplaire').value.toLowerCase();
            var filterStatut = document.getElementById('filterStatut').value;
            
            var table = document.getElementById('tableEmprunts');
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
            
            var table = document.getElementById('tableEmprunts');
            var rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
            
            for (var i = 0; i < rows.length; i++) {
                rows[i].style.display = '';
            }
        }
        
        // Filtrage en temps réel pour l'exemplaire
        document.getElementById('filterExemplaire').addEventListener('input', function() {
            if (this.value.length > 2) {
                filtrerEmprunts();
            } else if (this.value.length === 0) {
                resetFiltres();
            }
        });
        
        // Filtrage automatique pour les selects
        document.getElementById('filterAdherent').addEventListener('change', filtrerEmprunts);
        document.getElementById('filterStatut').addEventListener('change', filtrerEmprunts);
    </script>
</body>
</html>