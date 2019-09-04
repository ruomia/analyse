/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50727
 Source Host           : localhost:3306
 Source Schema         : analyse

 Target Server Type    : MySQL
 Target Server Version : 50727
 File Encoding         : 65001

 Date: 09/08/2019 21:54:20
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ball
-- ----------------------------
DROP TABLE IF EXISTS `ball`;
CREATE TABLE `ball` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `ball_number` varchar(20) NOT NULL COMMENT '球号',
  `issue` int(5) NOT NULL COMMENT '期号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of ball
-- ----------------------------
BEGIN;
INSERT INTO `ball` VALUES (1, '25-38-42-19-39-14-46', 83);
INSERT INTO `ball` VALUES (2, '16-10-07-18-35-11-43', 84);
INSERT INTO `ball` VALUES (3, '14-45-04-24-28-39-08', 85);
INSERT INTO `ball` VALUES (4, '13-45-09-24-32-45-01', 86);
INSERT INTO `ball` VALUES (5, '14-56-23-65-12-54-11', 87);
INSERT INTO `ball` VALUES (6, '34-42-51-11-09-12-45', 88);
INSERT INTO `ball` VALUES (7, '06-21-37-22-15-05-36', 89);
INSERT INTO `ball` VALUES (10, '19-30-08-44-25-09-37', 90);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
