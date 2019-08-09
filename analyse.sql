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

 Date: 09/08/2019 13:55:03
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '昵称',
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '电子邮箱',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态:0=隐藏,1=正常',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of admin
-- ----------------------------
BEGIN;
INSERT INTO `admin` VALUES (1, 'admin', '管理员', 'e10adc3949ba59abbe56e057f20f883e', NULL, 'blc0927@163.com', 1, NULL, '2019-07-27 21:37:45');
INSERT INTO `admin` VALUES (30, 'test', '', '4297f44b13955235245b2497399d7a93', '/assets/img/avatar.png', '123@163.com', 1, '2019-07-28 07:43:30', '2019-07-28 07:43:30');
COMMIT;

-- ----------------------------
-- Table structure for auth_role
-- ----------------------------
DROP TABLE IF EXISTS `auth_role`;
CREATE TABLE `auth_role` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL COMMENT '角色名称',
  `pid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '父角色ID',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态',
  `remark` varchar(255) DEFAULT '' COMMENT '备注',
  `listorder` int(3) NOT NULL DEFAULT '0' COMMENT '排序，优先级，越小优先级越高',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='角色表';

-- ----------------------------
-- Records of auth_role
-- ----------------------------
BEGIN;
INSERT INTO `auth_role` VALUES (1, '超级管理员', 0, 1, '拥有最高管理员权限', 0);
INSERT INTO `auth_role` VALUES (8, '测试员', 1, 1, '', 999);
COMMIT;

-- ----------------------------
-- Table structure for auth_role_admin
-- ----------------------------
DROP TABLE IF EXISTS `auth_role_admin`;
CREATE TABLE `auth_role_admin` (
  `role_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '角色 id',
  `admin_id` int(10) NOT NULL DEFAULT '0' COMMENT '管理员id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='用户角色对应表';

-- ----------------------------
-- Records of auth_role_admin
-- ----------------------------
BEGIN;
INSERT INTO `auth_role_admin` VALUES (1, 1);
INSERT INTO `auth_role_admin` VALUES (8, 30);
COMMIT;

