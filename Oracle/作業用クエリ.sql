

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
