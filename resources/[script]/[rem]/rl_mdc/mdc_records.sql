/*
Navicat MySQL Data Transfer

Source Server         : Database
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : mta

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2021-12-01 03:53:04
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `mdc_records`
-- ----------------------------
DROP TABLE IF EXISTS `mdc_records`;
CREATE TABLE `mdc_records` (
  `id` int(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `plate` varchar(255) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of mdc_records
-- ----------------------------
INSERT INTO `mdc_records` VALUES ('544', 'sourceluascripting', '', 'sikinti yooook', '27.04.2021 / 01:21', 'player', null);
INSERT INTO `mdc_records` VALUES ('4', 'Kawasaki KXF250', 'KH5 7140', 'bakicam yaaaa', '27.04.2021 / 02:10', 'vehicle', null);
INSERT INTO `mdc_records` VALUES ('549', 'sourceluascripting', '', 'asdasd', '28.04.2021 / 00:27', 'player', null);
INSERT INTO `mdc_records` VALUES ('549', 'sourceluascripting', '', 'ekliyorum amk benim degil mi', '28.04.2021 / 00:32', 'player', null);
