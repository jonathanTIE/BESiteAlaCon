-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : mar. 12 jan. 2021 à 10:43
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
(2, 'Ryu', 'Corentin', 'ryu.corentin@enac.fr', 'b', 'b', 1, 0);

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

--
-- Déchargement des données de la table `parking`
--

INSERT INTO `parking` (`idParking`, `nomParking`, `categorie`, `coordonnees`, `waypointProche`) VALUES
('P1', 'Parking Nord 1', 'B', '139.78942, 35.55493', 'T1'),
('P10', 'Parking Ouest 6', 'A', '139.79079, 35.54998', 'T3'),
('P11', 'Parking Sud 1', 'C', '139.79149, 35.54928', 'T3'),
('P12', 'Parking Sud 2', 'C', '139.79224, 35.54939', 'T3'),
('P13', 'Parking Sud 2', 'C', '139.79247, 35.54974', 'T3'),
('P14', 'Parking Sud 3', 'B', '139.79304, 35.54988', 'T3'),
('P2', 'Parking Nord 2', 'A', '139.78883, 35.55461', 'T1'),
('P3', 'Parking Nord 3', 'A', '139.78786, 35.55411', 'T1'),
('P4', 'Parking Ouest 1', 'A', '139.78836, 35.55320', 'T1'),
('P5', 'Parking Ouest 2', 'B', '139.78882, 35.55270', 'T2'),
('P6', 'Parking ouest 3', 'B', '139.78921, 35.55218', 'T2'),
('P7', 'Parking Ouest 3', 'B', '139.78959, 35.55162', 'T2'),
('P8', 'Parking Ouest 4', 'A', '139.78997, 35.55109', 'T2'),
('P9', 'Parking Ouest 5', 'A', '139.79041, 35.55051', 'T3');

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `vueavionlibre`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `vueavionlibre` (
`idAvion` int(11)
,`immatAvion` varchar(10)
,`categorie` varchar(5)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `vueparkinglibre`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `vueparkinglibre` (
`idParking` varchar(5)
);

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
-- Déchargement des données de la table `waypoint`
--

INSERT INTO `waypoint` (`idWaypoint`, `coordonnees`, `type`, `rang`) VALUES
('A1', '139.82050, 35.54157', 'taxiway', 1),
('A2', '139.80679, 35.53006', 'taxiway', 2),
('A3', '139.80132, 35.53793', 'taxiway', 3),
('A4', '139.80004, 35.53732', 'taxiway', 4),
('A5', '139.80556, 35.52920', 'taxiway', 5),
('A6', '139.80143, 35.52579', 'taxiway', 6),
('ARR1', '139.80383, 35.52428', 'pisteArrivee', 1),
('ARR2', '139.82198, 35.54049', 'pisteArrivee', 2),
('C1', '139.78066, 35.50289', 'circuit', 1),
('DEP1', '139.80376, 35.52421', 'pisteDepart', 1),
('DEP2', '139.84302, 35.55940', 'pisteDepart', 2),
('T1', '139.78913, 35.55393', 'taxiway', 1),
('T2', '139.79029, 35.55205', 'taxiway', 2),
('T3', '139.79165, 35.55012', 'taxiway', 3);

-- --------------------------------------------------------

--
-- Structure de la vue `vueavionlibre`
--
DROP TABLE IF EXISTS `vueavionlibre`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vueavionlibre`  AS  select `avions`.`idAvion` AS `idAvion`,`avions`.`immatAvion` AS `immatAvion`,`avions`.`categorie` AS `categorie` from (`avions` left join `asso_avionparking` on(`avions`.`idAvion` = `asso_avionparking`.`idAvion`)) where `asso_avionparking`.`dateArrivee` is null ;

-- --------------------------------------------------------

--
-- Structure de la vue `vueparkinglibre`
--
DROP TABLE IF EXISTS `vueparkinglibre`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vueparkinglibre`  AS  select `parking`.`idParking` AS `idParking`,`parking`.`categorie` AS `categorie` from (`parking` left join `asso_avionparking` on(`parking`.`idParking` = `asso_avionparking`.`idParking`)) where `asso_avionparking`.`dateArrivee` is null ;

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
  MODIFY `idUser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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

ALTER TABLE `asso_avionparking` CHANGE `dateDepart` `dateDepart` DATETIME NULL DEFAULT NULL;
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
