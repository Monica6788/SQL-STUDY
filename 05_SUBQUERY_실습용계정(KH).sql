/*
    서브쿼리: 하나의 쿼리문 내에서 사용되는 또 다른 쿼리문
            메인 쿼리문의 조건이나 결과를 위해 먼저 실행되어 값을 제공 (보조 역할)
*/
-- 노옹철 직원과 같은 부서에 속한 직원 정보를 조회
-- 1) 노옹철 직원의 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';     --> D9

-- 2) 부서코드가 D9인 직원들의 정보 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 1), 2)를 하나로 합치기
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = (
        SELECT DEPT_CODE
        FROM EMPLOYEE
        WHERE EMP_NAME = '노옹철');

-- 전체 직원의 평균 급여보다 더 많은 급여를 받는 직원 정보를 조회
-- 1) 전체 직원의 평균 급여 조회
SELECT FLOOR(AVG(SALARY))
FROM EMPLOYEE;

-- 2) 평균 급여보다 더 많이 받는 직원 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE SALARY > 3047662;

-- 1), 2)를 하나로 합치기
SELECT *
FROM EMPLOYEE
WHERE SALARY > (
    SELECT AVG(SALARY)
    FROM EMPLOYEE);
------------------------------------------------------------------------------
/*
    서브쿼리의 종류
    : 서브쿼리를 수행한 결과의 "행"과 "열"의 수에 따라 분류
    
    1. 단일행 서브쿼리: 수행 결과가 오로지 1개 (1행 1열)
    2. 다중행 서브쿼리: 수행 결과가 여러 행 (N행 1열)
    3. 다중열 서브쿼리: 수행 결과가 1행이고 여러 개의 컬럼 (1행 N열)
    4. 다중행 다중열 서브쿼리: 수행 결과가 여러 행 여러 열 (N행 M열)
    
    => 종류에 따라 서브쿼리 앞에 사용되는 연산자가 달라질 수 있음!
*/

/*
    단일행 서브쿼리: 비교연산자 사용 가능! (=, !=, >, <,  >=, <=, ...)
*/
-- 최저 급여를 받는 직원의 이름, 급여, 입사일 조회
-- 1) 최저 급여 조회
SELECT MIN(SALARY)
FROM EMPLOYEE;  --> 1380000

-- 2) 최저 급여를 받는 직원 정보 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = 1380000;

-- 1), 2)를 합치기
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (
    SELECT MIN(SALARY)
    FROM EMPLOYEE);
-----------------------------------------------------------------------------
-- 노옹철 직원보다 급여를 더 많이 받는 직원 정보 조회 (이름, 부서코드, 급여)
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (
    SELECT SALARY
    FROM EMPLOYEE
    WHERE EMP_NAME = '노옹철');

-- 부서코드가 아닌 부서명을 조회
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE SALARY > (
    SELECT SALARY
    FROM EMPLOYEE
    WHERE EMP_NAME = '노옹철');

-- 부서별 급여합이 가장 큰 부서의 부서코드, 총급여 조회
-- 1) 부서별 급여 합의 최댓값
-- 1-1) 부서별 급여 합
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;
-- 1-2) 부서별 급여합의 최댓값
SELECT MAX(SUM(SALARY))  --> 17700000
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 2) 급여 합이 최대인 부서의 부서코드, 급여합 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (
    SELECT MAX(SUM(SALARY))
    FROM EMPLOYEE
    GROUP BY DEPT_CODE);


-- 전지연 직원과 같은 부서인 직원들의 직원번호, 직원명, 연락처, 입사일, 부서명을 조회
-- 단, 조회 결과에서 전지연 직원 정보는 제외
-- 1) 전지연 직원의 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '전지연';

-- 2) 1)의 쿼리문을 서브쿼리로 사용하여 같은 부서의 직원 정보 조회
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE EMP_NAME != '전지연' AND
    DEPT_CODE = (
       SELECT DEPT_CODE
       FROM EMPLOYEE
       WHERE EMP_NAME = '전지연');