-- ----------------------------
-- Table structure for auth_rule
-- ----------------------------
DROP TABLE IF EXISTS `auth_rule`;
CREATE TABLE `auth_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) DEFAULT '1' COMMENT '认证类型',
  `pid` int(10) NOT NULL DEFAULT '0' COMMENT '父ID',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '规则名称',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '规则名称',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=正常',
  `condition` char(100) NOT NULL DEFAULT '' COMMENT '条件\r\n条件',
  `ismenu` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为菜单',
  `icon` varchar(50) DEFAULT NULL COMMENT '图标',
  `listorder` int(10) DEFAULT '999',
  `path` varchar(60) NOT NULL DEFAULT '-' COMMENT '所有上级分类的ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=51 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of auth_rule
-- ----------------------------
BEGIN;
INSERT INTO `auth_rule` VALUES (1, 1, 0, 'auth', '权限管理', 1, '', 1, NULL, 999, '-');
INSERT INTO `auth_rule` VALUES (25, 1, 14, 'auth/rule/index', 'View', 1, '', 0, NULL, 999, '-1-14-');
INSERT INTO `auth_rule` VALUES (7, 1, 14, 'auth/rule/add', 'Add', 1, '', 0, NULL, 999, '-1-14-');
INSERT INTO `auth_rule` VALUES (24, 1, 13, 'auth/admin/index', 'View', 1, '', 0, NULL, 999, '-1-13-');
INSERT INTO `auth_rule` VALUES (6, 1, 1, 'auth/role', '角色组', 1, '', 1, NULL, 999, '1');
INSERT INTO `auth_rule` VALUES (8, 1, 14, 'auth/rule/edit', 'Edit', 1, '', 0, NULL, 999, '-1-14-');
INSERT INTO `auth_rule` VALUES (9, 1, 14, 'auth/rule/del', 'Del', 1, '', 0, NULL, 999, '-1-14-');
INSERT INTO `auth_rule` VALUES (10, 1, 13, 'auth/admin/add', 'Add', 1, '', 0, NULL, 999, '-1-13-');
INSERT INTO `auth_rule` VALUES (11, 1, 13, 'auth/admin/edit', 'Edit', 1, '', 0, NULL, 999, '-1-13-');
INSERT INTO `auth_rule` VALUES (12, 1, 13, 'auth/admin/del', 'Del', 1, '', 0, NULL, 999, '-1-13-');
INSERT INTO `auth_rule` VALUES (13, 1, 1, 'auth/admin', '管理员管理', 1, '', 1, NULL, 999, '1');
INSERT INTO `auth_rule` VALUES (14, 1, 1, 'auth/rule', '菜单规则', 1, '', 1, NULL, 999, '-1-');
INSERT INTO `auth_rule` VALUES (46, 1, 0, 'low', '低频彩分析', 1, '', 1, NULL, 999, '-');
INSERT INTO `auth_rule` VALUES (16, 1, 6, 'auth/role/add', 'Add', 1, '', 0, NULL, 999, '1-6');
INSERT INTO `auth_rule` VALUES (17, 1, 6, 'auth/role/edit', 'Edit', 1, '', 0, NULL, 999, '-1-6-');
INSERT INTO `auth_rule` VALUES (18, 1, 6, 'auth/role/del', 'Del', 1, '', 0, NULL, 999, '-1-6-');
INSERT INTO `auth_rule` VALUES (19, 1, 6, 'auth/role/auth', '授权', 1, '', 0, NULL, 999, '-1-6-');
INSERT INTO `auth_rule` VALUES (20, 1, 6, 'auth/role/authList', '获取授权列表', 1, '', 0, NULL, 999, '-1-6-');
INSERT INTO `auth_rule` VALUES (47, 1, 46, 'low/index', '查看', 1, '', 0, NULL, 999, '46');
INSERT INTO `auth_rule` VALUES (23, 1, 6, 'auth/role/index', 'View', 1, '', 0, NULL, 999, '-1-6-');
INSERT INTO `auth_rule` VALUES (48, 1, 46, 'low/add', '添加', 1, '', 0, NULL, 999, '46');
INSERT INTO `auth_rule` VALUES (49, 1, 46, 'low/edit', '修改', 1, '', 0, NULL, 999, '46');
INSERT INTO `auth_rule` VALUES (50, 1, 46, 'low/del', '删除', 1, '', 0, NULL, 999, '46');
INSERT INTO `auth_rule` VALUES (41, 1, 0, 'plan', '计划管理', 1, '', 1, NULL, 999, '-');
INSERT INTO `auth_rule` VALUES (42, 1, 41, 'plan/index', '查看', 1, '', 0, NULL, 999, '41');
INSERT INTO `auth_rule` VALUES (43, 1, 41, 'plan/add', '添加', 1, '', 0, NULL, 999, '41');
INSERT INTO `auth_rule` VALUES (44, 1, 41, 'plan/edit', '修改', 1, '', 0, NULL, 999, '41');
INSERT INTO `auth_rule` VALUES (45, 1, 41, 'plan/del', '删除', 1, '', 0, NULL, 999, '41');
COMMIT;

-- ----------------------------
-- Table structure for auth_rule_role
-- ----------------------------
DROP TABLE IF EXISTS `auth_rule_role`;
CREATE TABLE `auth_rule_role` (
  `rule_id` int(10) NOT NULL COMMENT '规则ID',
  `role_id` int(10) NOT NULL COMMENT '角色ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of auth_rule_role
-- ----------------------------
BEGIN;
INSERT INTO `auth_rule_role` VALUES (42, 8);
INSERT INTO `auth_rule_role` VALUES (46, 8);
INSERT INTO `auth_rule_role` VALUES (47, 8);
INSERT INTO `auth_rule_role` VALUES (48, 8);
INSERT INTO `auth_rule_role` VALUES (49, 8);
INSERT INTO `auth_rule_role` VALUES (50, 8);
COMMIT;

-- ----------------------------
-- Table structure for ball
-- ----------------------------
DROP TABLE IF EXISTS `ball`;
CREATE TABLE `ball` (
  `id` int(10) NOT NULL COMMENT '期号',
  `ball_number` varchar(20) NOT NULL COMMENT '球号'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of ball
-- ----------------------------
BEGIN;
INSERT INTO `ball` VALUES (83, '25-38-42-19-39-14-46');
INSERT INTO `ball` VALUES (84, '16-10-07-18-35-11-43');
INSERT INTO `ball` VALUES (85, '14-45-04-24-28-39-08');
INSERT INTO `ball` VALUES (86, '13-45-09-24-32-45-01');
INSERT INTO `ball` VALUES (87, '14-56-23-65-12-54-11');
INSERT INTO `ball` VALUES (88, '34-42-51-11-09-12-45');
INSERT INTO `ball` VALUES (91, '45-50-09-87-14-43-67');
INSERT INTO `ball` VALUES (92, '46-12-90-12-65-56-34');
INSERT INTO `ball` VALUES (93, '31-41-53-12-52-56-43');
INSERT INTO `ball` VALUES (94, '12-43-09-52-47-91-31');
INSERT INTO `ball` VALUES (95, '65-71-34-51-67-89-12');
INSERT INTO `ball` VALUES (96, '91-12-01-31-54-11-88');
INSERT INTO `ball` VALUES (97, '51-12-56-19-81-45-67');
INSERT INTO `ball` VALUES (98, '12-13-14-15-16-17-13');
INSERT INTO `ball` VALUES (99, '21-22-23-24-25-26-53');
INSERT INTO `ball` VALUES (100, '31-32-33-34-35-36-36');
INSERT INTO `ball` VALUES (101, '41-42-43-44-45-66-34');
INSERT INTO `ball` VALUES (89, '06-21-37-22-15-05-36');
COMMIT;

-- ----------------------------
-- Table structure for plan
-- ----------------------------
DROP TABLE IF EXISTS `plan`;
CREATE TABLE `plan` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '计划类型:1=低频彩.2=高频彩',
  `number` tinyint(1) NOT NULL DEFAULT '3' COMMENT '计划球数',
  `description` varchar(255) NOT NULL COMMENT '计划描述',
  `ball_number` varchar(200) NOT NULL COMMENT '球号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of plan
-- ----------------------------
BEGIN;
INSERT INTO `plan` VALUES (1, 1, 3, '第一个计划', '42-51-34,12-76-45,27-34-12,65-09-07');
INSERT INTO `plan` VALUES (2, 1, 3, 'fgdgg', '12-23-34');
INSERT INTO `plan` VALUES (3, 2, 3, 'gfsdg', '');
INSERT INTO `plan` VALUES (4, 1, 3, '多对多', '1-2-3,5-6-7');
INSERT INTO `plan` VALUES (5, 1, 3, '丰富公司法规', '1-2-3,5-6-7');
INSERT INTO `plan` VALUES (7, 1, 3, '2233', '32-43-12,12-76-13,45-13-76,13-65-13,65-78-12,52-72-23,41-61-13,76-12-23,24-53-52,54-24-62');
INSERT INTO `plan` VALUES (8, 1, 3, '这是一个10期计划', '24-25-26,32-33-34,41-42-43,22-25-34,24-28-35,1-8-10,2-5-7,25-32-42,22-27-28,11-24-38');
INSERT INTO `plan` VALUES (9, 1, 4, '', '1-2-3-4,2-3-4-5,3-4-5-6,4-5-6-7,5-6-7-8,6-7-8-9,7-8-9-10,8-9-10-11,9-10-11-12,10-11-12-13');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
