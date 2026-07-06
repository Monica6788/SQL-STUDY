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



















