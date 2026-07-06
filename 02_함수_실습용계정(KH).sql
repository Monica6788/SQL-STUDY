/*
    함수(FUCTION): 전달된 값(컬럼값)을 실행한 결과를 반환
                (메서드와 비슷한 것. 당연함. 메서드가 자바의 함수였음.)
    단일 행 함수: N개의 값을 읽어서 N개의 결과값으로 반환
                => 행마다 함수의 실행한 결과를 반환
                => 일변수함수(단변수함수).
    그룹 함수: N개의 값을 읽어서 1개의 결과값으로 반환
            => 그룹을 지어 그룹 별로 함수의 결과를 반환
            => 즉, 다변수함수
    => 함수식을 사용할 수 있는 위치: SELECT절, WHERE절, ORDER BY 절, GROUP BY절, HAVING절
        (FROM절 빼고 다!!!!)
    => SELECT절에 단일 행 함수와 그룹 함수를 함께 사용할 수 없음.
*/

-- =========================== 단일 행 함수 ==================================
/*
    문자 타입의 데이터 처리 함수
    - 문자 타입: CHAR, VARCHAR2
    - LENGTH(값): 값의 길이를 반환 (글자 수 반환)
    - LENGTHB(값): 값의 바이트 수를 반환
    
    => 영문자, 숫자, 특수문자는 글자당 1BYTE, 한글은 3BYTE
*/
-- '오라클'이라는 단어의 글자 수, 바이트 수를 확인
SELECT LENGTH('오라클') "글자 수", LENGTHB('오라클')"바이트 수"
FROM DUAL;

SELECT LENGTH('ORACLE') "글자 수", LENGTHB('ORACLE')"바이트 수"
FROM DUAL;

-- 직원명, 직원명(글자수), 직원명(바이트 수), 이메일, 이메일(글자수), 이메일(바이트수) 조회
SELECT EMP_NAME, LENGTH(EMP_NAME) "직원명(글자 수)", LENGTHB(EMP_NAME)"직원명(바이트 수)",
            EMAIL, LENGTH(EMAIL) "이메일(글자 수)", LENGTHB(EMAIL)"이메일(바이트 수)"
FROM EMPLOYEE;
-------------------------------------------------------------------------------
/*
    INSTR: 문자열로부터 특정 문자의 시작 위치를 반환
    
    INSTR(문자열, '특정문자'[, 찾을 위치의 시작값, 순번]) => 숫자 타입 결과
    --INSTR(문자열, '특정문자')에서 문자열: 리터럴을 입력할 수도 있고, 문자열 타입의 컬럼도 가능
*/

SELECT INSTR('AABAACAABBAA',  'B') FROM DUAL;   -- 앞에서부터 첫 번째 B의 위치: 3
SELECT INSTR('AABAACAABBAA',  'B', 1) FROM DUAL; -- 찾을 위치의 시작값을 1로 지정 => 결과는 위와 동일
SELECT INSTR('AABAACAABBAA',  'B', -1) FROM DUAL; -- 시작값을 음수로 지정하면 뒤에서부터 찾는다!
SELECT INSTR('AABAACAABBAA',  'B', 1, 2) FROM DUAL; -- 앞에서부터 두 번째로 찾은 위치
SELECT INSTR('AABAACAABBAA',  'B', -1, 2) FROM DUAL;

-- 직원 정보 중 이메일의 _위 첫 번째 위치, @의 첫 번째 위치 조회
SELECT EMAIL, INSTR(EMAIL, '_', 1, 1) "_의 위치",INSTR(EMAIL, '@', 1) "@의 위치"
FROM EMPLOYEE;
-------------------------------------------------------------------------------
/*
    SUBSTR: 문자열에서 특정 문자열을 추출해서 반환 => 결과는 문자 타입
    
    SUBSTR(문자열, 시작위치[, 길이])
    => 길이를 지정하지 않으면 문자열 끝까지 추출함!!!
*/
SELECT SUBSTR('ORACLE SQL DEVELOPER', 10) FROM DUAL;

