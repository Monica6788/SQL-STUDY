/*
    DDL(DATA DEFINITION LANGUAGE) = 데이터 정의어
    
    : 데이터베이스의 객체(테이블, 사용자, 뷰, 인덱스 등)의 구조를 정의하거나 변경, 삭제하는 명령어(SQL)
      실제 데이터 값이 아닌 구조(틀, 규칙)를 정의
*/
------------------------------------------------------------------------------
/*
    테이블 생성: CREATE TABLE
    
    CREATE TABLE 테이블명 (
        컬럼명 데이터타입,
        컬럼명 데이터타입 DEFAULT 기본값,
        컬럼명 데이터타입 제약조건,
        컬럼명 데이터타입 DEFAULT 기본값 제약조건
        ...
    );
    
    오라클 기본 자료형 (데이터타입)
    날짜: DATE (날짜 및 시간 데이터)
    숫자: NUMBER (숫자 데이터, 정수, 실수)
    문자: CHAR (고정 길이 문자열, 최대 2000바이트. 지정한 크기보다 작은 데이터 입력 시 공백으로 채워짐)
         VARCHAR2(가변 길이 문자열, 최대 4000바이트. 입력된 데이터의 실제 크기만큼만 공간을 차지하므로 효율적)
*/
-- 회원(MEMBER): 회원번호(MEM_NO), 회원아이디(MEM_ID), 회원비밀번호(MEM_PWD), 회원이름(MEM_NAME),
--              성별(GENDER), 연락처(PHONE), 이메일(EMAIL), 가입일시(ENROLLDATE)
CREATE TABLE MEMBER (
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3), -- '여' 또는 '남' (오라클에서는 한글 1자 당 3byte)
    PHONE CHAR(13),  -- '010-XXXX-XXXX'
    EMAIL VARCHAR2(40),
    ENROLLDATE DATE
);
-- 컬럼에 주석 추가
-- 테이블 구조의 각 컬럼이 무엇을 의미하는지 설명 추가
-- COMMENT ON COLUMN 테이블명.컬럼명 IS '설명 문구';

COMMENT ON COLUMN MEMBER.MEM_NO IS  '회원번호';
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEM_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS  '회원이름';
COMMENT ON COLUMN MEMBER.GENDER IS '성별';
COMMENT ON COLUMN MEMBER.PHONE IS '연락처';
COMMENT ON COLUMN MEMBER.EMAIL IS '이메일';
COMMENT ON COLUMN MEMBER.ENROLLDATE IS '가입일시';

-- 데이터 추가 (테스트)
INSERT INTO MEMBER VALUES(1, 'Dante', '1234', '단테', '남',
        '010-0000-0000', 'devilmaycry@gmail.com', SYSDATE);
INSERT INTO MEMBER VALUES(2, 'Vergil', '4444', '버질', '남',
        '010-1111-1111', 'burythelight@gmail.com', SYSDATE);
INSERT INTO MEMBER VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

COMMIT;     -- 변경사항 적용

SELECT *
FROM MEMBER;
------------------------------------------------------------------------------
/*
    제약조건: 테이블의 특정 컬럼에 부적절한 데이터가 들어오지 못하도록 설정하는 규칙
            데이터 무결성(정확성, 일관성, 신뢰성)을 보장하는 것이 목적.
            
    - 설정 방식
    [1] 컬럼 레벨 방식: 컬럼 정의 바로 옆에 제약조건을 기술하는 방식
                        모든 제약조건 설정 가능
    [2] 테이블 레벨 방식: 모든 컬럼 정의를 마친 후 하단에 별도로 기술하는 방식
                        NOT NULL 설정 불가능
*/
-----------------------------------------------------------------------------
/*
    NOT NULL 제약조건
    : 해당 컬럼에 NULL 값이 저장될 수 없도록 제한
      필수적으로 입력되어야 하는 데이터(ID, PW, 연락처 등)에 지정
    
    => 컬럼 레벨 방식으로만 지정 가능.
*/
-- 회원(MEMBER_NOTNULL): 회원번호(MEM_NO), 회원아이디(MEM_ID), 회원비밀번호(MEM_PWD), 회원이름(MEM_NAME)
--                      컬럼에 NOT NULL 제약조건 설정
CREATE TABLE MEMBER_NOTNULL (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE CHAR(13),
    EMAIL VARCHAR2(40),
    ENROLLDATE DATE
);

