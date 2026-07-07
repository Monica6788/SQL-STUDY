/*
    GROUP BY절: 그룹 기준을 제시할 수 있는 구문
*/
-- 전체 직원의 급여 총합 조회
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- 부서별 급여 총합 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1;
-- 부서가 미배정인 직원들의 급여 합계는 (null)행으로 확인 가능

-- 부서별 직원 수 조회
SELECT DEPT_CODE 부서코드, COUNT(*) || '명' "직원 수"
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1;

-- 부서코드가 D6, D9, D1인 각 부서별 급여 총합, 직원 수 조회
SELECT DEPT_CODE 부서코드, TO_CHAR(SUM(SALARY), 'L99,999,999') 총급여,
        COUNT(*) || '명' "직원 수"
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D1', 'D6', 'D9')
GROUP BY DEPT_CODE
ORDER BY 1;

-- 직급별 총 직원 수, 보너스 받은 직원 수, 급여 총합, 평균 급여, 최저 급여, 최고 급여 조회 (직급코드 오름차순 정렬)
SELECT JOB_CODE 직급코드, COUNT(*) || '명' "총 직원 수",
        COUNT(BONUS) || '명' "보너스를 받는 직원 수",
        TO_CHAR(SUM(SALARY), '999,999,999') || '원' "급여 총합",
        TO_CHAR(TRUNC(AVG(SALARY)), '999,999,999') || '원' "평균 급여",
        MIN(SALARY) || '원' 최저급여, MAX(SALARY) || '원' 최고급여
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 1;

-- 부서 내 직급별로 직원 수, 급여 총합 조회
SELECT DEPT_CODE, JOB_CODE, COUNT(*) || '명' "직원 수",
        TO_CHAR(SUM(SALARY), '999,999,999') || '원' "급여 총합"
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY 1, 2;
-----------------------------------------------------------------------------
/*
    HAVING: 그룹에 대한 조건을 제시할 때 사용하는 구문
*/
-- 각 부서별 평균 급여가 300만원 이상인 부서만 조회
SELECT DEPT_CODE 부서코드, TO_CHAR(FLOOR(AVG(SALARY)), '999,999,999') || '원' 평균급여
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(SALARY)) >= 3000000
ORDER BY 1;
--> 부서별로 먼저 묶어 평균부터 구하고, 조건에 맞지 않는 그룹을 걸러낸다.

SELECT DEPT_CODE 부서코드, TO_CHAR(FLOOR(AVG(SALARY)), '999,999,999') || '원' 평균급여
FROM EMPLOYEE
WHERE SALARY >= 3000000
GROUP BY DEPT_CODE
ORDER BY 1;
--> 월급이 300만원 이상인 직원들만 그룹화한 것으로 위와 결과가 다름.

-- 직급별 급여 총합 조회 (급여 총합 >= 1000만 이상 직급만)
SELECT JOB_CODE 직급코드, TO_CHAR(SUM(SALARY), '999,999,999') || '원' 급여총합
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000
ORDER BY 1;

-- 보너스를 받는 직원이 없는 부서 정보 조회
SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0
ORDER BY 1;
------------------------------------------------------------------------------
/*
    ROLLUP, CUBE: 그룹 별 산출 결과 값의 집계 계산 함수
    
    ROLLUP: 전달 받은 그룹 중 가장 먼저 지정한 그룹 별로 추가적 집계 반환
    CUBE: 전달 받은 그룹들로 가능한 모든 조합 별로 집계 반환
    --> 전달 받은 그룹이 1개일 땐 별 차이가 없고, 2개 이상일 때에는 차이가 생김.
*/
-- 각 부서 내 직급별 급여 합, 부서별 급여 합, 전체 직원 급여 총합 조회
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY) "급여 총합"
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1;
-- D1 (null) 7820000이 D1부서의 부서별 급여 합.
-- (null) (null) 70096240이 전체 직원 급여 총합

-- (비교용) 전체 직원 급여 총합
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- (비교용) ROLLUP 없는 부분
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY) "급여 총합"
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY 1;

-- 부서별 급여 합, 직급별 급여 합, 부서 내 직급별 급여 합, 전체 지구언 급여 총합 조회
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY) "급여 총합"
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY) "급여 총합",
        CASE WHEN GROUPING(DEPT_CODE) = 0 AND GROUPING(JOB_CODE) = 1 THEN '부서별 합계'
             WHEN GROUPING(DEPT_CODE) = 1 AND GROUPING(JOB_CODE) = 0 THEN '직급별 합계'
             WHEN GROUPING(DEPT_CODE) = 1 AND GROUPING(JOB_CODE) = 1 THEN '총 합계'
             ELSE '그룹별 합계'
        END 구분
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;
-----------------------------------------------------------------------------
/*
    집합 연산자: 여러 개의 SQL문을 하나의 SQL문으로 만들어주는 연산자
    
    UNION: 합집합(두 SQL문의 결과를 더해줌) --> OR과 유사
    INTERSECT: 교집합(두 SQL문을 수행한 결과 중복되는 부분을 추출해줌) --> AND와 유사
    UNION ALL: 합집합 + 교집합(중복되는 데이터는 두 번 조회될 수 있음.)
    MINUS: 차집합(선행 결과에서 후행 결과를 뺀 나머지)
*/
-- UNION
-- 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원들의 정보 조회 (직원번호, 이름, 부서코드, 급여)
-- UNION 미사용
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY > 3000000;

-- UNION 사용
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- UNION ALL 사용
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- INTERSECT
-- INTERSECT 미사용
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY > 3000000;

-- INETERSECT 사용
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

/*
    집합 연산자 사용 시 주의 사항
    [1] SQL문들의 컬럼 개수가 동일해야 함
    [2] 컬럼 자리마다 동일한 타입으로 작성해야 함
    [3] 정렬하고자 한다면 ORDER BY절은 "마지막 쿼리문"에 작성해야 함.
*/


















