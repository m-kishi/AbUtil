SELECT
    A.year AS year
  , A.earn AS earn
  , A.bonus AS bonus
  , A.expense AS expense
  , A.special AS special
  , A.balance AS balance
  , B.finance AS finance
FROM
    ( -- 年度単位(4月〜3月)
      SELECT
          CASE WHEN type <> '投資'
            THEN
                CASE WHEN STRFTIME('%m', date) > '03'
                  THEN
                    STRFTIME('%Y', date) + 0
                  ELSE
                    STRFTIME('%Y', date) - 1
                END
            ELSE
                STRFTIME('%Y', date) + 0
          END AS year
        , SUM(CASE type WHEN '収入' THEN cost ELSE 0 END) AS earn
        , SUM(CASE type WHEN '特入' THEN cost ELSE 0 END) AS bonus
        , SUM(CASE WHEN type NOT IN ('収入','特入','特出', '投資') THEN cost ELSE 0 END) AS expense
        , SUM(CASE type WHEN '特出' THEN cost ELSE 0 END) AS special
        , SUM(CASE WHEN type = '投資' THEN 0 WHEN type IN ('収入','特入') THEN cost ELSE -cost END) AS balance
      FROM
          expenses
      WHERE
          -- 年単位を左結合するため投資は除外しない
          type NOT IN ('秘密入','秘密出')
      GROUP BY
          year
    ) A
    -- 年単位(1月〜3月)
    LEFT JOIN (
        SELECT
            STRFTIME('%Y', date) + 0 AS year
          , SUM(cost) AS finance
        FROM
            expenses
        WHERE
            type = '投資'
        GROUP BY
            year
    ) B
      ON A.year = B.year
ORDER BY
    A.year
;