-- SQL 부분만 추출
SELECT SUBSTR('ORACLE SQL DEVELOPER', 8, 3) FROM DUAL;
SELECT SUBSTR('ORACLE SQL DEVELOPER', -3) FROM DUAL;
-- 끝에서 3번째 위치부터 문자열 끝까지 추출

-- 직원들의 이름, 주민번호 조회
SELECT EMP_NAME, EMP_NO
FROM EMPLOYEE;

-- 여직원 정보만 조회 (이름, 주민번호)
SELECT EMP_NAME, EMP_NO
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4')
ORDER BY EMP_NAME;

-- 남직원 정보만 조회 (이름, 주민번호)
SELECT EMP_NAME, EMP_NO
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3')
ORDER BY EMP_NAME;

-- 직원 정보를 조회 (이름, 이메일, 아이디)
-- 함수를 중첩해서 사용
-- [1] 이메일에서 @ 위치 찾기 INSTR
-- [2] 이메일에서 첫 번째 위치부터 @ 위치까지만 추출 SUBSTR
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@', 1) - 1) ID
FROM EMPLOYEE;
-------------------------------------------------------------------------------
/*
    LPAD/RPAD:  문자열을 조회하며 통일감 있게 조회하고자 할 때 사용
                문자열에 덧붙이고자 하는 문자를 왼/오른쪽에 붙여 최종 길이만큼 문자열 반환
                => 결과는 문자 타입
    LPAD(문자열, 최종길이 [, 덧붙일문자]) => 왼쪽에 덧붙일문자를 채움
    RPAD(문자열, 최종길이 [, 덧붙일문자]) => 오른쪽에 덧붙일문자를 채움.
    => 덧붙일문자가 생략될 경우 공백으로 채워진다!
*/
SELECT EMP_NAME, LPAD(EMP_NAME, 20) "이름"
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMP_NAME, 20) "이름"
FROM EMPLOYEE;

-- 이메일
SELECT EMP_NAME, LPAD(EMAIL, 20) "이메일"
FROM EMPLOYEE;

-- 주민번호 뒷자리를 숨겨서 조회
SELECT RPAD('050706-4', 14, '*') 주민번호 FROM DUAL;
-- SUBSTR(EMP_NO, 1, 8) || '******'

-- 직원 정보 중 주민번호 뒷자리를 *로 표시하여 조회 (이름, 주민번호)
[1] 주민번호에서 8자리를 추출
[2] 나머지 길이만큼은 *로 채움.
SELECT EMP_NAME 이름, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') "주민번호(뒷자리 제외)"
FROM EMPLOYEE;
------------------------------------------------------------------------------
/*
    LTRIM/RTRIM: 문자열에서 특정 문자를 제거한 후 나머지를 반호나
                => 결과는 문자 타입
    LTRIM(문자열[, 제거하고자하는문자들]) => 왼쪽에서 제거
    RTRIM(문자열[, 제거하고자하는문자들]) => 오른쪽에서 제거
    => 제거할문자 생략 시 공백을 제거한다!
*/
SELECT LTRIM('        H I ') FROM DUAL;  -- 왼쪽 공백들이 모두 제거됨!
SELECT RTRIM('       H I       ') FROM DUAL;  -- 오른쪽 공백들이 모두 제거됨!

SELECT LTRIM('123123HI123', '123') FROM DUAL;
SELECT LTRIM('123123HI123', '321') FROM DUAL;
SELECT RTRIM('123123HI123', '123') FROM DUAL;

/*
    TRIM: 문자열 앞/뒤/양쪽에 있는 지정한 문자들을 제거한 후 반환
        => 결과는 문자 타입
    TRIM([LEADING 또는 TRAILING 또는 BOTH] [제거할문자 FROM] 문자열)
    => 제거할문자 생략 시 공백 제거
    => 위치 옵션 생략 시 양쪽에서 제거
*/
SELECT TRIM('              H   I               ') "값" FROM DUAL;
SELECT TRIM ('L' FROM 'LLLLLLLLLLLLHLLLLLLLLLLLLLL') FROM DUAL;

