-- ** KH_연습문제 **
-- 1. JOB 테이블의 모든 정보 조회
SELECT *
FROM JOB;

-- 2. JOB 테이블의 직급 이름 조회
SELECT JOB_NAME
FROM JOB;

-- 3. DEPARTMENT 테이블의 모든 정보 조회
SELECT *
FROM DEPARTMENT;

-- 4. EMPLOYEE테이블의 직원명, 이메일, 전화번호, 고용일 조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE
FROM EMPLOYEE;

-- 5. EMPLOYEE테이블의 고용일, 사원 이름, 월급 조회
SELECT HIRE_DATE, EMP_NAME, SALARY
FROM EMPLOYEE;

-- 6. EMPLOYEE테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총수령액 - (연봉*세금 3%)) 조회
SELECT EMP_NAME, SALARY * 12 연봉, SALARY * (12 + 12 * BONUS) "총수령액(보너스 포함)",
        (12 * BONUS + 11.64) * SALARY 실수령액
FROM EMPLOYEE;
            
-- 7. EMPLOYEE테이블에서 급여가 600만원 이상 1000만원 이하인 사원의 이름, 월급, 고용일, 연락처 조회
SELECT EMP_NAME, SALARY, HIRE_DATE, PHONE
FROM EMPLOYEE
WHERE SALARY BETWEEN 6000000 AND 10000000;
-- WHERE SALARY >= 6000000 AND SALARY <= 10000000;

-- 8. EMPLOYEE테이블에서 실수령액(6번 참고)이 5천만원 이상인 사원의 이름, 월급, 실수령액, 고용일 조회
SELECT EMP_NAME, SALARY, (12 * BONUS + 11.64) * SALARY 실수령액, HIRE_DATE
FROM EMPLOYEE
WHERE (12 * BONUS + 11.64) * SALARY >= 50000000;

-- 별칭은 WHERE절이 실행된 이후에 부여된 것이므로 WHERE절에서는 사용할 수 없음.

-- 9. EMPLOYEE테이블에 월급이 4000000이상이고 JOB_CODE가 J2인 사원의 전체 내용 조회
SELECT *
FROM EMPLOYEE
WHERE SALARY >= 4000000 AND JOB_CODE = 'J2';

-- 10. EMPLOYEE테이블에 DEPT_CODE가 D9이거나 D5인 사원 중 
--     고용일이 02년 1월 1일보다 빠른 사원의 이름, 부서코드, 고용일 조회
SELECT EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
-- WHERE (DEPT_CODE IN ('D5', 'D9') AND HIRE_DATE < '2002-01-01';
-- 2002-02-01 대신 02/02/01을 사용해도 됨.
WHERE (DEPT_CODE = 'D9' OR DEPT_CODE = 'D5') AND HIRE_DATE < '2002-01-01';

-- 11. EMPLOYEE테이블에 고용일이 90/01/01 ~ 01/01/01인 사원의 전체 내용을 조회
SELECT *
FROM EMPLOYEE
-- WHERE HIRE_DATE BETWEEN '1990-01-01' AND '2001-01-01';
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

-- 12. EMPLOYEE테이블에서 이름 끝이 '연'으로 끝나는 사원의 이름 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';

-- 13. EMPLOYEE테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE NOT (PHONE LIKE '010%');
-- WHERE NOT PHONE LIKE '010%';
-- WHERE PHONE NOT LIKE '010%';

-- 14. EMPLOYEE테이블에서 메일주소 '_'의 앞이 4자이면서 DEPT_CODE가 D9 또는 D6이고 
--     고용일이 90/01/01 ~ 00/12/01이고, 급여가 270만 이상인 사원의 전체를 조회
SELECT *
FROM EMPLOYEE
WHERE (EMAIL LIKE '____^_%' ESCAPE '^') AND (DEPT_CODE IN ('D6', 'D9'))
    AND (HIRE_DATE BETWEEN '1990-01-01' AND '2000-12-01')
    AND (SALARY >= 2700000);












