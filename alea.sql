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


INSERT INTO JourFerie (dateJourFerie, libelle, annuel) VALUES 
('2025-07-13', 'Jour férié spécial', FALSE),
('2025-07-26', 'Jour férié spécial', FALSE),
('2025-07-20', 'Jour férié spécial', FALSE),
('2025-07-19', 'Jour férié spécial', FALSE),
('2025-07-27', 'Jour férié spécial', FALSE),
('2025-08-03', 'Jour férié spécial', FALSE),
('2025-08-10', 'Jour férié spécial', FALSE),
('2025-08-17', 'Jour férié spécial', FALSE);

INSERT INTO Auteur (nom) VALUES 
('Victor Hugo'),
('Albert Camus'),
('J.K. Rowling');

INSERT INTO GenreLitteraire (libelle) VALUES 
('Littérature classique'),
('Philosophie'),
('Jeunesse / Fantastique');

INSERT INTO Livre (idLivre, titre, edition, tag, idAuteur, idMaison, idGenre, agesup) VALUES 
(1, 'Les Misérables', NULL, '9782070409189', 1, NULL, 1, NULL),
(2, 'L\'Étranger', NULL, '9782070360022', 2, NULL, 2, NULL),
(3, 'Harry Potter à l\'école des sorciers', NULL, '9782070643026', 3, NULL, 3, NULL);

INSERT INTO Exemplaire (numExemplaire, idLivre) VALUES
('MIS001', 1),
('MIS002', 1),
('MIS003', 1),
('ETR001', 2),
('ETR002', 2),
('HAR001', 3);

INSERT INTO Adherent (nom, email, dateNaissance, motdepasse, idProfil) VALUES
('Amine Bensaïd', 'ETU001', NULL, 'azerty', 1),
('Sarah El Khattabi', 'ETU002', NULL, 'azerty', 1),
('Youssef Moujahid', 'ETU003', NULL, 'azerty', 1),
('Nadia Benali', 'ENS001', NULL, 'azerty', 2),
('Karim Haddadi', 'ENS002', NULL, 'azerty', 2),
('Salima Touhami', 'ENS003', NULL, 'azerty', 2),
('Rachid El Mansouri', 'PROF001', NULL, 'azerty', 3),
('Amina Zerouali', 'PROF002', NULL, 'azerty', 3);

INSERT INTO AdherentAbonnement (idAdherent, dateInscription, dateFin) VALUES
(1, '2025-02-01', '2025-07-24'),
(2, '2025-02-01', '2025-07-01'),
(3, '2025-04-01', '2025-12-01'),
(4, '2025-07-01', '2026-07-01'),
(5, '2025-08-01', '2026-05-01'),
(6, '2025-07-01', '2026-06-01'),
(7, '2025-06-01', '2025-12-01'),
(8, '2024-10-01', '2025-06-01');

INSERT INTO Penalite (idProfil, restriction) VALUES
(1, 10),  -- Étudiants
(2, 9),   -- Enseignants
(3, 8);   -- Professionnels

INSERT INTO Quota (idProfil, nbExemplaires, nbResa, nbProlong) VALUES
(1, 2, 1, 3),  -- Étudiants
(2, 3, 2, 5),  -- Enseignants
(3, 4, 3, 7);  -- Professionnels

INSERT INTO DureeEmprunt (idProfil, idTypePret, nbJour) VALUES
(1, 1, 7),   -- Étudiants
(2, 1, 9),   -- Enseignants
(3, 1, 12);  -- Professionnels
