WITH dense_rank_cte AS (

    SELECT id, login_date,

           DENSE_RANK() OVER(PARTITION BY id ORDER BY login_date) AS dense_rank_num

      FROM Logins

),

grouping_cte AS (

    SELECT id, login_date, dense_rank_num,

           DATE_ADD(login_date, INTERVAL -dense_rank_num DAY) AS groupings

      FROM dense_rank_cte

),

grouping_info_cte AS (

    SELECT id, MIN(login_date) AS start_date, MAX(login_date) AS end_date,

           dense_rank_num, groupings, COUNT(*),

           DATEDIFF(MAX(login_date), MIN(login_date)) + 1 AS duration

      FROM grouping_cte

     GROUP BY id, groupings

    HAVING DATEDIFF(MAX(login_date), MIN(login_date)) + 1 >= 5

     ORDER BY id, start_date

)

SELECT DISTINCT g.id, a.name

  FROM grouping_info_cte AS g

  JOIN Accounts AS a

USING(id)

ORDER BY g.id;