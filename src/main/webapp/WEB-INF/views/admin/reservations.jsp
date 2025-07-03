<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion des Réservations - Bibliothèque</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <span class="navbar-brand">🏛️ Admin - Gestion des Réservations</span>
            <div class="navbar-nav ms-auto">
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-outline-light btn-sm me-2">📚 Emprunts</a>
                <a href="<%= request.getContextPath() %>/admin/retours" class="btn btn-outline-light btn-sm me-2">🔄 Retours</a>
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
                                    <option value="En retard de récupération">En retard de récupération</option>
                                    <option value="À récupérer bientôt">À récupérer bientôt</option>
                                    <option value="En attente">En attente</option>
                                </select>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-12">
                                <button type="button" class="btn btn-primary" onclick="filtrerReservations()">
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
        
        <!-- Liste des réservations en cours -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">📋 Réservations en cours</h5>
                        <small class="text-muted">Livres réservés en attente de récupération</small>
                    </div>
                    <div class="card-body">
                        <% 
                        List<Map<String, Object>> reservations = (List<Map<String, Object>>) request.getAttribute("reservationsEnCours");
                        if (reservations != null && !reservations.isEmpty()) {
                        %>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover" id="tableReservations">
                                <thead class="table-primary">
                                    <tr>
                                        <th>Adhérent</th>
                                        <th>Profil</th>
                                        <th>Exemplaire</th>
                                        <th>Livre</th>
                                        <th>Auteur</th>
                                        <th>Date réservation</th>
                                        <th>Date récupération</th>
                                        <th>Date limite retour</th>
                                        <th>Retard (jours)</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Map<String, Object> reservation : reservations) { 
                                        String statut = (String) reservation.get("statut");
                                        String badgeClass = "bg-success";
                                        String rowClass = "";
                                        
                                        if ("En retard de récupération".equals(statut)) {
                                            badgeClass = "bg-danger";
                                            rowClass = "table-danger";
                                        } else if ("À récupérer bientôt".equals(statut)) {
                                            badgeClass = "bg-warning";
                                            rowClass = "table-warning";
                                        }
                                        
                                        Object joursRetardObj = reservation.get("joursRetard");
                                        Integer joursRetard = 0;
                                        if (joursRetardObj != null) {
                                            if (joursRetardObj instanceof Number) {
                                                joursRetard = ((Number) joursRetardObj).intValue();
                                            }
                                        }
                                    %>
                                    <tr class="<%= rowClass %>" 
                                        data-adherent="<%= reservation.get("nomAdherent") %>" 
                                        data-exemplaire="<%= reservation.get("numExemplaire") %>" 
                                        data-statut="<%= statut %>">
                                        <td>
                                            <strong><%= reservation.get("nomAdherent") %></strong><br>
                                            <small class="text-muted"><%= reservation.get("emailAdherent") %></small>
                                        </td>
                                        <td><%= reservation.get("profilAdherent") %></td>
                                        <td><code><%= reservation.get("numExemplaire") %></code></td>
                                        <td>
                                            <strong><%= reservation.get("titreLivre") %></strong>
                                            <% if (reservation.get("edition") != null) { %>
                                                <br><small class="text-muted"><%= reservation.get("edition") %></small>
                                            <% } %>
                                        </td>
                                        <td><%= reservation.get("auteur") != null ? reservation.get("auteur") : "N/A" %></td>
                                        <td><%= reservation.get("dateEtat") %></td>
                                        <td><%= reservation.get("dateDebut") %></td>
                                        <td><%= reservation.get("dateFin") %></td>
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
                                                    data-bs-target="#confirmerReservationModal"
                                                    data-reservation-id="<%= reservation.get("idReservation") %>"
                                                    data-adherent="<%= reservation.get("nomAdherent") %>"
                                                    data-livre="<%= reservation.get("titreLivre") %>"
                                                    data-exemplaire="<%= reservation.get("numExemplaire") %>"
                                                    title="Confirmer la récupération">
                                                <i class="bi bi-check-circle"></i> Récupéré
                                            </button>
                                            <button type="button" class="btn btn-danger btn-sm" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#annulerReservationModal"
                                                    data-reservation-id="<%= reservation.get("idReservation") %>"
                                                    data-adherent="<%= reservation.get("nomAdherent") %>"
                                                    data-livre="<%= reservation.get("titreLivre") %>"
                                                    title="Annuler la réservation">
                                                <i class="bi bi-x-circle"></i> Annuler
                                            </button>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                        <div class="alert alert-info" role="alert">
                            <i class="bi bi-info-circle"></i> Aucune réservation en cours.
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Modal de confirmation de récupération -->
    <div class="modal fade" id="confirmerReservationModal" tabindex="-1" aria-labelledby="confirmerReservationModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="confirmerReservationModalLabel">📖 Confirmer la récupération</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="<%= request.getContextPath() %>/admin/confirmer-reservation" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="idReservationConfirmer" name="idReservation">
                        
                        <div class="mb-3">
                            <h6>Informations de la réservation :</h6>
                            <ul class="list-unstyled">
                                <li><strong>Adhérent :</strong> <span id="modalAdherentConfirmer"></span></li>
                                <li><strong>Livre :</strong> <span id="modalLivreConfirmer"></span></li>
                                <li><strong>Exemplaire :</strong> <span id="modalExemplaireConfirmer"></span></li>
                            </ul>
                        </div>
                        
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i>
                            Cette action va transformer la réservation en emprunt actif.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-check-circle"></i> Confirmer la récupération
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Modal d'annulation de réservation -->
    <div class="modal fade" id="annulerReservationModal" tabindex="-1" aria-labelledby="annulerReservationModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="annulerReservationModalLabel">❌ Annuler la réservation</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="<%= request.getContextPath() %>/admin/annuler-reservation" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="idReservationAnnuler" name="idReservation">
                        
                        <div class="mb-3">
                            <h6>Informations de la réservation :</h6>
                            <ul class="list-unstyled">
                                <li><strong>Adhérent :</strong> <span id="modalAdherentAnnuler"></span></li>
                                <li><strong>Livre :</strong> <span id="modalLivreAnnuler"></span></li>
                                <li><strong>Exemplaire :</strong> <span id="modalExemplaireAnnuler"></span></li>
                            </ul>
                        </div>
                        
                        <div class="alert alert-warning">
                            <i class="bi bi-exclamation-triangle"></i>
                            <strong>Attention :</strong> Cette action va annuler définitivement la réservation.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Retour</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="bi bi-x-circle"></i> Confirmer l'annulation
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Gestion du modal de confirmation
        document.getElementById('confirmerReservationModal').addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var reservationId = button.getAttribute('data-reservation-id');
            var adherent = button.getAttribute('data-adherent');
            var livre = button.getAttribute('data-livre');
            var exemplaire = button.getAttribute('data-exemplaire');
            
            document.getElementById('idReservationConfirmer').value = reservationId;
            document.getElementById('modalAdherentConfirmer').textContent = adherent;
            document.getElementById('modalLivreConfirmer').textContent = livre;
            document.getElementById('modalExemplaireConfirmer').textContent = exemplaire;
        });
        
        // Gestion du modal d'annulation
        document.getElementById('annulerReservationModal').addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var reservationId = button.getAttribute('data-reservation-id');
            var adherent = button.getAttribute('data-adherent');
            var livre = button.getAttribute('data-livre');
            var exemplaire = button.getAttribute('data-exemplaire');
            
            document.getElementById('idReservationAnnuler').value = reservationId;
            document.getElementById('modalAdherentAnnuler').textContent = adherent;
            document.getElementById('modalLivreAnnuler').textContent = livre;
            document.getElementById('modalExemplaireAnnuler').textContent = exemplaire;
        });
        
        // Fonctions de filtrage
        function filtrerReservations() {
            var filterAdherent = document.getElementById('filterAdherent').value.toLowerCase();
            var filterExemplaire = document.getElementById('filterExemplaire').value.toLowerCase();
            var filterStatut = document.getElementById('filterStatut').value;
            
            var table = document.getElementById('tableReservations');
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
            
            var table = document.getElementById('tableReservations');
            var rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
            
            for (var i = 0; i < rows.length; i++) {
                rows[i].style.display = '';
            }
        }
        
        // Filtrage en temps réel pour l'exemplaire
        document.getElementById('filterExemplaire').addEventListener('input', function() {
            if (this.value.length > 2) {
                filtrerReservations();
            } else if (this.value.length === 0) {
                resetFiltres();
            }
        });
        
        // Filtrage automatique pour les selects
        document.getElementById('filterAdherent').addEventListener('change', filtrerReservations);
        document.getElementById('filterStatut').addEventListener('change', filtrerReservations);
    </script>
</body>
</html>