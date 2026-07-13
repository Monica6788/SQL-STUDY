/*
    SEQUENCE(시퀀스)
    : 자동으로 번호를 발생시켜주는 객체
    정수를 순차적으로 일정한 값마다 증가시키며 생성
    
    => 등차수열 생성기!!!
    EX) 사번, 회원번호, 도서번호, ... 
        -> 중복되면 안 되는 기본키(PRIMARY KEY) 컬럼에 주로 사용
*/
-------------------------------------------------------------------------------
/*
    시퀀스 생성
    
    CREATE SEQUENCE 시퀀스명
    [START WITH 시작번호]    -- 초항 (생략 시 기본값 1)
    [INCREMENT BY 증감값]    -- 공차 지정 (생략 시 기본값 1)
    [MAXVALUE 최댓값]        -- 최댓값 (생략 시 기본값 무한에 가까운 느낌)
    [MINVALUE 최솟값]        -- 최솟값 (생략 시 기본값 1 / 증가하는 시퀀스라는 전제 하에]
    [CYCLE | NOCYCLE]       -- 값의 순환 여부 (기본값 NOCYCLE)
                                CYCLE: 최댓값 도달 시 최솟값부터 다시 시작 (초항 말고 최솟값!)
                                NOCYCLE: 최댓값 도달 시 더 이상 증가 없이 오류 발생
    [NOCACHE | CACHE 숫자]   -- 캐시 메모리 할당 여부 (기본값 CACHE 20)
                                CACHE: 번호를 미리 메모리에 "숫자"만큼 만들어 둔다 (속도 빠름)
                                    주의: 컴퓨터 비정상종료 시 메모리에 있던 번호 날라감
                                        => 번호 건너뛰기 현상(Gap) 발생 가능!
                                NOCACHE: 필요할 때마다 그때그때 번호를 생성 (결제, 주문번호 등)
    
    
    [참고] 이름 규칙(관례)
    - 테이블: TB_XXX (OR TBL_XXX)
    - 뷰: VW_XXX
    - 시퀀스: SEQ_XXX
    - 트리거: TRG_XXX
*/
-- 기본값으로 시퀀스를 생성: SEQ_TEST
CREATE SEQUENCE SEQ_TEST;

-- 현재 계정에 생성된 시퀀스 목록 조회
SELECT * FROM USER_SEQUENCES;

-- SEQ_EMPNO 시퀀스 생성
-- 시작번호 300 증가값 5 최댓값 310 순환 X 캐시메모리 X
CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;
-------------------------------------------------------------------------------
/*
    시퀀스 사용
    
    - 시퀀스명.NEXTVAL: 다음 시퀀스 값(다음 항) 가져오기 (호출할 때마다 값 증가)
    - 시퀀스명.CURRVAL: 현재 시퀀스 값 확인 (마지막으로 성공한 NEXTVAL의 결과값)
*/
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;
--> NEXTVAL을 한 번도 수행하지 않은 상태로 CURRVAL 사용 시 에러 발생
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; --> 300
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; --> 300

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; --> 305
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; --> 310

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;
--> 오류 발생! 최댓값 310을 초과할 수 없음 (NOCYCLE 옵션으로 생성했기 때문에)
-------------------------------------------------------------------------------
/*
    시퀀스 변경
    
    ALTER SEQUENCE 시퀀스명
    [INCREMENT BY 변경할값]
    [MAXVALUE 변경할값]
    [MINVALUE 변경할값]
    [CYCLE | NOCYCLE]
    [NOCACHE | CACHE 숫자];
    
    => START WITH (시작값)은 변경할 수 없음!
       변경하고 싶으면 제거(DROP)한 후 다시 생성(CREATE)해야 함.
*/
-- SEQ_EMPNO 시퀀스의 증가값을 10 최댓값을 400으로 변경
ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;

SELECT SEQ_EMPNO.CURRVAL FROM DUAL;     -- 현재값 확인(310)
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;     -- 320
-------------------------------------------------------------------------------
/*
    시퀀스 삭제
    
    DROP SEQUENCE 시퀀스명
*/
-- SEQ_EMPNO 시퀀스 삭제
DROP SEQUENCE SEQ_EMPNO;

SELECT * FROM USER_SEQUENCES;
-------------------------------------------------------------------------------
-- 직원번호용 시퀀스 생성 (300번부터 시작, 1씩 증가, 캐시 사용 안함) SEQ_ENO
DROP SEQUENCE SEQ_ENO;

CREATE SEQUENCE SEQ_ENO
START WITH 300
--INCREMENT BY 1
NOCACHE;
-- 데이터 추가 시 사용 => 직원번호 컬럼에 사용
DELETE FROM EMPLOYEE WHERE EMP_ID = '300';
INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
    VALUES (SEQ_ENO.NEXTVAL, 'DANTE', '010713-3124555', 'J6', SYSDATE);
--> 300번 직원번호가 저장됨
INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
    VALUES (SEQ_ENO.NEXTVAL, 'TRISH', '010713-4123456', 'J6', SYSDATE);
--> 301번 직원번호가 저장됨

SELECT * FROM EMPLOYEE;
ROLLBACK;       --> 300, 301번 직원 정보가 지워짐(취소)

INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
    VALUES (SEQ_ENO.NEXTVAL, 'NERO', '070707-3444555', 'J6', SYSDATE);
--> ROLLBACK과 상관 없이 이미 증가된 시퀀스 번호가 반영되어 302번으로 저장됨

ROLLBACK;























