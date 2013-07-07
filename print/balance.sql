SELECT
    CASE WHEN STRFTIME('%m', date) > '03'
      THEN
        STRFTIME('%Y', date) + 0
      ELSE
        STRFTIME('%Y', date) - 1
    END  AS year
  , SUM(CASE type WHEN '収入' THEN cost ELSE 0 END)                        AS earn
  , SUM(CASE type WHEN '特入' THEN cost ELSE 0 END)                        AS bonus
  , SUM(CASE WHEN type NOT IN ('収入','特入','特出') THEN cost ELSE 0 END) AS expense
  , SUM(CASE type WHEN '特出' THEN cost ELSE 0 END)                        AS special
  , SUM(CASE WHEN type IN ('収入','特入') THEN cost ELSE -cost END)        AS balance
FROM
    expenses
WHERE
    type NOT IN ('秘密入','秘密出')
GROUP BY
    year
ORDER BY
    year
;