SELECT TRIM (LEADING 'L' FROM 'LLLLLHLLLLLLL') FROM DUAL;  --> LTRIM과 유사
SELECT TRIM (TRAILING 'L' FROM 'LLLLLHLLLLLLL') FROM DUAL;  --> RTRIM과 유사
SELECT TRIM (BOTH 'L' FROM 'LLLLLHLLLLLLL') FROM DUAL;
-------------------------------------------------------------------------------
/*
    LOWER / UPPER / INITCAP
    LOWER(문자열): 알파벳을 모두 소문자로 변환
    UPPER(문자열): 알파벳을 모두 대문자로 변환
    INITCAP(문자열): 공백(띄어쓰기)을 기준으로 첫 글자마다 대문자로 변경해서 반환
*/
-- No pain, no Gain
SELECT LOWER('No pain, no Gain') FROM DUAL;
SELECT UPPER('No pain, no Gain') FROM DUAL;
SELECT INITCAP('No pain, no Gain') FROM DUAL;
-------------------------------------------------------------------------------
/*
    CONCAT: 문자열 두 개를 하나의 문자열로 합쳐서 반환
    
    CONCAT(문자열1, 문자열2)
*/
SELECT 'KH' || ' C 강의장' FROM DUAL;
SELECT CONCAT('KH', ' C강의장') FROM DUAL;

-- 2층 KH C강의장
SELECT CONCAT('2층', CONCAT('KH', ' C강의장')) FROM DUAL;

-- 직원 정보를 조회 (출력 형식: {직원번호}{직원명}님)
SELECT CONCAT(EMP_ID, CONCAT(EMP_NAME, '님')) FROM EMPLOYEE;
------------------------------------------------------------------------------
/*
    REPLACE: 문자열에서 특정 부분을 다른 값으로 교체하여 반환
    
    REPLACE(문자열, 특정부분(문자열), 교체할값(문자열))
*/
SELECT REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동') FROM DUAL;

-- 직원들의 이메일에서 '@kh.or.kr' 부분을 '@gmail.com'으로 변경하여 조회 (이메일, 변경된 이메일)
SELECT EMAIL 이메일, REPLACE(EMAIL, 'kh.or.kr', 'gmail.com') "변경된 이메일"
FROM EMPLOYEE;
-------------------------------------------------------------------------------
-- 숫자 타입의 데이터 처리 함수
/*
    ABS: 숫자의 절댓값을 반환
    
    ABS(수)
*/
SELECT ABS(-10) FROM DUAL;
SELECT ABS(-3.14) FROM DUAL;
SELECT ABS(2.71) FROM DUAL;


/*
    MOD: 두 수를 나눈 나머지 값을 구해주는 함수
    
    MOD(나누어지는수, 나누는수) -- 자바에서 나누어지는수 % 나누는수
*/
SELECT MOD(10, 3) FROM DUAL;
SELECT MOD(10.9, 3) FROM DUAL;
-----------------------------------------------------------------------------
/*
    ROUND: 반올림한 결과를 반환
    
    ROUND(수[, 위치]): 소수점 몇째 자리까지 반올림 할 것인지
    => 위치 생략 시 일의자리까지 반올림 (기본값 0인 것임)
    => 0이 일의 자리, 1이 소수점 아래 첫째 자리, -1은 10의 자리
*/
SELECT ROUND(3.14, 0) FROM DUAL;
SELECT ROUND(2.71) FROM DUAL;

SELECT ROUND(3.141592, 1) FROM DUAL;
SELECT ROUND(2.718281, 1) FROM DUAL;

SELECT ROUND(3.141592, 3) FROM DUAL;
SELECT ROUND(2.718281, 2) FROM DUAL;

