--단일 행 서브쿼리 : SELECT 결과가 1행인 서브쿼리
--서브쿼리는 ()로 묶는다. 연산자보다 오른쪽에 나온다.

SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Nancy';
--위 쿼리를 ()안에 넣어서 다른 쿼리의 WHERE절에 집어넣을 수 있다.
SELECT * FROM EMPLOYEES WHERE SALARY >= (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Nancy');

SELECT * FROM EMPLOYEES WHERE JOB_ID = (SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = '103');
-- 직원번호가 103인 사람과 직원번호가 같은 사람의 정보를 출력하기

--주의점 : 서브쿼리가 2개이상의 행을 반환하는 경우 에러 발생.
--이런 경우에는 일반 서브쿼리절에 넣을 수 없다. 다중 행 연산자를 써야 한다
SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David'; --3개의 튜플이 반환되어 에러 발생


-----------------------------------------------------------------------------------------------
--다중 행 서브쿼리

--   > ANY : 서브쿼리 내 결과 중 가장 작은값보다 큰지 검사 
SELECT * FROM EMPLOYEES WHERE SALARY > ANY(SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

--   < ANY : 서브쿼리 내 결과 중 가장 큰 값보다 작은지 검사 
SELECT * FROM EMPLOYEES WHERE SALARY < ANY(SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

--   > ALL : 서브쿼리 내 결과 중 가장 큰 값보다 큰지 검사 
SELECT * FROM EMPLOYEES WHERE SALARY > ALL(SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

--   < ALL : 서브쿼리 내 결과 중 가장 작은 값보다 작은지 검사 
SELECT * FROM EMPLOYEES WHERE SALARY < ALL(SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

-- IN : 다중쿼리값들 중 하나와 일치하는 데이터가 나온다.
SELECT * FROM EMPLOYEES WHERE SALARY IN (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');


-----------------------------------------------------------------------------------------------------------------------------
--연습문제 
--문제 1.
--EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들을 데이터를 출력 하세요 ( AVG(컬럼) 사용)
SELECT * FROM EMPLOYEES WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES);
--EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들을 수를 출력하세요
SELECT COUNT(*) FROM EMPLOYEES WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES);
--EMPLOYEES 테이블에서 job_id가 IT_PFOG인 사원들의 평균급여보다 높은 사원들을 데이터를 출력하세요.
SELECT * FROM EMPLOYEES WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG');
SELECT AVG(SALARY) FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG';

--문제 2.
--DEPARTMENTS테이블에서 manager_id가 100인 사람의 department_id(부서아이디) 와
--EMPLOYEES테이블에서 department_id(부서아이디) 가 일치하는 모든 사원의 정보를 검색하세요.
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE MANAGER_ID = '100');

--문제 3.
--EMPLOYEES테이블에서 “Pat”의 manager_id보다 높은 manager_id를 갖는 모든 사원의 데이터를 출력하세요
SELECT * FROM EMPLOYEES WHERE MANAGER_ID > (SELECT MANAGER_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Pat');
--EMPLOYEES테이블에서 “James”(2명)들의 manager_id와 같은 모든 사원의 데이터를 출력하세요.
SELECT * FROM EMPLOYEES WHERE MANAGER_ID IN (SELECT MANAGER_ID FROM EMPLOYEES WHERE FIRST_NAME = 'James');
--Steven과 동일한 부서에 있는 사람들을 출력해주세요.
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Steven');
--Steven의 급여보다 많은 급여를 받는 사람들은 출력하세요.
SELECT * FROM EMPLOYEES WHERE SALARY > ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Steven');
SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Steven';

--------------------------------------------------------------------------------------------------------------
--스칼라 서브쿼리: SELECT 절에 들어가는 서브쿼리, 조인을 대체할 수 있다.
SELECT FIRST_NAME, (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID)
FROM EMPLOYEES E;
--조인 구문으로 쓰면
SELECT FIRST_NAME, DEPARTMENT_NAME FROM EMPLOYEES E LEFT JOIN DEPARTMENTS D ON D.DEPARTMENT_ID = E.DEPARTMENT_ID;
--쿼리 날리고 F10 누르면 소요량을 볼수가 있음.

SELECT FIRST_NAME, 
        (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) AS 부서명
FROM EMPLOYEES E;
--스칼라 서브쿼리는 한번에 하나의 컬럼을 가지고 오기 때문에 많은 열을 가지고 오게 되면 가독성이 떨어질 수 있다.
SELECT FIRST_NAME, 
        (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID),
        (SELECT MANAGER_ID FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID)
FROM EMPLOYEES E;
--스칼라 서브쿼리는 다른 테이블로 한 개의 컬럼만 가지고 올 때 활용성이 높다
-- 회원별로 JOBS 테이블의 TITLE을 가지고 오고, 부서테이블의 부서명을 조회하는 경우 등.
SELECT FIRST_NAME, 
        (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) 부서명,
        (SELECT JOB_TITLE FROM JOBS J WHERE J.JOB_ID = E.JOB_ID) 직위
FROM EMPLOYEES E;

--------------------------------------------------------------------------------------------------
--연습문제
--문제 4.
--EMPLOYEES테이블 DEPARTMENTS테이블을 left 조인하세요
--조건) 직원아이디, 이름(성, 이름), 부서아이디, 부서명 만 출력합니다.
--조건) 직원아이디 기준 오름차순 정렬
SELECT E.EMPLOYEE_ID AS 직원아이디, 
        E.FIRST_NAME||' '||E.LAST_NAME AS 이름, 
        E.DEPARTMENT_ID AS 부서아이디, 
        D.DEPARTMENT_NAME AS 부서명
FROM EMPLOYEES E LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY E.EMPLOYEE_ID;

--문제 5.
--문제 4의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
SELECT E.EMPLOYEE_ID AS 직원아이디, 
        E.FIRST_NAME||' '||E.LAST_NAME AS 이름, 
        E.DEPARTMENT_ID AS 부서아이디, 
        (SELECT D.DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) AS 부서명
FROM EMPLOYEES E ORDER BY E.EMPLOYEE_ID;



--문제 6.
--DEPARTMENTS테이블 LOCATIONS테이블을 left 조인하세요
--조건) 부서아이디, 부서이름, 스트릿_어드레스, 시티 만 출력합니다
--조건) 부서아이디 기준 오름차순 정렬

