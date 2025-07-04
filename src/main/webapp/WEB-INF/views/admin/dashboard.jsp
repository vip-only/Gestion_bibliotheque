<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Admin - Bibliothèque</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <span class="navbar-brand">🏛️ Admin - Dashboard</span>
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
        
        <!-- Ajouter après les messages d'alerte et avant la card -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="bi bi-search"></i>
                                    </span>
                                    <input type="text" 
                                           class="form-control" 
                                           id="rechercheInput" 
                                           placeholder="🔍 Rechercher par titre, auteur, genre, édition ou maison d'édition..."
                                           autocomplete="off">
                                    <button class="btn btn-outline-secondary" type="button" id="btnEffacerRecherche">
                                        <i class="bi bi-x-circle"></i> Effacer
                                    </button>
                                </div>
                                <small class="form-text text-muted">
                                    Tapez au moins 2 caractères pour commencer la recherche
                                </small>
                            </div>
                            <div class="col-md-4 text-end">
                                <div id="resultatsRecherche" class="text-muted">
                                    <span id="nombreResultats">Tous les livres affichés</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <div>
                            <h5 class="card-title mb-0">📚 Exemplaires Disponibles par Livre</h5>
                            <small class="text-muted">Système de vérification des quotas et pénalités activé</small>
                        </div>
                        <div>
                            <span id="indicateurFiltre" class="badge bg-info d-none">
                                <i class="bi bi-funnel"></i> Filtré
                            </span>
                        </div>
                    </div>
                    <div class="card-body">
                        <div id="aucunResultat" class="alert alert-warning d-none" role="alert">
                            <i class="bi bi-search"></i> 
                            <strong>Aucun livre trouvé</strong> pour votre recherche "<span id="termeRecherche"></span>".
                            <br>
                            <small>Essayez avec d'autres mots-clés ou <button type="button" class="btn btn-link p-0" onclick="effacerRecherche()">effacez la recherche</button>.</small>
                        </div>
                        
                        <% 
                        List<Map<String, Object>> exemplaires = (List<Map<String, Object>>) request.getAttribute("exemplairesDisponibles");
                        if (exemplaires != null && !exemplaires.isEmpty()) {
                        %>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover" id="tableLivres">
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
                                <tbody id="tbodyLivres">
                                    <% for (Map<String, Object> livre : exemplaires) { %>
                                    <tr class="livre-row" 
                                        data-titre="<%= livre.get("titre") != null ? livre.get("titre").toString().toLowerCase() : "" %>"
                                        data-auteur="<%= livre.get("auteur") != null ? livre.get("auteur").toString().toLowerCase() : "" %>"
                                        data-genre="<%= livre.get("genre") != null ? livre.get("genre").toString().toLowerCase() : "" %>"
                                        data-edition="<%= livre.get("edition") != null ? livre.get("edition").toString().toLowerCase() : "" %>"
                                        data-maison="<%= livre.get("maisonEdition") != null ? livre.get("maisonEdition").toString().toLowerCase() : "" %>">
                                        <td>
                                            <strong class="livre-titre"><%= livre.get("titre") != null ? livre.get("titre") : "N/A" %></strong>
                                            <% if (livre.get("ageMinimum") != null) { %>
                                                <br><small class="text-warning">⚠️ Âge min: <%= livre.get("ageMinimum") %> ans</small>
                                            <% } %>
                                        </td>
                                        <td class="livre-auteur"><%= livre.get("auteur") != null ? livre.get("auteur") : "N/A" %></td>
                                        <td class="livre-genre"><%= livre.get("genre") != null ? livre.get("genre") : "N/A" %></td>
                                        <td class="livre-edition"><%= livre.get("edition") != null ? livre.get("edition") : "N/A" %></td>
                                        <td class="livre-maison"><%= livre.get("maisonEdition") != null ? livre.get("maisonEdition") : "N/A" %></td>
                                        <td><span class="badge bg-success"><%= livre.get("nombreExemplaires") %></span></td>
                                        <td><small class="text-muted"><%= livre.get("listeExemplaires") != null ? livre.get("listeExemplaires") : "N/A" %></small></td>
                                        <td>
                                            <button type="button" class="btn btn-dark btn-sm" 
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
        
        const rechercheInput = document.getElementById('rechercheInput');
        const btnEffacer = document.getElementById('btnEffacerRecherche');
        const tableLivres = document.getElementById('tableLivres');
        const tbodyLivres = document.getElementById('tbodyLivres');
        const aucunResultat = document.getElementById('aucunResultat');
        const termeRecherche = document.getElementById('termeRecherche');
        const nombreResultats = document.getElementById('nombreResultats');
        const indicateurFiltre = document.getElementById('indicateurFiltre');
        
        let timeoutId;
        const DELAI_RECHERCHE = 300; // milliseconds
        
        function filtrerLivres(terme) {
            if (!tbodyLivres) return;
            
            const lignes = tbodyLivres.querySelectorAll('.livre-row');
            let compteurVisible = 0;
            
            if (terme.length < 2) {
                lignes.forEach(ligne => {
                    ligne.style.display = '';
                    compteurVisible++;
                });
                
                if (aucunResultat) aucunResultat.classList.add('d-none');
                if (tableLivres) tableLivres.style.display = '';
                
                if (nombreResultats) nombreResultats.textContent = 'Tous les livres affichés';
                if (indicateurFiltre) indicateurFiltre.classList.add('d-none');
                
                return;
            }
            
            const termeNormalise = terme.toLowerCase().trim();
            
            lignes.forEach(ligne => {
                const titre = ligne.getAttribute('data-titre') || '';
                const auteur = ligne.getAttribute('data-auteur') || '';
                const genre = ligne.getAttribute('data-genre') || '';
                const edition = ligne.getAttribute('data-edition') || '';
                const maison = ligne.getAttribute('data-maison') || '';
                
                // Recherche dans tous les champs
                const contientTerme = titre.includes(termeNormalise) ||
                                     auteur.includes(termeNormalise) ||
                                     genre.includes(termeNormalise) ||
                                     edition.includes(termeNormalise) ||
                                     maison.includes(termeNormalise);
                
                if (contientTerme) {
                    ligne.style.display = '';
                    compteurVisible++;
                } else {
                    ligne.style.display = 'none';
                }
            });
            
            // Gestion de l'affichage des résultats
            if (compteurVisible === 0) {
                // Aucun résultat trouvé
                if (tableLivres) tableLivres.style.display = 'none';
                if (aucunResultat) {
                    aucunResultat.classList.remove('d-none');
                    if (termeRecherche) termeRecherche.textContent = terme;
                }
                if (nombreResultats) nombreResultats.textContent = 'Aucun résultat';
            } else {
                // Résultats trouvés
                if (tableLivres) tableLivres.style.display = '';
                if (aucunResultat) aucunResultat.classList.add('d-none');
                if (nombreResultats) {
                    nombreResultats.textContent = `${compteurVisible} livre${compteurVisible > 1 ? 's' : ''} trouvé${compteurVisible > 1 ? 's' : ''}`;
                }
            }
            
            // Afficher l'indicateur de filtrage
            if (indicateurFiltre) indicateurFiltre.classList.remove('d-none');
        }
        
        // Fonction pour effacer la recherche
        function effacerRecherche() {
            if (rechercheInput) rechercheInput.value = '';
            filtrerLivres('');
        }
        
        // Écouteur d'événement pour la saisie (avec debouncing)
        if (rechercheInput) {
            rechercheInput.addEventListener('input', function(e) {
                const terme = e.target.value;
                
                // Annuler le timeout précédent
                if (timeoutId) {
                    clearTimeout(timeoutId);
                }
                
                // Définir un nouveau timeout
                timeoutId = setTimeout(() => {
                    filtrerLivres(terme);
                }, DELAI_RECHERCHE);
            });
            
            // Recherche en temps réel pour les caractères spéciaux
            rechercheInput.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    effacerRecherche();
                }
            });
        }
        
        // Écouteur pour le bouton effacer
        if (btnEffacer) {
            btnEffacer.addEventListener('click', effacerRecherche);
        }
        
        // Fonction globale pour le lien dans le message "aucun résultat"
        window.effacerRecherche = effacerRecherche;
        
        // Initialisation : s'assurer que tous les livres sont visibles au chargement
        document.addEventListener('DOMContentLoaded', function() {
            if (nombreResultats) {
                const totalLivres = document.querySelectorAll('.livre-row').length;
                nombreResultats.textContent = `${totalLivres} livre${totalLivres > 1 ? 's' : ''} disponible${totalLivres > 1 ? 's' : ''}`;
            }
        });
    </script>
</body>
</html>