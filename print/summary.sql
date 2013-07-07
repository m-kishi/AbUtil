SELECT
    STRFTIME('%Y', date) AS year
  , STRFTIME('%m', date) AS month
  , SUM(CASE type WHEN '食費'   THEN cost ELSE 0 END) AS food
  , SUM(CASE type WHEN '外食費' THEN cost ELSE 0 END) AS otfd
  , SUM(CASE type WHEN '雑貨'   THEN cost ELSE 0 END) AS good
  , SUM(CASE type WHEN '交際費' THEN cost ELSE 0 END) AS frnd
  , SUM(CASE type WHEN '交通費' THEN cost ELSE 0 END) AS trfc
  , SUM(CASE type WHEN '遊行費' THEN cost ELSE 0 END) AS play
  , SUM(CASE type WHEN '家賃'   THEN cost ELSE 0 END) AS hous
  , SUM(CASE type WHEN '光熱費' THEN cost ELSE 0 END) AS engy
  , SUM(CASE type WHEN '通信費' THEN cost ELSE 0 END) AS cnct
  , SUM(CASE type WHEN '医療費' THEN cost ELSE 0 END) AS medi
  , SUM(CASE type WHEN '保険料' THEN cost ELSE 0 END) AS insu
  , SUM(CASE type WHEN 'その他' THEN cost ELSE 0 END) AS othr
  , SUM(CASE type WHEN '収入'   THEN cost ELSE 0 END) AS earn
  , SUM(CASE type WHEN '特入'   THEN cost ELSE 0 END) AS bnus
  , SUM(CASE type WHEN '特出'   THEN cost ELSE 0 END) AS spcl
  , SUM(CASE type WHEN '秘密入' THEN cost ELSE 0 END) AS prvi
  , SUM(CASE type WHEN '秘密出' THEN cost ELSE 0 END) AS prvo
  , SUM(CASE WHEN type NOT IN ('収入', '特入', '特出', '秘密入', '秘密出') THEN cost ELSE 0 END) AS ttal
  , SUM(CASE WHEN type = '収入' THEN cost WHEN type NOT IN('収入', '特入', '特出', '秘密入', '秘密出') THEN -cost ELSE 0 END) AS blnc
FROM
    expenses
GROUP BY
    year, month
ORDER BY
    year, month
;