SELECT * FROM DEPARTMENTS;
SELECT * FROM LOCATIONS;

SELECT D.DEPARTMENT_ID AS 부서아이디,
        D.DEPARTMENT_NAME AS 부서이름,
        L.STREET_ADDRESS AS 주소,
        L.CITY AS 도시명
FROM DEPARTMENTS D LEFT JOIN LOCATIONS L
ON D.LOCATION_ID = L.LOCATION_ID
ORDER BY D.DEPARTMENT_ID;

--문제 7.
--문제 6의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
SELECT D.DEPARTMENT_ID AS 부서아이디,
        D.DEPARTMENT_NAME AS 부서이름,
        (SELECT L.STREET_ADDRESS AS 주소 FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID) 주소,
        (SELECT L.CITY AS 도시 FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID) 도시명
FROM DEPARTMENTS D
ORDER BY D.DEPARTMENT_ID;

--문제 8.
--LOCATIONS테이블 COUNTRIES테이블을 스칼라 쿼리로 조회하세요.
--조건) 로케이션아이디, 주소, 시티, country_id, country_name 만 출력합니다 -- L,L,L,L,C
--조건) country_name기준 오름차순 정렬
SELECT * FROM LOCATIONS;
SELECT * FROM COUNTRIES;

SELECT L.LOCATION_ID AS 지역아이디
        , L.STREET_ADDRESS AS 주소
        , L.CITY AS 도시
        , L.COUNTRY_ID 국가아이디
        , (SELECT C.COUNTRY_NAME FROM COUNTRIES C WHERE C.COUNTRY_ID = L.COUNTRY_ID) 국가명
FROM LOCATIONS L
ORDER BY 국가명;

------------------------------------------------------------------------------------------
--인라인 뷰 : FROM절 하위에 서브쿼리가 들어간다.
--SELECT 절에서 만든 가상 컬럼에 대해 조회해 나갈 때 사용

SELECT * 
FROM (SELECT * 
      FROM EMPLOYEES);
      
--ROWNUM은 조회된 순서에 대해서 번호가 붙기 때문에 ORDER BY를 하면 순서가 뒤바뀐다.
SELECT ROWNUM, EMPLOYEE_ID, FIRST_NAME, SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC;