-- 데이터 추가
INSERT INTO MEMBER_NOTNULL VALUES(1, 'Dante', '1234', '단테', '남',
        '010-0000-0000', 'devilmaycry@gmail.com', SYSDATE);
INSERT INTO MEMBER_NOTNULL VALUES(2, 'Vergil', '4444', '버질', '남',
        '010-1111-1111', 'burythelight@gmail.com', SYSDATE);
INSERT INTO MEMBER_NOTNULL VALUES(3, 'NERO', '0123678131520', '네로', NULL, NULL, NULL, NULL);
COMMIT;

SELECT *
FROM MEMBER_NOTNULL;
------------------------------------------------------------------------------
/*
    UNIQUE 제약조건
    : 해당 컬럼에 중복된 데이터 값이 들어오는 것을 제한.
      고유해야 하는 데이터(주민번호, 아이디, 이메일 등)에 적용
    
    => NULL은 값이 없는 상태를 의미하므로, UNIQUE 조건이 있어도 여러 개 저장될 수 있다.
    
    보통 제약조건명을 지정하여 설정: 에러 발생 시 어떤 제약조건을 위배했는지 명확하게 파악하기 위함.
*/
-- 회원 (MEMBER_UNIQUE): 회원아이디(MEM_ID) UNIQUE 제약조건 설정
DROP TABLE MEMBER_UNIQUE;

CREATE TABLE MEMBER_UNIQUE (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE CHAR(13),
    EMAIL VARCHAR2(40),
    ENROLLDATE DATE,
    CONSTRAINT UNIQUE_MEM_ID UNIQUE(MEM_ID)
);

-- 데이터 추가
INSERT INTO MEMBER_UNIQUE VALUES(1, 'DEVILMAYCRY', '1234', 'DMC', '남',
        '010-0000-0000', 'devilmaycry@gmail.com', SYSDATE);
INSERT INTO MEMBER_UNIQUE VALUES(2, 'DEVILMAYCRY', '0000', '포르투나', '남',
        '010-0000-0000', 'devilmaycry@gmail.com', SYSDATE);

SELECT *
FROM MEMBER_UNIQUE;
-------------------------------------------------------------------------------
/*
    CHECK 제약조건
    : 해당 컬럼에 저장될 수 있는 값의 범위나 특정 조건식을 지정해주는 규칙
      조건식의 결과가 TRUE인 데이터만 저장할 수 있으며, NULL 값도 저장 가능!
*/
-- 회원(MEMBER_CHECK): 성별(GENDER) '남' 또는 '여' 값만 저장되도록 조건 지정
CREATE TABLE MEMBER_CHECK (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CONSTRAINT CHECK_GENDER CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(40),
    ENROLLDATE DATE,
    CONSTRAINT UNIQUE2_MEM_ID UNIQUE(MEM_ID)
);

-- 데이터 추가
INSERT INTO MEMBER_CHECK VALUES(1, 'Dante', '1234', '단테', '남',
        '010-0000-0000', 'devilmaycry@gmail.com', SYSDATE);
INSERT INTO MEMBER_CHECK VALUES(2, 'Vergil', '4444', '버질', NULL,
        '010-1111-1111', 'burythelight@gmail.com', SYSDATE);
INSERT INTO MEMBER_CHECK VALUES(3, 'V', '02', '브이', '2',
        '010-0000-0000', 'devilmaycry@gmail.com', SYSDATE);
-------------------------------------------------------------------------------
/*
    PRIMARY KEY (기본키) 제약조건
    : 테이블 내에서 각 행을 고유하게 식별하기 위해 사용하는 대표 컬럼을 지정
      NOT NULL + UNIQUE (NULL 값 비허용, 중복 불가)
      테이블당 오직 1개만 지정하여 설정할 수 있음!
*/
-- 회원(MEMBER_PRI): 회원번호(MEM_NO) 컬럼을 기본키로 지정
CREATE TABLE MEMBER_PRI (
    MEM_NO NUMBER NOT NULL CONSTRAINT PRI_MEM_NO PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CONSTRAINT CHECK2_GENDER CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(40),
    ENROLLDATE DATE,
    CONSTRAINT UNIQUE3_MEM_ID UNIQUE(MEM_ID)
);
-- 데이터 추가
INSERT INTO MEMBER_PRI VALUES(1, 'Dante', '1234', '단테', '남',
        '010-0000-0000', 'devilmaycry@gmail.com', SYSDATE);