SELECT ROUND(256, -1) FROM DUAL;
SELECT ROUND(512, -3) FROM DUAL;
------------------------------------------------------------------------------
/*
    CEIL: 올림 처리
    
    CEIL(수)     -- 안타깝게도 이것은... 위치 지정이 불가하다...
    그냥 일의자리까지로 통일!
*/
SELECT CEIL(3.14) FROM DUAL;

/*
    FLOOR: 버림 처리
    
    FLOOR(수)
    이것도 위치 지정 불가. 일의자리까지 남기고 소수점 아래 버림.
*/
SELECT FLOOR(2.71) FROM DUAL;

/*
    TRUNC: 위치 지정이 가능한 버림 처리
    
    TRUNC(수[, 위치])
*/
SELECT TRUNC(3.14) FROM DUAL;
SELECT TRUNC(3.14, 1) FROM DUAL;
SELECT TRUNC(1024, -1) FROM DUAL;
-------------------------------------------------------------------------------
-- 날짜 타입의 데이터 처리 함수
SELECT SYSDATE FROM DUAL;  -- 시스템 기준 현재 날짜 시간 정보

/*
    MONTHS_BETWEEN: 두 날짜의 개월 수를 반환
    
    MONTHS_BETWEEN(날짜1, 날짜2): 날짜1 - 날짜2 개월 수 반환
*/
-- 직원의 근속 개월 수 조회 (이름, 입사일, 근속 개월 수)
SELECT EMP_NAME, HIRE_DATE,
    CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)), '개월차') "근속 개월 수"
FROM EMPLOYEE;

-- 우리 반 공부 시작한 지 몇 개월차?
SELECT CEIL(MONTHS_BETWEEN(SYSDATE, '26/06/11')) || '개월차' FROM DUAL;
SELECT CEIL(ABS(MONTHS_BETWEEN('26/06/11', SYSDATE))) || '개월차' FROM DUAL;

-- 우리 반 수료일까지 몇 개월 남았는지?
SELECT FLOOR(MONTHS_BETWEEN('26/12/16', SYSDATE)) || '개월' FROM DUAL;
------------------------------------------------------------------------------
/*
    ADD_MONTHS: 특정 날짜의 N개월 후 날짜를 반환
    
    ADD_MONTHS(날짜, 더할 개월 수)
*/
-- 현재 날짜 기준으로 3개월 후 조회
SELECT ADD_MONTHS(SYSDATE, 3) FROM DUAL;

-- 직원들의 수습기간(3개월) 종료일 조회 (이름, 입사일, 입사일+3개월)
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 3) "수습기간 종료일"
FROM EMPLOYEE;
-------------------------------------------------------------------------------
/*
    NEXT_DAY: 특정 날짜 이후로 지정한 요일의 가장 가까운 날짜를 반환
    
    NEXT_DAY(날짜, 요일)
    => 요일: 문자 또는 숫자
            1: 일요일, 2: 월요일, ... , 7: 토요일
*/
-- 현재 날짜 기준으로 가장 가까운 금요일의 날짜 조회
SELECT SYSDATE, NEXT_DAY(SYSDATE, 6) FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금요일') FROM DUAL;
-- SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL;
-- 언어 설정이 한국어로 되어 있기 때문에 이대로는 작성 불가.

ALTER SESSION SET NLS_LANGUAGE = KOREAN;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금') FROM DUAL;

ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRI') FROM DUAL;
-----------------------------------------------------------------------------
/*
    LAST_DAY: 해당 월의 마지막 날짜를 구해주는 함수
    
    LAST_DAY(날짜)
*/
-- 이번 달의 마지막 날짜 조회
SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- 직원 정보 조회 (이름, 입사일, 입사한 달의 마지막 날짜, 입사한 달의 근무일수)
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE) "입사한 달의 마지막 날짜",
        LAST_DAY(HIRE_DATE) - HIRE_DATE + 1 || '일' "입사한 달의 근무 일수"
