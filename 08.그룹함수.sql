--그룹함수: 여러 행에 대해서 합계, 평균, 최소, 최대, 튜플 개수 세기 등의 연산을 할 수 있다.
--전부 NULL을 제외한 값에 대한 계산이 이루어진다.
SELECT AVG(SALARY), MAX(SALARY), MIN(SALARY), SUM(SALARY), COUNT(SALARY) FROM EMPLOYEES WHERE JOB_ID LIKE 'SA%';

--MIN, MAX는 날짜와 문자열에도 적용된다. 날짜에서 MIN은 가장 예전 값, MAX는 가장 최근값임
--문자열에서는 알파벳순서로 A가 MIN임
SELECT MIN(HIRE_DATE), MAX(HIRE_DATE), MIN(FIRST_NAME), MAX(FIRST_NAME) FROM EMPLOYEES;

--COUNT(*) : NULL값을 포함한 전체 튜플의 수를 반환
--COUNT(컬럼명) : NULL값을 제외한 전체 튜플의 수를 반환
SELECT COUNT(COMMISSION_PCT) FROM EMPLOYEES; --NULL 아닌 값이 35개임
SELECT COUNT(*) FROM EMPLOYEES; --NULL포함!

--그룹 함수와 일반 컬럼은 함께 사용못함.
--선생님이 일반컬럼이랑 그룹함수의 튜플수가 다르니까 안된다는데,
--검색조건에 잡아이디 프레지던트 걸면 일반컬럼도 한개인데 그래도 안되는걸 보면 오라클에서 안되게 만들었나봄
SELECT FIRST_NAME, AVG(SALARY) FROM EMPLOYEES WHERE JOB_ID = 'AD_PRES';
--그래도 굳이 쓰려면 그룹함수 뒤에 OVER() 를 붙이면 전체 행에 그룹함수의 계산값이 출력되면서 
--그룹함수와 일반컬럼이 함께 출력되긴 함
SELECT FIRST_NAME, AVG(SALARY) OVER() FROM EMPLOYEES;


-----------------------------------------------------------------------------------------
--일반컬럼에 GROUP BY 절을 써서 그룹화하는 경우에 그룹함수와 일반컬럼도 사용이 가능
SELECT DEPARTMENT_ID FROM EMPLOYEES GROUP BY DEPARTMENT_ID;
SELECT DEPARTMENT_ID, SUM(SALARY), MAX(SALARY), MIN(SALARY), AVG(SALARY) FROM EMPLOYEES GROUP BY DEPARTMENT_ID;
--주의점 : GROUP BY절을 쓰는 경우, GROUP BY에 지정되지 않은 컬럼은 SELECT절에 사용 불가

--2개 이상의 그룹화
SELECT DEPARTMENT_ID, JOB_ID
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY DEPARTMENT_ID;

--COUNT(*) GROUP BY 한 각 그룹에 대한 튜플수를 뽑아냄
SELECT DEPARTMENT_ID, JOB_ID, COUNT(*)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY DEPARTMENT_ID;

--WHERE절에 그룹의 조건을 넣는 것이 아님.
SELECT DEPARTMENT_ID, SUM(SALARY)
FROM EMPLOYEES
WHERE SUM(SALARY) >= 50000 
GROUP BY DEPARTMENT_ID;
--GROUP BY 된 조건은 HAVING 절에 써 준다.
----------------------------------------------------------------------------

--HAVING (그룹BY의 조건) // WHERE는 일반 행에 대한 조건
SELECT DEPARTMENT_ID, AVG(SALARY), COUNT(*)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) > 5000 AND COUNT(*) >= 3
ORDER BY AVG(SALARY) DESC;

--세일즈 디파트먼트에서 급여평균이 10000이 넘는 JOB_ID를 구한다고 할 때
SELECT JOB_ID, AVG(SALARY)
FROM EMPLOYEES
WHERE JOB_ID LIKE 'SA%'
GROUP BY JOB_ID
HAVING AVG(SALARY) >= 10000;
-----------------------------------------------------------------------------

--ROLLUP : 그룹함수 사용 시 함께 사용하면 그룹별 소계를 내준다.
--GROUP BY ROLLUP(컬럼명, 컬럼명)으로 사용
SELECT DEPARTMENT_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID);

SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY), COUNT(*)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID, JOB_ID;

