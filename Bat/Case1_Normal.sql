/* RDAステータス管理テストデータ */
USE [ES_990_DB]

-- テスト用テーブル名変更(NG -> OK)

BEGIN
  DECLARE @mode VARCHAR(100)
  SET @mode = '$(Param1)'
  
  IF @mode = 'before1'
  BEGIN
    BEGIN
    
      SELECT '共通処理を実施_TEST部分の名前を変更'
      
      IF EXISTS(SELECT name FROM sys.tables WHERE NAME = 'TRN_990_JOBSTATUS_TEST')
        -- 関連ジョブステータストランザクションテーブル
        EXEC sp_rename 'TRN_990_JOBSTATUS_TEST' , 'TRN_990_JOBSTATUS'
        
      IF EXISTS(SELECT name FROM sys.tables WHERE NAME = 'TRN_990_RELATION_JOB_TEST')
        -- 関連ジョブステータストランザクションテーブル
        EXEC sp_rename 'TRN_990_RELATION_JOB_TEST' , 'TRN_990_RELATION_JOB'
        
      IF EXISTS(SELECT name FROM sys.tables WHERE NAME = 'TRN_990_REFDB_TEST')
        -- 関連ジョブステータストランザクションテーブル
        EXEC sp_rename 'TRN_990_REFDB_TEST' , 'TRN_990_REFDB'
        
      IF EXISTS(SELECT name FROM sys.tables WHERE NAME = 'TRN_990_REFDB_TEST')
        -- 関連ジョブステータストランザクションテーブル
        EXEC sp_rename 'TRN_990_REFDB_TEST' , 'TRN_990_REFDB'
      
    END
    
    /* MST_990_REFSYSTEM(参照システムマスタ)データ作成 */
    SELECT 'MST_990_REFSYSTEM(参照システムマスタ)データ作成'
    
    IF EXISTS(SELECT * FROM MST_990_REFSYSTEM WHERE SYSTEM_NO = 'RDA0001')
    
      BEGIN
        /* 外部キー制約があるため、関連テーブルを全部消す*/
        DELETE MST_990_REFDB WHERE SYSTEM_NO = 'RDA0001'
        DELETE MST_990_RELATION_JOB WHERE JOB_PATH LIKE '%/RDA_TEST%' OR JOB_PATH LIKE '%TRK_GRP%'
        DELETE MST_990_REFSYSTEM WHERE SYSTEM_NO = 'RDA0001'
        
        INSERT INTO [dbo].MST_990_REFSYSTEM ([SYSTEM_NO] ,[SYSTEM_NM])
               VALUES ('RDA0001', n'RDAテスト用')
      END
      
      /* MST_990_RELATION_JOB(関連ジョブマスタ)データ作成 */
      SELECT 'MST_990_RELATION_JOB(関連ジョブマスタ)データ作成'
      IF EXISTS(SELECT * FROM MST_990_RELATION_JOB WHERE SYSTEM_NO IN ('RDA0001'))
        BEGIN
          DELETE MST_990_RELATION_JOB WHERE SYSTEM_NO IN ('RDA0001')
        END
        
      BEGIN
        -- test case 1: ジョブがトラッキングジョブでない場合　注意：OSの環境変数も合わせて変更
        INSERT INTO [dbo].[MST_990_RELATION_JOB] ([JOB_PATH] ,[PROC_NM] ,[SYSTEM_NO] ,[JP1_EVENT_ID] ,[TROUBLE_DIV] ,[JUDGE_CONDITION])
               VALUES ('/TEST_RDA/JobName', N'RDAステータス管理テスト用', 'RDA0001', '00000001', 'I', 'NO')
      END
      
      -- リードレプリカ反映チェックテスト用テーブルを作成
      SELECT 'TEST_READREPLICATE(リードレプリカ反映チェック)テストデータを作成'
      BEGIN
        DROP TABLE IF EXISTS dbo.TEST_READREPLICATE;
        CREATE TABLE dbo.TEST_READREPLICATE
        (
          DATABASE_NAME VARCHAR(100) NOT NULL,
          LAST_HARDENED_TIME VARCHAR(100)
        );
        
        TRUNCATE TABLE [ES_990_DB].[dbo].[TEST_READREPLICATE];
        INSERT INTO [dbo].[TEST_READREPLICATE] ([DATABASE_NAME], [LAST_HARDENED_TIME])
                           VALUES (N'TestDB_RDA' , '2022/08/09 18:00:00.000');
                           
      END
      
      SELECT 'param is before1 終了' 
   END
      
    ELSE IF @mode = 'testFinish'
      BEGIN
        SELECT 'testFinish 実行'
      END
        
    ELSE
      BEGIN
        SELECT '(NG_ここはありえない)'
      END
    
END