FROM EMPLOYEE;
------------------------------------------------------------------------------
/*
    EXTRACT: 특정 날짜로부터 연도/월/일 값을 추출해서 반환 (숫자값)
    
    EXTRACT(YEAR FROM 날짜): 연도 추출
    EXTRACT(MONTH FROM 날짜): 월 추출
    EXTRACT(DAY FROM 날짜): 일 추출
*/
-- 현재 날짜 기준으로 연도/월/일 추출
SELECT EXTRACT(YEAR FROM SYSDATE) || '년' 연도,
        EXTRACT(MONTH FROM SYSDATE) || '월' 월,
        EXTRACT(DAY FROM SYSDATE) || '일' 일
FROM DUAL;

-- 직원 정보 조회 (이름, 입사연도, 입사월, 입사일) 입사연도, 입사월, 입사일 기준 오름차순 정렬
SELECT EMP_NAME, EXTRACT(YEAR FROM HIRE_DATE) || '년' 입사연도,
        EXTRACT(MONTH FROM HIRE_DATE) || '월' "입사한 달",
        EXTRACT(DAY FROM HIRE_DATE) || '일' 입사날
FROM EMPLOYEE
-- ORDER BY 입사연도, "입사한 달", 입사날;
ORDER BY 2, 3, 4;       -- SELECT절에 나열한 순번으로 정렬시키기 가능~!
------------------------------------------------------------------------------
/*
    형 변환 함수: 데이터 타입을 변환해주는 함수 (문자, 수, 날짜)
    
    TO_CHAR: 수 또는 날짜 타입의 값을 문자 타입으로 변환해주는 함수
    
    TO_CHAR(데이터[, 포맷])
*/
-- 수 -> 문자
SELECT 1024 "수 타입 데이터", TO_CHAR(1024) "문자 타입 데이터" FROM DUAL;
SELECT TO_CHAR(1024, '999999') FROM DUAL;
-- '9': 개수만큼 자릿수를 확보하여 빈칸을 공백으로 채움.

SELECT TO_CHAR(1024, '000000') FROM DUAL;
-- '0': 개수만큼 자릿수를 확보하여 빈칸은 0으로 채움.

SELECT TO_CHAR(1024, 'L999999') FROM DUAL;
-- 'L': 화폐단위 표시.

-- 직원 정보 조회 (이름, 급여, 연봉) + 화폐단위 표시
SELECT EMP_NAME, TO_CHAR(SALARY, 'L9,999,999') 월급,
        TO_CHAR(SALARY * 12, 'L99,999,999') 연봉
FROM EMPLOYEE;
------------------------------------------------------------------------------
-- 날짜 => 문자
SELECT SYSDATE, TO_CHAR(SYSDATE) FROM DUAL;

/*
    YYYY: 연도를 4글자로 표현 (2026)
    YY  : 연도를 2글자로 표현 (26)
    
    MM: 월
    DD: 일
    
    HH: 시 정보 --> 12시간제
    HH24: 시 정보 --> 24시간제
    
    MI: 분 정보
    
    SS: 초 정보
*/
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-D | HH24:MI:SS') FROM DUAL;

/* 
    DAY: 요일 정보 (X요일)
    DY: 요일 정보 (X)
*/
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD  DAY DY') FROM DUAL;

/*
    MONTH, MON: 월 정보 (X월)
*/
SELECT TO_CHAR(SYSDATE, 'MONTH MON') FROM DUAL;

-- 직원 정보 조회 (이름, 입사일) (입사일: XXXX년, XX월, XX일 형식)
SELECT EMP_NAME 이름, TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일"') 입사일
FROM EMPLOYEE;
-- 표시할 문자(값 자체)는 큰 따옴표("")로 묶어서 형식을 지정해야 함!!!
-------------------------------------------------------------------------------
/*
    TO_NUMBER: 문자 타입의 데이터를 숫자 타입으로 변환
    
    TO_NUMBER(데이터[, 포맷])
    => 화폐 단위 등의 기호가 포함될 경우 포맷을 지정해야 한다.
*/
SELECT TO_NUMBER('0123456789') FROM DUAL;

