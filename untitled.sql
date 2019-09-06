/*
 Navicat MySQL Data Transfer
 Source Server         : qcloud-db2
 Source Server Type    : MySQL
 Source Server Version : 50718
 Source Host           : cdb-68kpvdlt.gz.tencentcdb.com:10068
 Source Schema         : datingtoday
 Target Server Type    : MySQL
 Target Server Version : 50718
 File Encoding         : 65001
 Date: 09/08/2019 11:52:01
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for contacts
-- ----------------------------
DROP TABLE IF EXISTS `contacts`;
CREATE TABLE `contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '对话id',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `peer_id` int(11) NOT NULL COMMENT '对方id',
  `creator_id` int(11) NOT NULL COMMENT '对话创建者id，有可能是uid，也可能是peer_id',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `last_msg` varchar(255) DEFAULT NULL COMMENT '最新一条消息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=200766 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for label
-- ----------------------------
DROP TABLE IF EXISTS `label`;
CREATE TABLE `label` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `gender` tinyint(2) DEFAULT NULL COMMENT '1男2女0未知',
  `meaning` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for location
-- ----------------------------
DROP TABLE IF EXISTS `location`;
CREATE TABLE `location` (
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `ip_addr` varchar(64) DEFAULT NULL COMMENT '用户登录IP',
  `longitude` double(12,6) DEFAULT NULL COMMENT '经度信息',
  `latitude` double(12,6) DEFAULT NULL COMMENT '纬度信息',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_uid` int(11) DEFAULT NULL,
  `to_uid` int(11) DEFAULT NULL,
  `msg_type` varchar(6) DEFAULT NULL COMMENT 'text,audio,image,video',
  `audio` varchar(128) DEFAULT NULL,
  `content` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `image` varchar(128) DEFAULT NULL,
  `send_time` datetime DEFAULT NULL,
  `read` tinyint(1) DEFAULT NULL COMMENT '1 已读 0 未读',
  PRIMARY KEY (`id`),
  KEY `FK_fk_letterrecieveid` (`to_uid`),
  KEY `FK_fk_lettersendid` (`from_uid`),
  CONSTRAINT `message_ibfk_1` FOREIGN KEY (`from_uid`) REFERENCES `user_info` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `message_ibfk_2` FOREIGN KEY (`to_uid`) REFERENCES `user_info` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=100539 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL COMMENT '产品名称',
  `desc` varchar(255) DEFAULT NULL COMMENT '产品描述',
  `vip_time` int(10) unsigned DEFAULT NULL COMMENT 'vip时间为天',
  `price` double(11,2) DEFAULT NULL COMMENT '单价',
  `market_price` double(11,2) DEFAULT NULL COMMENT '市场价',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for user_album
-- ----------------------------
DROP TABLE IF EXISTS `user_album`;
CREATE TABLE `user_album` (
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `photo` varchar(100) NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `FK_fk_ufid` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for user_auth
-- ----------------------------
DROP TABLE IF EXISTS `user_auth`;
CREATE TABLE `user_auth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `open_id` varchar(128) DEFAULT NULL,
  `session_key` varchar(255) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `expired_time` timestamp NULL DEFAULT NULL COMMENT 'auth_code过期时间',
  `login_type` varchar(16) DEFAULT NULL COMMENT '登录方式，目前有phone,third_party',
  `login_time` timestamp NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '注册时间',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_auth_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user_info` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for user_info
-- ----------------------------
DROP TABLE IF EXISTS `user_info`;
CREATE TABLE `user_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(64) DEFAULT NULL,
  `nickname` varchar(64) DEFAULT NULL,
  `phone` varchar(16) DEFAULT NULL,
  `gender` int(2) DEFAULT '0' COMMENT '1男2女0未知',
  `birthday` datetime DEFAULT NULL,
  `avatar` varchar(128) DEFAULT NULL,
  `emotion` tinyint(2) DEFAULT '0' COMMENT '0 单身 1 已婚 2 离异 3保密',
  `height` int(3) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT NULL,
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100785 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for user_label
-- ----------------------------
DROP TABLE IF EXISTS `user_label`;
CREATE TABLE `user_label` (
  `user_id` int(11) NOT NULL,
  `label_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `FK_fk_ullabelid` (`label_id`),
  KEY `FK_fk_uluserid` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for user_order
-- ----------------------------
DROP TABLE IF EXISTS `user_order`;
CREATE TABLE `user_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned DEFAULT NULL,
  `product_id` int(11) unsigned DEFAULT NULL,
  `product_name` varchar(128) DEFAULT NULL,
  `fee` double(11,2) DEFAULT NULL,
  `open_id` varchar(64) DEFAULT NULL,
  `trade_no` varchar(64) DEFAULT NULL,
  `pay` int(2) unsigned DEFAULT '0' COMMENT '0 待支付，1 已支付，2 已取消',
  `order_time` timestamp NULL DEFAULT NULL COMMENT '下单时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for vip_info
-- ----------------------------
DROP TABLE IF EXISTS `vip_info`;
CREATE TABLE `vip_info` (
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `vip_deadline` timestamp NOT NULL DEFAULT '1970-01-01 11:11:11' COMMENT 'vip到期时间',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for visitor
-- ----------------------------
DROP TABLE IF EXISTS `visitor`;
CREATE TABLE `visitor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `visitor_id` int(11) NOT NULL COMMENT '访问者id',
  `visit_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '0 未读 1 已读',
  PRIMARY KEY (`id`),
  KEY `FK_fk_uvuserid` (`user_id`),
  KEY `FK_fk_uvvid` (`visitor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=244 DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;