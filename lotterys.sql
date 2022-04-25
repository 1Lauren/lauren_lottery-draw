/*
 Navicat Premium Data Transfer

 Source Server         : server
 Source Server Type    : MySQL
 Source Server Version : 100417
 Source Host           : localhost:3306
 Source Schema         : qb

 Target Server Type    : MySQL
 Target Server Version : 100417
 File Encoding         : 65001

 Date: 26/04/2022 01:02:24
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for lotterys
-- ----------------------------
DROP TABLE IF EXISTS `lotterys`;
CREATE TABLE `lotterys`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `ticketnumber` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `price` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of lotterys
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
