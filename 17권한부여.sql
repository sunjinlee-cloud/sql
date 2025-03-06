select * from hr.employees;
--사용자 계정 확인
SELECT * FROM ALL_USERS;
--현재 사용자의 권한을 확인해 보는 방법
SELECT * FROM USER_SYS_PRIVS;

--사용자 계정 생성(관리자만 가능)
CREATE USER USER01 IDENTIFIED BY USER01; --USER뒤가 아이디, IDENTIFIED 뒤가 비밀번호임
--계정이 있다고 다 접속되는게 아니다. 접속 권한도 주어져야 접속이 가능. 접속/테이블생성/뷰생성/시퀀스생성/프로시저생성..
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE TO USER01;

--TABLESPACE : 테이블이 저장되는 물리적인 공간.
ALTER USER USER01 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
--이걸 해줘야 USERS라는 테이블스페이스를 이용할 수 있다.

--권한의 회수 : REVOKE FROM
REVOKE CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE FROM USER01;
DROP USER USER01 CASCADE ; --계정이 테이블과 데이터를 가지고 있으면 테이블을 포함해서 삭제가 일어나야 함.

--롤을 이용한 권한 부여 : 권한을 더 빠르고 쉽게 주거나 회수할 수 있음
CREATE USER USER01 IDENTIFIED BY USER01;
GRANT RESOURCE, CONNECT TO USER01; --리소스롤(테이블, 뷰, 시퀀스, 프로시저등 권한의 그룹)
ALTER USER USER01 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
DROP USER USER01;

-------------------------------------------------------------------------------
--계정 생성과 권한부여를 마우스로 하기
--보기 탭에서 DBA - 좌측하단 DBA창에서 +로 관리자계정 접속 - 저장영역 - 테이블스페이스
--데이터가 저장되는 논리적 공간임.