SELECT '10000' + '500' FROM DUAL;   -- 10000500 (X)  10000 + 500 (O)
SELECT '10,000' + '500' FROM DUAL;  -- 오류 발생
SELECT TO_NUMBER('10,000', '99,999') + '500' FROM DUAL;
SELECT TO_NUMBER('10,000', '99,999') + TO_NUMBER('500', '000') FROM DUAL;
-- 또는 TO_NUMBER('500', '999')
-------------------------------------------------------------------------------
/*
    TO_DATE: 숫자 타입 또는 문자 타입을 날짜 타입으로 변환
    
    TO_DATE(데이터[, 포맷])
*/
SELECT TO_DATE(20260706) FROM DUAL;     -- YYYYMMDD
SELECT TO_DATE(260706) FROM DUAL;       -- YYMMDD
SELECT TO_DATE(960706) FROM DUAL;
-- 현재 연도 기준(50년 미만): 50년 미만 데이터는 자동으로 20XX년으로 변환
--                         50년 이상 데이터는 19XX년으로 변환

SELECT TO_DATE(060706) FROM DUAL;   -- 060706-> 60706 (X)
SELECT TO_DATE('060706') FROM DUAL;

-- TO_DATE 기본 포맷: YYYYMMDD 또는 YYMMDD일 것임!
SELECT TO_DATE('260706 143940') FROM DUAL;    -- 오류
SELECT TO_DATE('260706 143940', 'YYMMDD HH24MISS') FROM DUAL;
-------------------------------------------------------------------------------
/*
    NVL: 해당 컬럼의 값이 NULL인 경우 다른 값으로 대체해주는 함수
    
    NVL(컬럼명, 대체할 값)
    대체할 값: 해당 컬럼의 값이 NULL인 경우 사용/
*/
SELECT EMP_NAME, NVL(BONUS, 0) 보너스
FROM EMPLOYEE;

-- 직원 정보 조회 (이름, 보너스 포함 연봉)
SELECT EMP_NAME, SALARY * 12 * (1 + NVL(BONUS, 0)) "BONUS INCLUDED YEARLY SALARY"
FROM EMPLOYEE;

/*
    NVL2: 해당 컬럼이 NULL인 경우 표시할 값을 지정하고,
            NULL이 아닐 경우 표시할 값도 지정할 수 있는 함수.
            
    NVL2(컬럼명, NULL이 아닐 경우 대체할 값, NULL일 경우 대체할 값)
*/
-- 직원 정보 조회 (이름, 보너스, 보너스 유무)
SELECT EMP_NAME, BONUS, NVL2(BONUS, 'O', 'X')
FROM EMPLOYEE;

--이름, 부서코드, 부서배치여부(배정완료/미배정) 조회
SELECT EMP_NAME, DEPT_CODE, NVL2(DEPT_CODE, '배정 완료', '미배정') 부서배치여부
FROM EMPLOYEE;

/*
    NILLIF: 두 값이 일치하면 NULL, 일치하지 않으면 비교대상1을 반환
    
    NULLIF(비교대상1, 비교대상2)
*/

SELECT NULLIF('999', '999') FROM DUAL;
SELECT NULLIF('999', '777') FROM DUAL;
-------------------------------------------------------------------------------
/*
    선택함수
    
    DECODE(비교대상, 비교값1, 결과값1, 비교값2, 결과값2, ...)
    => 비교대상: 컬럼, 연산식, 함수식, ...
    
    -> 자바에서 SWITCH문과 비슷
*/
-- 직원 정보 조회 (직원번호, 이름, 주민번호, 성별)
SELECT EMP_ID, EMP_NAME, EMP_NO,
        DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남', 2, '여', 3, '남', 4, '여') 성별
FROM EMPLOYEE;

