/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 50721
 Source Host           : localhost:3306
 Source Schema         : feedback

 Target Server Type    : MySQL
 Target Server Version : 50721
 File Encoding         : 65001

 Date: 22/07/2019 10:20:56
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '昵称',
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '电子邮箱',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态:0=隐藏,1=正常',
  `department` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '部门',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'admin', '管理员', '4297f44b13955235245b2497399d7a93', NULL, 'blc0927@163.com', 1, '菁英部', NULL, NULL);
INSERT INTO `admin` VALUES (29, '丘猫', '管理员', '4297f44b13955235245b2497399d7a93', '/assets/img/avatar.png', '123@163.com', 1, '菁英部', NULL, '2019-07-19 10:04:47');

-- ----------------------------
-- Table structure for auth_role
-- ----------------------------
DROP TABLE IF EXISTS `auth_role`;
CREATE TABLE `auth_role`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色名称',
  `pid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父角色ID',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备注',
  `listorder` int(3) NOT NULL DEFAULT 0 COMMENT '排序，优先级，越小优先级越高',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_role
-- ----------------------------
INSERT INTO `auth_role` VALUES (1, '超级管理员', 0, 1, '拥有最高管理员权限', 0);
INSERT INTO `auth_role` VALUES (6, '问题汇报组', 1, 1, '', 999);
INSERT INTO `auth_role` VALUES (7, 'test', 1, 1, '', 999);

-- ----------------------------
-- Table structure for auth_role_admin
-- ----------------------------
DROP TABLE IF EXISTS `auth_role_admin`;
CREATE TABLE `auth_role_admin`  (
  `role_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '角色 id',
  `admin_id` int(10) NOT NULL DEFAULT 0 COMMENT '管理员id'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户角色对应表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_role_admin
-- ----------------------------
INSERT INTO `auth_role_admin` VALUES (1, 1);
INSERT INTO `auth_role_admin` VALUES (6, 29);

-- ----------------------------
-- Table structure for auth_rule
-- ----------------------------
DROP TABLE IF EXISTS `auth_rule`;
CREATE TABLE `auth_rule`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NULL DEFAULT 1 COMMENT '认证类型',
  `pid` int(10) NOT NULL DEFAULT 0 COMMENT '父ID',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '规则名称',
  `title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '规则名称',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态:0=禁用,1=正常',
  `condition` char(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '条件\r\n条件',
  `ismenu` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为菜单',
  `icon` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图标',
  `listorder` int(10) NULL DEFAULT 999,
  `path` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '-' COMMENT '所有上级分类的ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 40 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_rule
-- ----------------------------
INSERT INTO `auth_rule` VALUES (1, 1, 0, 'auth', '权限管理', 1, '', 1, NULL, 999, '-');
INSERT INTO `auth_rule` VALUES (25, 1, 14, 'auth/rule/index', 'View', 1, '', 0, NULL, 999, '-1-14-');
INSERT INTO `auth_rule` VALUES (7, 1, 14, 'auth/rule/add', 'Add', 1, '', 0, NULL, 999, '-1-14-');
INSERT INTO `auth_rule` VALUES (24, 1, 13, 'auth/admin/index', 'View', 1, '', 0, NULL, 999, '-1-13-');
INSERT INTO `auth_rule` VALUES (6, 1, 6, 'auth/role', '角色组', 1, '', 1, NULL, 999, '1-6');
INSERT INTO `auth_rule` VALUES (8, 1, 14, 'auth/rule/edit', 'Edit', 1, '', 0, NULL, 999, '-1-14-');
INSERT INTO `auth_rule` VALUES (9, 1, 14, 'auth/rule/del', 'Del', 1, '', 0, NULL, 999, '-1-14-');
INSERT INTO `auth_rule` VALUES (10, 1, 13, 'auth/admin/add', 'Add', 1, '', 0, NULL, 999, '-1-13-');
INSERT INTO `auth_rule` VALUES (11, 1, 13, 'auth/admin/edit', 'Edit', 1, '', 0, NULL, 999, '-1-13-');
INSERT INTO `auth_rule` VALUES (12, 1, 13, 'auth/admin/del', 'Del', 1, '', 0, NULL, 999, '-1-13-');
INSERT INTO `auth_rule` VALUES (13, 1, 1, 'auth/admin', '管理员管理', 1, '', 1, NULL, 999, '1');
INSERT INTO `auth_rule` VALUES (14, 1, 1, 'auth/rule', '菜单规则', 1, '', 1, NULL, 999, '-1-');
INSERT INTO `auth_rule` VALUES (21, 1, 0, 'type', '问题类型', 1, '', 1, NULL, 999, '-');
INSERT INTO `auth_rule` VALUES (16, 1, 6, 'auth/role/add', 'Add', 1, '', 0, NULL, 999, '1-6');
INSERT INTO `auth_rule` VALUES (17, 1, 6, 'auth/role/edit', 'Edit', 1, '', 0, NULL, 999, '-1-6-');
INSERT INTO `auth_rule` VALUES (18, 1, 6, 'auth/role/del', 'Del', 1, '', 0, NULL, 999, '-1-6-');
INSERT INTO `auth_rule` VALUES (19, 1, 6, 'auth/role/auth', '授权', 1, '', 0, NULL, 999, '-1-6-');
INSERT INTO `auth_rule` VALUES (20, 1, 6, 'auth/role/authList', '获取授权列表', 1, '', 0, NULL, 999, '-1-6-');
INSERT INTO `auth_rule` VALUES (26, 1, 21, 'type/index', 'View', 1, '', 0, NULL, 999, '-21-');
INSERT INTO `auth_rule` VALUES (23, 1, 6, 'auth/role/index', 'View', 1, '', 0, NULL, 999, '-1-6-');
INSERT INTO `auth_rule` VALUES (27, 1, 21, 'type/add', 'Add', 1, '', 0, NULL, 999, '-21-');
INSERT INTO `auth_rule` VALUES (28, 1, 21, 'type/edit', 'Edit', 1, '', 0, NULL, 999, '-21-');
INSERT INTO `auth_rule` VALUES (29, 1, 21, 'type/del', 'Del', 1, '', 0, NULL, 999, '-21-');
INSERT INTO `auth_rule` VALUES (30, 1, 0, 'problem', '问题汇总', 1, '', 1, NULL, 999, '-');
INSERT INTO `auth_rule` VALUES (31, 1, 30, 'problem/index', 'View', 1, '', 0, NULL, 999, '-30-');
INSERT INTO `auth_rule` VALUES (32, 1, 30, 'problem/add', 'Add', 1, '', 0, NULL, 999, '-30-');
INSERT INTO `auth_rule` VALUES (33, 1, 30, 'problem/edit', 'Edit', 1, '', 0, NULL, 999, '-30-');
INSERT INTO `auth_rule` VALUES (34, 1, 30, 'problem/del', 'Del', 1, '', 0, NULL, 999, '-30-');
INSERT INTO `auth_rule` VALUES (35, 1, 0, 'module', '问题模块', 1, '', 1, NULL, 999, '-');
INSERT INTO `auth_rule` VALUES (36, 1, 35, 'module/index', 'View', 1, '', 0, NULL, 999, '-35-');
INSERT INTO `auth_rule` VALUES (37, 1, 35, 'module/add', 'Add', 1, '', 0, NULL, 999, '-35-');
INSERT INTO `auth_rule` VALUES (38, 1, 35, 'module/edit', 'Edit', 1, '', 0, NULL, 999, '-35-');
INSERT INTO `auth_rule` VALUES (39, 1, 35, 'module/del', 'Del', 1, '', 0, NULL, 999, '-35-');

-- ----------------------------
-- Table structure for auth_rule_role
-- ----------------------------
DROP TABLE IF EXISTS `auth_rule_role`;
CREATE TABLE `auth_rule_role`  (
  `rule_id` int(10) NOT NULL COMMENT '规则ID',
  `role_id` int(10) NOT NULL COMMENT '角色ID'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_rule_role
-- ----------------------------
INSERT INTO `auth_rule_role` VALUES (26, 6);
INSERT INTO `auth_rule_role` VALUES (31, 6);
INSERT INTO `auth_rule_role` VALUES (32, 6);
INSERT INTO `auth_rule_role` VALUES (33, 6);
INSERT INTO `auth_rule_role` VALUES (36, 6);

-- ----------------------------
-- Table structure for module
-- ----------------------------
DROP TABLE IF EXISTS `module`;
CREATE TABLE `module`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `pid` int(10) NOT NULL COMMENT '上一级id',
  `name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类名称',
  `path` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '-' COMMENT 'path',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of module
