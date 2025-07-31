-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 31, 2025 at 05:09 AM
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
-- Database: `docuease`
--

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `id_number` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`id`, `name`, `password`, `id_number`) VALUES
(1, 'Alexandra Anonuevo', '$2y$10$RhlxpKUiA23YheDORsrhR.Lx0b/Rhpxa3XULKf8xqaSCfD1TRspbi', 'EMP-288901'),
(2, 'Eliza Danlag', '$2y$10$rsh5nLhd7hg5LiGnXGWJ0e/5vs0oMA3exbtaO0lI3aO2Qhs4lqB2q', 'EMP-448209'),
(3, 'Eliza Jameah Danlag', '$2y$10$qm51zv7pdR1K0aU2nby/WOhzORY8871qLePsyEYNZEwt7BmVIO.9u', 'EMP-734594'),
(4, 'Eliza Danlag', '$2y$10$/pDU7J7BXFD5pxYfVCrp.Oi8UVXnQnLa4yUJOM7IEM2f8VbR90Rye', 'EMP-474694'),
(5, 'Christian Luis Hiwatig', '$2y$10$rvd4iDNBjmEj8sVnUnPKUON0.VUUFaT4je587WSb80skfXVJSlM5y', 'EMP-784831');

-- --------------------------------------------------------

--
-- Table structure for table `requests`
--

CREATE TABLE `requests` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `certificate_type` varchar(50) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `contact_number` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  `valid_id_path` varchar(255) DEFAULT NULL,
  `submitted_at` datetime NOT NULL DEFAULT current_timestamp(),
  `status` varchar(50) NOT NULL DEFAULT 'Pending',
  `date_of_birth` date DEFAULT NULL,
  `place_of_birth` varchar(255) DEFAULT NULL,
  `spouse_name` varchar(255) DEFAULT NULL,
  `date_of_marriage` date DEFAULT NULL,
  `date_of_death` date DEFAULT NULL,
  `place_of_death` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `requests`
--

