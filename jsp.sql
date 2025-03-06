select * from board;

SELECT * FROM (
    SELECT B.*, 
    LAG(BNO, 1, 0) OVER(ORDER BY BNO) AS PREV_NO,
    LAG(TITLE, 1, '이전글이 없습니다') OVER(ORDER BY BNO) AS PREV_TITLE,
    LEAD(BNO, 1,0) OVER(ORDER BY BNO) AS NEXT_NO,
    LEAD(TITLE, 1, '다음글이 없습니다') OVER(ORDER BY BNO) AS NEXT_TITLE
    FROM BOARD B)
WHERE BNO = 9;