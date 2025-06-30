INSERT INTO bibliothecaire (nom, motdepasse, adresse, telephone, email)
VALUES ('Rakoto Fara', 'motdepasse123', 'Lot 112B Ambohijatovo', '0321234567', 'fara@biblio.mg');

-- ETATS
INSERT INTO Etat (libelle) VALUES ('en cours'), ('accepté'), ('refusé');

-- TYPES DE PRÊT
INSERT INTO TypePret (libelle) VALUES ('à domicile'), ('sur place');

-- PROFILS
INSERT INTO Profil (libelle) VALUES ('Étudiant'), ('Prof'), ('Pro'), ('Anonyme');

-- QUOTAS
INSERT INTO Quota (idProfil, nbExemplaires) VALUES
(1, 3), -- Étudiant
(2, 5), -- Prof
(3, 4), -- Pro
(4, 1); -- Anonyme

-- DURÉES D'EMPRUNT
INSERT INTO DureeEmprunt (idProfil, idTypePret, nbJour) VALUES
(1, 1, 14), -- Étudiant - à domicile : 14 jours
(2, 1, 30), -- Prof - à domicile : 30 jours
(3, 1, 20), -- Pro - à domicile : 20 jours
(4, 1, 5),  -- Anonyme - à domicile : 5 jours
(1, 2, 1),  -- Tous profils - sur place : 1 jour
(2, 2, 1),
(3, 2, 1),
(4, 2, 1);

-- AUTEURS
INSERT INTO Auteur (nom) VALUES ('Victor Hugo'), ('J.K. Rowling');

-- MAISONS D'ÉDITION
INSERT INTO MaisonEdition (nom) VALUES ('Gallimard'), ('Bloomsbury');

-- GENRES
INSERT INTO GenreLitteraire (libelle) VALUES ('Roman'), ('Fantastique');

INSERT INTO Livre (titre, edition, tag, idAuteur, idMaison, idGenre) VALUES
('Les Misérables', '3e édition', 'classique', 1, 1, 1),
('Harry Potter', '1ère édition', 'magie', 2, 2, 2);

INSERT INTO Exemplaire (numExemplaire, idLivre) VALUES
('EXP001', 1),
('EXP002', 2);

INSERT INTO Inscription (duree, montant, idProfil) VALUES
(365, 15000, 1), -- Étudiant
(365, 25000, 2); -- Prof

INSERT INTO Adherent (nom, email, dateNaissance, motdepasse, idProfil) VALUES
('Jean Rakoto', 'jean@mail.com', '2000-05-20', 'jean123', 1),
('Lalao Rasoa', 'lalao@mail.com', '1980-02-15', 'lalao456', 2);

INSERT INTO AdherentInscription (idAdherent, idInscription, montant, dateInscription) VALUES
(1, 1, 15000, '2024-06-30'),
(2, 2, 25000, '2024-06-30');

INSERT INTO AdherentExemplaire (idAdherent, idExemplaire, idTypePret, dateEmprunt, dateRetour, dateLimite) VALUES
(1, 1, 1, '2025-05-30', NULL, '2025-07-30');

INSERT INTO ProlongementExemplaire (idExemplaire, prolongement, idEtat) VALUES
(1, 1, 1); -- en cours

INSERT INTO Penalite (idProfil, restriction) VALUES
(1, 7),  -- Étudiant : 7 jours
(2, 30); -- Prof : 30 jours

INSERT INTO AdherentPenalite (idAdherent, idPenalite, dateDebut, dateFin) VALUES
(2, 2, '2025-04-30', '2025-05-30');

INSERT INTO Reservation (idAdherent, idExemplaire, dateDebut, dateFin, idEtat) VALUES
(1, 2, '2025-06-30', '2025-07-30', 1); -- en cours