-- ----------------------------
INSERT INTO `module` VALUES (1, 0, '我是用户-我的', '-');
INSERT INTO `module` VALUES (2, 1, '标题栏1', '1');
INSERT INTO `module` VALUES (4, 1, '我的档案5', '1');
INSERT INTO `module` VALUES (5, 0, '我是用户-叮医1', '-');
INSERT INTO `module` VALUES (6, 5, '医生标签1', '5');
INSERT INTO `module` VALUES (7, 0, '我是用户-消息', '-');
INSERT INTO `module` VALUES (8, 0, '我是医生-叮友1', '-');
INSERT INTO `module` VALUES (11, 4, 'test123', '1-4');
INSERT INTO `module` VALUES (12, 4, '2233135445', '1-4');

-- ----------------------------
-- Table structure for problem
-- ----------------------------
DROP TABLE IF EXISTS `problem`;
CREATE TABLE `problem`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `type_id` int(10) NOT NULL COMMENT '类型ID',
  `path` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '问题模块',
  `content` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '问题内容',
  `programme` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '改进方案',
  `admin_id` int(10) NOT NULL COMMENT '管理员ID',
  `create_time` date NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` date NULL DEFAULT NULL COMMENT '更改时间',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '图片',
  `link` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '问题链接',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '备注',
  `weigh` int(10) NOT NULL DEFAULT 0 COMMENT '权重',
  `serious` int(10) NOT NULL DEFAULT 0 COMMENT '严重程度',
  `status` tinyint(1) NOT NULL COMMENT '状态:0=待处理,1=已解决,2=未解决',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of problem
-- ----------------------------
INSERT INTO `problem` VALUES (7, 2, '-1-2-', '第一个问题', 'asfasdfasf', 1, '2019-07-03', '2019-07-16', '', 'asdfasdff', 'asdfadsf', 0, 10, 0);
INSERT INTO `problem` VALUES (8, 2, '-5-6-', '111', '111', 1, '2019-07-20', '2019-07-20', '', '11111', '11111', 0, 0, 0);
INSERT INTO `problem` VALUES (12, 2, '-1-', 'gsfdgsfdg', 'sgfsdgsdfg', 1, '2019-07-20', '2019-07-20', '', 'sdgsdgsdfg', 'gsdgsdfgsdfgsfdg', 0, 0, 0);

-- ----------------------------
-- Table structure for type
-- ----------------------------
DROP TABLE IF EXISTS `type`;
CREATE TABLE `type`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型名称',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of type
-- ----------------------------
INSERT INTO `type` VALUES (1, '建议优化1', 1);
INSERT INTO `type` VALUES (2, '不当之处', 1);
INSERT INTO `type` VALUES (5, '13424人情味儿', 1);
INSERT INTO `type` VALUES (6, '不当之处1', 1);

SET FOREIGN_KEY_CHECKS = 1;
