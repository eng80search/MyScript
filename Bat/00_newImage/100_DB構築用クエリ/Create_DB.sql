-- --------------------------------------------------------
-- ホスト:                          127.0.0.1
-- サーバーのバージョン:                   10.5.5-MariaDB - mariadb.org binary distribution
-- サーバー OS:                      Win64
-- HeidiSQL バージョン:               11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

--  テーブル new_image.システム連携用sku番号 の構造をダンプしています
DROP TABLE IF EXISTS `システム連携用sku番号`;
CREATE TABLE IF NOT EXISTS `システム連携用sku番号` (
  `商品番号` varchar(200) DEFAULT NULL,
  `色_表示順` int(11) DEFAULT NULL,
  `サイズ_表示順` int(11) DEFAULT NULL,
  `納期_表示順` varchar(1) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `SKU管理番号` varchar(3) DEFAULT NULL,
  `システム連携用SKU番号` varchar(602) DEFAULT NULL,
  `バリエーション項目キー1` varchar(3) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `バリエーション項目選択肢1` varchar(200) DEFAULT NULL,
  `バリエーション項目キー2` varchar(6) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `バリエーション項目選択肢2` varchar(213) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- エクスポートするデータが選択されていません

--  ビュー new_image.システム連携用sku番号a の構造をダンプしています
DROP VIEW IF EXISTS `システム連携用sku番号a`;
-- VIEW 依存エラーを克服するために、一時テーブルを作成
CREATE TABLE `システム連携用sku番号a` (
	`商品番号` VARCHAR(200) NULL COLLATE 'utf8_general_ci',
	`色_表示順` INT(11) NULL,
	`サイズ_表示順` INT(11) NULL,
	`納期_表示順` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`SKU管理番号` VARCHAR(3) NULL COLLATE 'utf8_general_ci',
	`システム連携用SKU番号` TEXT(65535) NULL COLLATE 'utf8_general_ci',
	`バリエーション項目キー1` VARCHAR(3) NOT NULL COLLATE 'utf8mb4_general_ci',
	`バリエーション項目選択肢1` VARCHAR(200) NULL COLLATE 'utf8_general_ci',
	`バリエーション項目キー2` VARCHAR(6) NOT NULL COLLATE 'utf8mb4_general_ci',
	`バリエーション項目選択肢2` VARCHAR(203) NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;

--  ビュー new_image.システム連携用sku番号b の構造をダンプしています
DROP VIEW IF EXISTS `システム連携用sku番号b`;
-- VIEW 依存エラーを克服するために、一時テーブルを作成
CREATE TABLE `システム連携用sku番号b` (
	`商品番号` VARCHAR(200) NULL COLLATE 'utf8_general_ci',
	`色_表示順` INT(11) NULL,
	`サイズ_表示順` INT(11) NULL,
	`納期_表示順` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`SKU管理番号` VARCHAR(3) NULL COLLATE 'utf8_general_ci',
	`システム連携用SKU番号` TEXT(65535) NULL COLLATE 'utf8_general_ci',
	`バリエーション項目キー1` VARCHAR(3) NOT NULL COLLATE 'utf8mb4_general_ci',
	`バリエーション項目選択肢1` VARCHAR(200) NULL COLLATE 'utf8_general_ci',
	`バリエーション項目キー2` VARCHAR(6) NOT NULL COLLATE 'utf8mb4_general_ci',
	`バリエーション項目選択肢2` VARCHAR(213) NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;

--  ビュー new_image.バリエーション選択肢定義 の構造をダンプしています
DROP VIEW IF EXISTS `バリエーション選択肢定義`;
-- VIEW 依存エラーを克服するために、一時テーブルを作成
CREATE TABLE `バリエーション選択肢定義` (
	`商品色_商品番号` VARCHAR(200) NULL COLLATE 'utf8_general_ci',
	`SKU管理番号` VARCHAR(3) NULL COLLATE 'utf8_general_ci',
	`商品サイズ_商品番号` VARCHAR(200) NOT NULL COLLATE 'utf8_general_ci',
	`バリエーション1選択肢定義` MEDIUMTEXT NULL COLLATE 'utf8_general_ci',
	`バリエーション2選択肢定義` MEDIUMTEXT NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;

--  テーブル new_image.商品サイズ の構造をダンプしています
DROP TABLE IF EXISTS `商品サイズ`;
CREATE TABLE IF NOT EXISTS `商品サイズ` (
  `商品番号` varchar(200) NOT NULL,
  `サイズ` varchar(200) NOT NULL,
  `表示順` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- エクスポートするデータが選択されていません

--  テーブル new_image.商品番号 の構造をダンプしています
DROP TABLE IF EXISTS `商品番号`;
CREATE TABLE IF NOT EXISTS `商品番号` (
  `商品管理番号` varchar(200) DEFAULT NULL,
  `商品番号` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- エクスポートするデータが選択されていません

--  テーブル new_image.商品色 の構造をダンプしています
DROP TABLE IF EXISTS `商品色`;
CREATE TABLE IF NOT EXISTS `商品色` (
  `商品番号` varchar(200) DEFAULT NULL,
  `商品色_日本語` varchar(200) DEFAULT NULL,
  `商品色_英語` varchar(200) DEFAULT NULL,
  `表示順` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- エクスポートするデータが選択されていません

--  ビュー new_image.システム連携用sku番号a の構造をダンプしています
DROP VIEW IF EXISTS `システム連携用sku番号a`;
-- 一時テーブルを削除して、最終的な VIEW 構造を作成
DROP TABLE IF EXISTS `システム連携用sku番号a`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `システム連携用sku番号a` AS select `product`.`商品番号` AS `商品番号`,`color`.`表示順` AS `色_表示順`,`size`.`表示順` AS `サイズ_表示順`,'0' AS `納期_表示順`,substr(`product`.`商品番号`,9,3) AS `SKU管理番号`,concat(`product`.`商品番号`,`color`.`商品色_英語`,lcase(`size`.`サイズ`),'/a') AS `システム連携用SKU番号`,'カラー' AS `バリエーション項目キー1`,`color`.`商品色_日本語` AS `バリエーション項目選択肢1`,'サイズ/納期' AS `バリエーション項目キー2`,concat(`size`.`サイズ`,'/','即納') AS `バリエーション項目選択肢2` from ((`商品番号` `product` left join `商品色` `color` on(`product`.`商品番号` = `color`.`商品番号`)) left join `商品サイズ` `size` on(`product`.`商品番号` = `size`.`商品番号`));

--  ビュー new_image.システム連携用sku番号b の構造をダンプしています
DROP VIEW IF EXISTS `システム連携用sku番号b`;
-- 一時テーブルを削除して、最終的な VIEW 構造を作成
DROP TABLE IF EXISTS `システム連携用sku番号b`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `システム連携用sku番号b` AS select `product`.`商品番号` AS `商品番号`,`color`.`表示順` AS `色_表示順`,`size`.`表示順` AS `サイズ_表示順`,'1' AS `納期_表示順`,substr(`product`.`商品番号`,9,3) AS `SKU管理番号`,concat(`product`.`商品番号`,`color`.`商品色_英語`,lcase(`size`.`サイズ`),'/b') AS `システム連携用SKU番号`,'カラー' AS `バリエーション項目キー1`,`color`.`商品色_日本語` AS `バリエーション項目選択肢1`,'サイズ/納期' AS `バリエーション項目キー2`,concat(`size`.`サイズ`,'/','注文後12営業日前後入荷') AS `バリエーション項目選択肢2` from ((`商品番号` `product` left join `商品色` `color` on(`product`.`商品番号` = `color`.`商品番号`)) left join `商品サイズ` `size` on(`product`.`商品番号` = `size`.`商品番号`));

--  ビュー new_image.バリエーション選択肢定義 の構造をダンプしています
DROP VIEW IF EXISTS `バリエーション選択肢定義`;
-- 一時テーブルを削除して、最終的な VIEW 構造を作成
DROP TABLE IF EXISTS `バリエーション選択肢定義`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `バリエーション選択肢定義` AS select `商品番号`.`商品番号` AS `商品色_商品番号`,substr(`商品番号`.`商品番号`,9,3) AS `SKU管理番号`,`商品サイズ`.`商品番号` AS `商品サイズ_商品番号`,group_concat(distinct `商品色`.`商品色_日本語` order by `商品色`.`表示順` ASC separator '|') AS `バリエーション1選択肢定義`,concat(group_concat(distinct `商品サイズ`.`サイズ` order by `商品サイズ`.`表示順` ASC separator '/即納|'),'/即納|',group_concat(distinct `商品サイズ`.`サイズ` order by `商品サイズ`.`表示順` ASC separator '/注文後12営業日前後入荷|'),'/注文後12営業日前後入荷') AS `バリエーション2選択肢定義` from ((`商品色` join `商品サイズ` on(`商品色`.`商品番号` = `商品サイズ`.`商品番号`)) join `商品番号` on(`商品色`.`商品番号` = `商品番号`.`商品番号`)) group by `商品色`.`商品番号`,`商品サイズ`.`商品番号`;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
