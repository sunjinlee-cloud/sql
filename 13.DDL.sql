--DDL문 (트랜잭션 없음)

DROP TABLE DEPTS;
CREATE TABLE DEPTS (
    DEPT_NO NUMBER(2),
    DEPT_NAME VARCHAR2(30), --VAR가 붙어있으면 가변크기를 차지함
    DEPT_YN CHAR(10),
    DEPT_DATE DATE,
    DEPT_BONUS NUMBER(10,2), --전체숫자가 10자리고 이중 2자리는 소수점 아래 자리
    DEPT_CONTENT LONG --최대 2기가까지 저장 가능한 가변문자열, 많이 사용되지는 않음
);
INSERT INTO DEPTS VALUES(99, 'HELLO', 'Y' , SYSDATE, 3.14, '졸리다');
INSERT INTO DEPTS VALUES(100, 'HELLO', 'B' , SYSDATE, 3.14, '졸리다');
INSERT INTO DEPTS VALUES(100, 'HELLO', '가' , SYSDATE, 3.14, '졸리다');

----------------------------------------------------------------------------
--컬럼 추가 ADD
ALTER TABLE DEPTS ADD(DEPT_COUNT NUMBER(3)); --DEPT_COUNT라는 컬럼을 추가
--컬럼명 변경 RENAME COLUMN (예전이름) TO (바꿀이름)
ALTER TABLE DEPTS RENAME COLUMN DEPT_COUNT TO EMP_COUNT;
--컬럼 수정 MODIFY
ALTER TABLE DEPTS MODIFY EMP_COUNT NUMBER(5);
DESC DEPTS;
ALTER TABLE DEPTS MODIFY DEPT_NAME VARCHAR2(2); --컬럼의 크기를 줄이는 변경은 보통 안됨
--컬럼 삭제 DROP COLUMN
ALTER TABLE DEPTS DROP COLUMN EMP_COUNT;
----------------------------------------------------------------------------
--테이블 삭제
DROP TABLE EMPS;
DROP TABLE DEPARTMENTS; --타 테이블에서 참조중이므로 안지워짐
-- 굳이 지우고 싶으면 DROP TABLE DEPARTMENTS CASCADE CONSTRAINTS;
--테이블 자르기 TRUNCATE : 데이터를 전부 지우고 할당된 저장 공간도 해제한다.
TRUNCATE TABLE DEPTS;
SELECT * FROM DEPTS;

-----------------------------------------------------------------------------
CREATE TABLE DEPT2 (
    DEPT_NO NUMBER(3),
    DEPT_NAME VARCHAR2(15),
    LOCA_NUMBER NUMBER(4),
    DEPT_GENDER CHAR(1),
    REG_DATE DATE,
    DEPT_BONUS NUMBER(10,5)
);
INSERT INTO DEPT2 VALUES(100, 'ACCOUNT', 123, 'A', SYSDATE, 0.12345);
SELECT * FROM DEPT2; 