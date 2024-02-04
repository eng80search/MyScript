class ConstProduct(object):

    """商品登録用定数"""

    def CSVinitCSV(self):
        """TODO: to be defined. """
        
    INPUT_EXCEL = "01_make_商品登録(sku対応).xlsx"

    INPUT_SHEET_PRODUCT = "10_product"
    INPUT_SHEET_COLOR = "11_color"
    INPUT_SHEET_SIZE = "12_size"

    COL_INDEX_商品_商品管理番号 = "商品管理番号"
    COL_INDEX_商品_商品番号 = "商品番号"
    COL_INDEX_商品_商品名 = "商品名"
    COL_INDEX_商品_キャッチコピー = "キャッチコピー"
    COL_INDEX_商品_販売価格 = "販売価格"
    COL_INDEX_商品_表示価格 = "表示価格"
    COL_INDEX_商品_在庫数_即納_12営業日 = "在庫数（即納／12営業日）"
    COL_INDEX_商品_スマートフォン用商品説明文 = "スマートフォン用商品説明文"
    COL_INDEX_商品_PC用販売説明文 = "PC用販売説明文"

    COL_INDEX_商品色_商品番号 = "商品番号"
    COL_INDEX_商品色_日本語 = "商品色_日本語"
    COL_INDEX_商品色_英語 = "商品色_英語"
    COL_INDEX_商品色_表示順 = "表示順"

    COL_INDEX_商品サイズ_商品番号 = "商品番号"
    COL_INDEX_商品サイズ_サイズ = "サイズ"
    COL_INDEX_商品サイズ_表示順 = "表示順"

    IMPORT_CSV_PRODUCT = "10_product.csv"
    IMPORT_CSV_COLOR = "11_color.csv"
    IMPORT_CSV_SIZE = "12_size.csv"

    IMPORT_CSV_VARIATION = "20_variation.csv"
    IMPORT_CSV_KANRI = "21_sku_kanri.csv"
    IMPORT_CSV_ITEM = "normal-item-template.csv"

    EXPORT_CSV = "normal-item.csv"
    EXPORT_IMAGE_PREFIX = "A240115-608"