-----------------------------------------------------------------------------
/*
    다중행 서브쿼리: 서브쿼리의 결과가 여러 행인 경우 (N행 1열)
    
    IN (서브쿼리): 여러 개의 결과값 중에서 하나라도 일치하는 값이 있다면 결과로 표시
    => 비교대상 = 결과값1 OR 비교대상 = 결과값2 OR ...
    
    > ANY (서브쿼리): 여러 개의 결과값 중에서 하나만이라도 이기면 결과로 표시
                    즉 MIN(서브쿼리의 결과값)보다만 크면 됨.
     => 비교대상 > 결과값1 OR 비교대상 > 결과값2 OR ...
    < ANY (서브쿼리): 여러 개의 결과값 중에서 하나만이라도 지면 결과로 표시
                    즉 MAX(서브쿼리의 결과값)보다만 작으면 됨.
     => 비교대상 < 결과값1 OR 비교대상 < 결과값2 OR ...
    
    > ALL (서브쿼리): 모든 결과값보다 크면 결과로 표시
                    즉 MAX(서브쿼리의 결과값)보다 커야 함.
    => 비교대상 > 결과값1 AND 비교대상 > 결과값2 AND ...
    < ALL (서브쿼리): 모든 결과값보다 작으면 결과로 표시
                    즉 MIN(서브쿼리의 결과값)보다 작아야 함.
    => 비교대상 < 결과값1 AND 비교대상 < 결과값2 AND ...
*/
-- 유재식 직원 또는 윤은해 직원과 같은 직급인 직원들의 정보 조회 (직원번호, 이름, 직급코드, 급여)
-- 1) 유재식 직원 또는 윤은해 직원의 직급 코드를 조회
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN ('유재식', '윤은해');
--> J3, J7

-- 2) 직급코드가 J3 또는 J7인 직원 정보 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN ('J3', 'J7');

-- 서브쿼리를 적용하여 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (
    SELECT JOB_cODE
    FROM EMPLOYEE
    WHERE EMP_NAME IN ('유재식', '윤은해')
);

-- 대리 직급 중 과장 직급 최소 급여보다 많이 받는 직원 정보 조회 (직원번호, 이름, 직급명, 급여)
-- 1) 과장 직급인 직원의 최소 급여 조회
SELECT SALARY
FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
ORDER BY 1;

-- 2) 대리 직급인 직원들 중 220만, 250만, 376만보다 많이 받는 직원 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리' AND
    SALARY > ANY (2200000, 2500000, 3760000)
ORDER BY 1;

-- 다중행 서브쿼리 적용
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리' AND
    SALARY > ANY (
        SELECT SALARY
        FROM EMPLOYEE
            JOIN JOB USING(JOB_CODE)
        WHERE JOB_NAME = '과장')
ORDER BY 1;

-- 단일행 서브쿼리 적용
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리' AND
    SALARY > (
        SELECT MIN(SALARY)
        FROM EMPLOYEE
            JOIN JOB USING(JOB_CODE)
        WHERE JOB_NAME = '과장')
ORDER BY 1;
------------------------------------------------------------------------------
/*
    다중열 서브쿼리: 서브쿼리의 결과가 한 행이고 여러 개의 컬럼(열)인 경우 (1행 N열)
    튜플 형식으로 비교
    
    (컬럼1, 컬럼2, ...) = (서브쿼리)
*/
-- 하이유 직원과 같은 부서, 같은 직급에 해당하는 직원 정보 조회 (이름, 부서코드, 직급코드, 급여)
-- 1) 하이유 직원이ㅡ 부서코드, 직급코드 조회
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '하이유';
--> D5, J5

-- 2) 부서코드가 D5, 직급코드가 J5인 직원 조회
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND
    JOB_CODE = 'J5'
ORDER BY 1;

-- 단일행 서브쿼리 적용 => 컬럼(열) 1개씩 조회하도록 쿼리문 작성
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = (
        SELECT DEPT_CODE
        FROM EMPLOYEE
        WHERE EMP_NAME = '하이유') AND
    JOB_CODE = (
        SELECT JOB_CODE
        FROM EMPLOYEE
        WHERE EMP_NAME = '하이유')
ORDER BY 1;

-- 다중열 서브쿼리
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (
    SELECT DEPT_CODE, JOB_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME = '하이유')
ORDER BY 1;

