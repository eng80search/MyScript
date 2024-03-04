-- -----------------------------------------------
-- Batファイルから呼び出しを想定するため、Encodeはsjisにすること！
-- データインポート(インポート用ファイル名は英語のみ)
-- -----------------------------------------------
TRUNCATE TABLE `商品番号`;
TRUNCATE TABLE `商品色`;
TRUNCATE TABLE `商品サイズ`;

-- これでShift_JISのファイルが取り込める
set character_set_database=sjis;

-- 注意：出力パスは呼び出し元のBATファイルから見た相対パス
LOAD DATA LOCAL INFILE
  "./_import_data/10_product.csv"
REPLACE INTO TABLE -- REPLACE を追記
  `商品番号`
FIELDS
  TERMINATED BY ','
  ENCLOSED BY '"'
  ESCAPED BY '\\'
LINES
  TERMINATED BY '\r\n'
IGNORE 1 ROWS
;

LOAD DATA LOCAL INFILE
  "./_import_data/11_color.csv"
REPLACE INTO TABLE -- REPLACE を追記
  `商品色`
FIELDS
  TERMINATED BY ','
  ENCLOSED BY '"'
  ESCAPED BY '\\'
LINES
  TERMINATED BY '\r\n'
IGNORE 1 ROWS
;

LOAD DATA LOCAL INFILE
  "./_import_data/12_size.csv"
REPLACE INTO TABLE -- REPLACE を追記
  `商品サイズ`
FIELDS
  TERMINATED BY ','
  ENCLOSED BY '"'
  ESCAPED BY '\\'
LINES
  TERMINATED BY '\r\n'
IGNORE 1 ROWS
;

-- -----------------------------------------------
-- データを作成する
-- -----------------------------------------------

-- システム連携用sku番号作成用の二つのビューを結合して
-- 新規テーブルを作成する
CREATE OR REPLACE  TABLE システム連携用sku番号 AS 
SELECT *  FROM
(
	SELECT * FROM システム連携用sku番号a 
	UNION 
	SELECT * FROM システム連携用sku番号b
) dt
;

-- -----------------------------------------------
-- バリエーション選択肢データを表示する
-- -----------------------------------------------
SELECT
    `商品色_商品番号` AS `商品番号`,
    `SKU管理番号`,
    `バリエーション1選択肢定義`,
    `バリエーション2選択肢定義`,
    `色`,
    `サイズ`
FROM バリエーション選択肢定義
ORDER BY `SKU管理番号`;

SELECT "";
-- -----------------------------------------------
-- SKU管理番号データを表示する
-- -----------------------------------------------
SELECT  
    `商品番号`,
	CONCAT(`SKU管理番号`,LPAD(ROW_NUMBER() over (PARTITION BY `商品番号` ORDER BY `商品番号`, `納期_表示順`, `色_表示順`, `サイズ_表示順`),2,0)) AS `SKU管理番号` ,
	`システム連携用SKU番号` ,
	`バリエーション項目キー1` ,
	`バリエーション項目選択肢1` ,
	`バリエーション項目キー2` ,
	`バリエーション項目選択肢2`  
 FROM システム連携用sku番号
 ORDER BY `商品番号`, `納期_表示順`, `色_表示順`, `サイズ_表示順`;
 
-- -----------------------------------------------
-- バリエーション選択肢データをCSVファイルへ出力する
-- -----------------------------------------------
SELECT
    `商品色_商品番号` AS `商品番号`,
    `SKU管理番号`,
    `バリエーション1選択肢定義`,
    `バリエーション2選択肢定義`,
    `色`,
    `サイズ`
FROM バリエーション選択肢定義
ORDER BY `SKU管理番号`
INTO OUTFILE
 "C:/temp/20_variation.csv"  -- MariaDBのインストール先に出力される
 CHARACTER SET 'sjis' -- エンコーディングはsjis
FIELDS
  TERMINATED BY ',' -- カンマで値を区切る
  ENCLOSED BY '"' -- " で値を囲む
  ESCAPED BY '\\' -- \ でエスケープする
LINES
  TERMINATED BY '\r\n' -- \r\n で改行する
 ;

-- -----------------------------------------------
 -- システム連携用sku番号データをCSVファイルへ出力する
-- -----------------------------------------------
 SELECT  
    `商品番号`,
	CONCAT(`SKU管理番号`,LPAD(ROW_NUMBER() over (PARTITION BY `商品番号` ORDER BY `商品番号`, `納期_表示順`, `色_表示順`, `サイズ_表示順`),2,0)) AS `SKU管理番号` ,
	`システム連携用SKU番号` ,
	`バリエーション項目キー1` ,
	`バリエーション項目選択肢1` ,
	`バリエーション項目キー2` ,
	`バリエーション項目選択肢2`  
 FROM システム連携用sku番号
 ORDER BY `商品番号`, `納期_表示順`, `色_表示順`, `サイズ_表示順`
 INTO OUTFILE
  "C:/temp/21_sku_kanri.csv"  -- MariaDBのインストール先に出力される
  CHARACTER SET 'sjis' -- エンコーディングはsjis
FIELDS
  TERMINATED BY ',' -- カンマで値を区切る
  ENCLOSED BY '"' -- " で値を囲む
  ESCAPED BY '\\' -- \ でエスケープする
LINES
  TERMINATED BY '\r\n' -- \r\n で改行する
;