--인라인뷰
SELECT ROWNUM, EMPLOYEE_ID, FIRST_NAME, SALARY FROM (SELECT * FROM EMPLOYEES ORDER BY SALARY DESC)
WHERE ROWNUM > 0 AND ROWNUM < 10;

--인라인 뷰로 SELECT 절에 필요한 컬럼들을 가상테이블로 만들어 놓은 후 그 내부에서 결과를 조회
SELECT * FROM (SELECT ROWNUM AS RN,
        FIRST_NAME||' '||LAST_NAME AS NAME,
        SALARY
FROM (SELECT * FROM EMPLOYEES ORDER BY SALARY DESC))
WHERE RN >10 AND RN<=20;

--인라인 뷰에서도 TABLE ALIAS를 사용 가능하다.
--인라인 뷰 EX
--근속년수 컬럼, 커미션이 더해진 급여 컬럼을 가상으로 만들고 다시 조회하기
SELECT * 
FROM( SELECT FIRST_NAME||' '||LAST_NAME AS 이름,
        TRUNC((SY SDATE-HIRE_DATE)/365) AS 근속년수,
        SALARY+SALARY*NVL(COMMISSION_PCT,0) AS 급여
FROM EMPLOYEES
ORDER BY 근속년수);

-------------------------------------------------------------------------------
--연습문제
--문제 9.
--EMPLOYEES테이블 에서 first_name기준으로 내림차순 정렬하고, 41~50번째 데이터의 행 번호, 이름을 출력하세요

SELECT * FROM(SELECT ROWNUM AS R, A.* FROM (SELECT * FROM EMPLOYEES ORDER BY FIRST_NAME DESC) A)
WHERE R > 40 AND R <51;

--문제 11.
--COMMITSSION을 적용한 급여를 새로운 컬럼으로 만들고, 이 데이터에서 10000보다 큰 사람들을 뽑아 보세요. (인라인뷰를 쓰면 됩니다)
SELECT * FROM(SELECT SALARY+SALARY*NVL(COMMISSION_PCT,0) AS 급여, E.* FROM EMPLOYEES E)
WHERE 급여 > 10000;

--문제 12.
--조인의 최적화
--SELECT CONCAT(FIRST_NAME, LAST_NAME) AS NAME,
--       D.DEPARTMENT_ID
--FROM EMPLOYEES E
--JOIN DEPARTMENTS D
--ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
--WHERE EMPLOYEE_ID = 200;
--
--이론적으로 위 구문의 실행방식은 EMPLOYEES - DEPARTMENTS 테이블을 먼저 조인하고, 후에 WHERE조건을 실행하게 됩니다.
--항상 이런것은 아닙니다. (이것은 데이터베이스 검색엔진(옵티마이저)에 의 해 바뀔 수도 있습니다)
--그렇다면 SUBQUERY절로 WHERE구문을 작성하고, JOIN을 붙이는 것도 가능하지 않을까요?
--
--=> 부서아이디가 200인 데이터를 인라인뷰로 조회한 후에 JOIN을 붙여보세요.
SELECT CONCAT(E.FIRST_NAME, E.LAST_NAME) AS NAME, E.DEPARTMENT_ID
FROM (SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = '200') A INNER JOIN EMPLOYEES E
ON E.EMPLOYEE_ID = A.EMPLOYEE_ID;


--문제13
--EMPLOYEES테이블, DEPARTMENTS 테이블을 left조인하여, 입사일 오름차순 기준으로 10-20번째 데이터만 출력합니다.
--조건) rownum을 적용하여 번호, 직원아이디, 이름, 입사일, 부서이름 을 출력합니다.
--조건) hire_date를 기준으로 오름차순 정렬 되어야 합니다. rownum이 망가지면 안되요.
SELECT *
FROM(SELECT ROWNUM AS 번호, 
            EMPLOYEE_ID AS 직원아이디, 
            FIRST_NAME||' '||LAST_NAME AS 이름, 
            HIRE_DATE AS 입사일,
            DEPARTMENT_NAME AS 부서이름
    FROM(SELECT * FROM EMPLOYEES E LEFT JOIN DEPARTMENTS D 
        ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
        ORDER BY HIRE_DATE))
WHERE 번호>9 AND 번호<21;

SELECT * FROM EMPLOYEES;

