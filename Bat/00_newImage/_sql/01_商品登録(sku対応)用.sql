-- -----------------------------------------------
-- Bat�t�@�C������Ăяo����z�肷�邽�߁AEncode��sjis�ɂ��邱�ƁI
-- �f�[�^�C���|�[�g(�C���|�[�g�p�t�@�C�����͉p��̂�)
-- -----------------------------------------------
TRUNCATE TABLE `���i�ԍ�`;
TRUNCATE TABLE `���i�F`;
TRUNCATE TABLE `���i�T�C�Y`;

-- �����Shift_JIS�̃t�@�C������荞�߂�
set character_set_database=sjis;

-- ���ӁF�o�̓p�X�͌Ăяo������BAT�t�@�C�����猩�����΃p�X
LOAD DATA LOCAL INFILE
  "./_import_data/10_product.csv"
REPLACE INTO TABLE -- REPLACE ��ǋL
  `���i�ԍ�`
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
REPLACE INTO TABLE -- REPLACE ��ǋL
  `���i�F`
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
REPLACE INTO TABLE -- REPLACE ��ǋL
  `���i�T�C�Y`
FIELDS
  TERMINATED BY ','
  ENCLOSED BY '"'
  ESCAPED BY '\\'
LINES
  TERMINATED BY '\r\n'
IGNORE 1 ROWS
;

-- -----------------------------------------------
-- �f�[�^���쐬����
-- -----------------------------------------------

-- �V�X�e���A�g�psku�ԍ��쐬�p�̓�̃r���[����������
-- �V�K�e�[�u�����쐬����
CREATE OR REPLACE  TABLE �V�X�e���A�g�psku�ԍ� AS 
SELECT *  FROM
(
	SELECT * FROM �V�X�e���A�g�psku�ԍ�a 
	UNION 
	SELECT * FROM �V�X�e���A�g�psku�ԍ�b
) dt
;

-- -----------------------------------------------
-- �o���G�[�V�����I�����f�[�^��\������
-- -----------------------------------------------
SELECT
    `���i�F_���i�ԍ�` AS `���i�ԍ�`,
    `SKU�Ǘ��ԍ�`,
    `�o���G�[�V����1�I������``,
    `�o���G�[�V����2�I������``,
    `�F`,
    `�T�C�Y`
FROM �o���G�[�V�����I������`
ORDER BY `SKU�Ǘ��ԍ�`;

SELECT "";
-- -----------------------------------------------
-- SKU�Ǘ��ԍ��f�[�^��\������
-- -----------------------------------------------
SELECT  
    `���i�ԍ�`,
	CONCAT(`SKU�Ǘ��ԍ�`,LPAD(ROW_NUMBER() over (PARTITION BY `���i�ԍ�` ORDER BY `���i�ԍ�`, `�[��_�\����`, `�F_�\����`, `�T�C�Y_�\����`),2,0)) AS `SKU�Ǘ��ԍ�` ,
	`�V�X�e���A�g�pSKU�ԍ�` ,
	`�o���G�[�V�������ڃL�[1` ,
	`�o���G�[�V�������ڑI����1` ,
	`�o���G�[�V�������ڃL�[2` ,
	`�o���G�[�V�������ڑI����2`  
 FROM �V�X�e���A�g�psku�ԍ�
 ORDER BY `���i�ԍ�`, `�[��_�\����`, `�F_�\����`, `�T�C�Y_�\����`;
 
-- -----------------------------------------------
-- �o���G�[�V�����I�����f�[�^��CSV�t�@�C���֏o�͂���
-- -----------------------------------------------
SELECT
    `���i�F_���i�ԍ�` AS `���i�ԍ�`,
    `SKU�Ǘ��ԍ�`,
    `�o���G�[�V����1�I������``,
    `�o���G�[�V����2�I������``,
    `�F`,
    `�T�C�Y`
FROM �o���G�[�V�����I������`
ORDER BY `SKU�Ǘ��ԍ�`
INTO OUTFILE
 "C:/temp/20_variation.csv"  -- MariaDB�̃C���X�g�[����ɏo�͂����
 CHARACTER SET 'sjis' -- �G���R�[�f�B���O��sjis
FIELDS
  TERMINATED BY ',' -- �J���}�Œl����؂�
  ENCLOSED BY '"' -- " �Œl���͂�
  ESCAPED BY '\\' -- \ �ŃG�X�P�[�v����
LINES
  TERMINATED BY '\r\n' -- \r\n �ŉ��s����
 ;

-- -----------------------------------------------
 -- �V�X�e���A�g�psku�ԍ��f�[�^��CSV�t�@�C���֏o�͂���
-- -----------------------------------------------
 SELECT  
    `���i�ԍ�`,
	CONCAT(`SKU�Ǘ��ԍ�`,LPAD(ROW_NUMBER() over (PARTITION BY `���i�ԍ�` ORDER BY `���i�ԍ�`, `�[��_�\����`, `�F_�\����`, `�T�C�Y_�\����`),2,0)) AS `SKU�Ǘ��ԍ�` ,
	`�V�X�e���A�g�pSKU�ԍ�` ,
	`�o���G�[�V�������ڃL�[1` ,
	`�o���G�[�V�������ڑI����1` ,
	`�o���G�[�V�������ڃL�[2` ,
	`�o���G�[�V�������ڑI����2`  
 FROM �V�X�e���A�g�psku�ԍ�
 ORDER BY `���i�ԍ�`, `�[��_�\����`, `�F_�\����`, `�T�C�Y_�\����`
 INTO OUTFILE
  "C:/temp/21_sku_kanri.csv"  -- MariaDB�̃C���X�g�[����ɏo�͂����
  CHARACTER SET 'sjis' -- �G���R�[�f�B���O��sjis
FIELDS
  TERMINATED BY ',' -- �J���}�Œl����؂�
  ENCLOSED BY '"' -- " �Œl���͂�
  ESCAPED BY '\\' -- \ �ŃG�X�P�[�v����
LINES
  TERMINATED BY '\r\n' -- \r\n �ŉ��s����
;
