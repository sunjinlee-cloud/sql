 --형변환 함수
--자동형변환을 제공 NUMBER<->문자, DATE<->문자
SELECT * FROM EMPLOYEES WHERE SALARY >=6000;
SELECT HIRE_DATE FROM EMPLOYEES WHERE HIRE_DATE = '05/09/30';

--강제형변환
--TO_CHAR : 날짜를 문자로 바꾸기(매개변수로 날짜 포맷 형식이 쓰임)
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS ') FROM DUAL;
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일') FROM DUAL; 
--데이트 포맷 형식이 아닌 값은 ""로 묶어준다.
SELECT FIRST_NAME, TO_CHAR(HIRE_DATE, 'YY-MM-DD AM') FROM EMPLOYEES;
--TO_CHAR : 숫자를 문자로 바꾸기(매개변수로 숫자에 대한 포맷 형식이 쓰임)
SELECT TO_CHAR(20000, '9999999999') AS "20000" FROM DUAL;
SELECT TO_CHAR(20000, '99') FROM DUAL; --출력공간이 숫자보다 작으면 #####로 표시됨
SELECT TO_CHAR(20000, '09999999') FROM DUAL; --앞에 0을 붙이면 남는자리는 앞부터 0으로 표시
SELECT TO_CHAR(22222.123, '90999.99') FROM DUAL;
SELECT TO_CHAR(20000, '$999,999.99') FROM DUAL; --$는 그냥 쓰면 된다. $대신 L을 붙이면 지역화폐기호가 나옴.
SELECT TO_CHAR(20000, 'L999,999') FROM DUAL;

SELECT '2000' + 2000 FROM DUAL; --자동형변환
-- SELECT '$2000' + 2000 FROM DUAL : 자동형변환 불가, TO_NUMBER 함수로 문자를 숫자로 바꿔줘야함
SELECT TO_NUMBER('$2,000', '$99,999') - 1500 FROM DUAL; --매개변수에는 TO_CHAR의 숫자형식이 그대로 들어간다.

--TO_DATE : 문자를 날짜로 바꿔준다(매개변수에는 TO_CHAR의 날짜형식이 그대로 들어간다.)
SELECT TO_DATE('2024-02-07', 'YYYY-MM-DD')FROM DUAL;
SELECT TO_DATE('2024-02-07', 'YYYY-MM-DD') - HIRE_DATE AS "총 근무일 수" FROM EMPLOYEES;
SELECT TO_DATE('2024년 02월 07일', 'YYYY"년" MM"월" DD"일"') FROM EMPLOYEES;
SELECT TO_DATE('2024-02-07 02:32:24', 'YYYY-MM-DD HH:MI:SS') FROM DUAL; 
--------------------------------------------------------------------------------------



--변환함수
--NVL(EXPR1,EXPR2) : 만약 매개변수 1이 NULL이면 매개변수 2로 값을 넣어준다.
--NULL값이 있는 컬럼을 사용해야 할 때 유용한 함수
SELECT NVL(3000,0), NVL(NULL, 0) FROM DUAL;
SELECT FIRST_NAME, SALARY, COMMISSION_PCT, SALARY+SALARY*NVL(COMMISSION_PCT, 0) 
AS "실제 급여" FROM EMPLOYEES;

--NVL2(EXPR1,EXPR2,EXPR3) : 만약 매개변수 1이 NULL이 아니면 매개변수 2로 실행하고, NULL이면 EXPR3으로 실행
SELECT FIRST_NAME, COMMISSION_PCT, NVL2(COMMISSION_PCT, SALARY+SALARY*COMMISSION_PCT, SALARY) AS 실제급여 FROM EMPLOYEES;

--DECODE(값, 비교값, 결과값, ........, ELSE문)
SELECT DECODE('B', 'A', 'A입니다', 'C', 'C입니다', '나머지입니다') AS 연습 FROM DUAL;
SELECT DECODE(JOB_ID, 'IT_PROG', SALARY*1.1
                    , 'FT_MGR', SALARY*1,2
                    , 'AD_VP', SALARY*1.3
                    , SALARY)
        , JOB_ID
FROM EMPLOYEES;

--CASE ~ WHEN ~ THEN ~ ELSE ~ END
SELECT FIRST_NAME
    , JOB_ID
    , SALARY
    , CASE JOB_ID WHEN 'IT_PROG' THEN SALARY+SALARY*0.1
                WHEN 'FI_MGR' THEN SALARY+SALARY*0.2
                WHEN 'AD_PRES' THEN SALARY*1.3
                ELSE SALARY
                END AS 계산
FROM EMPLOYEES;
--2ND - WHEN 조건식을 넣을 수도 있음
SELECT FIRST_NAME
    , JOB_ID
    , SALARY
    , CASE WHEN JOB_ID = 'IT_PROG' THEN SALARY+SALARY*0.1
           WHEN JOB_ID = 'FI_MGR' THEN SALARY+SALARY*0.2
           WHEN JOB_ID = 'AD_PRES' THEN SALARY*1.3
           ELSE SALARY
           END AS 계산
