-- BIBLIOTHÉCAIRES
INSERT INTO bibliothecaire (nom, motdepasse, adresse, telephone, email)
VALUES 
('Rakoto Fara', 'motdepasse123', 'Lot 112B Ambohijatovo', '0321234567', 'fara@biblio.mg'),
('Rabe Soa', 'admin456', '67 Rue Rainilaiarivony', '0331234567', 'soa@biblio.mg');

-- ÉTATS
INSERT INTO Etat (libelle) VALUES 
('en cours'), 
('accepté'), 
('refusé'), 
('actif'), 
('inactif'), 
('terminé');

-- TYPES DE PRÊT
INSERT INTO TypePret (libelle) VALUES 
('à domicile'), 
('sur place'), 
('numérique');

-- PROFILS
INSERT INTO Profil (libelle) VALUES 
('Étudiant'), 
('Prof'), 
('Pro'), 
('Anonyme');

-- QUOTAS (nombre max d'exemplaires empruntables)
INSERT INTO Quota (idProfil, nbExemplaires) VALUES
(1, 3), -- Étudiant : 3 livres
(2, 5), -- Prof : 5 livres
(3, 4), -- Pro : 4 livres
(4, 1); -- Anonyme : 1 livre

-- DURÉES D'EMPRUNT
INSERT INTO DureeEmprunt (idProfil, idTypePret, nbJour) VALUES
-- Étudiant
(1, 1, 14), -- à domicile : 14 jours
(1, 2, 1),  -- sur place : 1 jour
(1, 3, 7),  -- numérique : 7 jours
-- Prof
(2, 1, 30), -- à domicile : 30 jours
(2, 2, 1),  -- sur place : 1 jour
(2, 3, 21), -- numérique : 21 jours
-- Pro
(3, 1, 20), -- à domicile : 20 jours
(3, 2, 1),  -- sur place : 1 jour
(3, 3, 14), -- numérique : 14 jours
-- Anonyme
(4, 1, 5),  -- à domicile : 5 jours
(4, 2, 1),  -- sur place : 1 jour
(4, 3, 3);  -- numérique : 3 jours

-- PÉNALITÉS (jours de restriction)
INSERT INTO Penalite (idProfil, restriction) VALUES
(1, 1),  -- Étudiant : 1 jour de restriction par jour de retard
(2, 2),  -- Prof : 2 jours de restriction par jour de retard
(3, 1),  -- Pro : 1 jour de restriction par jour de retard
(4, 1);  -- Anonyme : 1 jour de restriction par jour de retard

-- ADHÉRENTS avec dates de naissance pour calcul d'âge
INSERT INTO Adherent (nom, email, dateNaissance, motdepasse, idProfil) VALUES
('Jean Dupont', 'jean.dupont@email.com', '2000-05-15', 'motdepasse123', 1), -- Étudiant, 24 ans
('Lalao Rakoto', 'lalao.rakoto@email.com', '1980-03-20', 'motdepasse456', 2), -- Prof, 44 ans
('Paul Martin', 'paul.martin@email.com', '1985-08-10', 'motdepasse789', 3), -- Pro, 39 ans
('Marie Rasoarivelo', 'marie.rasoarivelo@email.com', '2005-12-05', 'motdepasse012', 4), -- Anonyme, 19 ans
('Naina Andrianisa', 'naina.andrianisa@email.com', '1995-07-25', 'motdepasse345', 1), -- Étudiant, 29 ans
('Hery Randriamalala', 'hery.randriamalala@email.com', '1975-11-30', 'motdepasse678', 2), -- Prof, 49 ans
('Vola Raharison', 'vola.raharison@email.com', '1990-04-18', 'motdepasse901', 3); -- Pro, 34 ans

-- ABONNEMENTS DES ADHÉRENTS (selon le schéma actuel)
INSERT INTO AdherentAbonnement (idAdherent, dateInscription, dateFin) VALUES
(1, '2025-01-15', '2026-01-15'), -- Jean - 1 an
(2, '2025-02-01', '2026-02-01'), -- Lalao - 1 an
(3, '2025-02-15', '2026-02-15'), -- Paul - 1 an
(4, '2025-03-01', '2026-03-01'), -- Marie - 1 an
(5, '2025-03-15', '2026-03-15'), -- Naina - 1 an
(6, '2025-04-01', '2026-04-01'), -- Hery - 1 an
(7, '2025-04-15', '2026-04-15'); -- Vola - 1 an

-- AUTEURS
INSERT INTO Auteur (nom) VALUES
('Victor Hugo'),
('J.K. Rowling'),
('Agatha Christie'),
('Antoine de Saint-Exupéry'),
('Stephen King'),
('Alexandre Dumas'),
('Émile Zola'),
('George Orwell'),
('Marcel Proust'),
('Albert Camus');

-- MAISONS D'ÉDITION
INSERT INTO MaisonEdition (nom) VALUES
('Gallimard'),
('Hachette'),
('Éditions du Seuil'),
('Flammarion'),
('Albin Michel'),
('Le Livre de Poche'),
('Folio'),
('Pocket'),
('J\'ai Lu'),
('10/18');

-- GENRES LITTÉRAIRES
INSERT INTO GenreLitteraire (libelle) VALUES
('Roman'),
('Fantasy'),
('Policier'),
('Conte'),
('Horreur'),
('Aventure'),
('Science-fiction'),
('Classique'),
('Philosophie'),
('Biographie');

-- LIVRES avec âge minimum
INSERT INTO Livre (titre, edition, tag, idAuteur, idMaison, idGenre, agesup) VALUES
('Les Misérables', '2019', 'classique', 1, 1, 1, 16), -- 16 ans minimum
('Harry Potter à l\'école des sorciers', '2020', 'magie', 2, 2, 2, 8), -- 8 ans minimum
('Le Crime de l\'Orient-Express', '2018', 'enquête', 3, 3, 3, 12), -- 12 ans minimum
('Le Petit Prince', '2021', 'enfance', 4, 4, 4, 6), -- 6 ans minimum
('Shining', '2017', 'terreur', 5, 5, 5, 18), -- 18 ans minimum (horreur)
('Le Comte de Monte-Cristo', '2019', 'vengeance', 6, 6, 6, 14), -- 14 ans minimum
('Germinal', '2020', 'social', 7, 7, 1, 16), -- 16 ans minimum
('1984', '2018', 'dystopie', 8, 8, 7, 15), -- 15 ans minimum
('Du côté de chez Swann', '2021', 'mémoire', 9, 9, 8, 18), -- 18 ans minimum
('L\'Étranger', '2019', 'absurde', 10, 10, 9, 17); -- 17 ans minimum

-- EXEMPLAIRES
INSERT INTO Exemplaire (numExemplaire, idLivre) VALUES
-- Les Misérables (3 exemplaires)
('EXP001', 1), ('EXP002', 1), ('EXP003', 1),
-- Harry Potter (4 exemplaires)
('EXP004', 2), ('EXP005', 2), ('EXP006', 2), ('EXP007', 2),
-- Le Crime de l'Orient-Express (2 exemplaires)
('EXP008', 3), ('EXP009', 3),
-- Le Petit Prince (5 exemplaires)
('EXP010', 4), ('EXP011', 4), ('EXP012', 4), ('EXP013', 4), ('EXP014', 4),
-- Shining (2 exemplaires)
('EXP015', 5), ('EXP016', 5),
-- Le Comte de Monte-Cristo (3 exemplaires)
('EXP017', 6), ('EXP018', 6), ('EXP019', 6),
-- Germinal (2 exemplaires)
('EXP020', 7), ('EXP021', 7),
-- 1984 (3 exemplaires)
('EXP022', 8), ('EXP023', 8), ('EXP024', 8),
-- Du côté de chez Swann (1 exemplaire)
('EXP025', 9),
-- L'Étranger (2 exemplaires)
('EXP026', 10), ('EXP027', 10);

-- EMPRUNTS EN COURS
INSERT INTO AdherentExemplaire (idAdherent, idExemplaire, idTypePret, dateEmprunt, dateRetour, dateLimite) VALUES
-- Emprunts en cours (dateRetour = NULL)
(1, 1, 1, '2025-06-15', NULL, '2025-06-29'),  -- Jean emprunte Les Misérables (âge OK: 24 >= 16)
(2, 6, 1, '2025-06-20', NULL, '2025-07-20'),  -- Lalao emprunte Harry Potter 1 (âge OK: 44 >= 8)
(3, 13, 1, '2025-06-25', NULL, '2025-07-15'), -- Paul emprunte Le Crime de l'Orient-Express (âge OK: 39 >= 12)
(4, 19, 1, '2025-07-01', NULL, '2025-07-06'); -- Marie emprunte Le Petit Prince (âge OK: 19 >= 6)

-- JOURS FÉRIÉS
INSERT INTO JourFerie (dateJourFerie, libelle, annuel) VALUES
('2025-01-01', 'Nouvel An', TRUE),
('2025-03-29', 'Jour des Martyrs', TRUE),
('2025-05-01', 'Fête du Travail', TRUE),
('2025-05-08', 'Ascension', FALSE),
('2025-06-26', 'Fête Nationale', TRUE),
('2025-08-15', 'Assomption', TRUE),
('2025-11-01', 'Toussaint', TRUE),
('2025-12-25', 'Noël', TRUE),
('2025-12-31', 'Veille du Nouvel An', FALSE);


-- ABONNEMENTS DES ADHÉRENTS (selon le schéma actuel)
INSERT INTO AdherentAbonnement (idAdherent, dateInscription, dateFin) VALUES
(1, '2025-01-15', '2026-01-15'), -- Jean - 1 an
(2, '2025-02-01', '2026-02-01'), -- Lalao - 1 an
(3, '2025-02-15', '2026-02-15'), -- Paul - 1 an
(4, '2025-03-01', '2026-03-01'), -- Marie - 1 an
(5, '2025-03-15', '2026-03-15'), -- Naina - 1 an
(6, '2025-04-01', '2026-04-01'), -- Hery - 1 an
(7, '2025-04-15', '2026-04-15'); -- Vola - 1 an