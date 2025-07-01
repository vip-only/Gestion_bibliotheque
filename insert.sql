

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

-- DURÉES D'EMPRUNT (en jours)
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
(1, 7),  -- Étudiant : 7 jours
(2, 14), -- Prof : 14 jours
(3, 10), -- Pro : 10 jours
(4, 3);  -- Anonyme : 3 jours

-- ABONNEMENTS (durée en jours et montant)
INSERT INTO Abonnement (duree, montant, idProfil) VALUES
(365, 15000.00, 1), -- Étudiant : 1 an - 15000 Ar
(365, 25000.00, 2), -- Prof : 1 an - 25000 Ar
(365, 20000.00, 3), -- Pro : 1 an - 20000 Ar
(365, 10000.00, 4); -- Anonyme : 1 an - 10000 Ar

-- INSCRIPTIONS (frais d'inscription)
INSERT INTO Inscription (duree, montant, idProfil) VALUES
(30, 5000.00, 1),  -- Étudiant : 1 mois - 5000 Ar
(30, 8000.00, 2),  -- Prof : 1 mois - 8000 Ar
(30, 7000.00, 3),  -- Pro : 1 mois - 7000 Ar
(30, 3000.00, 4);  -- Anonyme : 1 mois - 3000 Ar

-- AUTEURS
INSERT INTO Auteur (nom) VALUES 
('Victor Hugo'), 
('J.K. Rowling'), 
('Agatha Christie'), 
('Stephen King'), 
('Antoine de Saint-Exupéry'),
('Alexandre Dumas'),
('Jules Verne'),
('Émile Zola');

-- MAISONS D'ÉDITION
INSERT INTO MaisonEdition (nom) VALUES 
('Gallimard'), 
('Hachette'), 
('Flammarion'), 
('Le Seuil'), 
('Albin Michel'),
('Plon');

-- GENRES LITTÉRAIRES
INSERT INTO GenreLitteraire (libelle) VALUES 
('Roman'), 
('Fantastique'), 
('Policier'), 
('Science-Fiction'), 
('Biographie'),
('Histoire'),
('Aventure'),
('Classique');

-- LIVRES
INSERT INTO Livre (titre, edition, tag, idAuteur, idMaison, idGenre) VALUES
('Les Misérables', '3e édition', 'classique-français', 1, 1, 8),
('Notre-Dame de Paris', '2e édition', 'classique-français', 1, 1, 8),
('Harry Potter à l école des sorciers', '1ère édition', 'magie-enfants', 2, 2, 2),
('Harry Potter et la Chambre des secrets', '1ère édition', 'magie-enfants', 2, 2, 2),
('Le Crime de l Orient-Express', '4e édition', 'enquête-mystère', 3, 3, 3),
('Dix Petits Nègres', '3e édition', 'suspense-mystère', 3, 3, 3),
('Shining', '2e édition', 'horreur-psychologique', 4, 4, 2),
('Le Petit Prince', '5e édition', 'conte-philosophique', 5, 1, 1),
('Le Comte de Monte-Cristo', '4e édition', 'aventure-classique', 6, 1, 7),
('Vingt Mille Lieues sous les mers', '3e édition', 'aventure-science', 7, 2, 4),
('Germinal', '2e édition', 'social-réalisme', 8, 1, 1);

-- EXEMPLAIRES
INSERT INTO Exemplaire (numExemplaire, idLivre) VALUES
-- Les Misérables (3 exemplaires)
('EXP001', 1), ('EXP002', 1), ('EXP003', 1),
-- Notre-Dame de Paris (2 exemplaires)
('EXP004', 2), ('EXP005', 2),
-- Harry Potter 1 (4 exemplaires)
('EXP006', 3), ('EXP007', 3), ('EXP008', 3), ('EXP009', 3),
-- Harry Potter 2 (3 exemplaires)
('EXP010', 4), ('EXP011', 4), ('EXP012', 4),
-- Le Crime de l'Orient-Express (2 exemplaires)
('EXP013', 5), ('EXP014', 5),
-- Dix Petits Nègres (2 exemplaires)
('EXP015', 6), ('EXP016', 6),
-- Shining (2 exemplaires)
('EXP017', 7), ('EXP018', 7),
-- Le Petit Prince (5 exemplaires)
('EXP019', 8), ('EXP020', 8), ('EXP021', 8), ('EXP022', 8), ('EXP023', 8),
-- Le Comte de Monte-Cristo (2 exemplaires)
('EXP024', 9), ('EXP025', 9),
-- Vingt Mille Lieues sous les mers (2 exemplaires)
('EXP026', 10), ('EXP027', 10),
-- Germinal (2 exemplaires)
('EXP028', 11), ('EXP029', 11);

-- ADHÉRENTS
INSERT INTO Adherent (nom, email, dateNaissance, motdepasse, idProfil) VALUES
('Jean Rakoto', 'jean@mail.com', '2000-05-20', 'jean123', 1),      -- Étudiant
('Lalao Rasoa', 'lalao@mail.com', '1980-02-15', 'lalao456', 2),    -- Prof
('Paul Randria', 'paul@mail.com', '1990-11-08', 'paul789', 3),     -- Pro
('Marie Rabe', 'marie@mail.com', '1995-07-30', 'marie012', 4),     -- Anonyme
('Naina Rakotomalala', 'naina@mail.com', '1999-09-12', 'naina345', 1), -- Étudiant
('Hery Rasoanaivo', 'hery@mail.com', '1983-04-18', 'hery678', 2),     -- Prof
('Vola Razafy', 'vola@mail.com', '1992-01-25', 'vola901', 3);         -- Pro

-- INSCRIPTIONS DES ADHÉRENTS
INSERT INTO AdherentInscription (idAdherent, idInscription, montant, dateInscription) VALUES
(1, 1, 5000.00, '2025-01-15'), -- Jean - Étudiant
(2, 2, 8000.00, '2025-02-01'), -- Lalao - Prof
(3, 3, 7000.00, '2025-02-15'), -- Paul - Pro
(4, 4, 3000.00, '2025-03-01'), -- Marie - Anonyme
(5, 1, 5000.00, '2025-03-15'), -- Naina - Étudiant
(6, 2, 8000.00, '2025-04-01'), -- Hery - Prof
(7, 3, 7000.00, '2025-04-15'); -- Vola - Pro

-- ABONNEMENTS DES ADHÉRENTS
INSERT INTO AdherentAbonnement (idAdherent, idAbonnement, prixPaiement, datePaiement) VALUES
(1, 1, 15000.00, '2025-01-15'), -- Jean
(2, 2, 25000.00, '2025-02-01'), -- Lalao
(3, 3, 20000.00, '2025-02-15'), -- Paul
(4, 4, 10000.00, '2025-03-01'), -- Marie
(5, 1, 15000.00, '2025-03-15'), -- Naina
(6, 2, 25000.00, '2025-04-01'), -- Hery
(7, 3, 20000.00, '2025-04-15'); -- Vola

-- EMPRUNTS EN COURS
INSERT INTO AdherentExemplaire (idAdherent, idExemplaire, idTypePret, dateEmprunt, dateRetour, dateLimite) VALUES
-- Emprunts en cours (dateRetour = NULL)
(1, 1, 1, '2025-06-15', NULL, '2025-06-29'),  -- Jean emprunte Les Misérables (14 jours)
(2, 6, 1, '2025-06-20', NULL, '2025-07-20'),  -- Lalao emprunte Harry Potter 1 (30 jours)
(3, 13, 1, '2025-06-25', NULL, '2025-07-15'), -- Paul emprunte Le Crime de l'Orient-Express (20 jours)
(4, 19, 1, '2025-07-01', NULL, '2025-07-06'), -- Marie emprunte Le Petit Prince (5 jours)

-- Emprunts terminés (avec dateRetour)
(5, 17, 1, '2025-05-01', '2025-05-14', '2025-05-15'), -- Naina a rendu Shining
(6, 24, 1, '2025-05-15', '2025-06-10', '2025-06-14'), -- Hery a rendu Le Comte de Monte-Cristo
(7, 28, 1, '2025-04-20', '2025-05-05', '2025-05-10'); -- Vola a rendu Germinal

-- PROLONGEMENTS
INSERT INTO ProlongementExemplaire (idAdherentExemplaire, prolongement) VALUES
(1, 7), -- Jean prolonge de 7 jours
(2, 14); -- Lalao prolonge de 14 jours

-- ÉTATS DES PROLONGEMENTS
INSERT INTO EtatProlongementExemplaire (idProlongementExemplaire, idEtat, dateEtat) VALUES
(1, 2, '2025-06-20'), -- Prolongement de Jean accepté
(2, 1, '2025-06-25'); -- Prolongement de Lalao en cours

-- PÉNALITÉS APPLIQUÉES
INSERT INTO AdherentPenalite (idAdherent, idPenalite, dateDebut, dateFin) VALUES
(3, 3, '2025-06-01', '2025-06-11'), -- Paul a eu une pénalité de 10 jours (terminée)
(4, 4, '2025-06-20', '2025-06-23'); -- Marie a une pénalité de 3 jours (terminée)

-- RÉSERVATIONS
INSERT INTO Reservation (idAdherent, idExemplaire, dateDebut, dateFin) VALUES
(5, 2, '2025-07-01', '2025-07-31'),  -- Naina réserve Les Misérables (exemplaire 2)
(6, 7, '2025-07-05', '2025-08-05'),  -- Hery réserve Harry Potter 1 (exemplaire 2)
(7, 20, '2025-07-10', '2025-08-10'); -- Vola réserve Le Petit Prince (exemplaire 2)

-- ÉTATS DES RÉSERVATIONS
INSERT INTO ReservationEtat (idReservation, idEtat, dateEtat) VALUES
(1, 1, '2025-07-01'), -- Réservation de Naina en cours
(2, 1, '2025-07-05'), -- Réservation de Hery en cours
(3, 1, '2025-07-10'); -- Réservation de Vola en cours


-- JOURS FÉRIÉS OFFICIELS MADAGASCAR 2025
INSERT INTO JourFerie (dateJourFerie, libelle, annuel) VALUES
-- Jours fériés officiels fixes
('2025-01-01', 'Nouvel An', TRUE),
('2025-03-29', 'Journée de Commémoration des Martyrs de 1947', TRUE),
('2025-05-01', 'Fête du Travail', TRUE),
('2025-06-26', 'Fête de l''Indépendance', TRUE),
('2025-08-15', 'Assomption', TRUE),
('2025-11-01', 'Toussaint', TRUE),
('2025-12-25', 'Noël', TRUE),

-- Jours fériés religieux variables 2025
('2025-04-20', 'Dimanche de Pâques', FALSE),
('2025-04-21', 'Lundi de Pâques', FALSE),
('2025-05-29', 'Ascension', FALSE),
('2025-06-09', 'Lundi de Pentecôte', FALSE),

-- Jours fériés musulmans 2025 (dates approximatives)
('2025-03-31', 'Aïd el-Fitr (fin du Ramadan)', FALSE),
('2025-06-07', 'Aïd el-Adha (Fête du Sacrifice)', FALSE),

-- Événements nationaux spéciaux 2025
('2025-06-25', 'Veille de l''Indépendance', FALSE),
('2025-12-24', 'Veille de Noël', FALSE),
('2025-12-31', 'Veille du Nouvel An', FALSE);