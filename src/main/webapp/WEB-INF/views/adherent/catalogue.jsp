<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>Catalogue - Bibliothèque</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <span class="navbar-brand">📚 Catalogue - Bibliothèque</span>
            <div class="navbar-nav ms-auto">
                <span class="navbar-text me-3">Bonjour, ${adherent.nom}</span>
                <a href="<%= request.getContextPath() %>/auth/logout" class="btn btn-outline-light btn-sm">Déconnexion</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- Catalogue des livres -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">📖 Catalogue des livres disponibles</h5>
                        <small class="text-muted">Découvrez notre collection</small>
                    </div>
                    <div class="card-body">
                        <% 
                        List<Map<String, Object>> catalogue = (List<Map<String, Object>>) request.getAttribute("catalogue");
                        if (catalogue != null && !catalogue.isEmpty()) {
                        %>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover" id="tableCatalogue">
                                <thead class="table-primary">
                                    <tr>
                                        <th>Titre</th>
                                        <th>Auteur</th>
                                        <th>Genre</th>
                                        <th>Édition</th>
                                        <th>Maison d'édition</th>
                                        <th>Nb Exemplaires</th>
                                        <th>Numéros Exemplaires</th>
                                        <th>Détails</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Map<String, Object> livre : catalogue) { %>
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
                                            <button type="button" class="btn btn-info btn-sm" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#detailModal"
                                                    data-titre="<%= livre.get("titre") %>"
                                                    data-auteur="<%= livre.get("auteur") %>"
                                                    data-genre="<%= livre.get("genre") %>"
                                                    data-tag="<%= livre.get("tag") %>"
                                                    data-edition="<%= livre.get("edition") != null ? livre.get("edition") : "N/A" %>"
                                                    data-maison="<%= livre.get("maisonEdition") %>"
                                                    data-age="<%= livre.get("ageMinimum") %>">
                                                <i class="bi bi-info-circle"></i> Détails
                                            </button>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                        <div class="alert alert-info" role="alert">
                            <i class="bi bi-info-circle"></i> Aucun livre disponible dans le catalogue.
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal de détails -->
    <div class="modal fade" id="detailModal" tabindex="-1" aria-labelledby="detailModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="detailModalLabel">📖 Détails du livre</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6><strong>Informations générales</strong></h6>
                            <ul class="list-unstyled">
                                <li><strong>Titre:</strong> <span id="modalTitre"></span></li>
                                <li><strong>Auteur:</strong> <span id="modalAuteur"></span></li>
                                <li><strong>Genre:</strong> <span id="modalGenre"></span></li>
                                <li><strong>Tag:</strong> <span id="modalTag"></span></li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <h6><strong>Détails techniques</strong></h6>
                            <ul class="list-unstyled">
                                <li><strong>Édition:</strong> <span id="modalEdition"></span></li>
                                <li><strong>Maison d'édition:</strong> <span id="modalMaison"></span></li>
                                <li><strong>Âge minimum:</strong> <span id="modalAge"></span></li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Gestion du modal de détails
        document.getElementById('detailModal').addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            
            document.getElementById('modalTitre').textContent = button.getAttribute('data-titre') || 'N/A';
            document.getElementById('modalAuteur').textContent = button.getAttribute('data-auteur') || 'N/A';
            document.getElementById('modalGenre').textContent = button.getAttribute('data-genre') || 'N/A';
            document.getElementById('modalTag').textContent = button.getAttribute('data-tag') || 'N/A';
            document.getElementById('modalEdition').textContent = button.getAttribute('data-edition') || 'N/A';
            document.getElementById('modalMaison').textContent = button.getAttribute('data-maison') || 'N/A';
            
            var age = button.getAttribute('data-age');
            document.getElementById('modalAge').textContent = age ? age + ' ans' : 'Aucune restriction';
        });
    </script>
</body>
</html>