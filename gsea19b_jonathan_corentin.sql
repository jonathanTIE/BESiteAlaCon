-- phpMyAdmin SQL Dump
-- version 4.6.6deb5
-- https://www.phpmyadmin.net/
--
-- Client :  localhost:3306
-- Généré le :  Mar 26 Janvier 2021 à 11:37
-- Version du serveur :  5.7.26-0ubuntu0.18.04.1
-- Version de PHP :  7.2.19-0ubuntu0.18.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `gsea19b_jonathan_corentin`
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
  `dateDepart` datetime DEFAULT NULL,
  `idUserValidation` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `asso_avionparking`
--

INSERT INTO `asso_avionparking` (`idAsso`, `idAvion`, `idParking`, `dateArrivee`, `dateDepart`, `idUserValidation`) VALUES
(56, 1, 'P4', '2021-01-26 11:03:20', '2021-01-26 11:04:40', 1),
(57, 2, 'P8', '2021-01-26 11:03:23', '2021-01-26 11:04:31', 1),
(58, 3, 'P2', '2021-01-26 11:04:40', NULL, 1),
(59, 4, 'P14', '2021-01-26 11:04:54', '2021-01-26 11:06:00', 1),
(60, 5, 'P7', '2021-01-26 11:05:00', '2021-01-26 11:05:32', 1),
(61, 6, 'P9', '2021-01-26 11:09:08', '2021-01-26 11:10:25', 1),
(62, 7, 'P4', '2021-01-26 11:27:19', NULL, 1),
(63, 8, 'P14', '2021-01-26 11:27:37', NULL, 1),
(64, 9, 'P1', '2021-01-26 11:28:27', NULL, 1),
(65, 10, 'P10', '2021-01-26 11:29:02', '2021-01-26 11:30:13', 1),
(66, 11, 'P8', '2021-01-26 11:29:13', '2021-01-26 11:30:30', 1),
(67, 12, 'P4', '2021-01-26 11:29:18', '2021-01-26 11:34:08', 1),
(68, 12, 'P4', '2021-01-26 11:33:47', '2021-01-26 11:34:08', 1);

-- --------------------------------------------------------

--
-- Structure de la table `asso_waypoint`
--

