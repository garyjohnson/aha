DELETE FROM `admin`;
INSERT INTO `admin` VALUES ('aha','3da541559918a808c2402bba5012f6c60b27661c');
DELETE FROM `device`;
INSERT INTO `device` VALUES
	('tylersphone',0,'hadidotj@gmail.com','6148799372'),
	('davidsphone',0,'davelhs03@yahoo.com','');
DELETE FROM `images`;
INSERT INTO `images` (guid,device,status) VALUES
	('tylersphone_image1','tylersphone',0),
	('tylersphone_image2','tylersphone',1),
	('tylersphone_image3','tylersphone',0),
	('davidsphone_image1','davidsphone',0),
	('davidsphone_image2','davidsphone',1);
