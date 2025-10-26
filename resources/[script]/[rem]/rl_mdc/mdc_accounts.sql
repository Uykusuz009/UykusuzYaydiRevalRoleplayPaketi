/*
Navicat MySQL Data Transfer

Source Server         : Database
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : mta

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2021-12-01 03:52:48
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `mdc_accounts`
-- ----------------------------
DROP TABLE IF EXISTS `mdc_accounts`;
CREATE TABLE `mdc_accounts` (
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of mdc_accounts
-- ----------------------------
INSERT INTO `mdc_accounts` VALUES ('egm', 'egm103582');
