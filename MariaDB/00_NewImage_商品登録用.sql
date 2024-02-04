select
    'u' AS `処理`,
    '1' AS `店舗番号`,
    concat(`product`.`商品番号`, ifnull(`color`.`商品色_英語`, ''), ifnull(`zaiko`.`商品在庫_英語`, '')) AS `コード(更新時使用)`,
    `product`.`商品番号` AS `親コード(新規登録時使用)`,
    '' AS `モード`,
    `zaiko`.`商品在庫_数量` AS `在庫数`,
    '' AS `発注点在庫数`,
    `product`.`商品番号` AS `newimage2コード`,
    `product`.`商品管理番号` AS `newimage2商品管理番号(URL)`,
    `color`.`商品色_日本語` AS `newimage2項目1`,
    `color`.`商品色_英語` AS `newimage2項目値1`,
    `zaiko`.`商品在庫_日本語` AS `newimage2項目2`,
    `zaiko`.`商品在庫_英語` AS `newimage2項目値2`,
    1 AS `newimage2on/off`,
    `product`.`商品番号` AS `ＮｅｗＩｍａｇｅ　Ｑoo10コード`,
    `color`.`商品色_日本語` AS `ＮｅｗＩｍａｇｅ　Ｑoo10項目1`,
    `zaiko`.`商品在庫_日本語` AS `ＮｅｗＩｍａｇｅ　Ｑoo10項目2`,
    `zaiko`.`商品在庫_英語` AS `ＮｅｗＩｍａｇｅ　Ｑoo10オプションコード`,
    1 AS `ＮｅｗＩｍａｇｅ　Ｑoo10on/off`,
    concat(`product`.`商品番号`, ifnull(`color`.`商品色_英語`, ''), ifnull(`zaiko`.`商品在庫_英語`, '')) AS `ＮｅｗＩｍａｇｅ Shoplistコード`,
    `color`.`商品色_日本語` AS `ＮｅｗＩｍａｇｅ Shoplist項目1`,
    `zaiko`.`商品在庫_日本語` AS `ＮｅｗＩｍａｇｅ Shoplist項目2`,
    1 AS `ＮｅｗＩｍａｇｅ Shopliston/off`,
    '----' AS `最終注文日`,
    '' AS `メモ`
from
    (
        (
            `商品番号` `product`
            left join
                `商品在庫` `zaiko`
            on  (
                    `product`.`商品番号` = `zaiko`.`商品番号`
                )
        )
        left join
            `商品色` `color`
        on  (
                `product`.`商品番号` = `color`.`商品番号`
            )
    )
order by
    `product`.`商品番号`