FROM EMPLOYEES;

--COALESCE : NULL이 아닌 첫번째 인자를 반환함
SELECT COALESCE(NULL, NULL, NULL, NULL) FROM DUAL;
SELECT COALESCE(COMMISSION_PCT, 0) AS 커미션 FROM EMPLOYEES;
-------------------------------------------------------------------------------



--3강 연습문제

--문제 1.
--1) 오늘의 환율이 1302.69원 입니다 SALARY컬럼을 한국돈으로 변경해서 소수점 2자리수까지 출력 하세요.
--2) '20250207' 문자를 '2025년 02월 07일' 로 변환해서 출력하세요.
SELECT TO_CHAR(SALARY*1302.69, 'L999,999,999.99') AS 한화월급 FROM EMPLOYEES;
SELECT TO_CHAR(TO_DATE('20250207', 'YYYY-MM-DD'), 'YYYY"년" MM"월" DD"일"') AS 변환 FROM DUAL; 

--문제 2.
--현재일자를 기준으로 EMPLOYEE테이블의 입사일자(hire_date)를 참조해서 근속년수가 10년 이상인
--사원을 다음과 같은 형태의 결과를 출력하도록 쿼리를 작성해 보세요. 
--조건 1) 근속년수가 높은 사원 순서대로 결과가 나오도록 합니다.

SELECT EMPLOYEE_ID AS 사원번호, 
        FIRST_NAME||' '||LAST_NAME AS 사원명,
        HIRE_DATE AS 입사일자,
        FLOOR((SYSDATE - HIRE_DATE)/365) AS 근속년수 
FROM EMPLOYEES WHERE FLOOR((SYSDATE - HIRE_DATE)/365) >= 10 ORDER BY 근속년수 DESC;

--문제 3.
--EMPLOYEE 테이블의 manager_id컬럼을 확인하여 first_name, manager_id, 직급을 출력합니다.
--100이라면 ‘부장’ 
--120이라면 ‘과장’
--121이라면 ‘대리’
--122라면 ‘주임’
--나머지는 ‘사원’ 으로 출력합니다.
--조건 1) 부서가 50인 사람들을 대상으로만 조회합니다
--조건 2) DECODE구문으로 표현해보세요.
--조건 3) CASE구문으로 표현해보세요.
SELECT FIRST_NAME AS 이름, MANAGER_ID, 
            DECODE(MANAGER_ID, 100, '부장',
                             120, '과장',
                             121, '대리',
                             122, '주임',
                             '사원')
            AS 직급                    
FROM EMPLOYEES WHERE DEPARTMENT_ID = 50;

SELECT FIRST_NAME, MANAGER_ID, 
            CASE MANAGER_ID WHEN 100 THEN '부장'
                             WHEN 120 THEN '과장'
                             WHEN 121 THEN '대리'
                             WHEN 122 THEN '주임'
                             ELSE '사원' END
            AS 직급                    
FROM EMPLOYEES WHERE DEPARTMENT_ID = 50;
--
--문제 4. 
--EMPLOYEES 테이블의 이름, 입사일, 급여, 진급대상, 급여상태 를 출력합니다.
--조건1) HIRE_DATE를 XXXX년XX월XX일 형식으로 출력하세요. 
--조건2) 급여는 커미션값이 퍼센트로 더해진 값을 출력하고, 1300을 곱한 원화로 바꿔서 출력하세요.
--조건3) 진급대상은 5년 마다 이루어 집니다. 근속년수가 5의 배수라면 진급대상으로 출력합니다.
--조건4) 부서가 NULL이 아닌 데이터를 대상으로 출력합니다.
--조건5) 급여상태는 10000이상이면 '상' 10000~5000이라면 '중', 5000이하라면 '하' 로 출력해주세요.

SELECT FIRST_NAME||' '||LAST_NAME AS 이름, 
        TO_CHAR(HIRE_DATE, 'YYYY"년"MM"월"DD"일"') AS 입사일, 
        TO_CHAR(TO_NUMBER(SALARY+SALARY*NVL(COMMISSION_PCT, 0))*1300, 'L999,999,999') AS 급여,
        CASE WHEN MOD(TRUNC((SYSDATE - HIRE_DATE)/365),5) = 0 THEN '진급대상'
            ELSE '대상아님'
            END
        AS 진급대상,
        CASE WHEN SALARY >= 10000 THEN '상'
            WHEN SALARY < 10000 AND SALARY >=5000 THEN '중'
            WHEN SALARY < 5000 THEN '하'
            END
        AS 급여상태 
        FROM EMPLOYEES WHERE DEPARTMENT_ID IS NOT NULL;