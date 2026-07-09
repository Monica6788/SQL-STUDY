-- * KH_연습 문제 *
-- * 연습용 계정 생성 후 아래 문제를 풀어봅시다 *
-- * 계정 정보 : C##TEST / TEST *
-- 1. 부서 정보를 저장하기 위한 TB_DEPT 테이블을 생성
--    컬럼: DEPT_CD(숫자, 기본키), DEPT_NAME(가변문자 30자, NOT NULL)
CREATE TABLE TB_DEPT (
    DEPT_CD NUMBER PRIMARY KEY,
    DEPT_NAME VARCHAR2(30) NOT NULL);

-- 2. 사원 정보를 저장하기 위한 TB_EMP 테이블을 생성
--    컬럼: EMP_NO(숫자, 기본키), EMP_NAME(가변문자 20자, NOT NULL)
--          GENDER(고정문자 1자, 'M' 또는 'F'만 허용하도록 CHECK 제약조건 설정)
--          DEPT_CD(숫자, TB_DEPT 테이블의 DEPT_CD 컬럼을 참조하는 외래키 설정)
CREATE TABLE TB_EMP (
    EMP_NO NUMBER PRIMARY KEY,
    EMP_NAME VARCHAR(20) NOT NULL,
    GENDER CHAR(1) CHECK(GENDER IN ('M', 'F')),
    DEPT_CD NUMBER REFERENCES TB_DEPT(DEPT_CD)
);


-- 3. TB_EMP 테이블에 연락처를 저장하기 위해 PHONE 컬럼 추가 (가변문자 15자)
ALTER TABLE TB_EMP ADD (PHONE VARCHAR2(15));

-- 4. TB_EMP 테이블의 EMP_NAME 컬럼의 크기를 가변문자 50자로 늘리고, NOT NULL 조건을 유지하도록 수정
ALTER TABLE TB_EMP MODIFY EMP_NAME VARCHAR2(50);

-- 5. TB_EMP 테이블의 PHONE 컬럼명을 CONTACT로 변경
ALTER TABLE TB_EMP RENAME COLUMN PHONE TO CONTACT;

-- 6. TB_EMP 테이블의 CONTACT 컬럼에 중복된 값이 들어가지 못하도록 UNIQUE 제약조건 설정
ALTER TABLE TB_EMP ADD CONSTRAINT UQ_EMP UNIQUE(CONTACT);

-- 7. TB_EMP 테이블의 GENDER 컬럼에 기본값으로 'M'이 들어가도록 설정
ALTER TABLE TB_EMP MODIFY GENDER CHAR(1) DEFAULT 'M';

-- 8. TB_EMP, TB_DEPT 테이블 삭제
DROP TABLE TB_EMP;
DROP TABLE TB_DEPT;