INSERT INTO MEMBER_PRI VALUES(1, 'TonyRedgrave', '1234', '토니', '남',
        '010-0000-0000', 'devilmaycry@gmail.com', SYSDATE);
--> 기본키가 중복되어 추가할 수 없음.
INSERT INTO MEMBER_PRI VALUES(NULL, 'TonyRedgrave', '1234', '토니', '남',
        '010-0000-0000', 'devilmaycry@gmail.com', SYSDATE);
--> 기본키를 NULL로 설정하여 추가할 수 없음.
-----------------------------------------------------------------------------
/*
    복합키
    : 단일 컬럼만으로 기본키 역할을 부여하기 어려울 때
      두 개 이상의 컬럼을 결합하여 하나의 기본키로 지정
    => 테이블 레벨 방식으로만 설정 가능하다.
*/
CREATE TABLE MEMBER_PRI2 (
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CONSTRAINT CHECK3_GENDER CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(40),
    ENROLLDATE DATE,
    CONSTRAINT UNIQUE4_MEM_ID UNIQUE(MEM_ID),
    CONSTRAINT PRI2_PK_IDPHONE PRIMARY KEY(MEM_ID, PHONE)
);
-- 데이터 추가
INSERT INTO MEMBER_PRI2 VALUES('Dante', '1234', '단테', '남',
        '010-0000-0000', 'devilmaycry@gmail.com', SYSDATE);
INSERT INTO MEMBER_PRI2 VALUES('DanteSPARDA', '1234', '단테', '남',
        '010-0000-0000', 'devilmaycry@gmail.com', SYSDATE);
INSERT INTO MEMBER_PRI2 VALUES('TonyRedgrave', '1234', '토니', '남',
        '010-0000-0000', 'devilmaycry@gmail.com', SYSDATE);
--> 기본키가 중복되어 추가할 수 없음.
INSERT INTO MEMBER_PRI2 VALUES('TonyRedgrave', '1234', '토니', '남',
        '010-0000-0000', 'devilmaycry@gmail.com', SYSDATE);

SELECT *
FROM MEMBER_PRI2;
------------------------------------------------------------------------------
/*
    FOREIGN KEY (외래키) 제약조건
    : 다른 테이블에 존재하는 데이터 범위에서만 값을 저장하고자 할 때 설정하는 제약조건
      테이블 간의 관계에 따라 지정
    
    부모 테이블 (참조 대상): 테이블 내 PK 또는 UNIQUE 컬럼만 자식에게 제공할 수 있다.
    자식 테이블 (참조 주체): 외래키 제약조건을 가지고 부모 컬럼을 가리키는 역할을 한다.
*/
-- 부모 테이블: 회원 등급(MEMBER_GRADE)
-- 등급번호(GRADE_NO), 등급명(GRADE_NAME)
CREATE TABLE MEMBER_GRADE (
    GRADE_NO NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(20) NOT NULL
);

COMMENT ON COLUMN MEMBER_GRADE.GRADE_NO IS '등급번호';
COMMENT ON COLUMN MEMBER_GRADE.GRADE_NAME IS '등급명';

INSERT INTO MEMBER_GRADE VALUES(100, '일반');
INSERT INTO MEMBER_GRADE VALUES(200, 'VIP');
INSERT INTO MEMBER_GRADE VALUES(300, 'VVIP');

-- 자식 테이블: 회원(MEMBER_FRK)
CREATE TABLE MEMBER_FRK (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    ENROLLDATE DATE,
    GRADE_ID NUMBER REFERENCES MEMBER_GRADE(GRADE_NO)
);

COMMENT ON COLUMN MEMBER_FRK.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEMBER_FRK.GRADE_ID IS '등급키';

INSERT INTO MEMBER_FRK VALUES(1, 'DANTE', '1234', '단테', '남', SYSDATE, 100);
INSERT INTO MEMBER_FRK VALUES(2, 'TONY', '1234', '토니', '남', SYSDATE, 300);
INSERT INTO MEMBER_FRK VALUES(3, 'REDGRAVE', '1234', '레드그레이브', '남', SYSDATE, NULL);
--> 부모키 자리에 NULL은 추가 가능
INSERT INTO MEMBER_FRK VALUES(4, 'NERO', '1234', '네로', '남', SYSDATE, 1000);
--> 부모키 리스트에 없는 값을 넣는 것은 안됨!!!

SELECT F.*, GRADE_NAME
FROM MEMBER_FRK F
    JOIN MEMBER_GRADE ON GRADE_ID = GRADE_NO;