-- 박나라 직원과 같은 직급, 같은 사수를 가진 직원 정보 조회 (이름, 직급코드, 사수번호)
-- 1) 박나라 직원의 직급코드, 사수번호 조회
SELECT JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NAME = '박나라';
--> J7, 207

-- 2) 해당 직급코드와 사수번호가 동일한 직원 조회
SELECT EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NAME != '박나라' AND
    (JOB_CODE, MANAGER_ID) = (
        SELECT JOB_CODE, MANAGER_ID
        FROM EMPLOYEE
        WHERE EMP_NAME = '박나라')
ORDER BY 1;
-----------------------------------------------------------------------------
/*
    다중행 다중열 서브쿼리: 서브쿼리의 결과가 여러 행, 여러 열인 경우 (N행 M열)
*/
-- 각 직급별 최소 급여를 받는 직원 정보 조회 (사번, 이름, 직급코드, 급여)
-- 1) 직급별 최소 급여 조회
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 1;

-- 서브쿼리 적용
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (
    SELECT JOB_CODE, MIN(SALARY)
    FROM EMPLOYEE
    GROUP BY JOB_CODE)
ORDER BY 3;

-- 각 직급별 최고 급여를 받은 직원 정보 조회(사번, 이름, 직급코드, 급여)
-- 서브쿼리 적용
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (
    SELECT JOB_CODE, MAX(SALARY)
    FROM EMPLOYEE
    GROUP BY JOB_CODE)
ORDER BY 3;
------------------------------------------------------------------------------
/*
    인라인뷰: 서브쿼리를 FROM절에 작성하여 마치 테이블처럼 활용
            (서브쿼리의 결과를 임시 테이블처럼 활용)
*/
-- 직원들의 직원번호, 이름, 보너스 포함 연봉, 부서코드 조회
-- 보너스 포함 연봉이 3000만원 이상인 직원들만 조회
-- 보너스 포함 연봉 내림차순 정렬
SELECT EMP_ID, EMP_NAME,
        SALARY * 12 * (1 + NVL(BONUS, 0)) "보너스 포함 연봉", DEPT_CODE
FROM EMPLOYEE
WHERE SALARY * 12 * (1 + NVL(BONUS, 0)) >= 30000000
ORDER BY "보너스 포함 연봉" DESC;

-- 인라인 적용
SELECT EMP_ID, EMP_NAME, "보너스 포함 연봉", 부서코드
FROM (
    SELECT EMP_ID, EMP_NAME,
        SALARY * 12 * (1 + NVL(BONUS, 0)) "보너스 포함 연봉",
        DEPT_CODE 부서코드
    FROM EMPLOYEE
    ORDER BY 3 DESC)
WHERE "보너스 포함 연봉" >= 30000000;
-- FROM절에 작성한 서브쿼리의 결과가 임시테이블이 되므로 컬럼명을 일치시켜주어야 함.
-- 서브쿼리에서 DEPT_CODE에 부서코드라는 별칭을 부여했다면 메인 쿼리에서도 부서코드를 SELECT
-- 서브쿼리에 없는 컬럼명을 메인 쿼리에 적어도 안됨
-----------------------------------------------------------------------------
-- TOP-N 분석: 상위 N개를 조회
-- ROWNUM: 조회된 행에 대하여 순서대로 1부터 순번을 부여해주는 가상 컬럼

-- 월급 탑텐
SELECT ROWNUM, EMP_ID, EMP_NAME, SALARY
FROM (
    SELECT EMP_ID, EMP_NAME, SALARY
    FROM EMPLOYEE
    ORDER BY 2 DESC)
WHERE ROWNUM <= 10;

SELECT EMP_ID, EMP_NAME, "보너스 포함 연봉", 부서코드
FROM (
    SELECT EMP_ID, EMP_NAME,
        SALARY * 12 * (1 + NVL(BONUS, 0)) "보너스 포함 연봉",
        DEPT_CODE 부서코드
    FROM EMPLOYEE
    ORDER BY 3 DESC)
WHERE "보너스 포함 연봉" >= 30000000 AND
    ROWNUM <= 5;

-- 가장 최근에 입사한 직원 5명을 조회 (사번, 이름, 입사일)
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM (
    SELECT EMP_ID, EMP_NAME, HIRE_DATE
    FROM EMPLOYEE
    ORDER BY 3 DESC)
