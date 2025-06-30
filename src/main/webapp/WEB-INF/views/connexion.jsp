<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Connexion - Bibliothèque</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="position-absolute top-0 end-0 m-3">
        <a href="<%= request.getContextPath() %>/auth/authAdmin" class="text-primary text-decoration-none fw-medium">Espace Admin</a>
    </div>
   
    <div class="container-fluid vh-100 d-flex align-items-center justify-content-center">
        <div class="card shadow" style="width: 400px;">
            <div class="card-body p-4">
                <div class="text-center mb-4">
                    <h1 class="h3 text-primary">📚 Bibliothèque</h1>
                    <p class="text-muted">Connectez-vous à votre compte</p>
                </div>
                
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger" role="alert">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>
                
                <% if (request.getAttribute("success") != null) { %>
                    <div class="alert alert-success" role="alert">
                        <%= request.getAttribute("success") %>
                    </div>
                <% } %>
                
                <form action="<%= request.getContextPath() %>/auth/login" method="post">
                    <div class="mb-3">
                        <label for="email" class="form-label">Email:</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="motdepasse" class="form-label">Mot de passe:</label>
                        <input type="password" class="form-control" id="motdepasse" name="motdepasse" required>
                    </div>
                    
                    <button type="submit" class="btn btn-primary w-100">Se connecter</button>
                </form>
                
                <div class="text-center mt-3">
                    <p class="mb-0">Pas encore de compte? <a href="<%= request.getContextPath() %>/auth/register" class="text-primary">S'inscrire</a></p>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>