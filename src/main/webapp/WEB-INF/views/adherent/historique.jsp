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
                                        <th>Actions</th>
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
                                        
                                        Integer idAdherentExemplaire = (Integer) emprunt.get("idAdherentExemplaire");
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
                                        <td>
                                            <% if (enCours) { %>
                                                <button type="button" class="btn btn-sm btn-outline-primary" 
                                                        data-id-adherent-exemplaire="<%= idAdherentExemplaire %>"
                                                        data-titre-livre="<%= emprunt.get("titreLivre") != null ? emprunt.get("titreLivre") : "" %>"
                                                        data-num-exemplaire="<%= emprunt.get("numExemplaire") != null ? emprunt.get("numExemplaire") : "" %>"
                                                        onclick="demanderProlongementSafe(this)">
                                                    <i class="bi bi-calendar-plus"></i> Prolonger
                                                </button>
                                            <% } else { %>
                                                <span class="text-muted">-</span>
                                            <% } %>
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
    
    <!-- Modal de prolongement -->
    <div class="modal fade" id="prolongementModal" tabindex="-1" aria-labelledby="prolongementModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="prolongementModalLabel">📅 Demander un prolongement</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="prolongementInfo">
                        <!-- Les informations du livre seront injectées ici -->
                    </div>
                    
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle"></i> 
                        Votre demande sera traitée par la bibliothèque.
                    </div>
                    
                    <div id="prolongementMessage"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-primary" id="btnConfirmerProlongement">
                        <i class="bi bi-send"></i> Envoyer la demande
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let idAdherentExemplaireActuel = null;
        
        // Fonction sécurisée pour demander un prolongement
        function demanderProlongementSafe(button) {
            const idAdherentExemplaire = button.getAttribute('data-id-adherent-exemplaire');
            const titreLivre = button.getAttribute('data-titre-livre');
            const numExemplaire = button.getAttribute('data-num-exemplaire');
            
            idAdherentExemplaireActuel = parseInt(idAdherentExemplaire);
            
            // Remplir les informations du livre dans le modal (pas de problème d'échappement)
            document.getElementById('prolongementInfo').innerHTML = `
                <div class="card bg-light">
                    <div class="card-body">
                        <h6 class="card-title">📚 ${titreLivre}</h6>
                        <p class="card-text">
                            <strong>Exemplaire:</strong> <code>${numExemplaire}</code>
                        </p>
                    </div>
                </div>
            `;
            
            // Réinitialiser le message
            document.getElementById('prolongementMessage').innerHTML = '';
            
            // Réactiver le bouton
            const btnConfirmer = document.getElementById('btnConfirmerProlongement');
            btnConfirmer.disabled = false;
            btnConfirmer.innerHTML = '<i class="bi bi-send"></i> Envoyer la demande';
            
            // Afficher le modal
            new bootstrap.Modal(document.getElementById('prolongementModal')).show();
        }
        
        // Garder l'ancienne fonction pour compatibilité (mais la rendre plus sûre)
        function demanderProlongement(idAdherentExemplaire, titreLivre, numExemplaire) {
            idAdherentExemplaireActuel = idAdherentExemplaire;
            
            // Nettoyer les chaînes pour éviter les erreurs JavaScript
            const titreLivreClean = (titreLivre || '').replace(/['"]/g, '');
            const numExemplaireClean = (numExemplaire || '').replace(/['"]/g, '');
            
            document.getElementById('prolongementInfo').innerHTML = `
                <div class="card bg-light">
                    <div class="card-body">
                        <h6 class="card-title">📚 ${titreLivreClean}</h6>
                        <p class="card-text">
                            <strong>Exemplaire:</strong> <code>${numExemplaireClean}</code>
                        </p>
                    </div>
                </div>
            `;
            
            document.getElementById('prolongementMessage').innerHTML = '';
            
            const btnConfirmer = document.getElementById('btnConfirmerProlongement');
            btnConfirmer.disabled = false;
            btnConfirmer.innerHTML = '<i class="bi bi-send"></i> Envoyer la demande';
            
            new bootstrap.Modal(document.getElementById('prolongementModal')).show();
        }
        
        // Gestionnaire pour confirmer le prolongement
        document.getElementById('btnConfirmerProlongement').addEventListener('click', function() {
            const btnConfirmer = this;
            const messageDiv = document.getElementById('prolongementMessage');
            
            // Vérifier qu'un emprunt est sélectionné
            if (!idAdherentExemplaireActuel) {
                messageDiv.innerHTML = `
                    <div class="alert alert-danger">
                        <i class="bi bi-exclamation-triangle"></i> Erreur: Aucun emprunt sélectionné.
                    </div>
                `;
                return;
            }
            
            // Désactiver le bouton et afficher le loader
            btnConfirmer.disabled = true;
            btnConfirmer.innerHTML = '<i class="bi bi-hourglass-split"></i> Envoi en cours...';
            
            // Envoyer la demande avec les bons headers
            fetch('<%= request.getContextPath() %>/adherent/prolongement', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Accept': 'application/json'
                },
                body: 'idAdherentExemplaire=' + encodeURIComponent(idAdherentExemplaireActuel)
            })
            .then(response => {
                console.log('Response status:', response.status);
                console.log('Response headers:', response.headers);
                
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                
                return response.json();
            })
            .then(data => {
                console.log('Data received:', data);
                
                if (data.success) {
                    messageDiv.innerHTML = `
                        <div class="alert alert-success">
                            <i class="bi bi-check-circle"></i> ${data.message}
                        </div>
                    `;
                    
                    // Fermer le modal après 2 secondes et recharger la page
                    setTimeout(() => {
                        bootstrap.Modal.getInstance(document.getElementById('prolongementModal')).hide();
                        location.reload();
                    }, 2000);
                } else {
                    messageDiv.innerHTML = `
                        <div class="alert alert-danger">
                            <i class="bi bi-exclamation-triangle"></i> ${data.message}
                        </div>
                    `;
                    
                    // Réactiver le bouton
                    btnConfirmer.disabled = false;
                    btnConfirmer.innerHTML = '<i class="bi bi-send"></i> Envoyer la demande';
                }
            })
            .catch(error => {
                console.error('Error details:', error);
                messageDiv.innerHTML = `
                    <div class="alert alert-danger">
                        <i class="bi bi-exclamation-triangle"></i> Erreur de connexion. Veuillez réessayer.
                    </div>
                `;
                
                // Réactiver le bouton
                btnConfirmer.disabled = false;
                btnConfirmer.innerHTML = '<i class="bi bi-send"></i> Envoyer la demande';
            });
        });
        
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