WHERE ROWNUM <= 5;
-----------------------------------------------------------------------------
/*
    순서를 매기는 함수 (윈도우 함수, WINDOW FUNCTION)
    
    1) RANK() OVER(정렬기준)
        : 동일한 순위 이후의 등수를 동일한 순위의 개수만큼 건너뛰고 순위 계산
        => 공동 1등 3명일 시 1등 1등 1등 4등
    2) DENSE_RANK() OVER(정렬기준)
        : 동일한 순위가 있더라도 그 다음 등수는 바로 다음 수로 순위 계산
        => 공동 1등 3명일 시 1등 1등 1등 2등
        
    => SELECT절에서만 사용 가능!
*/
-- 급여가 높은 순서대로 순위를 매겨서 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "급여 순위"
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) "급여 순위"
FROM EMPLOYEE;

-- 5위까지만 조회 (상위 5명)
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "급여 순위"
FROM EMPLOYEE;
-- WHERE "급여 순위" <= 5;
--> WHERE절에서 사용 불가! 왜냐하면 급여 순위는 SELECT절에서 정의한 별칭이니까~

SELECT *
FROM (
    SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "급여 순위"
    FROM EMPLOYEE)
WHERE "급여 순위" BETWEEN 3 AND 5;
-- 1등부터 조회할 수 있는 ROWNUM
-- 그와 달리 인라인뷰와 랭크오버 함수를 이용하면 원하는 범위의 순위 조회 가능.
------------------------------------------------------------------------------
-- [1] ROWNUM을 활용하여 급여가 가장 높은 5명을 조회하려고 했으나 제대로 조회되지 않았다
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5
ORDER BY SALARY DESC;

-- 문제점: ORDER BY절은 가장 마지막에 실행되므로 정렬기준과 상관없이 ROWNUM이 매겨진다.
--          즉 정렬기준에 맞지 않게 추출된 데이터 5개를 급여 내림차순으로 정렬하게 되어
--          원하는 방식대로 조회할 수 없다.
--      쌤 답) 정렬되기 전에 5명이 추려짐
-- 해결: 메인 쿼리의 WHERE절보다 ORDER BY가 먼저 실행되도록 FROM절 안에 서브쿼리에서 정렬한다.
--      쌤 답) 정렬을 먼저 한 후에 5명을 추려내야 함!
SELECT ROWNUM 급여순위, E.*
FROM (
    SELECT EMP_NAME, SALARY
    FROM EMPLOYEE
    ORDER BY 2 DESC) E
WHERE ROWNUM <= 5;

-- [2] 부서별 평균 급여가 270만원을 초과하는 부서에 해당하는 부서코드, 부서별 총 급여합, 부서별 평균급여,
--      부서별 직원 수를 조회하려고 했으나 제대로 조회가 되지 않았다.
SELECT DEPT_CODE, SUM(SALARY) 총합, FLOOR(AVG(SALARY)) 평균급여, COUNT(*) "직원 수"
FROM EMPLOYEE
WHERE SALARY > 2700000
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- 문제점: 해당 쿼리문에서는 부서별로 그룹화하지 않고 처음부터 급여가 270만원을 넘는 직원만 추출했다.
--      실행 순서는 WHERE절이 GROUP BY보다 먼저이므로 그룹화 한 후의 조건을 넣고 싶다면
--      HAVING절에 조건을 작성해야 한다.
--    쌤 답) 부서별 평균 급여가 아닌 각 직원의 급여를 기준으로 조건을 제시함!
-- 해결: 
SELECT DEPT_CODE, SUM(SALARY) 총합, FLOOR(AVG(SALARY)) 평균급여, COUNT(*) "직원 수"
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(SALARY)) > 2700000
ORDER BY DEPT_CODE;

-- 인라인 뷰 적용
SELECT *
FROM (
    SELECT DEPT_CODE, SUM(SALARY) 총합, FLOOR(AVG(SALARY)) 평균급여, COUNT(*) "직원 수"
    FROM EMPLOYEE
    GROUP BY DEPT_CODE)
WHERE 평균급여 > 2700000;














