create database IF NOT EXISTS biblio;
use biblio;
CREATE table bibliothecaire (
    idBibliothecaire INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    motdepasse VARCHAR(100) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    telephone VARCHAR(20),
    email VARCHAR(100)
);
CREATE TABLE Etat (
    idEtat INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL 
);

CREATE TABLE Auteur (
    idAuteur INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL
);
CREATE TABLE MaisonEdition (
    idMaison INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL
);
CREATE TABLE GenreLitteraire (
    idGenre INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);
CREATE TABLE Livre (
    idLivre INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(200) NOT NULL,
    edition VARCHAR(100),
    tag VARCHAR(100),
    idAuteur INT,
    idMaison INT,
    idGenre INT
);
CREATE TABLE Exemplaire (
    idExemplaire INT AUTO_INCREMENT PRIMARY KEY,
    numExemplaire VARCHAR(50) NOT NULL,
    idLivre INT NOT NULL,
    FOREIGN KEY (idLivre) REFERENCES Livre(idLivre)
);
CREATE TABLE Profil (
    idProfil INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL 
);
CREATE TABLE Adherent (
    idAdherent INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    dateNaissance DATE,
    motdepasse VARCHAR(100) NOT NULL,
    idProfil INT,
    FOREIGN KEY (idProfil) REFERENCES Profil(idProfil)
);

CREATE TABLE Inscription (
    idInscription INT AUTO_INCREMENT PRIMARY KEY,
    duree INT NOT NULL, 
    montant DECIMAL(10,2) NOT NULL,
    idProfil INT,
    FOREIGN KEY (idProfil) REFERENCES Profil(idProfil)
);
CREATE TABLE AdherentInscription (
    idAdherentInscription INT AUTO_INCREMENT PRIMARY KEY,
    idAdherent INT,
    idInscription INT,
    montant DECIMAL(10,2) NOT NULL,
    dateInscription DATE NOT NULL,
    FOREIGN KEY (idAdherent) REFERENCES Adherent(idAdherent),
    FOREIGN KEY (idInscription) REFERENCES Inscription(idInscription)
);

CREATE TABLE AdherentExemplaire (
    idAdherentExemplaire INT AUTO_INCREMENT PRIMARY KEY,
    idAdherent INT,
    idExemplaire INT,
    idTypePret INT,
    dateEmprunt DATE NOT NULL,
    dateRetour DATE,
    dateLimite DATE,
    FOREIGN KEY (idAdherent) REFERENCES Adherent(idAdherent),
    FOREIGN KEY (idExemplaire) REFERENCES Exemplaire(idExemplaire),
    FOREIGN KEY (idTypePret) REFERENCES TypePret(idTypePret)
);
CREATE TABLE ProlongementExemplaire (
    idProlongementExemplaire INT AUTO_INCREMENT PRIMARY KEY,
    idAdherentExemplaire INT,
    prolongement INT NOT NULL,
    idEtat INT,
    FOREIGN KEY (idAdherentExemplaire) REFERENCES AdherentExemplaire(idAdherentExemplaire),
    FOREIGN KEY (idEtat) REFERENCES Etat(idEtat)
);
CREATE TABLE TypePret (
    idTypePret INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL -- ("à domicile", "sur place")
);
CREATE TABLE Penalite (
    idPenalite INT AUTO_INCREMENT PRIMARY KEY,
    idProfil INT,
    restriction INT NOT NULL, -- nombre de jours de restriction
    FOREIGN KEY (idProfil) REFERENCES Profil(idProfil)
);

CREATE TABLE AdherentPenalite (
    idAdherentPenalite INT AUTO_INCREMENT PRIMARY KEY,
    idAdherent INT,
    idPenalite INT,
    dateDebut DATE,
    dateFin DATE,
    FOREIGN KEY (idAdherent) REFERENCES Adherent(idAdherent),
    FOREIGN KEY (idPenalite) REFERENCES Penalite(idPenalite)
);
CREATE TABLE Reservation (
    idReservation INT AUTO_INCREMENT PRIMARY KEY,
    idAdherent INT,
    idExemplaire INT,
    dateDebut DATE,
    dateFin DATE,
    idEtat INT,
    FOREIGN KEY (idAdherent) REFERENCES Adherent(idAdherent),
    FOREIGN KEY (idExemplaire) REFERENCES Exemplaire(idExemplaire),
    FOREIGN KEY (idEtat) REFERENCES Etat(idEtat)
);
CREATE TABLE Quota (
    idQuota INT AUTO_INCREMENT PRIMARY KEY,
    idProfil INT,
    nbExemplaires INT NOT NULL, -- nombre d'exemplaires autorisés
    FOREIGN KEY (idProfil) REFERENCES Profil(idProfil)
);

CREATE TABLE DureeEmprunt (
    idDureeEmprunt INT AUTO_INCREMENT PRIMARY KEY,
    idProfil INT,
    idTypePret INT,
    nbJour INT NOT NULL, 
    FOREIGN KEY (idProfil) REFERENCES Profil(idProfil),
    FOREIGN KEY (idTypePret) REFERENCES TypePret(idTypePret)
);