--CUBE : ROLLUP에 의해 반환되는 소계값에, 해당 소계값의 계까지 함께 계산해준다.
SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY), COUNT(*)
FROM EMPLOYEES
GROUP BY CUBE(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID, JOB_ID;

--GROUPING : 그룹 절로 만들어진 행의 경우 0을, 롤업이나 큐브로 만들어진 행의 경우에는 1을 반환
SELECT DECODE(GROUPING(DEPARTMENT_ID), 1, '총계', DEPARTMENT_ID) AS DEPARTMENT_ID, 
        DECODE(GROUPING(JOB_ID), 1, '소계', JOB_ID) AS JOB_ID, 
        AVG(SALARY), 
        GROUPING(DEPARTMENT_ID) G,
        GROUPING(JOB_ID) GG
FROM EMPLOYEES
GROUP BY CUBE  (DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID;
-------------------------------------------------------------------------------
--연습문제
--
--문제 1.
--사원 테이블에서 JOB_ID별 사원 수, 월급의 평균울 구하세요. 월급의 평균 순으로 내림차순 정렬하세요.
--시원 테이블에서 JOB_ID별 가장 빠른 입사일을 구하세요.
SELECT JOB_ID, COUNT(*), AVG(SALARY), MIN(HIRE_DATE)
FROM EMPLOYEES
GROUP BY JOB_ID
ORDER BY AVG(SALARY) DESC, MIN(HIRE_DATE) DESC;

--문제 2.
--사원 테이블에서 입사 년도 별 사원 수를 구하세요.
SELECT CONCAT('20', TO_CHAR(HIRE_DATE, 'YY')) AS 입사년도, COUNT(*) AS "사원 수"
FROM EMPLOYEES
GROUP BY CONCAT('20', TO_CHAR(HIRE_DATE, 'YY'));

--문제 3.
--급여가 1000 이상인 사원들의 부서별 평균 급여를 출력하세요. 단 부서 평균 급여가 2000이상인 부서만 출력
SELECT DEPARTMENT_ID, AVG(SALARY)
FROM EMPLOYEES
WHERE SALARY >= 1000
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 2000;

--문제 3.
--부서아이디가 NULL이 아니고, 입사일은 05년도 인 사람들의 부서 급여평균과, 급여합계를 평균기준 내림차순 조회하세요.
----조건은 급여평균이 10000이상인 데이터만.
SELECT DEPARTMENT_ID, AVG(SALARY), SUM(SALARY)
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL AND HIRE_DATE LIKE '05%'
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 10000
ORDER BY AVG(SALARY) DESC;

--문제 4.
--사원 테이블에서 commission_pct(커미션) 컬럼이 null이 아닌 사람들의
--department_id(부서별) salary(월급)의 평균, 합계, count를 구합니다.
--조건 1) 월급의 평균은 커미션을 적용시킨 월급입니다.
--조건 2) 평균은 소수 2째 자리에서 절삭 하세요.
SELECT DEPARTMENT_ID AS 부서번호
        , TRUNC(AVG(SALARY),2) 월급평균
        , SUM(SALARY+SALARY*COMMISSION_PCT) 월급합계
        , COUNT(*) 인원수
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL
GROUP BY DEPARTMENT_ID;

--문제 5.
--부서아이디가 NULL이 아니고, 입사일은 05년도 인 사람들의 부서 급여평균과, 급여합계를 평균기준 내림차순합니다
--조건) 평균이 10000이상인 데이터만
SELECT DEPARTMENT_ID, AVG(SALARY) 급여평균, SUM(SALARY) 급여합계
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL AND HIRE_DATE LIKE '05%'
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 10000
ORDER BY AVG(SALARY) DESC;

--문제 6.
--직업별 월급합, 총합계를 출력하세요
SELECT DECODE(GROUPING(JOB_ID), 1, '총합계', JOB_ID) AS "직업",
        SUM(SALARY) 월급합
FROM EMPLOYEES
GROUP BY CUBE(JOB_ID)
ORDER BY JOB_ID;

--문제 7.
--부서별, JOB_ID를 그룹핑 하여 토탈, 합계를 출력하세요.
--GROUPING() 을 이용하여 소계 합계를 표현하세요
SELECT DECODE(GROUPING(DEPARTMENT_ID), 1, '합계', DEPARTMENT_ID) DEPARTMENT_ID, 
       DECODE(GROUPING(JOB_ID), 1, '소계', JOB_ID) JOB_ID, 
        COUNT(*) TOTAL, 
        SUM(SALARY) SUM
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID);  