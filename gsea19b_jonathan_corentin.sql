-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 27, 2021 at 12:51 PM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.4.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gsea19b_jonathan_corentin`
--

-- --------------------------------------------------------

--
-- Table structure for table `asso_avionparking`
--

CREATE TABLE `asso_avionparking` (
  `idAsso` int(11) NOT NULL,
  `idAvion` int(11) NOT NULL,
  `idParking` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `dateArrivee` datetime NOT NULL,
  `dateDepart` datetime DEFAULT NULL,
  `idUserValidation` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `asso_waypoint`
--

CREATE TABLE `asso_waypoint` (
  `WaypointBegin` varchar(5) NOT NULL,
  `Path` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `asso_waypoint`
--

INSERT INTO `asso_waypoint` (`WaypointBegin`, `Path`) VALUES
('C1', 'ARR1-ARR2-A1-A2-A3'),
('T3', 'B1-B2-B3-DEP1-DEP2'),
('05', 'B1-B2-B3-DEP1-DEP2'),
('C2', 'ARR3-ARR4-ARR5-E1-E2-E3-E4'),
('34R', 'F1-F2-F3-DEP3-DEP4');

-- --------------------------------------------------------

--
-- Table structure for table `avions`
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
-- Dumping data for table `avions`
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
(13, 'Lockheed L-1011 TriStar', 'JAUNKW2', 'A', 4, 'Avion_3.png');

-- --------------------------------------------------------

--
-- Table structure for table `compagnie`
--

CREATE TABLE `compagnie` (
  `idCompagnie` int(11) NOT NULL,
  `nomCompagnie` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `compagnie`
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
-- Table structure for table `identification`
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
-- Dumping data for table `identification`
--

INSERT INTO `identification` (`idUser`, `nom`, `prenom`, `mail`, `login`, `motPasse`, `statut`, `newMdp`) VALUES
(1, 'Kiku', 'Jonathan', 'kiku.jonathan@enac.fr', 'a', 'ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb', 0, 0),
(2, 'Ryu', 'Corentin', 'ryu.corentin@enac.fr', 'b', 'b', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `parking`
--

CREATE TABLE `parking` (
  `idParking` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `nomParking` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `categorie` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `coordonnees` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `waypointProche` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `parking`
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
-- Stand-in structure for view `vueavionlibre`
-- (See below for the actual view)
--
CREATE TABLE `vueavionlibre` (
`idAvion` int(11)
,`images` varchar(50)
,`immatAvion` varchar(10)
,`categorie` varchar(5)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vueparkinglibre`
-- (See below for the actual view)
--
CREATE TABLE `vueparkinglibre` (
`idParking` varchar(5)
,`categorie` varchar(5)
);

-- --------------------------------------------------------

--
-- Table structure for table `waypoint`
--

CREATE TABLE `waypoint` (
  `idWaypoint` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `coordonnees` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_mysql500_ci NOT NULL,
  `type` enum('taxiway','circuit','pisteArrivee','pisteDepart','circuitDep','') CHARACTER SET ucs2 COLLATE ucs2_general_mysql500_ci NOT NULL,
  `rang` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `waypoint`
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
-- Structure for view `vueavionlibre`
--
DROP TABLE IF EXISTS `vueavionlibre`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vueavionlibre`  AS  select `avions`.`idAvion` AS `idAvion`,`avions`.`images` AS `images`,`avions`.`immatAvion` AS `immatAvion`,`avions`.`categorie` AS `categorie` from (`avions` left join `asso_avionparking` on(`avions`.`idAvion` = `asso_avionparking`.`idAvion`)) where `asso_avionparking`.`dateArrivee` is null ;

-- --------------------------------------------------------

--
-- Structure for view `vueparkinglibre`
--
DROP TABLE IF EXISTS `vueparkinglibre`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vueparkinglibre`  AS  select `parking`.`idParking` AS `idParking`,`parking`.`categorie` AS `categorie` from (`parking` left join (select distinct `asso_avionparking`.`idParking` AS `idParking`,`asso_avionparking`.`dateArrivee` AS `dateArrivee`,first_value(`asso_avionparking`.`dateDepart`) over ( partition by `asso_avionparking`.`idParking` order by `asso_avionparking`.`idAsso` desc) AS `FIRST_VALUE(dateDepart) OVER (PARTITION BY idParking ORDER BY idAsso DESC)` from `asso_avionparking` where `asso_avionparking`.`dateDepart` is null) `nonlibre` on(`parking`.`idParking` = `nonlibre`.`idParking`)) where `nonlibre`.`idParking` is null ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `asso_avionparking`
--
ALTER TABLE `asso_avionparking`
  ADD PRIMARY KEY (`idAsso`),
  ADD KEY `FKAvion` (`idAvion`),
  ADD KEY `FKParking` (`idParking`),
  ADD KEY `FKUser` (`idUserValidation`);

--
-- Indexes for table `asso_waypoint`
--
ALTER TABLE `asso_waypoint`
  ADD KEY `WaypointBegin` (`WaypointBegin`);

--
-- Indexes for table `avions`
--
ALTER TABLE `avions`
  ADD PRIMARY KEY (`idAvion`),
  ADD KEY `FKCompagnie` (`idCompagnie`);

--
-- Indexes for table `compagnie`
--
ALTER TABLE `compagnie`
  ADD PRIMARY KEY (`idCompagnie`);

--
-- Indexes for table `identification`
--
ALTER TABLE `identification`
  ADD PRIMARY KEY (`idUser`);

--
-- Indexes for table `parking`
--
ALTER TABLE `parking`
  ADD PRIMARY KEY (`idParking`),
  ADD KEY `FKwaypoint` (`waypointProche`);

--
-- Indexes for table `waypoint`
--
ALTER TABLE `waypoint`
  ADD PRIMARY KEY (`idWaypoint`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `asso_avionparking`
--
ALTER TABLE `asso_avionparking`
  MODIFY `idAsso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=253;

--
-- AUTO_INCREMENT for table `avions`
--
ALTER TABLE `avions`
  MODIFY `idAvion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `compagnie`
--
ALTER TABLE `compagnie`
  MODIFY `idCompagnie` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `identification`
--
ALTER TABLE `identification`
  MODIFY `idUser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `asso_avionparking`
--
ALTER TABLE `asso_avionparking`
  ADD CONSTRAINT `FKAvion` FOREIGN KEY (`idAvion`) REFERENCES `avions` (`idAvion`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FKParking` FOREIGN KEY (`idParking`) REFERENCES `parking` (`idParking`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FKUser` FOREIGN KEY (`idUserValidation`) REFERENCES `identification` (`idUser`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `avions`
--
ALTER TABLE `avions`
  ADD CONSTRAINT `FKCompagnie` FOREIGN KEY (`idCompagnie`) REFERENCES `compagnie` (`idCompagnie`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `parking`
--
ALTER TABLE `parking`
  ADD CONSTRAINT `FKwaypoint` FOREIGN KEY (`waypointProche`) REFERENCES `waypoint` (`idWaypoint`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
