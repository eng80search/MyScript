-- --------------------------------------------------------
-- �z�X�g:                          127.0.0.1
-- �T�[�o�[�̃o�[�W����:                   10.5.5-MariaDB - mariadb.org binary distribution
-- �T�[�o�[ OS:                      Win64
-- HeidiSQL �o�[�W����:               11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

--  �e�[�u�� new_image.�V�X�e���A�g�psku�ԍ� �̍\�����_���v���Ă��܂�
CREATE TABLE IF NOT EXISTS `�V�X�e���A�g�psku�ԍ�` (
  `���i�ԍ�` varchar(200) DEFAULT NULL,
  `�F_�\����` int(11) DEFAULT NULL,
  `�T�C�Y_�\����` int(11) DEFAULT NULL,
  `�[��_�\����` varchar(1) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `SKU�Ǘ��ԍ�` varchar(3) DEFAULT NULL,
  `�V�X�e���A�g�pSKU�ԍ�` varchar(602) DEFAULT NULL,
  `�o���G�[�V�������ڃL�[1` varchar(3) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `�o���G�[�V�������ڑI����1` varchar(200) DEFAULT NULL,
  `�o���G�[�V�������ڃL�[2` varchar(6) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `�o���G�[�V�������ڑI����2` varchar(213) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- �G�N�X�|�[�g����f�[�^���I������Ă��܂���

--  �r���[ new_image.�V�X�e���A�g�psku�ԍ�a �̍\�����_���v���Ă��܂�
-- VIEW �ˑ��G���[���������邽�߂ɁA�ꎞ�e�[�u�����쐬
CREATE TABLE `�V�X�e���A�g�psku�ԍ�a` (
	`���i�ԍ�` VARCHAR(200) NULL COLLATE 'utf8_general_ci',
	`�F_�\����` INT(11) NULL,
	`�T�C�Y_�\����` INT(11) NULL,
	`�[��_�\����` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`SKU�Ǘ��ԍ�` VARCHAR(3) NULL COLLATE 'utf8_general_ci',
	`�V�X�e���A�g�pSKU�ԍ�` TEXT(65535) NULL COLLATE 'utf8_general_ci',
	`�o���G�[�V�������ڃL�[1` VARCHAR(3) NOT NULL COLLATE 'utf8mb4_general_ci',
	`�o���G�[�V�������ڑI����1` VARCHAR(200) NULL COLLATE 'utf8_general_ci',
	`�o���G�[�V�������ڃL�[2` VARCHAR(6) NOT NULL COLLATE 'utf8mb4_general_ci',
	`�o���G�[�V�������ڑI����2` VARCHAR(203) NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;

--  �r���[ new_image.�V�X�e���A�g�psku�ԍ�b �̍\�����_���v���Ă��܂�
-- VIEW �ˑ��G���[���������邽�߂ɁA�ꎞ�e�[�u�����쐬
CREATE TABLE `�V�X�e���A�g�psku�ԍ�b` (
	`���i�ԍ�` VARCHAR(200) NULL COLLATE 'utf8_general_ci',
	`�F_�\����` INT(11) NULL,
	`�T�C�Y_�\����` INT(11) NULL,
	`�[��_�\����` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`SKU�Ǘ��ԍ�` VARCHAR(3) NULL COLLATE 'utf8_general_ci',
	`�V�X�e���A�g�pSKU�ԍ�` TEXT(65535) NULL COLLATE 'utf8_general_ci',
	`�o���G�[�V�������ڃL�[1` VARCHAR(3) NOT NULL COLLATE 'utf8mb4_general_ci',
	`�o���G�[�V�������ڑI����1` VARCHAR(200) NULL COLLATE 'utf8_general_ci',
	`�o���G�[�V�������ڃL�[2` VARCHAR(6) NOT NULL COLLATE 'utf8mb4_general_ci',
	`�o���G�[�V�������ڑI����2` VARCHAR(213) NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;

--  �r���[ new_image.�o���G�[�V�����I������` �̍\�����_���v���Ă��܂�
-- VIEW �ˑ��G���[���������邽�߂ɁA�ꎞ�e�[�u�����쐬
CREATE TABLE `�o���G�[�V�����I������`` (
	`���i�F_���i�ԍ�` VARCHAR(200) NULL COLLATE 'utf8_general_ci',
	`SKU�Ǘ��ԍ�` VARCHAR(3) NULL COLLATE 'utf8_general_ci',
	`���i�T�C�Y_���i�ԍ�` VARCHAR(200) NOT NULL COLLATE 'utf8_general_ci',
	`�o���G�[�V����1�I������`` MEDIUMTEXT NULL COLLATE 'utf8_general_ci',
	`�o���G�[�V����2�I������`` MEDIUMTEXT NULL COLLATE 'utf8_general_ci',
	`�F` MEDIUMTEXT NULL COLLATE 'utf8_general_ci',
	`�T�C�Y` MEDIUMTEXT NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;

--  �e�[�u�� new_image.���i�T�C�Y �̍\�����_���v���Ă��܂�
CREATE TABLE IF NOT EXISTS `���i�T�C�Y` (
  `���i�ԍ�` varchar(200) NOT NULL,
  `�T�C�Y` varchar(200) NOT NULL,
  `�\����` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- �G�N�X�|�[�g����f�[�^���I������Ă��܂���

--  �e�[�u�� new_image.���i�݌� �̍\�����_���v���Ă��܂�
CREATE TABLE IF NOT EXISTS `���i�݌�` (
  `���i�ԍ�` varchar(200) DEFAULT NULL,
  `���i�݌�_���{��` varchar(200) DEFAULT NULL,
  `���i�݌�_�p��` varchar(200) DEFAULT NULL,
  `���i�݌�_����` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- �G�N�X�|�[�g����f�[�^���I������Ă��܂���

--  �e�[�u�� new_image.���i�F �̍\�����_���v���Ă��܂�
CREATE TABLE IF NOT EXISTS `���i�F` (
  `���i�ԍ�` varchar(200) DEFAULT NULL,
  `���i�F_���{��` varchar(200) DEFAULT NULL,
  `���i�F_�p��` varchar(200) DEFAULT NULL,
  `�\����` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- �G�N�X�|�[�g����f�[�^���I������Ă��܂���

--  �r���[ new_image.�V�X�e���A�g�psku�ԍ�a �̍\�����_���v���Ă��܂�
-- �ꎞ�e�[�u�����폜���āA�ŏI�I�� VIEW �\�����쐬
DROP TABLE IF EXISTS `�V�X�e���A�g�psku�ԍ�a`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `�V�X�e���A�g�psku�ԍ�a` AS select `product`.`���i�ԍ�` AS `���i�ԍ�`,`color`.`�\����` AS `�F_�\����`,`size`.`�\����` AS `�T�C�Y_�\����`,'0' AS `�[��_�\����`,substr(`product`.`���i�ԍ�`,9,3) AS `SKU�Ǘ��ԍ�`,concat(`product`.`���i�ԍ�`,`color`.`���i�F_�p��`,lcase(`size`.`�T�C�Y`),'/a') AS `�V�X�e���A�g�pSKU�ԍ�`,'�J���[' AS `�o���G�[�V�������ڃL�[1`,`color`.`���i�F_���{��` AS `�o���G�[�V�������ڑI����1`,'�T�C�Y/�[��' AS `�o���G�[�V�������ڃL�[2`,concat(`size`.`�T�C�Y`,'/','���[') AS `�o���G�[�V�������ڑI����2` from ((`���i�ԍ�` `product` left join `���i�F` `color` on(`product`.`���i�ԍ�` = `color`.`���i�ԍ�`)) left join `���i�T�C�Y` `size` on(`product`.`���i�ԍ�` = `size`.`���i�ԍ�`));

--  �r���[ new_image.�V�X�e���A�g�psku�ԍ�b �̍\�����_���v���Ă��܂�
-- �ꎞ�e�[�u�����폜���āA�ŏI�I�� VIEW �\�����쐬
DROP TABLE IF EXISTS `�V�X�e���A�g�psku�ԍ�b`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `�V�X�e���A�g�psku�ԍ�b` AS select `product`.`���i�ԍ�` AS `���i�ԍ�`,`color`.`�\����` AS `�F_�\����`,`size`.`�\����` AS `�T�C�Y_�\����`,'1' AS `�[��_�\����`,substr(`product`.`���i�ԍ�`,9,3) AS `SKU�Ǘ��ԍ�`,concat(`product`.`���i�ԍ�`,`color`.`���i�F_�p��`,lcase(`size`.`�T�C�Y`),'/b') AS `�V�X�e���A�g�pSKU�ԍ�`,'�J���[' AS `�o���G�[�V�������ڃL�[1`,`color`.`���i�F_���{��` AS `�o���G�[�V�������ڑI����1`,'�T�C�Y/�[��' AS `�o���G�[�V�������ڃL�[2`,concat(`size`.`�T�C�Y`,'/','������12�c�Ɠ��O�����') AS `�o���G�[�V�������ڑI����2` from ((`���i�ԍ�` `product` left join `���i�F` `color` on(`product`.`���i�ԍ�` = `color`.`���i�ԍ�`)) left join `���i�T�C�Y` `size` on(`product`.`���i�ԍ�` = `size`.`���i�ԍ�`));

--  �r���[ new_image.�o���G�[�V�����I������` �̍\�����_���v���Ă��܂�
-- �ꎞ�e�[�u�����폜���āA�ŏI�I�� VIEW �\�����쐬
DROP TABLE IF EXISTS `�o���G�[�V�����I������``;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `�o���G�[�V�����I������`` AS select `���i�ԍ�`.`���i�ԍ�` AS `���i�F_���i�ԍ�`,substr(`���i�ԍ�`.`���i�ԍ�`,9,3) AS `SKU�Ǘ��ԍ�`,`���i�T�C�Y`.`���i�ԍ�` AS `���i�T�C�Y_���i�ԍ�`,group_concat(distinct `���i�F`.`���i�F_���{��` order by `���i�F`.`�\����` ASC separator '|') AS `�o���G�[�V����1�I������``,concat(group_concat(distinct `���i�T�C�Y`.`�T�C�Y` order by `���i�T�C�Y`.`�\����` ASC separator '/���[|'),'/���[|',group_concat(distinct `���i�T�C�Y`.`�T�C�Y` order by `���i�T�C�Y`.`�\����` ASC separator '/������12�c�Ɠ��O�����|'),'/������12�c�Ɠ��O�����') AS `�o���G�[�V����2�I������``,group_concat(distinct `���i�F`.`���i�F_���{��` order by `���i�F`.`�\����` ASC separator '/') AS `�F`,group_concat(distinct `���i�T�C�Y`.`�T�C�Y` order by `���i�F`.`�\����` ASC separator '/') AS `�T�C�Y` from ((`���i�F` join `���i�T�C�Y` on(`���i�F`.`���i�ԍ�` = `���i�T�C�Y`.`���i�ԍ�`)) join `���i�ԍ�` on(`���i�F`.`���i�ԍ�` = `���i�ԍ�`.`���i�ԍ�`)) group by `���i�F`.`���i�ԍ�`,`���i�T�C�Y`.`���i�ԍ�`;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
