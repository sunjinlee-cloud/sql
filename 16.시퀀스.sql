--시퀀스는 순차적으로 증가하는 값
--보통 pk 지정에 사용된다.
SELECT * FROM USER_SEQUENCES;

--생성하기
CREATE SEQUENCE DEPTS_SEQ;  --기본값으로 지정되면서 시퀀스가 생성됨.
DROP SEQUENCE DEPTS_SEQ;

CREATE SEQUENCE DEPTS_SEQ
    INCREMENT BY 1 --몇씩 증가하는지
    START WITH 1 --시작값
    MAXVALUE 10 --최댓값
    MINVALUE 1 --최솟값
    NOCYCLE --시퀀스가 맥스에 도달시 재사용할거냐.
    NOCACHE; --시퀀스는 메모리(캐시)에 두지 않는다.
    
DROP TABLE DEPTS;
CREATE TABLE DEPTS(
    DEPT_NO NUMBER(2) PRIMARY KEY,
    DEPT_NAME VARCHAR2(30)
);

--시퀀스 사용 방법 2가지
SELECT DEPTS_SEQ.CURRVAL FROM DUAL; --NEXTVAL이 한번 실행된 이후에 사용가능.
SELECT DEPTS_SEQ.NEXTVAL FROM DUAL;

INSERT INTO DEPTS VALUES(DEPTS_SEQ.NEXTVAL, 'EX');
SELECT * FROM DEPTS;

--시퀀스 수정
ALTER SEQUENCE DEPTS_SEQ MAXVALUE 1000;
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY 10;

--시퀀스가 테이블에서 사용 중에 있는 경우 시퀀스를 DROP하면 안됨.
--주기적으로 시퀀스를 초기화해야 한다. 약간 꼼수인데, 시퀀스 앞에 연도를 붙이는 경우처럼.
--시퀀스 증가값을 현재값의 음수로 바꾼 후
SELECT DEPTS_SEQ.CURRVAL FROM DUAL;
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY -40 MINVALUE 0;
--전진을 시키고
SELECT DEPTS_SEQ.NEXTVAL FROM DUAL;
--다시 시퀀스 증가값을 양수값으로 바꾼다.
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY 1;

-------------------------------------------------------------------------
--연습문제
CREATE TABLE EMPS(
    EMPS_NO VARCHAR2(30) PRIMARY KEY,
    EMPS_NAME VARCHAR(30)
);
--이 테이블에 기본키를 2025-00001 형식으로 INSERT 하려고 할 때
--시퀀스를 만들고 INSERT 하시오.

SELECT * FROM EMPS;
DROP SEQUENCE EMPS;

CREATE SEQUENCE EMPS_SEQ
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 99999
    MINVALUE 1
    NOCYCLE
    NOCACHE;
SELECT EMPS_SEQ.NEXTVAL FROM DUAL;
INSERT INTO EMPS VALUES(TO_CHAR(SYSDATE,'YYYY')||'-'||LPAD(EMPS_SEQ.NEXTVAL,5,0),'현타');
------------------------------------------------------------------------------------
--인덱스 : 검색을 빠르게 해준다.
--인덱스의 종류 : 고유 인덱스, 비고유 인덱스
--고유 인덱스 : PK, UK를 만들 때 자동으로 생성되는 인덱스
--비고유인덱스 : 일반 컬럼에 지정해서 조회를 빠르게 할 수 있는 인덱스
--단 인덱스가 너무 많이 사용되면 성능 저하를 일으킬 수 있음
--주로 사용되는 컬럼에서 SELECT 절의 속도 저하가 감지되면 먼저 인덱스를 의심해 볼 수 있다.

DROP TABLE EMPS;
CREATE TABLE EMPS AS (SELECT * FROM EMPLOYEES);

SELECT * FROM EMPS WHERE FIRST_NAME = 'Nancy';
--FIRST_NAME 컬럼에 인덱스 만들어 붙이기
CREATE INDEX EMPS_IDX ON EMPS(FIRST_NAME);
DROP INDEX EMPS_IDX;

--결합인덱스 : 여러 컬럼을 묶어서 생성할 수 있음
CREATE INDEX EMPS_IDX ON EMPS(FIRST_NAME, LAST_NAME);
SELECT * FROM EMPS WHERE FIRST_NAME = 'Nancy';
SELECT * FROM EMPS WHERE FIRST_NAME = 'Nancy' AND LAST_NAME = 'Greenberg';
SELECT * FROM EMPS WHERE LAST_NAME = 'Greenberg';

--고유인덱스
--CREATE UNIQUE INDEX 인덱스명 ON 테이블명(부착할 컬럼); --PK,UK 만들 때 자동 생성
SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = 100;