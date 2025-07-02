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
        <!-- Message de succès/erreur -->
        <div id="messageContainer"></div>

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
                                        <th>Actions</th>
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
                                            <button type="button" class="btn btn-info btn-sm me-1" 
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
                                            <button type="button" class="btn btn-warning btn-sm" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#reservationModal"
                                                    data-livre-titre="<%= livre.get("titre") %>"
                                                    data-exemplaires="<%= livre.get("listeExemplaires") %>">
                                                <i class="bi bi-bookmark"></i> Réserver
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

    <!-- Modal de réservation -->
    <div class="modal fade" id="reservationModal" tabindex="-1" aria-labelledby="reservationModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="reservationModalLabel">📖 Réserver un exemplaire</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label"><strong>Livre sélectionné:</strong></label>
                        <p id="livreSelectionneReservation" class="text-primary"></p>
                    </div>
                    
                    <div class="mb-3">
                        <label for="numExemplaireReservation" class="form-label">Choisir un exemplaire:</label>
                        <select class="form-select" id="numExemplaireReservation" required>
                            <option value="">Sélectionner un exemplaire</option>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label for="dateReservation" class="form-label">Date de récupération souhaitée:</label>
                        <input type="date" class="form-control" id="dateReservation" required>
                        <div class="form-text">Choisissez la date à laquelle vous souhaitez récupérer le livre</div>
                    </div>
                    
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle"></i> 
                        La durée d'emprunt sera calculée automatiquement selon votre profil et le type d'emprunt choisi.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-warning" onclick="confirmerReservation()">
                        <i class="bi bi-bookmark"></i> Confirmer la réservation
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Fonction de confirmation de réservation avec plus de logs
        function confirmerReservation() {
            console.log("=== DEBUT CONFIRMATION RESERVATION ===");
            
            var numExemplaire = document.getElementById('numExemplaireReservation').value;
            var dateReservation = document.getElementById('dateReservation').value;
            
            console.log("Exemplaire sélectionné:", numExemplaire);
            console.log("Date sélectionnée:", dateReservation);
            
            if (!numExemplaire) {
                alert('Veuillez sélectionner un exemplaire');
                return;
            }
            
            if (!dateReservation) {
                alert('Veuillez sélectionner une date de récupération');
                return;
            }
            
            // Vérifier que la date n'est pas dans le passé
            var aujourdhui = new Date();
            var dateChoisie = new Date(dateReservation);
            if (dateChoisie < aujourdhui.setHours(0,0,0,0)) {
                alert('La date de récupération ne peut pas être dans le passé');
                return;
            }
            
            // Désactiver le bouton pour éviter les doubles clics
            var btnConfirmer = document.querySelector('#reservationModal .btn-warning');
            btnConfirmer.disabled = true;
            btnConfirmer.innerHTML = '<i class="bi bi-hourglass-split"></i> Réservation en cours...';
            
            console.log("Envoi de la requête...");
            
            // Envoyer la requête de réservation
            fetch('<%= request.getContextPath() %>/adherent/reserver', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'numExemplaire=' + encodeURIComponent(numExemplaire) + 
                      '&dateReservation=' + encodeURIComponent(dateReservation)
            })
            .then(response => {
                console.log("Réponse reçue, status:", response.status);
                if (!response.ok) {
                    throw new Error('Erreur HTTP: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log("Données reçues:", data);
                
                // Fermer le modal
                var modal = bootstrap.Modal.getInstance(document.getElementById('reservationModal'));
                modal.hide();
                
                // Afficher le message
                afficherMessage(data.success, data.message);
                
                // Réactiver le bouton
                btnConfirmer.disabled = false;
                btnConfirmer.innerHTML = '<i class="bi bi-bookmark"></i> Confirmer la réservation';
                
                if (data.success) {
                    console.log("Réservation réussie !");
                    // Optionnel: recharger la page pour mettre à jour les disponibilités
                    setTimeout(() => {
                        window.location.reload();
                    }, 2000);
                }
            })
            .catch(error => {
                console.error('Erreur complète:', error);
                
                // Message d'erreur plus détaillé
                var errorMessage = 'Erreur lors de la réservation';
                if (error.message && error.message !== 'Failed to fetch') {
                    errorMessage = error.message;
                } else if (error.message === 'Failed to fetch') {
                    errorMessage = '❌ PROBLÈME DE CONNEXION\n\n' +
                                 'Impossible de contacter le serveur.\n' +
                                 '💡 Vérifiez votre connexion internet et réessayez.';
                }
                
                afficherMessage(false, errorMessage);
                
                // Réactiver le bouton
                btnConfirmer.disabled = false;
                btnConfirmer.innerHTML = '<i class="bi bi-bookmark"></i> Confirmer la réservation';
            });
        }

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

        // Gestion du modal de réservation
        document.getElementById('reservationModal').addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var livreTitre = button.getAttribute('data-livre-titre');
            var exemplaires = button.getAttribute('data-exemplaires');
            
            // Mise à jour du titre du livre
            document.getElementById('livreSelectionneReservation').textContent = livreTitre;
            
            // Mise à jour de la liste des exemplaires
            var selectExemplaire = document.getElementById('numExemplaireReservation');
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
            
            // Définir la date minimum à aujourd'hui
            var today = new Date().toISOString().split('T')[0];
            document.getElementById('dateReservation').setAttribute('min', today);
            document.getElementById('dateReservation').value = today;
        });

        // Fonction d'affichage des messages
        function afficherMessage(success, message) {
            var container = document.getElementById('messageContainer');
            var alertClass = success ? 'alert-success' : 'alert-danger';
            var icon = success ? 'bi-check-circle' : 'bi-exclamation-triangle';
            
            // Préserver les retours à la ligne pour les messages d'erreur
            var formattedMessage = message.replace(/\n/g, '<br>');
            
            container.innerHTML = `
                <div class="alert ${alertClass} alert-dismissible fade show" role="alert">
                    <i class="bi ${icon}"></i> ${formattedMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
            
            // Faire défiler vers le haut pour voir le message si c'est une erreur
            if (!success) {
                container.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        }

        // Fonctions de filtrage
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
                
                if (filterTitre && !titre.includes(filterTitre)) {
                    showRow = false;
                }
                
                if (filterAuteur && auteur !== filterAuteur) {
                    showRow = false;
                }
                
                if (filterGenre && genre !== filterGenre) {
                    showRow = false;
                }
                
                if (filterTag && tag !== filterTag) {
                    showRow = false;
                }
                
                if (filterMaison && maison !== filterMaison) {
                    showRow = false;
                }
                
                row.style.display = showRow ? '' : 'none';
                if (showRow) visibleCount++;
            }
            
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

        // Filtrage en temps réel pour le titre
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