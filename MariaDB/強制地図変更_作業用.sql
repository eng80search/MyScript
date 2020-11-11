-- 地図位置変更作業用クエリ
-- 前回解除しなかった店舗の備考欄に「前回解除せず」をつける
SELECT a.no, a.clinic_id
       ,(CASE WHEN b.clinic_id IS null THEN '' ELSE '前回解除せず' END)  '備考'
		 , b.clinic_id
FROM temp_new a
LEFT JOIN temp_old b
ON a.clinic_id = b.clinic_id 
ORDER BY a.no asctemp_old