--문제14
--SA_MAN 사원의 급여 내림차순 기준으로 ROWNUM을 붙여주세요.
--조건) SA_MAN 사원들의 ROWNUM, 이름, 급여, 부서아이디, 부서명을 출력하세요.
SELECT * 
FROM(SELECT ROWNUM AS ROUNUM, 
            FIRST_NAME||' '||LAST_NAME AS 이름,
            SALARY AS 급여,
            DEPARTMENT_ID AS 부서아이디,
            부서명
    FROM(SELECT (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D
                WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) AS 부서명
            , E.*
            FROM EMPLOYEES E
            WHERE JOB_ID = 'SA_MAN'
            ORDER BY SALARY DESC));


--문제15
--DEPARTMENTS테이블에서 각 부서의 부서명, 매니저아이디, 부서에 속한 인원수 를 출력하세요.
--조건) 인원수 기준 내림차순 정렬하세요.
--조건) 사람이 없는 부서는 출력하지 뽑지 않습니다.
--힌트) 부서의 인원수 먼저 구한다. 이 테이블을 조인한다.
SELECT DEPARTMENT_NAME AS 부서명,
        MANAGER_ID AS 매니저아이디,
        부서인원수
FROM DEPARTMENTS D
INNER JOIN (SELECT COUNT(*) AS 부서인원수, 
        DEPARTMENT_ID 
FROM EMPLOYEES GROUP BY DEPARTMENT_ID 
HAVING DEPARTMENT_ID IS NOT NULL) A
ON D.DEPARTMENT_ID = A.DEPARTMENT_ID
ORDER BY 부서인원수 DESC;

--문제16
--부서에 모든 컬럼, 주소, 우편번호, 부서별 평균 연봉을 구해서 출력하세요.
--조건) 부서별 평균이 없으면 0으로 출력하세요
--DEPARTMENTS는 부서이름, 매니저아이디, LOCATION_ID만 있음
--LOCATIONS는 LOCATION_ID, STREET_ADDRESS, POSTAL_CODE 있음
--EMPLOYEES에서 평균연봉 구해야 함

--조인을 두번 해서 구해도 됨. 보니까 스칼라쿼리 넣은 뷰를 조인시킨 다음에 그걸 또 뷰로 만드는 경우
--뷰에 알리아스를 쓸수가 없음. 처음에는 자원소비를 줄이려고 스칼라쿼리 썼는데 그러면 sql문이 길어짐
--예쁘게 작성하는건 아무도 신경안쓰는거같지만 어쨌든 짧게 하려면 그냥 조인2번이 나은듯

SELECT 부서이름, 
        매니저아이디, 
        STREET_ADDRESS AS 주소, 
        POSTAL_CODE AS 우편번호, 
        NVL("연봉",0) AS "부서별 평균 연봉"
FROM LOCATIONS L
LEFT JOIN(SELECT DEPARTMENT_ID,
            DEPARTMENT_NAME AS 부서이름,
            MANAGER_ID AS 매니저아이디,
            LOCATION_ID,
            (SELECT TRUNC(NVL(AVG(SALARY),0),-2) 
            FROM EMPLOYEES E
            WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
            GROUP BY DEPARTMENT_ID) AS "연봉"
        FROM DEPARTMENTS D) A
ON L.LOCATION_ID = A.LOCATION_ID
WHERE 부서이름 IS NOT NULL;









--문제17
--문제 16결과에 대해 DEPARTMENT_ID기준으로 내림차순 정렬해서 ROWNUM을 붙여 1-10데이터 까지만
--출력하세요
SELECT * 
FROM(SELECT ROWNUM AS RN,
            부서이름,
            매니저아이디,
            주소,
            우편번호,
            "부서별 평균 연봉"
    FROM (SELECT 부서이름, 
            매니저아이디, 
            STREET_ADDRESS AS 주소, 
            POSTAL_CODE AS 우편번호, 
            NVL("연봉",0) AS "부서별 평균 연봉"
            FROM LOCATIONS L
            LEFT JOIN(SELECT DEPARTMENT_ID,
                DEPARTMENT_NAME AS 부서이름,
                MANAGER_ID AS 매니저아이디,
                LOCATION_ID,
                (SELECT TRUNC(NVL(AVG(SALARY),0),-2) 
                FROM EMPLOYEES E
                WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
                GROUP BY DEPARTMENT_ID) AS "연봉"
            FROM DEPARTMENTS D) A
            ON L.LOCATION_ID = A.LOCATION_ID
        WHERE 부서이름 IS NOT NULL
    )
)
WHERE RN >=1 AND RN<11;