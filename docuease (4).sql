-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 07, 2025 at 07:39 AM
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
CREATE DATABASE IF NOT EXISTS `docuease` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `docuease`;

-- --------------------------------------------------------

--
-- Table structure for table `requests`
--

DROP TABLE IF EXISTS `requests`;
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
(1, 1, 'birth', 'Eliza Jameah Danlag', 'bagongpook', '09279843328', 'elizajameahd@gmail.com', 'uploads/valid_ids/1751718154_6869190aa3288_484774110_1043784791119473_1402494193239981523_n.jpg', '2025-07-05 14:22:54', 'Pending', '2003-06-25', 'lipa city', NULL, NULL, NULL, NULL),
(2, 1, 'Birth Certificate', 'Eliza Jameah Danlag', '888 F. Medrano Street Bagong Pook Lipa City', '09279843328', 'elizajameahd@gmail.com', 'uploads/valid_ids/id_68691aec05501.jpg', '2025-07-05 14:30:36', 'Pending', '2003-06-25', 'Lipa City', NULL, NULL, NULL, NULL),
(3, 1, 'Birth Certificate', 'Eliza Jameah Danlag', '888 F. Medrano Street Bagong Pook Lipa City', '09279843328', 'elizajameahd@gmail.com', 'uploads/valid_ids/id_68691af32d8a8.jpg', '2025-07-05 14:30:43', 'Pending', '2003-06-25', 'Lipa City', NULL, NULL, NULL, NULL),
(4, 1, 'Birth Certificate', 'Eliza Jameah Danlag', '888 F. Medrano Street Bagong Pook Lipa City', '09279843328', 'elizajameahd@gmail.com', 'uploads/valid_ids/id_68691af335134.jpg', '2025-07-05 14:30:43', 'Pending', '2003-06-25', 'Lipa City', NULL, NULL, NULL, NULL),
(5, 1, 'Birth Certificate', 'Eliza Jameah Danlag', '888 F. Medrano Street Bagong Pook Lipa City', '09279843328', 'elizajameahd@gmail.com', 'uploads/valid_ids/id_68691af4137f3.jpg', '2025-07-05 14:30:44', 'Pending', '2003-06-25', 'Lipa City', NULL, NULL, NULL, NULL),
(6, 1, 'Marriage Certificate', 'Maria Velina', 'Lipa City', '0912345678', 'maria@gmail.com', 'uploads/valid_ids/id_68691dcb61763.png', '2025-07-05 14:42:51', 'Pending', NULL, NULL, 'Dino Velina', '2025-07-05', NULL, NULL),
(7, 1, 'Birth Certificate', 'Daniel', 'Batangas', '09193928187', 'daniel@gmail.com', 'uploads/valid_ids/id_6869220acbad5.jpg', '2025-07-05 15:00:58', 'Pending', '2004-07-05', 'Garcia', NULL, NULL, NULL, NULL),
(8, 1, 'Birth Certificate', 'Daniel', 'Batangas', '09193928187', 'daniel@gmail.com', 'uploads/valid_ids/id_6869220c64e90.jpg', '2025-07-05 15:01:00', 'Pending', '2004-07-05', 'Garcia', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `address` varchar(255) NOT NULL,
  `contact_no` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `address`, `contact_no`, `email`, `password`, `created_at`) VALUES
(1, 'eliza', 'danlag', 'bagongpook', '09876543211', 'elizajameahd@gmail.com', '$2y$10$pL8SKccQchr4Xr2Kn/eqs.4AY23tTLlUuSTRS/TEmsz/giIrkC.su', '2025-07-05 20:21:45'),
(2, 'Maria', 'Velina', 'Lipa City', '09213685127', 'maria@gmail.com', '$2y$10$xZb.Hz7ZSyTgP0LQjUtize6bl.N/XMCCMQWs.bpIKIRdFYh6KdjrG', '2025-07-05 20:41:27');

--
-- Indexes for dumped tables
--

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
-- AUTO_INCREMENT for table `requests`
--
ALTER TABLE `requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
