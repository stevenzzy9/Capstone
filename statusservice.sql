/*
 Navicat Premium Data Transfer

 Source Server         : test
 Source Server Type    : MySQL
 Source Server Version : 50614
 Source Host           : localhost
 Source Database       : statusservice

 Target Server Type    : MySQL
 Target Server Version : 50614
 File Encoding         : utf-8

 Date: 04/25/2014 15:58:05 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `keyword`
-- ----------------------------
DROP TABLE IF EXISTS `keyword`;
CREATE TABLE `keyword` (
  `MeetingID` bigint(20) NOT NULL,
  `KeyWord` varchar(50) NOT NULL,
  PRIMARY KEY (`MeetingID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `keyword`
-- ----------------------------
BEGIN;
INSERT INTO `keyword` VALUES ('0', 'meeting1'), ('1', 'meeting');
COMMIT;

-- ----------------------------
--  Table structure for `location`
-- ----------------------------
DROP TABLE IF EXISTS `location`;
CREATE TABLE `location` (
  `userid` bigint(10) NOT NULL,
  `location` text NOT NULL,
  `locationtype` int(11) NOT NULL,
  KEY `userid` (`userid`),
  CONSTRAINT `userid` FOREIGN KEY (`userid`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `location`
-- ----------------------------
BEGIN;
INSERT INTO `location` VALUES ('2', '0.0,0.0', '0'), ('1', '43.03833980179119,-87.95729264616966', '1'), ('1', '43.81317978337242,-91.22641324996948', '0'), ('12', '0.12617872142034017,0.09332176297903061', '0'), ('12', '40.63366406331576,-74.11998555064201', '1'), ('23', '43.81306970257903,-91.22656345367432', '0'), ('23', '40.71236774221048,-73.98992892354727', '1'), ('24', '8.931317933689161,9.057778604328632', '0'), ('24', '40.710459399047274,-74.00068625807762', '1'), ('25', '5.7887729996997725,-2.1205145493149757', '0'), ('25', '40.790392642678434,-73.93545527011156', '1'), ('26', '4.945020158118541,13.066413067281246', '0'), ('26', '43.81330099297835,-91.22620638459921', '1'), ('27', '6.19689569469035,-4.538067318499088', '0'), ('27', '43.813230347888634,-91.22627008706331', '1'), ('28', '43.02002234421559,-89.36562839895487', '0'), ('28', '43.812806717532474,-91.22630696743727', '1'), ('30', '43.81283260479634,-91.23159024864435', '0'), ('30', '44.64726535200626,-93.30797508358955', '1'), ('31', '43.813031960545985,-91.2313112989068', '0'), ('31', '43.04876956951685,-89.34854440391064', '1'), ('32', '43.8130689767709,-91.22636798769236', '0'), ('32', '43.53135377952031,-89.44897804409266', '1');
COMMIT;

-- ----------------------------
--  Table structure for `movie`
-- ----------------------------
DROP TABLE IF EXISTS `movie`;
CREATE TABLE `movie` (
  `MovieName` varchar(50) NOT NULL,
  `MovieID` int(11) NOT NULL,
  `MovieImageUrl` varchar(100) NOT NULL,
  `MovieTime` varchar(255) NOT NULL,
  `HitTime` int(11) DEFAULT NULL,
  `TheaterName` varchar(100) DEFAULT NULL,
  `Location` varchar(100) DEFAULT NULL,
  `MovieType` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`MovieName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `movie`
-- ----------------------------
BEGIN;
INSERT INTO `movie` VALUES ('As The Light ', '1', 'asthelightgoesout', '2014-04-25 15:00', '456', 'AMC Entertainment Inc', 'New York, NY, United States', 'C'), ('City of Bones', '5', 'mortal', '2014-04-25 15:42', '456', 'Cinemark Theatres', 'New York, NY, United States', 'D'), ('Despicable Me', '2', 'despicableme', '2014-04-25 15:40', '456', 'Cineplex Entertainment', 'New York, NY, United States', 'C'), ('Ender`s Game', '3', 'endersgame', '2014-04-25 15:30', '456', 'National Amusements', 'New York, NY, United States', 'D'), ('Metro', '4', 'metro', '2014-04-25 14:00', '456', 'Rave Motion Pictures', 'New York, NY, United States', 'C'), ('Olympus has fallen', '6', 'olympushasfallen', '2014-04-25 14:30', '456', 'Cineplex Entertainment', 'New York, NY, United States', 'D'), ('The Frog Kindom', '7', 'thefrogkingdom', '2014-04-25 15:00', '456', 'Cinemark Theatres', 'New York, NY, United States', 'C');
COMMIT;

-- ----------------------------
--  Table structure for `position`
-- ----------------------------
DROP TABLE IF EXISTS `position`;
CREATE TABLE `position` (
  `Positionid` bigint(20) NOT NULL AUTO_INCREMENT,
  `PositionLat` mediumtext NOT NULL,
  `PositionLon` mediumtext NOT NULL,
  `userid` bigint(20) DEFAULT NULL,
  `PositionType` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`Positionid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `position`
-- ----------------------------
BEGIN;
INSERT INTO `position` VALUES ('1', '39.4574545', '117.4768534', '1', '1'), ('2', '20.4574545', '110.4768534', '2', '2');
COMMIT;

-- ----------------------------
--  Table structure for `restaurant`
-- ----------------------------
DROP TABLE IF EXISTS `restaurant`;
CREATE TABLE `restaurant` (
  `RestaurantName` varchar(50) NOT NULL,
  `RestaurantID` int(11) NOT NULL,
  `RestaurantType` varchar(100) NOT NULL,
  `HitTime` int(11) DEFAULT NULL,
  `Location` varchar(100) DEFAULT NULL,
  `LocationDescription` varchar(100) DEFAULT NULL,
  `RestaurantImage` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`RestaurantName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `restaurant`
-- ----------------------------
BEGIN;
INSERT INTO `restaurant` VALUES ('A & W All-American Food', '14', 'american food', '231', '3005 South Ave', 'American', 'sprinkles'), ('Bodega Brew Pub', '9', 'American', '234', '122 4th St S', 'Pub Food ', 'yountville'), ('Burritos House', '10', 'Mexican', '456', '1205 La Crosse Stree', 'Mexican', 'omelette'), ('Charlie Trotter\'s', '2', 'italian food', '89', '2120 Rose St, La Crosse, ', 'something', 'trotter'), ('Del\'s Bar', '8', 'American', '345', ' La Crosse, WI', 'Food', 'sprinkles'), ('Fat Sams', '13', 'American food', '234', '412 Main Street', 'sandwiches', 'trotter'), ('French Laundry Yountville', '3', 'chinese food', '67', '222 Pearl St', 'something', 'yountville'), ('Great Wall', '12', 'chinese food', '234', ' 322 Main St', 'chinese', 'rainforest'), ('Le Chateau', '11', 'French', '94', 'Mediterranean 410 Cass Street', 'French', 'yountville'), ('Ocean Park Omelette Parlor', '1', 'American food', '456', 'Vegetarian 115 4th St S', 'something', 'omelette'), ('Pearl Ice Cream Parlor', '7', 'Dessert', '23', '229 3rd St N, La Crosse, WI', 'Dessert', 'tavern'), ('Rainforest Restrant', '6', 'chinese food', '445', 'Soup 327 Jay St', 'something', 'rainforest'), ('Sprinkles', '4', 'American food', '1', '1800 State St', 'something', 'sprinkles'), ('Tavern on the Green', '5', 'American food', '1', 'New York, NY, United States', 'something', 'tavern');
COMMIT;

-- ----------------------------
--  Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `userid` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `userpassword` varchar(50) NOT NULL,
  `googleusername` varchar(255) NOT NULL,
  `googlepassword` varchar(255) NOT NULL,
  `googlehomeusername` varchar(255) NOT NULL,
  `googlehomepassword` varchar(255) NOT NULL,
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `user`
-- ----------------------------
BEGIN;
INSERT INTO `user` VALUES ('1', 'admin', 'admin', 'testcapcal@gmail.com', 'testcapcal1234', 'linhui900520@gmail.com', 'lh900520@'), ('2', 'user1', 'user1', 'testcapcal@gmail.com', 'testcapcal@gmail.com', '', ''), ('3', 'admin1', 'admin', 'testcapcal@gmail.com', 'testcapcal@gmail.com', '', ''), ('10', 'admin2', 'admin2', 'ssss', 'ssss', '', ''), ('12', 'linhui', 'linhui', 'testcapcal', 'testcapcal@gmail.com', 'null', 'null'), ('13', 'testcapcal@gmail.com', 'testcapcal1234', 'testcapcal1234', 'testcapcal@gmail.com', '', ''), ('14', 'linhui1234', '123456', 'testcapcal1234', 'testcapcal@gmail.com', 'linhui900520@gmail.com', 'lh900520@'), ('19', '444', 'ddd', 'ddd', 'è¿?å¾?å¥½', 'å¥½', 'ddd'), ('20', '444', 'ddd', 'ddd', 'è¿?å¾?å¥½', 'å¥½', 'ddd'), ('21', '444', 'ddd', 'ddd', 'è¿?å¾?å¥½', 'å¥½', 'ddd'), ('22', '444', 'ddd', 'ddd', 'è¿?å¾?å¥½', 'å¥½', 'ddd'), ('23', 'steven', '123456', 'testcapcal1234', 'testcapcal@gmail.com', 'testcapcal@gmail.com', 'testcapcal1234'), ('24', 'qwer', '1234', 'testcapcal1234', 'testcapcal@gmail.com', 'linhui900520@gmail.com', 'lh900520@'), ('25', 'asdf', '1234', 'testcapcal@gmail.com', 'testcapcal1234', 'testcapcal@gmail.com', 'testcapcal1234'), ('26', '123456', '123456', 'zhang.zhen@uwlax.edu', 'ZLzlm5656953@', 'testcapcal@gmail.com', 'testcapcal1234'), ('27', '112233', '1234', 'testcapcal@gmail.com', 'testcapcal1234', 'zhang.zhen@uwlax.edu', 'ZLzlm5656953@'), ('28', '1122', '12', 'testcapcal@gmail.com', 'testcapcal1234', 'zhang.zhen@uwlax.edu', 'ZLzlm5656953@'), ('29', 'qqwer', '1234', 'testcapcal@gmail.com', 'testcapcal1234', 'zhang.zhen@uwlax.edu', 'ZLzlm5656953@'), ('30', '123456789', '123456', 'testcapcal@gmail.com', 'testcapcal1234', 'zhang.zhen@uwlax.edu', 'ZLzlm5656953@'), ('31', '112233445566', '123456', 'testcapcal@gmail.com', 'testcapcal1234', 'zhang.zhen@uwlax.edu', 'ZLzlm5656953@'), ('32', 'zhang', '123456', 'testcapcal@gmail.com', 'testcapcal1234', 'zhang.zhen@uwlax.edu', 'qwer1234@');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
