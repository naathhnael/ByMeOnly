-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 01, 2024 at 03:35 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_tokoperhiasan`
--

-- --------------------------------------------------------

--
-- Table structure for table `tb_customer`
--

CREATE TABLE `tb_customer` (
  `id_customer` varchar(100) NOT NULL,
  `nama_customer` varchar(100) NOT NULL,
  `no_hp` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_customer`
--

INSERT INTO `tb_customer` (`id_customer`, `nama_customer`, `no_hp`) VALUES
('C01', 'Nathanael', '0897617434'),
('C02', 'Heisya', '08976636434'),
('C03', 'Dheva', '0897615524'),
('C04', 'Suparta', '0897588434');

-- --------------------------------------------------------

--
-- Table structure for table `tb_kategori`
--

CREATE TABLE `tb_kategori` (
  `id_kategori` varchar(100) NOT NULL,
  `jenis_kategori` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_kategori`
--

INSERT INTO `tb_kategori` (`id_kategori`, `jenis_kategori`) VALUES
('K01', 'Emas'),
('K02', 'Perunggu'),
('K03', 'Perak');

-- --------------------------------------------------------

--
-- Table structure for table `tb_perhiasan`
--

CREATE TABLE `tb_perhiasan` (
  `id_perhiasan` varchar(100) NOT NULL,
  `id_kategori` varchar(100) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `karat` int(10) DEFAULT NULL,
  `berat` int(10) DEFAULT NULL,
  `harga` int(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_perhiasan`
--

INSERT INTO `tb_perhiasan` (`id_perhiasan`, `id_kategori`, `nama`, `deskripsi`, `karat`, `berat`, `harga`) VALUES
('P01', 'K01', 'Liontin', 'Liontin yang terbuat dari emas', 24, 5, 1000000),
('P02', 'K03', 'Gelang', 'Gelang bagus dari perunggu', 16, 10, 500000),
('P03', 'K02', 'Kalung', 'Kalung terbuat dari perunggu', 10, 100, 250000),
('P04', 'K02', 'Cincin', 'cincin bagus', 5, 20, 200000);

-- --------------------------------------------------------

--
-- Table structure for table `tb_transaksi`
--

CREATE TABLE `tb_transaksi` (
  `id_transaksi` int(100) NOT NULL,
  `id_customer` varchar(100) NOT NULL,
  `id_perhiasan` varchar(100) NOT NULL,
  `jumlah` int(100) DEFAULT NULL,
  `total_harga` int(100) DEFAULT NULL,
  `diskon` int(100) DEFAULT NULL,
  `total_harga_akhir` int(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_transaksi`
--

INSERT INTO `tb_transaksi` (`id_transaksi`, `id_customer`, `id_perhiasan`, `jumlah`, `total_harga`, `diskon`, `total_harga_akhir`) VALUES
(1, 'C03', 'P03', 5, 1000000, NULL, NULL),
(2, 'C02', 'P02', 4, NULL, 0, 2000000),
(3, 'C02', 'P02', 40, 20000000, 0, NULL),
(4, 'C02', 'P02', 40, 20000000, 2000000, 18000000),
(5, 'C02', 'P02', 4, 2000000, 0, 2000000);

--
-- Triggers `tb_transaksi`
--
DELIMITER $$
CREATE TRIGGER `hitung_total_harga` BEFORE INSERT ON `tb_transaksi` FOR EACH ROW BEGIN
    DECLARE harga_per_item INT(100);
    DECLARE total_harga INT(100);

    -- Mengambil harga per item dari tabel tb_perhiasan
    SELECT harga INTO harga_per_item
    FROM tb_perhiasan
    WHERE id_perhiasan = NEW.id_perhiasan;

    -- Menghitung total harga sebelum diskon per item
    SET total_harga = NEW.jumlah * harga_per_item;

    -- Menghitung diskon
    IF total_harga > 10000000 THEN
        SET NEW.diskon = 0.1 * total_harga; -- Diskon 10% jika total harga melebihi 10.000.000
    ELSE
        SET NEW.diskon = 0; -- Tidak ada diskon jika total harga tidak melebihi 10.000.000
    END IF;
    
    -- Menghitung total harga akhir
    SET NEW.total_harga = total_harga;
    SET NEW.total_harga_akhir = total_harga - NEW.diskon;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_transaksi_detail`
-- (See below for the actual view)
--
CREATE TABLE `view_transaksi_detail` (
`id_transaksi` int(100)
,`nama_customer` varchar(100)
,`no_hp` varchar(15)
,`nama_perhiasan` varchar(100)
,`deskripsi_perhiasan` text
,`karat` int(10)
,`berat` int(10)
,`jumlah` int(100)
,`total_harga` int(100)
,`diskon` int(100)
,`total_harga_akhir` int(100)
);

-- --------------------------------------------------------

--
-- Structure for view `view_transaksi_detail`
--
DROP TABLE IF EXISTS `view_transaksi_detail`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_transaksi_detail`  AS SELECT `t`.`id_transaksi` AS `id_transaksi`, `c`.`nama_customer` AS `nama_customer`, `c`.`no_hp` AS `no_hp`, `p`.`nama` AS `nama_perhiasan`, `p`.`deskripsi` AS `deskripsi_perhiasan`, `p`.`karat` AS `karat`, `p`.`berat` AS `berat`, `t`.`jumlah` AS `jumlah`, `t`.`total_harga` AS `total_harga`, `t`.`diskon` AS `diskon`, `t`.`total_harga_akhir` AS `total_harga_akhir` FROM ((`tb_transaksi` `t` join `tb_customer` `c` on(`t`.`id_customer` = `c`.`id_customer`)) join `tb_perhiasan` `p` on(`t`.`id_perhiasan` = `p`.`id_perhiasan`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_customer`
--
ALTER TABLE `tb_customer`
  ADD PRIMARY KEY (`id_customer`);

--
-- Indexes for table `tb_kategori`
--
ALTER TABLE `tb_kategori`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indexes for table `tb_perhiasan`
--
ALTER TABLE `tb_perhiasan`
  ADD PRIMARY KEY (`id_perhiasan`),
  ADD KEY `id_kategori` (`id_kategori`);

--
-- Indexes for table `tb_transaksi`
--
ALTER TABLE `tb_transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_customer` (`id_customer`),
  ADD KEY `id_perhiasan` (`id_perhiasan`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_transaksi`
--
ALTER TABLE `tb_transaksi`
  MODIFY `id_transaksi` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tb_perhiasan`
--
ALTER TABLE `tb_perhiasan`
  ADD CONSTRAINT `tb_perhiasan_ibfk_1` FOREIGN KEY (`id_kategori`) REFERENCES `tb_kategori` (`id_kategori`);

--
-- Constraints for table `tb_transaksi`
--
ALTER TABLE `tb_transaksi`
  ADD CONSTRAINT `tb_transaksi_ibfk_1` FOREIGN KEY (`id_customer`) REFERENCES `tb_customer` (`id_customer`),
  ADD CONSTRAINT `tb_transaksi_ibfk_2` FOREIGN KEY (`id_perhiasan`) REFERENCES `tb_perhiasan` (`id_perhiasan`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
