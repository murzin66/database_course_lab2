-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Май 21 2024 г., 20:12
-- Версия сервера: 10.3.16-MariaDB
-- Версия PHP: 7.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `observatory`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `EnsureDateUpdateColumnExists` ()  BEGIN
    ALTER TABLE sector ADD COLUMN IF NOT EXISTS date_update DATETIME;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Join_procedure` (IN `Table1` VARCHAR(40), IN `Table2` VARCHAR(40))  BEGIN        SET @sql = CONCAT('SELECT * FROM ', Table1, ' AS t1 CROSS JOIN ', Table2, ' AS t2 ON t1.id = t2.id');PREPARE stmt FROM @sql;EXECUTE stmt;DEALLOCATE PREPARE stmt;END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `files`
--

CREATE TABLE `files` (
  `id_file` int(11) NOT NULL,
  `id_my` int(11) NOT NULL,
  `description` text NOT NULL,
  `name_origin` text NOT NULL,
  `path` text NOT NULL,
  `date_upload` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `files`
--

INSERT INTO `files` (`id_file`, `id_my`, `description`, `name_origin`, `path`, `date_upload`) VALUES
(16, 17, 'Закачка из менеджера', 'test file 1.pdf', 'files/test_file1.pdf', '31-03-2023  20:07:59');

-- --------------------------------------------------------

--
-- Структура таблицы `natural_objects`
--

CREATE TABLE `natural_objects` (
  `id_object` int(10) NOT NULL,
  `type` varchar(40) NOT NULL,
  `galaxy` varchar(40) NOT NULL,
  `accuracy` float NOT NULL,
  `light_current` int(8) NOT NULL,
  `related_objects` varchar(40) NOT NULL,
  `note` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Структура таблицы `objects`
--

CREATE TABLE `objects` (
  `id_objects` int(10) NOT NULL,
  `type` varchar(40) NOT NULL,
  `accuracy` int(2) NOT NULL,
  `amount` int(5) NOT NULL,
  `time` time NOT NULL,
  `date` date NOT NULL,
  `note` varchar(40) NOT NULL,
  `date_update` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Структура таблицы `observable_objects`
--

CREATE TABLE `observable_objects` (
  `id_sector` int(10) NOT NULL,
  `id_object` int(10) NOT NULL,
  `id_position` int(10) NOT NULL,
  `object_name` varchar(40) NOT NULL,
  `object_speed` int(3) NOT NULL,
  `distance_to_object` int(6) NOT NULL,
  `id_scientist` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Структура таблицы `position`
--

CREATE TABLE `position` (
  `id_position` int(10) NOT NULL,
  `Earth_position` point NOT NULL,
  `Sun_position` point NOT NULL,
  `Moon_position` point NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Структура таблицы `scientists`
--

CREATE TABLE `scientists` (
  `id` int(11) NOT NULL,
  `text` text NOT NULL,
  `description` text NOT NULL,
  `keywords` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `scientists`
--

INSERT INTO `scientists` (`id`, `text`, `description`, `keywords`) VALUES
(12, 'Nikolay', 'engineer', 'MSU'),
(14, 'Julia', 'C++', '3 year experience'),
(17, 'Baranov', 'Engeneer', 'Ivanov'),
(18, 'Dmitry', 'C#', '1 year experience'),
(101, 'Ivan', 'Artist', 'SPBSTU'),
(102, 'Nikita', 'Ruby', '2year exp'),
(104, 'Bistrov Alex', 'Angular', '4 year experience');

-- --------------------------------------------------------

--
-- Структура таблицы `sector`
--

CREATE TABLE `sector` (
  `id` int(10) NOT NULL,
  `coordinates` point NOT NULL,
  `light_intensity` int(6) NOT NULL,
  `foreign_objects` varchar(40) NOT NULL,
  `objects_amount` int(4) NOT NULL,
  `unknown_amount` int(4) NOT NULL,
  `specified_amount` int(11) NOT NULL,
  `note` text NOT NULL,
  `date_update` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Дамп данных таблицы `sector`
--

INSERT INTO `sector` (`id`, `coordinates`, `light_intensity`, `foreign_objects`, `objects_amount`, `unknown_amount`, `specified_amount`, `note`, `date_update`) VALUES
(2, 0x, 133, 'no', 3, 2, 1, '', '2024-05-06 05:00:00'),
(12, 0x, 100, 'no', 1, 2, 1, '', '0000-00-00 00:00:00'),
(14, 0x, 150, '2', 3, 41, 1, '', '0000-00-00 00:00:00'),
(17, 0x, 100, '51', 1, 2, 4, '', '2024-05-21 20:10:25'),
(18, 0x, 2, '', 1, 0, 0, '', '0000-00-00 00:00:00');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `files`
--
ALTER TABLE `files`
  ADD PRIMARY KEY (`id_file`),
  ADD KEY `id_my` (`id_my`);

--
-- Индексы таблицы `natural_objects`
--
ALTER TABLE `natural_objects`
  ADD KEY `id_object` (`id_object`);

--
-- Индексы таблицы `objects`
--
ALTER TABLE `objects`
  ADD KEY `id_objects` (`id_objects`);

--
-- Индексы таблицы `observable_objects`
--
ALTER TABLE `observable_objects`
  ADD PRIMARY KEY (`id_object`),
  ADD KEY `id_sector` (`id_sector`),
  ADD KEY `id_position` (`id_position`),
  ADD KEY `id_scientist` (`id_scientist`);

--
-- Индексы таблицы `position`
--
ALTER TABLE `position`
  ADD PRIMARY KEY (`id_position`),
  ADD KEY `id_position` (`id_position`);

--
-- Индексы таблицы `scientists`
--
ALTER TABLE `scientists`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `sector`
--
ALTER TABLE `sector`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `files`
--
ALTER TABLE `files`
  MODIFY `id_file` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT для таблицы `scientists`
--
ALTER TABLE `scientists`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=105;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `files`
--
ALTER TABLE `files`
  ADD CONSTRAINT `files_ibfk_1` FOREIGN KEY (`id_my`) REFERENCES `scientists` (`id`);

--
-- Ограничения внешнего ключа таблицы `natural_objects`
--
ALTER TABLE `natural_objects`
  ADD CONSTRAINT `natural_objects_ibfk_1` FOREIGN KEY (`id_object`) REFERENCES `observable_objects` (`id_object`);

--
-- Ограничения внешнего ключа таблицы `objects`
--
ALTER TABLE `objects`
  ADD CONSTRAINT `objects_ibfk_1` FOREIGN KEY (`id_objects`) REFERENCES `observable_objects` (`id_object`);

--
-- Ограничения внешнего ключа таблицы `observable_objects`
--
ALTER TABLE `observable_objects`
  ADD CONSTRAINT `observable_objects_ibfk_1` FOREIGN KEY (`id_position`) REFERENCES `position` (`id_position`),
  ADD CONSTRAINT `observable_objects_ibfk_2` FOREIGN KEY (`id_sector`) REFERENCES `sector` (`id`),
  ADD CONSTRAINT `observable_objects_ibfk_3` FOREIGN KEY (`id_scientist`) REFERENCES `scientists` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