INSERT INTO `requests` (`id`, `user_id`, `certificate_type`, `full_name`, `address`, `contact_number`, `email`, `valid_id_path`, `submitted_at`, `status`, `date_of_birth`, `place_of_birth`, `spouse_name`, `date_of_marriage`, `date_of_death`, `place_of_death`) VALUES
(12, 2, 'marriage', 'Alexandra Anonuevo', 'Tadlac, Alitagtag Batangas', '0912345678', 'elizajameahd@gmail.com', 'uploads/valid_ids/1752201269_68707835de52c_ChatGPT Image Jun 17, 2025, 10_04_07 PM.png', '2025-07-11 04:34:38', 'Completed', NULL, NULL, 'Ivhan Villapando', '1234-03-12', NULL, NULL),
(13, 2, 'birth', 'Juan Dela Cruz', 'Tadlac, Alitagtag Batangas', '09123456789', 'maria@gmail.com', 'uploads/valid_ids/1752201355_6870788bc601d_ChatGPT Image May 22, 2025, 12_12_01 PM.png', '2025-07-11 04:36:36', 'Pending', '2003-03-21', 'Tadlac, Alitagtag', NULL, NULL, NULL, NULL),
(15, 2, 'birth', 'Alexandra Anonuevo', 'Tadlac, Alitagtag Batangas', '0912345678', 'elizajameahd@gmail.com', 'uploads/valid_ids/1752216766_6870b4be57380_a511d9bc-e51b-4bf3-832f-75e0cda54b50.png', '2025-07-11 08:52:59', 'Pending', '2003-03-12', 'Lipa City', NULL, NULL, NULL, NULL),
(21, 9, 'Birth Certificate', 'Ashanti Pederoso Añonuevo', 'Ibaan Batangas', '09519657113', 'ashanti@gmail.com', 'uploads/valid_ids/id_6876fd764947d.jpg', '2025-07-16 09:16:38', 'Pending', '2025-05-15', 'Poblacion 8, Padre Garcia, Batangas', NULL, NULL, NULL, NULL),
(22, 9, 'Birth Certificate', 'Ashanti Pederoso Añonuevo', 'Ibaan Batangas', '09519657113', 'ashanti@gmail.com', 'uploads/valid_ids/id_6876fd77939d0.jpg', '2025-07-16 09:16:39', 'Pending', '2025-05-15', 'Poblacion 8, Padre Garcia, Batangas', NULL, NULL, NULL, NULL),
(23, 7, 'Birth Certificate', 'ria cruz', 'lipa city', '09251436251', 'ria@gmail.com', 'uploads/valid_ids/id_6876fe482c338.jpg', '2025-07-16 09:20:08', 'Pending', '2025-07-16', 'sa tabi lang', NULL, NULL, NULL, NULL),
(24, 8, 'Marriage Certificate', 'Melvi Añonuevo', 'Iban', '09279193352', 'alex@gmail.com', 'uploads/valid_ids/id_68772748cc883.jpg', '2025-07-16 12:15:04', 'Pending', NULL, NULL, 'Allan Añonuevo', '2025-05-06', NULL, NULL),
(25, 5, 'Birth Certificate', 'Maria Dela Cruz', 'lipa city', '09940352015', 'jun@gmail.com', 'uploads/valid_ids/id_68772848dc02c.jpg', '2025-07-16 12:19:20', 'Pending', '2025-07-16', 'lipa city', NULL, NULL, NULL, NULL),
(28, 15, 'death', 'Sharsi', 'pook', '09251346251', 'shelly@gmail.com', 'uploads/valid_ids/id_687f727d8b09b.jpg', '2025-07-22 19:14:05', 'Pending', NULL, NULL, NULL, NULL, '2025-07-22', 'liaan'),
(33, 427, 'marriage', 'Eliza', 'Lipa', '09940352015', 'elizajameahd@gmail.com', 'uploads/valid_ids/id_68839a9d48d23.jpg', '2025-07-25 22:54:21', 'Pending', NULL, NULL, 'jn', '2025-07-14', NULL, NULL),
(35, 427, 'death', 'yaya', 'lipa', '09940352015', 'elizajameahd@gmail.com', 'uploads/valid_ids/id_6888484ff2882.jpg', '2025-07-29 12:04:31', 'Processing', NULL, NULL, NULL, NULL, '2025-07-01', 'dyan lang'),
(36, 427, 'marriage', 'marie', 'lipa', '09940352015', 'elizajameahd@gmail.com', 'uploads/valid_ids/id_68884f2ea80a5.jpg', '2025-07-29 12:33:50', 'Pending', NULL, NULL, 'mario', '2025-07-21', NULL, NULL),
(37, 440, 'marriage', 'Maria Dela Cruz', 'Lipa City, Batangas', '09940352015', 'elizajameah25@gmail.com', 'uploads/valid_ids/id_68896018321c7.jpg', '2025-07-30 07:58:16', 'Processing', NULL, NULL, 'Mario Dela Cruz', '2025-07-06', NULL, NULL),
(38, 427, 'birth', 'Alexandra P. Añonuevo', 'Ibaan,  Batangas', '09519657113', 'elizajameahd@gmail.com', 'uploads/valid_ids/id_6889a7033888e.jpg', '2025-07-30 13:00:51', 'Pending', '2025-07-30', 'Padre Garcia Batangas', NULL, NULL, NULL, NULL),
(39, 427, 'birth', 'Alexandra P. Añonuevo', 'Ibaan,  Batangas', '09519657113', 'elizajameahd@gmail.com', 'uploads/valid_ids/id_6889a7202f7b9.jpg', '2025-07-30 13:01:20', 'Pending', '2025-07-29', 'Padre Garcia', NULL, NULL, NULL, NULL),
(40, 443, 'birth', 'Gilbert Saludaga', 'Padre Garcia', '09519657113', 'gilbertsaludaga89@gmail.com', 'uploads/valid_ids/id_6889cf4de695f.jpg', '2025-07-30 15:52:45', 'Pending', '2025-07-30', 'Padre Garcia', NULL, NULL, NULL, NULL),
(41, 446, 'birth', 'Alexandra Añonuevo', 'Padrea Garcia Batangas', '09519657113', 'alexandraannonuevo@gmail.com', 'uploads/valid_ids/id_6889d1456cdcd.jpg', '2025-07-30 16:01:09', 'Pending', '2025-07-15', 'Padre Garcia', NULL, NULL, NULL, NULL),
(42, 446, 'marriage', 'Alexandra Añonuevo', 'Padrea Garcia Batangas', '09519657113', 'alexandraannonuevo@gmail.com', 'uploads/valid_ids/id_6889d16cdf0ff.jpg', '2025-07-30 16:01:48', 'Processing', NULL, NULL, 'Juan Dela Criz', '2025-07-08', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `address` varchar(255) NOT NULL,
  `contact_no` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `otp` varchar(6) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'unverified'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `address`, `contact_no`, `email`, `password`, `created_at`, `otp`, `status`) VALUES