CREATE TABLE `asso_waypoint` (
  `WaypointBegin` varchar(5) NOT NULL,
  `Path` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `asso_waypoint`
--

INSERT INTO `asso_waypoint` (`WaypointBegin`, `Path`) VALUES
('C1', 'ARR1-ARR2-A1-A2-A3'),
('T3', 'B1-B2-B3-DEP1-DEP2'),
('05', 'B1-B2-B3-DEP1-DEP2'),
('C2', 'ARR3-ARR4-ARR5-E1-E2-E3-E4'),
('34R', 'F1-F2-F3-DEP3-DEP4');

-- --------------------------------------------------------

--
-- Structure de la table `avions`
--

CREATE TABLE `avions` (
  `idAvion` int(11) NOT NULL,
  `typeAvion` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `immatAvion` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `categorie` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `idCompagnie` int(11) NOT NULL,
  `images` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `avions`
--

INSERT INTO `avions` (`idAvion`, `typeAvion`, `immatAvion`, `categorie`, `idCompagnie`, `images`) VALUES
(1, 'A380', 'F-GAFT', 'A', 1, 'Avion_1.png'),
(2, 'B777', 'HL7534', 'A', 8, 'Avion_5.png'),
(3, 'TB-10', 'F-EVIL', 'C', 9, 'Avion_4.png'),
(4, 'TB-20', 'F-GOOD', 'C', 9, 'Avion_4.png'),
(5, 'PZL-104 Wilga', 'N123T', 'C', 9, 'Avion_4.png'),
(6, 'B727', 'JA73NM', 'A', 2, 'Avion_7.png'),
(7, 'B737', 'JA56AN', 'A', 7, 'Avion_7.png'),
(8, 'Boeing 747 Supertanker', 'N470EV', 'B', 10, 'Avion_2.png'),
(9, 'Douglas DC-10 Air Tanker', 'N17085', 'B', 11, 'Avion_6.png'),
(10, 'Douglas DC-8', 'JA8003', 'A', 2, 'Avion_2.png'),
(11, 'A300', 'JA8377', 'A', 6, 'Avion_6.png'),
(12, 'NAMC YS-11', 'JAUNKW', 'A', 4, 'Avion_5.png'),
(13, 'Lockheed L-1011 TriStar', 'JAUNKW', 'A', 4, 'Avion_3.png');

-- --------------------------------------------------------

--
-- Structure de la table `compagnie`
--

CREATE TABLE `compagnie` (
  `idCompagnie` int(11) NOT NULL,
  `nomCompagnie` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `compagnie`
--

INSERT INTO `compagnie` (`idCompagnie`, `nomCompagnie`) VALUES
(1, 'Air France'),
(2, 'Japan AIrlines'),
(3, 'Philippine Air Lines	'),
(4, 'All Nippon Airways'),
(5, 'JASDF'),
(6, 'Japan Air System'),
(7, 'Skymark Airlines'),
(8, 'Korean Air	'),
(9, 'Vol de courses/plaisance'),
(10, 'Evergreen International Airlines'),
(11, '10 Tanker Air Carrier');

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
-- Contenu de la table `identification`
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
-- Contenu de la table `parking`
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
,`images` varchar(50)
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
,`categorie` varchar(5)
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
-- Contenu de la table `waypoint`
--

INSERT INTO `waypoint` (`idWaypoint`, `coordonnees`, `type`, `rang`) VALUES
('A1', '139.82050, 35.54157', 'taxiway', 1),
('A2', '139.80679, 35.53006', 'taxiway', 2),
('A3', '139.80132, 35.53793', 'taxiway', 3),
('ARR1', '139.80383, 35.52428', 'pisteArrivee', 1),
('ARR2', '139.82198, 35.54049', 'pisteArrivee', 2),
('ARR3', '139.80307, 35.54261', 'pisteArrivee', 1),
('ARR4', '139.80081, 35.54595', 'pisteArrivee', 2),
('ARR5', '139.78678, 35.56565', 'pisteArrivee', 3),
('B1', '139.80004, 35.53732', 'taxiway', 1),
('B2', '139.80556, 35.52920', 'taxiway', 2),
('B3', '139.80143, 35.52579', 'taxiway', 3),
('C1', '139.78066, 35.50289', 'circuit', 1),
('C2', '139.81992, 35.51907', 'circuit', 1),
('DEP1', '139.80376, 35.52421', 'pisteDepart', 1),
('DEP2', '139.84302, 35.55940', 'pisteDepart', 2),
('DEP3', '139.80311, 35.54250', 'pisteDepart', 1),
('DEP4', '139.77512, 35.58139', 'pisteDepart', 2),
('E1', '139.78478, 35.56486', 'taxiway', 1),
('E2', '139.78748, 35.56114', 'taxiway', 2),
('E3', '139.78984, 35.55760', 'taxiway', 3),
('E4', '139.79183, 35.55498', 'taxiway', 4),
('F1', '139.79432, 35.55159', 'taxiway', 1),
('F2', '139.79709, 35.54730', 'taxiway', 2),
('F3', '139.80129, 35.54166', 'taxiway', 3),
('T1', '139.78913, 35.55393', 'taxiway', 1),
('T2', '139.79029, 35.55205', 'taxiway', 2),
('T3', '139.79165, 35.55012', 'taxiway', 3);

-- --------------------------------------------------------

--
-- Structure de la vue `vueavionlibre`
--
DROP TABLE IF EXISTS `vueavionlibre`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vueavionlibre`  AS  select `avions`.`idAvion` AS `idAvion`,`avions`.`images` AS `images`,`avions`.`immatAvion` AS `immatAvion`,`avions`.`categorie` AS `categorie` from (`avions` left join `asso_avionparking` on((`avions`.`idAvion` = `asso_avionparking`.`idAvion`))) where isnull(`asso_avionparking`.`dateArrivee`) ;

-- --------------------------------------------------------

--
-- Structure de la vue `vueparkinglibre`
--
DROP TABLE IF EXISTS `vueparkinglibre`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vueparkinglibre`  AS  select `parking`.`idParking` AS `idParking`,`parking`.`categorie` AS `categorie` from (`parking` left join `asso_avionparking` on((`parking`.`idParking` = `asso_avionparking`.`idParking`))) where (isnull(`asso_avionparking`.`dateArrivee`) or ((`asso_avionparking`.`dateArrivee` is not null) and (`asso_avionparking`.`dateDepart` is not null))) ;

--
-- Index pour les tables exportées
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
-- Index pour la table `asso_waypoint`
--
ALTER TABLE `asso_waypoint`
  ADD KEY `WaypointBegin` (`WaypointBegin`);

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
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `asso_avionparking`
--
ALTER TABLE `asso_avionparking`
  MODIFY `idAsso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;
--
-- AUTO_INCREMENT pour la table `avions`
--
ALTER TABLE `avions`
  MODIFY `idAvion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT pour la table `compagnie`
--
ALTER TABLE `compagnie`
  MODIFY `idCompagnie` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT pour la table `identification`
--
ALTER TABLE `identification`
  MODIFY `idUser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- Contraintes pour les tables exportées
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

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