-- 이름, 급여, 인상될 급여 조회
/*
    직급이 J7: 10% 인상
          J6: 15% 인상
          J5: 20% 인상
          
          그 외: 5% 인상
*/
SELECT EMP_NAME, SALARY,
        DECODE(JOB_CODE, 'J7', SALARY * 1.1, 'J6', SALARY * 1.15, 'J5', SALARY * 1.2, SALARY * 1.05) "인상 후 급여"
FROM EMPLOYEE;
-------------------------------------------------------------------------------
/*
    CASE WHEN THEN: 조건식에 따라 결과값을 반환해주는 구문(함수)
    
    CASE
        WHEN 조건식1 THEN 결과값1
        WHEN 조건식2 THEN 결과값2
        WHEN 조건식3 THEN 결과값3
        ...
        ELSE 결과값
    END
*/
-- 이름, 급여, 급여에 따른 등급 조회
/*
    급여 >= 500만: '고급'
        >= 350만: '중급'
        그 외: '초급'
*/
SELECT EMP_NAME 이름, TO_CHAR(SALARY, '9,999,999') 월급,
        CASE
            WHEN SALARY >= 5000000 THEN '고급'
            WHEN SALARY >= 3500000 THEN '중급'
            ELSE '초급'
        END 급여등급
FROM EMPLOYEE;
------------------------------------------------------------------------------
/*
                    그룹 함수
    SUM: 해당 컬럼 값들의 총합을 반환
    
    SUM(데이터) => 데이터는 숫자 타입!!!
*/
-- 전체 직원들의 총 급여 조회
SELECT TO_CHAR(SUM(SALARY), 'L999,999,999') 총급여
FROM EMPLOYEE;

-- 남직원들의 총급여 조회
SELECT TO_CHAR(SUM(SALARY), 'L999,999,999') "남직원 총급여"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3');

--여직원들의 총급여 조회
SELECT TO_CHAR(SUM(SALARY), 'L999,999,999') "여직원 총급여"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4');

-- 부서코드가 'D5'인 직원들의 총급여 조회
SELECT TO_CHAR(SUM(SALARY), 'L999,999,999') "해외영업1부 총급여"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- 'D5' 부서 총 연봉
SELECT TO_CHAR(SUM(SALARY * 12), 'L999,999,999') "해외영업1부 총연봉"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';
------------------------------------------------------------------------------
/*
    AVG: 해당 컬럼의 평균을 반환
    
    AVG(데이터) => 데이터는 숫자 타입
*/
-- 직원들의 평균 급여 조회
SELECT TO_CHAR(ROUND(AVG(SALARY)), 'L999,999,999') 평균급여
FROM EMPLOYEE;

/*
    MIN / MAX: 최솟값, 최댓값을 반환
    
    MIN(데이터) / MAX(데이터)
    => 데이터는 모든 타입 가능.
*/
SELECT MIN(EMP_NAME) "문자타입 최솟값", MIN(SALARY) "숫자타입 최솟값",
        MIN(HIRE_DATE) "날짜타입 최솟값"
FROM EMPLOYEE;

SELECT MAX(EMP_NAME) "문자타입 최댓값", MAX(SALARY) "숫자타입 최댓값",
        MAX(HIRE_DATE) "날짜타입 최댓값"
FROM EMPLOYEE;

/*
    COUNT: 행의 개수를 반환 (단, 조건이 있을 경우 해당 조건에 맞는 행의 개수 반환)
    
    COUNT(*): 조회된 결과의 모든 행 개수 반환
    COUNT(컬럼): 해당 컬럼값이 NULL이 아닌 것만 세어서 개수를 반환
    COUNT(DISTINCT 컬럼): 해당 컬럼값의 중복을 제거한 후의 개수 반환
                        => 중복 제거 시에도 NULL은 포함하지 않은 개수를 반환함.
*/
-- 전체 직원 수 조회
SELECT COUNT(*)
FROM EMPLOYEE;

-- 남직원 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3');

-- 보너스를 받는 직원 수 조회
SELECT COUNT(*)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

SELECT COUNT(BONUS)
FROM EMPLOYEE;
















