<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Connexion - Bibliothèque</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
</head>
<style>
        .admin-link {
            position: absolute;
            top: 20px;
            right: 20px;
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
        }
        .admin-link:hover {
            text-decoration: underline;
        }
    </style>
<body>
     <a href="<%= request.getContextPath() %>/auth/authAdmin" class="admin-link">Espace Admin</a>
   
    <div class="login-container">
        <div class="login-header">
            <h1>Bibliothèque</h1>
            <p>Connectez-vous à votre compte</p>
        </div>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <% if (request.getAttribute("success") != null) { %>
            <div class="success-message">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>
        
        <form action="<%= request.getContextPath() %>/auth/login" method="post">
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
            </div>
            
            <div class="form-group">
                <label for="motdepasse">Mot de passe:</label>
                <input type="password" id="motdepasse" name="motdepasse" required>
            </div>
            
            <button type="submit" class="btn-login">Se connecter</button>
        </form>
        
        <div class="register-link">
            <p>Pas encore de compte? <a href="<%= request.getContextPath() %>/auth/register">S'inscrire</a></p>
        </div>
    </div>
</body>
</html>