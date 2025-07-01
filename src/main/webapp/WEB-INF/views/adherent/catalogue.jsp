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
        <!-- Filtres de recherche -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h6 class="card-title mb-0">🔍 Filtres de recherche</h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <label for="filterTitre" class="form-label">Rechercher par titre:</label>
                                <input type="text" class="form-control" id="filterTitre" placeholder="Rechercher un titre...">
                            </div>
                            <div class="col-md-6">
                                <label for="filterAuteur" class="form-label">Rechercher par auteur:</label>
                                <select class="form-select" id="filterAuteur">
                                    <option value="">Tous les auteurs</option>
                                    <% 
                                    List<String> auteurs = (List<String>) request.getAttribute("auteurs");
                                    if (auteurs != null) {
                                        for (String auteur : auteurs) { 
                                    %>
                                    <option value="<%= auteur %>"><%= auteur %></option>
                                    <% 
                                        }
                                    } 
                                    %>
                                </select>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-md-4">
                                <label for="filterGenre" class="form-label">Filtrer par genre:</label>
                                <select class="form-select" id="filterGenre">
                                    <option value="">Tous les genres</option>
                                    <% 
                                    List<String> genres = (List<String>) request.getAttribute("genres");
                                    if (genres != null) {
                                        for (String genre : genres) { 
                                    %>
                                    <option value="<%= genre %>"><%= genre %></option>
                                    <% 
                                        }
                                    } 
                                    %>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="filterTag" class="form-label">Filtrer par tag:</label>
                                <select class="form-select" id="filterTag">
                                    <option value="">Tous les tags</option>
                                    <% 
                                    List<String> tags = (List<String>) request.getAttribute("tags");
                                    if (tags != null) {
                                        for (String tag : tags) { 
                                    %>
                                    <option value="<%= tag %>"><%= tag %></option>
                                    <% 
                                        }
                                    } 
                                    %>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="filterMaison" class="form-label">Filtrer par maison d'édition:</label>
                                <select class="form-select" id="filterMaison">
                                    <option value="">Toutes les maisons</option>
                                    <% 
                                    List<String> maisonsEdition = (List<String>) request.getAttribute("maisonsEdition");
                                    if (maisonsEdition != null) {
                                        for (String maison : maisonsEdition) { 
                                    %>
                                    <option value="<%= maison %>"><%= maison %></option>
                                    <% 
                                        }
                                    } 
                                    %>
                                </select>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-12">
                                <button type="button" class="btn btn-primary" onclick="filtrerCatalogue()">
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
                                        <th>Tag</th>
                                        <th>Édition</th>
                                        <th>Maison d'édition</th>
                                        <th>Nb Exemplaires</th>
                                        <th>Numéros Exemplaires</th>
                                        <th>Détails</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Map<String, Object> livre : catalogue) { %>
                                    <tr data-titre="<%= livre.get("titre") != null ? livre.get("titre").toString().toLowerCase() : "" %>"
                                        data-auteur="<%= livre.get("auteur") != null ? livre.get("auteur").toString().toLowerCase() : "" %>"
                                        data-genre="<%= livre.get("genre") != null ? livre.get("genre").toString().toLowerCase() : "" %>"
                                        data-tag="<%= livre.get("tag") != null ? livre.get("tag").toString().toLowerCase() : "" %>"
                                        data-maison="<%= livre.get("maisonEdition") != null ? livre.get("maisonEdition").toString().toLowerCase() : "" %>">
                                        <td>
                                            <strong><%= livre.get("titre") != null ? livre.get("titre") : "N/A" %></strong>
                                            <% if (livre.get("ageMinimum") != null) { %>
                                                <br><small class="text-warning">⚠️ Âge min: <%= livre.get("ageMinimum") %> ans</small>
                                            <% } %>
                                        </td>
                                        <td><%= livre.get("auteur") != null ? livre.get("auteur") : "N/A" %></td>
                                        <td><%= livre.get("genre") != null ? livre.get("genre") : "N/A" %></td>
                                        <td><%= livre.get("tag") != null ? livre.get("tag") : "N/A" %></td>
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

        // Fonctions de filtrage (inspirées de retours.jsp)
        function filtrerCatalogue() {
            var filterTitre = document.getElementById('filterTitre').value.toLowerCase();
            var filterAuteur = document.getElementById('filterAuteur').value.toLowerCase();
            var filterGenre = document.getElementById('filterGenre').value.toLowerCase();
            var filterTag = document.getElementById('filterTag').value.toLowerCase();
            var filterMaison = document.getElementById('filterMaison').value.toLowerCase();
            
            var table = document.getElementById('tableCatalogue');
            var rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
            var visibleCount = 0;
            
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                var titre = row.getAttribute('data-titre');
                var auteur = row.getAttribute('data-auteur');
                var genre = row.getAttribute('data-genre');
                var tag = row.getAttribute('data-tag');
                var maison = row.getAttribute('data-maison');
                
                var showRow = true;
                
                // Filtrage par titre (recherche partielle)
                if (filterTitre && !titre.includes(filterTitre)) {
                    showRow = false;
                }
                
                // Filtrage par auteur (exact)
                if (filterAuteur && auteur !== filterAuteur) {
                    showRow = false;
                }
                
                // Filtrage par genre (exact)
                if (filterGenre && genre !== filterGenre) {
                    showRow = false;
                }
                
                // Filtrage par tag (exact)
                if (filterTag && tag !== filterTag) {
                    showRow = false;
                }
                
                // Filtrage par maison d'édition (exact)
                if (filterMaison && maison !== filterMaison) {
                    showRow = false;
                }
                
                row.style.display = showRow ? '' : 'none';
                if (showRow) visibleCount++;
            }
            
            // Optionnel: afficher un message si aucun résultat
            if (visibleCount === 0 && (filterTitre || filterAuteur || filterGenre || filterTag || filterMaison)) {
                console.log('Aucun livre trouvé avec ces critères');
            }
        }

        function resetFiltres() {
            document.getElementById('filterTitre').value = '';
            document.getElementById('filterAuteur').value = '';
            document.getElementById('filterGenre').value = '';
            document.getElementById('filterTag').value = '';
            document.getElementById('filterMaison').value = '';
            
            var table = document.getElementById('tableCatalogue');
            var rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
            
            for (var i = 0; i < rows.length; i++) {
                rows[i].style.display = '';
            }
        }

        // Filtrage en temps réel pour le titre (comme dans retours.jsp)
        document.getElementById('filterTitre').addEventListener('input', function() {
            if (this.value.length > 2) {
                filtrerCatalogue();
            } else if (this.value.length === 0) {
                resetFiltres();
            }
        });

        // Filtrage automatique pour les selects
        document.getElementById('filterAuteur').addEventListener('change', filtrerCatalogue);
        document.getElementById('filterGenre').addEventListener('change', filtrerCatalogue);
        document.getElementById('filterTag').addEventListener('change', filtrerCatalogue);
        document.getElementById('filterMaison').addEventListener('change', filtrerCatalogue);
    </script>
</body>
</html>