CREATE DATABASE IF NOT EXISTS biblio;
USE biblio;

CREATE TABLE Etat (
    idEtat INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL 
);

CREATE TABLE Profil (
    idProfil INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL 
);

CREATE TABLE TypePret (
    idTypePret INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL
);

CREATE TABLE JourFerie (
    idJourFerie INT AUTO_INCREMENT PRIMARY KEY,
    dateJourFerie DATE NOT NULL UNIQUE,
    libelle VARCHAR(100) NOT NULL,
    annuel BOOLEAN DEFAULT FALSE
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
    idGenre INT,
    agesup INT,
    FOREIGN KEY (idAuteur) REFERENCES Auteur(idAuteur),
    FOREIGN KEY (idMaison) REFERENCES MaisonEdition(idMaison),
    FOREIGN KEY (idGenre) REFERENCES GenreLitteraire(idGenre)
);

CREATE TABLE Exemplaire (
    idExemplaire INT AUTO_INCREMENT PRIMARY KEY,
    numExemplaire VARCHAR(50) NOT NULL,
    idLivre INT NOT NULL,
    FOREIGN KEY (idLivre) REFERENCES Livre(idLivre)
);

CREATE TABLE Bibliothecaire (
    idBibliothecaire INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    motdepasse VARCHAR(100) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    telephone VARCHAR(20),
    email VARCHAR(100)
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

CREATE TABLE AdherentAbonnement (
    idAdherentInscription INT AUTO_INCREMENT PRIMARY KEY,
    idAdherent INT,
    dateInscription DATE NOT NULL,
    dateFin DATE NOT NULL,
    FOREIGN KEY (idAdherent) REFERENCES Adherent(idAdherent)
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
    FOREIGN KEY (idAdherentExemplaire) REFERENCES AdherentExemplaire(idAdherentExemplaire)
);

CREATE TABLE EtatProlongementExemplaire (
    idEtatProlongementExemplaire INT AUTO_INCREMENT PRIMARY KEY,
    idProlongementExemplaire INT,
    idEtat INT,
    dateEtat DATE,
    FOREIGN KEY (idProlongementExemplaire) REFERENCES ProlongementExemplaire(idProlongementExemplaire),
    FOREIGN KEY (idEtat) REFERENCES Etat(idEtat)
);

CREATE TABLE Reservation (
    idReservation INT AUTO_INCREMENT PRIMARY KEY,
    idAdherent INT,
    idExemplaire INT,
    dateDebut DATE,
    dateFin DATE,
    FOREIGN KEY (idAdherent) REFERENCES Adherent(idAdherent),
    FOREIGN KEY (idExemplaire) REFERENCES Exemplaire(idExemplaire)
);

CREATE TABLE ReservationEtat (
    idReservationEtat INT AUTO_INCREMENT PRIMARY KEY,
    idReservation INT,
    idEtat INT,
    dateEtat DATE,
    FOREIGN KEY (idReservation) REFERENCES Reservation(idReservation),
    FOREIGN KEY (idEtat) REFERENCES Etat(idEtat)
);

CREATE TABLE Penalite (
    idPenalite INT AUTO_INCREMENT PRIMARY KEY,
    idProfil INT,
    restriction INT NOT NULL,
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

CREATE TABLE Quota (
    idQuota INT AUTO_INCREMENT PRIMARY KEY,
    idProfil INT,
    nbExemplaires INT NOT NULL,
    nbResa INT NOT NULL,
    nbProlong INT NOT NULL,
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