(2, 'Maria', 'Velina', 'Lipa City', '09213685127', 'maria@gmail.com', '$2y$10$xZb.Hz7ZSyTgP0LQjUtize6bl.N/XMCCMQWs.bpIKIRdFYh6KdjrG', '2025-07-05 20:41:27', NULL, 'unverified'),
(3, 'Jem ', 'Villapando', 'BagongPook, Lipa City', '09123456123', 'jem@gmail.com', '$2y$10$ieEx4xo5PIyMx9HO7ETvQ.1DuyMCdNvYvuy2Mva29J8u7ModSmn0a', '2025-07-11 10:41:37', NULL, 'unverified'),
(4, 'John Nicole', 'Catapang', 'San Jose, Lipa City', '09940352015', 'jn@gmail.com', '$2y$10$OMpPfCwdGhAlGR4f2llXAOPQKG3QPVyf7IKUOYXGGtbmvG8Zr15Ry', '2025-07-15 13:05:33', NULL, 'unverified'),
(5, 'Jun ', 'Cruz', 'lipa city', '09123621142', 'jun@gmail.com', '$2y$10$rY9u1EAejziAgElwVbRp4.di1ufpo6NCVGm910S9IZONOPLRgVu1u', '2025-07-15 15:49:50', NULL, 'unverified'),
(7, 'Ria', 'Cruz', 'Lipa City', '09940352015', 'ria@gmail.com', '$2y$10$MXE24xrutibb8w2mmvheZ.vbPVDneMXroTrLTj6QzCbxhEslY/K0W', '2025-07-15 23:14:03', NULL, 'unverified'),
(8, 'alex', 'maybe', 'lipa', '09940352015', 'alex@gmail.com', '$2y$10$zA7AnUq7kZyXnonPNpns9ePQ8seKuof5nrn6uMsx3c7NmRphu7nAy', '2025-07-16 08:13:58', NULL, 'unverified'),
(9, 'Ashati ', 'Añonuevo', 'Ibaan Batangas', '09279193352', 'ashanti@gmail.com', '$2y$10$fTlyVy1.o.aDtXwszo2jFeNVcZOUUG848XSa.8ewA8bMpQXsyd9Kq', '2025-07-16 08:49:25', NULL, 'unverified'),
(10, 'alex', 'anon', 'ibaan', ',,,,;)(', 'aaa@gmail.com', '$2y$10$rAdg/.q2Jj2yoRvuzypR1esMU6StJeR9gulQtPDB4Ac/4XeyPx0Si', '2025-07-16 10:16:41', NULL, 'unverified'),
(11, 'Christian', 'Hiwatig', 'Padre Garia Batangas', '09279193352', 'christian@gmail.com', '$2y$10$IqT8NmRrc0QA8atbbZoeOu2okeebILbqglPGzkjn7k8g4XlQm2Pcq', '2025-07-16 10:21:16', NULL, 'unverified'),
(13, 'Ayessa E', 'Enderez', 'Lipa', '09271182542', 'ayessae@outlook.com', '$2y$10$Izk8L9k1Q2y8GE61jP6id.BbkroXPvZ0cn3kScuBiQ77HLzTY33H.', '2025-07-16 10:52:25', NULL, 'unverified'),
(14, 'AyessaE', 'Ayessa', 'Lipa', '09271182542', 'ayessa@gmail.com', '$2y$10$PxiwdYPEbs49gz0X4NA6C.YsvBgYY4jpi7nR/gSWiW06JLcR4hH4S', '2025-07-16 10:54:56', NULL, 'unverified'),
(15, 'Shelly', 'Don', 'Lipa City Batangas ', '09940352015', 'shelly@gmail.com', '$2y$10$CjtKdWUo/Oug5FTBbWOhmeAmQpk0eHVGkRCNhJUxXeFC5Iew1EpQ.', '2025-07-16 12:32:32', '997259', 'unverified'),
(35, 'John Nicole', 'Catapang', 'san jose, lipa city', '09215939902', 'johnnicole@gmail.com', '$2y$10$53MyC60uIBlr5OvHn7SEPui3i0/FTJLzoxsg3Qfhq84F986zJECM2', '2025-07-21 14:28:52', NULL, 'unverified'),
(314, 'angelita', 'atienza', 'lipa batangas', '09940352015', 'angelitaatienza@gmail.com', '$2y$10$AeayWuzV8LlhJbxTDu2jpujytbRHy1SIax/77Qr76ZLGBBBcbqh6u', '2025-07-23 10:20:16', NULL, 'unverified'),
(318, 'Jem', 'Villapando', '888 F. Medrano Street Bagong Pook Lipa City', '09178405045', 'jematienza@gmail.com', '$2y$10$LsIdOL4L5qnNpMnMrYwzBecDp0M7ax8ArNP7rvAOHNsQWWgn/3VmK', '2025-07-23 10:27:40', NULL, 'unverified'),
(427, 'Eliza Jameah', 'Danlag', 'bpook lipa city', '09940352015', 'elizajameahd@gmail.com', '$2y$10$2rGCUi/20BaaDpElngV8LuAYKuCEoKodLYFqjCMgDyba3G3qQXrUm', '2025-07-25 22:52:55', NULL, 'verified'),
(438, 'Christian Luis', 'Hiwatig', 'Padre Garcia, Batangas', '09602718018', 'luis.hwtg@gmail.com', '$2y$10$ek.hp6IAYjScLqMhh6dgCOEnzvbtj3xvy9TeO3qMlyLL0682kwjYC', '2025-07-26 13:21:13', '784467', 'unverified'),
(439, 'Christian Luis', 'Hiwatig', 'Padre Garcia, Batangas', '09602718018', 'christian.loowis@gmail.com', '$2y$10$kAn2bbgraLxVJD3.gs6XCuGljgrmvkWTgK6hyPgF5YBR5a6YOfnga', '2025-07-26 13:22:13', NULL, 'verified'),
(440, 'Alex', 'Cruz', 'Ibaan, Batangas', '09940352015', 'elizajameah25@gmail.com', '$2y$10$HMfPPsbkyt6T27wmFV/QAOCN7zx9AQo5i9jyojiFChDUSQbwgiFUe', '2025-07-29 22:42:53', NULL, 'verified'),
(443, 'Gilbert', 'Saludaga', 'lipa City', '09940352015', 'gilbertsaludaga89@gmail.com', '$2y$10$HaXLw8/ySdI1x5sMDppW7Oa5q/exG4MAkk/O7Vc8QliWX7aeErs4y', '2025-07-30 09:07:11', NULL, 'verified'),
(444, 'Angelo', 'Torano', 'Lipa City', '09519657113', 'jelotorano17@gmail.com', '$2y$10$iNaL27yeV.317CpD8bGoVO4q/PH5h3J/DweiMnYW4ILzjm5IhZEEW', '2025-07-30 15:08:26', NULL, 'verified'),
(446, 'Alexandra', 'Anonuevo', 'Lipa City', '09519657113', 'alexandraannonuevo@gmail.com', '$2y$10$aEY0U1BmQegC/C7MrJOLEOJpiUHzaR/YUNPv6W7h1HbmfzVSxz7dK', '2025-07-30 15:58:40', NULL, 'verified');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_number` (`id_number`);

--
-- Indexes for table `requests`
--
ALTER TABLE `requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `requests`
--
ALTER TABLE `requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=447;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `requests`
--
ALTER TABLE `requests`
  ADD CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
