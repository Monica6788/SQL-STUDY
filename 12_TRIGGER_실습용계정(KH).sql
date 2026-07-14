/*
    트리거 (TRIGGER)
    : 특정 테이블의 DML(INSERT, UPDATE, DELETE)문에 의해 변경사항이 발생했을 때
      (이벤트가 발생했을 때) 자동으로 매번 실행할 내용을 미리 정의해두는 객체
      
    * 종류 *
    [1] 실행 시기에 따른 분류
        - BEFORE TRIGGER: 테이블의 데이터가 "바뀌기 전"에 트리거 실행
                          (데이터 검증용)
        - AFTER TRIGGER: 테이블의 데이터가 "바뀐 후"에 실행
                         (대부분 비즈니스 로직 처리용)
    [2] 영향을 받는 행에 따른 분류
        - 문장 트리거: SQL문이 실행될 때 딱 "한 번"만 트리거 실행
        - 행 트리거: SQL문에 의해 영향을 받는 행의 개수만큼 "매번" 트리거 실행
                => 반드시 FOR EACH ROW 옵션 작성
    
    * 가상 변수(의사 레코드) *
        - :OLD 변경 전 데이터(UPDATE(수정), DELETE(삭제) 전 데이터)
        - :NEW 변경 후 데이터(INSERT(추가), UPDATE(수정) 후 데이터)
*/
-------------------------------------------------------------------------------
/*
    트리거 생성
    
    CREATE[ OR REPLACE] TRIGGER 트리거명
    BEFORE | AFTER
    INSERT | UPDATE | DELETE ON 테이블명
    [FOR EACH ROW]                          -- 행 트리거 옵션
    -- PL/SQL 구문
    [DECLARE]
    BEGIN
    [EXCEPTION]
    END;
    /
*/
-------------------------------------------------------------------------------
-- EMPLOYEE 테이블에 데이터가 추가된 후에 작동하는 행 트리거 생성
-- 동작할 내용: 'XXX님 환영합니다 ^^' 출력

CREATE OR REPLACE TRIGGER TRG_WELCOME
AFTER INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE(:NEW.EMP_NAME||'님 환영합니다 ^^');
END;
/
-- 트리거 동작 확인 => 이벤트 발생시키기 (EMPLOYEE 테이블에 데이터 추가)
INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
    VALUES (SEQ_ENO, '은하제', '060714-4271828', 'J6', SYSDATE);

SELECT * FROM USER_SEQUENCES;





































