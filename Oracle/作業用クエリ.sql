

-- 慎重に！ データを削除する
delete from TEST_INVENTORY;
delete from STORE_INSTITUTION;
delete from STORE_MCHLV_ADD;

-- 慎重に！　テーブルを削除する
DROP TABLE TBLCINFON_20190920;
-- commit;

-- すべてのデータを削除する
TRUNCATE TABLE STORE_BATCH_LOG;
--  副問合せでデータをInsertする
INSERT INTO TBLCINFON
SELECT * 
FROM TBLCINFON_20190920
--  WHERE TBLCINFON_20190920.CLINICID IN ('80460')
WHERE TBLCINFON_20190920.CLINICID IN (SELECT TEST_INVENTORY.CLINICID from TEST_INVENTORY);


--  副問合せで条件に一致するデータリストを取得する
SELECT * 
FROM TEST_INVENTORY
WHERE TEST_INVENTORY.CLINICID NOT IN (SELECT STORE_MCHLV_ADD.CLINICID FROM STORE_MCHLV_ADD);


--  副問合せでテーブルを新規作成する
CREATE TABLE TBLCINFON_IMGBACKUP
AS
SELECT * 
FROM TBLCINFON WHERE  CLINICID  IN ('22001','29998', '29999');

--  副問合せでテーブルをコピーする
CREATE TABLE TBLCINFON_BACKUP_20210309
AS
SELECT * 
FROM TBLCINFON;

-- 取り込み先のテーブルをクリアする
delete from TBLCINFON;
select count(*) from TBLCINFON;

select count(*) from test_inventory;
--
--バッチ実行後、結果確認用
select count(*) from TEST_INVENTORY;
select count(*) from STORE_INSTITUTION;
select count(*) from STORE_MCHLV_ADD;

select count(*) from vwstore_info_batch;
select * from vwstore_info_batch;

select count(*) from tblcinfon;
select count(*) from snpstore_info;

select * from tblcinfon;

select to_date('19-09-19') from dual;

--  テーブル一覧を取得する
SELECT * FROM   USER_TABLES ORDER BY TABLE_NAME;

--  テーブル名を変更する

ALTER TABLE TAB_A RENAME TO TAB_B;


--  テーブルサイズを確認する
SELECT 
    A.TABLE_NAME --テーブル名称
    ,A.NUM_ROWS --テーブルのレコード数
    , B.MB -- テーブルの利用容量
FROM USER_TABLES A -- 全てのテーブル
, (SELECT SEGMENT_NAME,SUM(BYTES)/1024/1024 MB FROM USER_SEGMENTS GROUP BY SEGMENT_NAME) B --テーブル名称＆容量の集合
WHERE A.TABLE_NAME = B.SEGMENT_NAME
ORDER BY A.NUM_ROWS DESC, B.MB DESC;

-- sql plusでsys権限でログインする
-- SQL Plusを立ち上げた後に以下のコマンドを入力する
sys as sysdba (password: password)

--  自宅開発環境
--  user: ri password: P@sswordq1

-- sqlplusにてSID(インスタンス)を確認する
SELECT INSTANCE_NAME FROM V$INSTANCE;

-- sqlplusにてpdb(データベース)一覧を確認する
select pdb_id, pdb_name,status from cdb_pdbs;

--  画像データをコピーする
--  注意：結合条件は必ずキーになる列を選択すること
--  でなければORA-01779エラーが発生する
UPDATE 
(
    SELECT
    TO_TB.BINARY_STOREIMG TO_BINARY_STOREIMG,
    FROM_TB.BINARY_STOREIMG FROM_BINARY_STOREIMG
    FROM 
        TBLCINFON_BACKUP1124 TO_TB
    INNER JOIN
        TBLCINFON FROM_TB
    ON
        TO_TB.CLINICID = FROM_TB.CLINICID
)
SET TO_BINARY_STOREIMG = FROM_BINARY_STOREIMG

-- Select文でTop n件抽出
SELECT * FROM VWSTORE_INFO FETCH FIRST 10 ROWS ONLY;

--  テーブル一覧を表示する
SELECT * FROM   USER_TABLES ORDER BY TABLE_NAME

-- バージョンを確認する
SELECT * FROM V$VERSION;

-- 文字コードを確認する
SELECT * FROM NLS_DATABASE_PARAMETERS WHERE PARAMETER= 'NLS_CHARACTERSET';

-- データベースのオブジェクト一覧を取得
SELECT * FROM USER_OBJECTS
ORDER BY OBJECT_TYPE,OBJECT_NAME;

-- データベースのオブジェクト一覧を取得(一部項目のみ)
SELECT OBJECT_NAME,OBJECT_TYPE,STATUS FROM USER_OBJECTS
WHERE OBJECT_TYPE IN ('TABLE','VIEW','PACKAGE','SEQUENCE')
ORDER BY OBJECT_TYPE,OBJECT_NAME;

-- 確認用：BCTK011_SFDC施設紹介マスタデータ取込を実施後、本番とQAのデータが同じであるかの検証用
-- 確認用：紹介プライオリティごとの件数をカウント
SELECT PRTFLG, COUNT(*) AS 件数 FROM TBLCINFON where clinicid > 29999 GROUP BY PRTFLG ORDER BY PRTFLG ;

SELECT COUNT(*) FROM VWSTORE_INFO;

-- VWSTORE_INFO関連テーブルをバックアップする
INSERT INTO TBLCINFON_2021MMDD SELECT * FROM TBLCINFON;
INSERT INTO STORE_INSTITUTION_2021MMDD SELECT * FROM STORE_INSTITUTION;
INSERT INTO STORE_MCHLV_ADD_2021MMDD SELECT * FROM STORE_MCHLV_ADD;
INSERT INTO T_STORE_LIST_2021MMDD SELECT * FROM T_STORE_LIST;

-- VWSTORE_INFO関連テーブルをバックアップから復元する
TRUNCATE TABLE TBLCINFON;
TRUNCATE TABLE STORE_INSTITUTION;
TRUNCATE TABLE STORE_MCHLV_ADD;
TRUNCATE TABLE T_STORE_LIST;

INSERT INTO TBLCINFON SELECT * FROM TBLCINFON_2021MMDD;
INSERT INTO STORE_INSTITUTION SELECT * FROM STORE_INSTITUTION_2021MMDD;
INSERT INTO STORE_MCHLV_ADD SELECT * FROM STORE_MCHLV_ADD_2021MMDD;
INSERT INTO T_STORE_LIST SELECT * FROM T_STORE_LIST_2021MMDD;

--シーケンス開始番号を既定値に設定する　注意：この時Currvalはまだ変更されていない！
alter SEQUENCE storeseq restart start with {10000};

--シーケンスの現在値を確認（何回実行しても値は不変）
select storeseq.CURRVAL from dual;

--シーケンスの新しい値を生成（実行するたびに値が前に進む）
--select storeseq.NEXTVAL from dual;
