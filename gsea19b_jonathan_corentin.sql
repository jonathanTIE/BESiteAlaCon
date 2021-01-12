-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : jeu. 07 jan. 2021 à 10:44
-- Version du serveur :  10.4.14-MariaDB
-- Version de PHP : 7.4.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `gsea19b_jonathan_corentin`
--

-- --------------------------------------------------------

--
-- Structure de la table `asso_avionparking`
--

CREATE TABLE `asso_avionparking` (
  `idAsso` int(11) NOT NULL,
  `idAvion` int(11) NOT NULL,
  `idParking` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `dateArrivee` datetime NOT NULL,
  `dateDepart` datetime NOT NULL,
  `idUserValidation` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `avions`
--

CREATE TABLE `avions` (
  `idAvion` int(11) NOT NULL,
  `typeAvion` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `immatAvion` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `categorie` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `idCompagnie` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `avions`
--

INSERT INTO `avions` (`idAvion`, `typeAvion`, `immatAvion`, `categorie`, `idCompagnie`) VALUES
(1, 'A380', 'F-GAFT', 'A', 1),
(2, 'B787', 'JA0011', 'A', 2);

-- --------------------------------------------------------

--
-- Structure de la table `compagnie`
--

CREATE TABLE `compagnie` (
  `idCompagnie` int(11) NOT NULL,
  `nomCompagnie` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `compagnie`
--

INSERT INTO `compagnie` (`idCompagnie`, `nomCompagnie`) VALUES
(1, 'Air France'),
(2, 'Japan AIrlines');

-- --------------------------------------------------------

--
-- Structure de la table `identification`
--

CREATE TABLE `identification` (
  `idUser` int(11) NOT NULL,
  `nom` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `prenom` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `mail` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `login` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `motPasse` varchar(200) NOT NULL,
  `statut` int(11) NOT NULL,
  `newMdp` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `identification`
--

INSERT INTO `identification` (`idUser`, `nom`, `prenom`, `mail`, `login`, `motPasse`, `statut`, `newMdp`) VALUES
(1, 'Kiku', 'Jonathan', 'kiku.jonathan@enac.fr', 'a', 'ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb', 0, 0),
(2, 'Ryu', 'Corentin', 'ryu.corentin@enac.fr', 'b', 'b', 1, 0),
(4, 'Armet', 'Sylvie', 'armet.corentin@orange.fr', 'bzr', 'a205eb4c3fbe4df83895bb808bda057458e1a0e517ec657490fa48f8c67a5063', 1, 2),
(6, 'Armet', 'Sylvie', 'armet.corentin@orange.fr', 'User2', 'f536f8a5d3a45b0922fd4afa5bc0664f782dea1d2f2ee3d37a470853966057d9', 1, 2);

-- --------------------------------------------------------

--
-- Structure de la table `parking`
--

CREATE TABLE `parking` (
  `idParking` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `nomParking` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `categorie` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `coordonnees` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `waypointProche` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `waypoint`
--

CREATE TABLE `waypoint` (
  `idWaypoint` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `coordonnees` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `type` enum('taxiway','circuit','pisteArrivee','pisteDepart','circuitDep','') CHARACTER SET ucs2 COLLATE ucs2_general_mysql500_ci NOT NULL,
  `rang` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `asso_avionparking`
--
ALTER TABLE `asso_avionparking`
  ADD PRIMARY KEY (`idAsso`),
  ADD KEY `FKAvion` (`idAvion`),
  ADD KEY `FKParking` (`idParking`),
  ADD KEY `FKUser` (`idUserValidation`);

--
-- Index pour la table `avions`
--
ALTER TABLE `avions`
  ADD PRIMARY KEY (`idAvion`),
  ADD KEY `FKCompagnie` (`idCompagnie`);

--
-- Index pour la table `compagnie`
--
ALTER TABLE `compagnie`
  ADD PRIMARY KEY (`idCompagnie`);

--
-- Index pour la table `identification`
--
ALTER TABLE `identification`
  ADD PRIMARY KEY (`idUser`);

--
-- Index pour la table `parking`
--
ALTER TABLE `parking`
  ADD PRIMARY KEY (`idParking`),
  ADD KEY `FKwaypoint` (`waypointProche`);

--
-- Index pour la table `waypoint`
--
ALTER TABLE `waypoint`
  ADD PRIMARY KEY (`idWaypoint`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `asso_avionparking`
--
ALTER TABLE `asso_avionparking`
  MODIFY `idAsso` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `avions`
--
ALTER TABLE `avions`
  MODIFY `idAvion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `compagnie`
--
ALTER TABLE `compagnie`
  MODIFY `idCompagnie` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `identification`
--
ALTER TABLE `identification`
  MODIFY `idUser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `asso_avionparking`
--
ALTER TABLE `asso_avionparking`
  ADD CONSTRAINT `FKAvion` FOREIGN KEY (`idAvion`) REFERENCES `avions` (`idAvion`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FKParking` FOREIGN KEY (`idParking`) REFERENCES `parking` (`idParking`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FKUser` FOREIGN KEY (`idUserValidation`) REFERENCES `identification` (`idUser`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `avions`
--
ALTER TABLE `avions`
  ADD CONSTRAINT `FKCompagnie` FOREIGN KEY (`idCompagnie`) REFERENCES `compagnie` (`idCompagnie`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `parking`
--
ALTER TABLE `parking`
  ADD CONSTRAINT `FKwaypoint` FOREIGN KEY (`waypointProche`) REFERENCES `waypoint` (`idWaypoint`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
