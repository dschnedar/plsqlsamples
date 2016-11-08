
Elapsed: 00:00:00.03
14:40:09 SQL> select cope_cost_center , denom , sum(rpt_qty) from mfg_order
14:40:36   2   group by cube(cope_cost_center,denom)
14:40:48   3   order by cope_cost_center , denom
14:40:48   4   ;

ccc,denom    total
ccc          total
denom        total
all          total
....
null in grouping column --> total of some kind
...
for cursor x loop
   store( nvl(x.key1,total_index) )( nvl(x.key2,total_index) ) := x.rpt_qty
end
print(  store(312204)     (total_index)      )----73094150  sum of sums for cost center 312204
print(  store(total_index)(20)               )----36629175  sum of sums for $20
print(  store(total_index)(total_index)      )----36629175  sum of all (  sum(all_notes)=sum(all_cost_centers)  )


COPE_C|     DENOM|SUM(RPT_QTY)
------|----------|------------
003600|         5|       30000
003600|~         |       30000
005945|         1|           0
005945|~         |           0
006100|         1|         750
006100|         5|       23750
006100|        10|       18875
006100|~         |       43375
009650|        20|       49000
009650|~         |       49000
104000|        20|       12000
104000|       100|        4000
104000|~         |       16000
106000|        50|       16000
106000|~         |       16000
107000|         5|        8000
107000|~         |        8000
107400|        20|       36000
107400|       100|       16000
107400|~         |       52000
300000|        50|       20000
300000|~         |       20000
311000|        20|           0
311000|       100|           0
311000|~         |           0
312204|         1|    29459200
312204|         2|        2750
312204|         5|     2201900
312204|        10|     4110100
312204|        20|    17516400
312204|        50|     3030000
312204|       100|    16773800
312204|~         |    73094150
322000|         1|       40000
322000|~         |       40000
351030|         1|    39805800
351030|         2|      675600
351030|         5|    14331100
351030|        10|     7857000
351030|        20|    18310400
351030|        50|     1669400
351030|       100|     1787200
351030|~         |    84436500
371000|         2|           5
371000|        50|      800000
371000|       100|      384000
371000|~         |     1184005
412000|         1|       40000
412000|        20|      200000
412000|        50|      201000
412000|~         |      441000
420000|         1|       20750
420000|         5|       26000
420000|        10|       28000
420000|        20|      373000
420000|        50|       24000
420000|       100|     1230124
420000|~         |     1701874
423000|        20|           0
423000|       100|       36000
423000|~         |       36000
425000|         1|           0
425000|         5|       16000
425000|       100|      776001
425000|~         |      792001
430000|         1|       36750
430000|         5|           0
430000|        20|       48000
430000|       100|       48500
430000|~         |      133250
432000|        20|       20000
432000|       100|        1000
432000|~         |       21000
434000|        20|       40000
434000|~         |       40000
436000|         1|           0
436000|        20|           0
436000|~         |           0
440000|         1|       56000
440000|         5|        1500
440000|        10|           0
440000|        20|        4375
440000|        50|        7250
440000|       100|       10125
440000|~         |       79250
452100|         1|       16000
452100|        20|       20000
452100|~         |       36000
461000|         1|        1000
461000|        20|           0
461000|~         |        1000
710000|         2|     2800128
710000|       100|       20000
710000|~         |     2820128
810200|         1|           0
810200|         5|       32000
810200|       100|           0
810200|~         |       32000
~     |         1|    69476250
~     |         2|     3478483
~     |         5|    16670250
~     |        10|    12013975
~     |        20|    36629175
~     |        50|     5767650
~     |       100|    21086750
~     |~         |   165122533

106 rows selected.

Elapsed: 00:00:00.01
14:40:49 SQL>

















SELECT division_id, job_id, SUM(salary)
FROM employees2
GROUP BY ROLLUP(division_id, job_id)
ORDER BY division_id, job_id;

DIV JOB SUM(SALARY)
--- --- -----------
BUS MGR      530000
BUS PRE      800000
BUS WOR      280000
BUS         1610000
OPE ENG      245000
OPE MGR      805000
OPE WOR      270000
OPE         1320000
SAL MGR     4446000
SAL WOR      490000
SAL         4936000
SUP MGR      465000
SUP TEC      115000
SUP WOR      435000
SUP         1015000
            8881000




SELECT division_id, job_id, SUM(salary)
FROM employees2
GROUP BY CUBE(division_id, job_id)
ORDER BY division_id, job_id;

DIV JOB SUM(SALARY)
--- --- -----------
BUS MGR      530000
BUS PRE      800000
BUS WOR      280000
BUS         1610000
OPE ENG      245000
OPE MGR      805000
OPE WOR      270000
OPE         1320000
SAL MGR     4446000
SAL WOR      490000
SAL         4936000
SUP MGR      465000
SUP TEC      115000
SUP WOR      435000
SUP         1015000
    ENG      245000
    MGR     6246000
    PRE      800000
    TEC      115000
    WOR     1475000
            8881000



SELECT *
FROM (
  SELECT month, prd_type_id, amount
  FROM all_sales
  WHERE year = 2003
  AND prd_type_id IN (1, 2, 3)
)
PIVOT (
  SUM(amount) FOR month IN (1 AS JAN, 2 AS FEB, 3 AS MAR, 4 AS APR)
)
ORDER BY prd_type_id;

PRD_TYPE_ID        JAN        FEB        MAR        APR
----------- ---------- ---------- ---------- ----------
          1   38909.04    70567.9   91826.98   120344.7
          2   14309.04    13367.9   16826.98    15664.7
          3   24909.04    15467.9   20626.98    23844.7


