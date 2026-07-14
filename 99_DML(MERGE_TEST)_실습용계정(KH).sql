-- DML 중 MERGE는 과연 트랜잭션 처리가 필요한지 확인
CREATE TABLE TB_TEST
AS SELECT * FROM EMPLOYEE;

CREATE TABLE TB_EMP 
AS SELECT * FROM EMPLOYEE;

INSERT INTO TB_EMP(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, SALARY)
    VALUES (500, '테스트', '060714-3000000', 'J2', 2000000);

COMMIT;

SELECT COUNT(*) FROM TB_TEST;   -- 25행
SELECT COUNT(*) FROM TB_EMP;    -- 26행

MERGE INTO TB_TEST T
USING TB_EMP E
ON (T.EMP_ID = E.EMP_ID)
WHEN MATCHED THEN       -- 일치하는 데이터가 있을 때는 업데이트!
    UPDATE SET T.SALARY = E.SALARY,
            T.BONUS = E.BONUS
WHEN NOT MATCHED THEN   -- 일치하는 데이터가 없을 때는 추가!
    INSERT (T.EMP_ID, T.EMP_NO, T.EMP_NAME, T.JOB_CODE, T.SALARY)
    VALUES (E.EMP_ID, E.EMP_NO, E.EMP_NAME, E.JOB_CODE, E.SALARY);
-- 두 테이블 모두 COUNT(*) 결과 26행

ROLLBACK;
-- ROLLBACK 이후 TB_TEST 테이블의 COUNT(*) 결과는 다시 25행
--> <결론> MERGE 명령어도 트랜잭션 처리가 필요하다!
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    