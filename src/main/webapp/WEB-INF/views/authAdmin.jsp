<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Connexion Admin - Bibliothèque</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="position-absolute top-0 start-0 m-3">
        <a href="<%= request.getContextPath() %>/" class="text-white text-decoration-none">← Retour</a>
    </div>
    
    <div class="container-fluid vh-100 d-flex align-items-center justify-content-center">
        <div class="card shadow" style="width: 400px;">
            <div class="card-body p-4">
                <div class="text-center mb-4">
                    <h1 class="h3 text-primary">🏛️ Espace Admin</h1>
                    <p class="text-muted">Connexion bibliothécaire</p>
                </div>
                
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger" role="alert">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>
                
                <form action="<%= request.getContextPath() %>/auth/loginAdmin" method="post">
                    <div class="mb-3">
                        <label for="nom" class="form-label">Nom:</label>
                        <input type="text" class="form-control" id="nom" name="nom" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="motdepasse" class="form-label">Mot de passe:</label>
                        <input type="password" class="form-control" id="motdepasse" name="motdepasse" required>
                    </div>
                    
                    <button type="submit" class="btn btn-primary w-100">Se connecter</button>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>