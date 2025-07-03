<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Admin - Bibliothèque</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <span class="navbar-brand">🏛️ Admin - Bibliothèque</span>
            <div class="navbar-nav ms-auto">
                <a href="<%= request.getContextPath() %>/admin/reservations" class="btn btn-outline-light btn-sm me-2">📋 Réservations</a>
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
        
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">📚 Exemplaires Disponibles par Livre</h5>
                        <small class="text-muted">Système de vérification des quotas et pénalités activé</small>
                    </div>
                    <div class="card-body">
                        <% 
                        List<Map<String, Object>> exemplaires = (List<Map<String, Object>>) request.getAttribute("exemplairesDisponibles");
                        if (exemplaires != null && !exemplaires.isEmpty()) {
                        %>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead class="table-primary">
                                    <tr>
                                        <th>Titre</th>
                                        <th>Auteur</th>
                                        <th>Genre</th>
                                        <th>Edition</th>
                                        <th>Maison d'édition</th>
                                        <th>Nb Exemplaires</th>
                                        <th>Numéros Exemplaires</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Map<String, Object> livre : exemplaires) { %>
                                    <tr>
                                        <td>
                                            <strong><%= livre.get("titre") != null ? livre.get("titre") : "N/A" %></strong>
                                            <% if (livre.get("ageMinimum") != null) { %>
                                                <br><small class="text-warning">⚠️ Âge min: <%= livre.get("ageMinimum") %> ans</small>
                                            <% } %>
                                        </td>
                                        <td><%= livre.get("auteur") != null ? livre.get("auteur") : "N/A" %></td>
                                        <td><%= livre.get("genre") != null ? livre.get("genre") : "N/A" %></td>
                                        <td><%= livre.get("edition") != null ? livre.get("edition") : "N/A" %></td>
                                        <td><%= livre.get("maisonEdition") != null ? livre.get("maisonEdition") : "N/A" %></td>
                                        <td><span class="badge bg-success"><%= livre.get("nombreExemplaires") %></span></td>
                                        <td><small class="text-muted"><%= livre.get("listeExemplaires") != null ? livre.get("listeExemplaires") : "N/A" %></small></td>
                                        <td>
                                            <button type="button" class="btn btn-primary btn-sm" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#empruntModal"
                                                    data-livre-id="<%= livre.get("idLivre") %>"
                                                    data-livre-titre="<%= livre.get("titre") %>"
                                                    data-exemplaires="<%= livre.get("listeExemplaires") %>">
                                                📖 Emprunter
                                            </button>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                        <div class="alert alert-info" role="alert">
                            <i class="bi bi-info-circle"></i> Aucun exemplaire disponible pour le moment.
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Modal d'emprunt -->
    <div class="modal fade" id="empruntModal" tabindex="-1" aria-labelledby="empruntModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="empruntModalLabel">📖 Nouvel Emprunt</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="<%= request.getContextPath() %>/admin/emprunter" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label"><strong>Livre sélectionné:</strong></label>
                            <p id="livreSelectionne" class="text-primary"></p>
                            <input type="hidden" id="idLivre" name="idLivre">
                        </div>
                        
                        <div class="mb-3">
                            <label for="numExemplaire" class="form-label">Exemplaire:</label>
                            <select class="form-select" id="numExemplaire" name="numExemplaire" required>
                                <option value="">Sélectionner un exemplaire</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="idAdherent" class="form-label">Adhérent disponible pour emprunt:</label>
                            <select class="form-select" id="idAdherent" name="idAdherent" required>
                                <option value="">Sélectionner un adhérent</option>
                                <% 
                                List<Map<String, Object>> adherents = (List<Map<String, Object>>) request.getAttribute("adherents");
                                if (adherents != null) {
                                    for (Map<String, Object> adherent : adherents) { 
                                        String statut = (String) adherent.get("statut");
                                        String quotaInfo = "";
                                        if (adherent.get("quotaMax") != null && adherent.get("empruntsActuels") != null) {
                                            quotaInfo = " [" + adherent.get("empruntsActuels") + "/" + adherent.get("quotaMax") + "]";
                                        }
                                        boolean isPenalise = statut != null && statut.contains("Pénalisé");
                                %>
                                <option value="<%= adherent.get("idAdherent") %>" 
                                        <%= isPenalise ? "disabled class=\"text-danger\"" : "" %>>
                                    <%= adherent.get("nom") %> (<%= adherent.get("email") %>) - <%= adherent.get("profil") %><%= quotaInfo %>
                                    <% if (isPenalise) { %> - <%= statut %><% } %>
                                </option>
                                <% 
                                    }
                                } 
                                %>
                            </select>
                            <small class="form-text text-muted">
                                Les adhérents pénalisés ou ayant atteint leur quota sont désactivés
                            </small>
                        </div>
                        
                        <div class="mb-3">
                            <label for="idTypePret" class="form-label">Type de prêt:</label>
                            <select class="form-select" id="idTypePret" name="idTypePret" required>
                                <option value="">Sélectionner un type</option>
                                <% 
                                List<Map<String, Object>> typesPret = (List<Map<String, Object>>) request.getAttribute("typesPret");
                                if (typesPret != null) {
                                    for (Map<String, Object> type : typesPret) { 
                                %>
                                <option value="<%= type.get("idTypePret") %>">
                                    <%= type.get("libelle") %>
                                </option>
                                <% 
                                    }
                                } 
                                %>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-primary">Confirmer l'emprunt</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Gestion du modal d'emprunt
        document.getElementById('empruntModal').addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var livreId = button.getAttribute('data-livre-id');
            var livreTitre = button.getAttribute('data-livre-titre');
            var exemplaires = button.getAttribute('data-exemplaires');
            
            // Mise à jour du titre du livre
            document.getElementById('livreSelectionne').textContent = livreTitre;
            document.getElementById('idLivre').value = livreId;
            
            // Mise à jour de la liste des exemplaires
            var selectExemplaire = document.getElementById('numExemplaire');
            selectExemplaire.innerHTML = '<option value="">Sélectionner un exemplaire</option>';
            
            if (exemplaires && exemplaires !== 'N/A') {
                var listeExemplaires = exemplaires.split(', ');
                listeExemplaires.forEach(function(exemplaire) {
                    var option = document.createElement('option');
                    option.value = exemplaire.trim();
                    option.textContent = exemplaire.trim();
                    selectExemplaire.appendChild(option);
                });
            }
        });
    </script>
</body>
</html>