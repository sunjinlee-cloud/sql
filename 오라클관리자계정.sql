--계정생성
create user jsp identified by jsp;
--권한부여
grant resource, connect to jsp;
--테이블스페이스 생성
alter user jsp default tablespace users quota unlimited on users;






DROP USER jsp;

CREATE USER JSP IDENTIFIED BY JSP;
GRANT RESOURCE, CONNECT TO JSP;
ALTER USER JSP DEFAULT TABLESPACE USER QUOTA UNLIMITED ON USERS;