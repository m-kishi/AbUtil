SELECT
    A.year AS year
  , A.earn AS earn
  , A.bonus AS bonus
  , A.expense AS expense
  , A.special AS special
  , A.balance AS balance
  , A.finance AS finance
FROM (
    -- 年度単位(4月〜3月)
    SELECT
        CASE WHEN STRFTIME('%m', date) > '03'
             THEN
                 STRFTIME('%Y', date) + 0
             ELSE
                 STRFTIME('%Y', date) - 1
        END AS year
      , SUM(CASE type WHEN '収入' THEN cost ELSE 0 END) AS earn
      , SUM(CASE type WHEN '特入' THEN cost ELSE 0 END) AS bonus
      , SUM(CASE WHEN type NOT IN ('収入','特入','特出', '利益', '損益') THEN cost ELSE 0 END) AS expense
      , SUM(CASE type WHEN '特出' THEN cost ELSE 0 END) AS special
      , SUM(CASE WHEN type IN ('収入','特入') THEN cost WHEN type IN ('利益', '損益') THEN 0 ELSE -cost END) AS balance
      , SUM(CASE WHEN type = '利益' THEN cost WHEN type = '損益' THEN -cost ELSE 0 END) as finance
    FROM
        expenses
    WHERE
        type NOT IN ('秘密入', '秘密出', '投資')
    GROUP BY
        year
    ) A
ORDER BY
    A.year
;
