--트랜잭션 (작업의 논리적인 단위)
--DML구문에 대해서만 트랜잭션이 적용 가능하다.

--오토커밋 상태 확인
SHOW AUTOCOMMIT;
SET AUTOCOMMIT ON;
SET AUTOCOMMIT OFF;
---------------------------------------------------
--SAVEPOINT : 실제로 많이 쓰진 않음
COMMIT;
SELECT * FROM DEPTS;
DELETE FROM DEPTS WHERE DEPARTMENT_ID = 10;
SAVEPOINT DEL10; --현재 시점을 세이브포인트로 기록
DELETE FROM DEPTS WHERE DEPARTMENT_ID = 20;
SAVEPOINT DEL20;

ROLLBACK TO DEL20;
ROLLBACK TO DEL10;
ROLLBACK; --마지막 커밋 시점으로 돌아감

--커밋: 데이터 변경을 실제로 DB에 반영하는 것, 한번 커밋이 일어나면 되돌릴 수 없음
INSERT INTO DEPTS VALUES(200, 'AAA', NULL, 1800);
COMMIT; --커밋 시점에서 위 쿼리문으로 삽입된 데이터가 DB에 저장됨