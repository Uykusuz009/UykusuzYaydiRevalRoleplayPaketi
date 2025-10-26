/*
Navicat MySQL Data Transfer

Source Server         : Database
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : mta

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2021-12-01 03:52:56
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `mdc_wanteds`
-- ----------------------------
DROP TABLE IF EXISTS `mdc_wanteds`;
CREATE TABLE `mdc_wanteds` (
  `id` int(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `plate` varchar(255) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of mdc_wanteds
-- ----------------------------
INSERT INTO `mdc_wanteds` VALUES ('544', 'sourceluascripting', '', 'test', '27.05.2021 / 01:21', 'player', null);
INSERT INTO `mdc_wanteds` VALUES ('4', 'Kawasaki KXF250', 'KH5 7140', 'test', '27.05.2021 / 02:10', 'vehicle', null);
INSERT INTO `mdc_wanteds` VALUES ('22282', 'Bekir_Askar', '', 'orosp uevladÄ±', '18.11.2021 / 04:03', 'player', 'pavlov');
INSERT INTO `mdc_wanteds` VALUES ('22282', 'Bekir_Askar', '', 'orospu evladÄ±', '18.11.2021 / 07:09', 'player', 'bekiroj');
