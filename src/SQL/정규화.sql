#######################################################
# 정규화실습
# 서유미
# 실습 DATABASE
# 작성일:2024-07-31
#######################################################

DROP DATABASE IF EXISTS 정규화;

CREATE DATABASE 정규화 DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_general_ci;

USE 정규화;
DROP TABLE 동아리가입학생학과;
CREATE TABLE 동아리가입학생학과
(
    동아리번호  CHAR(2),
    동아리명   varchar(50) not null,
    동아리창립일 date        not null,
    학번     varchar(20),
    학생이름   varchar(30) not null,
    동아리가입일 date        not null,
    학과번호   CHAR(2),
    학과명    varchar(30),
    primary key (동아리번호, 학번)
) DEFAULT CHARSET = utf8mb4;


insert into 동아리가입학생학과
values ('c1', '지구한바퀴여행', '2000-02-01', 231001, '문지영', '2023-04-01', 'D1', '화학공학과');
insert into 동아리가입학생학과
values ('c1', '지구한바퀴여행', '2000-02-01', 231002, '배경민', '2023-04-03', 'D4', '경영학과');
insert into 동아리가입학생학과
values ('c2', '클래식연주동아리', '2010-06-05', 232001, '김명희', '2023-03-22', 'D2', '통계학과');
insert into 동아리가입학생학과
values ('c3', '워너비골퍼', '2020-03-01', 232002, '천은정', '2023-03-07', 'D2', '통계학과');
insert into 동아리가입학생학과
values ('c3', '워너비골퍼', '2020-03-01', 231002, '배경민', '2023-04-02', 'D2', '경영학과');
insert into 동아리가입학생학과
values ('c4', '쉘위댄스', '2021-07-01', 231001, '문지영', '2023-04-30', 'D1', '화학공학과');
insert into 동아리가입학생학과
values ('c4', '쉘위댄스', '2021-07-01', 233001, '이현경', '2023-03-27', 'D3', '역사학과');
commit;
select *
from 동아리가입학생학과;

DROP TABLE 동아리;
CREATE TABLE 동아리
(
    동아리번호  CHAR(2),
    동아리명   varchar(50) not null,
    동아리창립일 date        not null
);
ALTER TABLE 동아리
    ADD PRIMARY KEY (동아리번호);


insert into 동아리
values ('c1', '지구한바퀴여행', '2000-02-01');
insert into 동아리
values ('c2', '클래식연주동아리', '2010-06-05');
insert into 동아리
values ('c3', '워너비골퍼', '2020-03-01');
insert into 동아리
values ('c4', '쉘위댄스', '2021-07-01');

select *
from 동아리;

DROP TABLE 동아리가입학생학과;
CREATE TABLE 동아리가입학생학과
(
    학번     varchar(20),
    학생이름   varchar(30) not null,
    동아리가입일 date        not null,
    학과번호   CHAR(2),
    학과명    varchar(30)
) DEFAULT CHARSET = utf8mb4;
ALTER TABLE 동아리가입학생학과
    ADD COLUMN 동아리번호 CHAR(2) NOT NULL;
ALTER TABLE 동아리가입학생학과
    ADD PRIMARY KEY (동아리번호, 학번);

insert into 동아리가입학생학과
values (231001, '문지영', '2023-04-01', 'D1', '화학공학과', 'c1');
insert into 동아리가입학생학과
values (231002, '배경민', '2023-04-03', 'D4', '경영학과', 'c1');
insert into 동아리가입학생학과
values (232001, '김명희', '2023-03-22', 'D2', '통계학과', 'c2');
insert into 동아리가입학생학과
values (232002, '천은정', '2023-03-07', 'D2', '통계학과', 'c3');
insert into 동아리가입학생학과
values (231002, '배경민', '2023-04-02', 'D2', '경영학과', 'c3');
insert into 동아리가입학생학과
values (231001, '문지영', '2023-04-30', 'D1', '화학공학과', 'c4');
insert into 동아리가입학생학과
values (233001, '이현경', '2023-03-27', 'D3', '역사학과', 'c4');
commit;
select *
from 동아리가입학생학과;

# 제 3정규형으로
# 학과(학과번호, 학과명), 학생(학번, 학과번호, 이름),
# 동아리가입(동아리번호, 학번, 학과번호, 동아리가입일), 동아리(동아리번호, 동아리명, 동아리개설일)
CREATE TABLE 학과
(
    학과번호 CHAR(2),
    학과명  VARCHAR(30)
);
ALTER TABLE 학과
    ADD PRIMARY KEY (학과번호);

INSERT INTO 학과
VALUES ('D1', '화학공학과');
INSERT INTO 학과
VALUES ('D2', '통계학과');
INSERT INTO 학과
VALUES ('D3', '역사학과');
INSERT INTO 학과
VALUES ('D4', '경영학과');
COMMIT;
SELECT *
FROM 학과;

CREATE TABLE 학생
(
    학번   VARCHAR(20),
    학생이름 VARCHAR(30) NOT NULL
);
ALTER TABLE 학생
    ADD COLUMN 학과번호 CHAR(2) NOT NUll;
ALTER TABLE 학생
    ADD PRIMARY KEY (학과번호, 학번);

INSERT INTO 학생
VALUES (231001, '문지영', 'D1');
INSERT INTO 학생
VALUES (231002, '배경민', 'D4');
INSERT INTO 학생
VALUES (232001, '김명희', 'D2');
INSERT INTO 학생
VALUES (232002, '천은정', 'D2');
INSERT INTO 학생
VALUES (233001, '이현경', 'D3');
COMMIT;
SELECT *
FROM 학생;

CREATE TABLE 동아리
(
    동아리번호  CHAR(2),
    동아리명   VARCHAR(50) NOT NULL,
    동아리창립일 DATE        NOT NULL
);
ALTER TABLE 동아리
    ADD PRIMARY KEY (동아리번호);
INSERT INTO 동아리
VALUES ('c1', '지구한바퀴여행', '2000-02-01');
INSERT INTO 동아리
VALUES ('c2', '클래식연주동아리', '2010-06-05');
INSERT INTO 동아리
VALUES ('c3', '워너비골퍼', '2020-03-01');
INSERT INTO 동아리
VALUES ('c4', '쉘위댄스', '2021-07-01');
COMMIT;
SELECT *
FROM 동아리;

CREATE TABLE 동아리가입
(
    동아리가입일 DATE NOT NULL
);
ALTER TABLE 동아리가입
    ADD COLUMN 동아리번호 CHAR(2);
ALTER TABLE 동아리가입
    ADD COLUMN 학번 VARCHAR(20);
ALTER TABLE 동아리가입
    ADD COLUMN 학과번호 CHAR(2);
ALTER TABLE 동아리가입
    ADD PRIMARY KEY (동아리번호, 학번, 학과번호);
INSERT INTO 동아리가입
VALUES ('2023-04-01', 'c1', 231001, 'D1');
INSERT INTO 동아리가입
VALUES ('2023-04-03', 'c1', 231002, 'D4');
INSERT INTO 동아리가입
VALUES ('2023-03-22', 'c2', 232001, 'D2');
INSERT INTO 동아리가입
VALUES ('2023-03-07', 'c3', 232002, 'D2');
INSERT INTO 동아리가입
VALUES ('2020-03-01', 'c3', 231002, 'D4');
INSERT INTO 동아리가입
VALUES ('2023-04-30', 'c4', 231001, 'D1');
INSERT INTO 동아리가입
VALUES ('2023-03-27', 'c4', 233001, 'D3');
COMMIT;
SELECT *
FROM 동아리가입;

-- 문제1) 동아리 'c1', '지구한바퀴여행'에 가입한 학생의 학번, 이름, 학과명을 출력하시오
SELECT 학생.학번, 학생.학생이름, 학과.학과명
FROM 학생
         JOIN 학과 ON 학과.학과번호 = 학생.학과번호
         JOIN 동아리가입 ON 동아리가입.학번 = 학생.학번
WHERE 동아리가입.동아리번호 = 'c1';

-- 문제2) '경영학과'에 디니고 있는 학생 명단을 출력하시오.
SELECT 학생.학생이름
FROM 학생
         JOIN 학과 ON 학과.학과번호 = 학생.학과번호
WHERE 학과.학과명 = '경영학과';

-- 문제3) 동아리 '쉘위댄스'에 가입한 학생중 '화학공학과'에 다니고 있는 학생의 학번과 이름, 동아리가입일을 출력하시오.
SELECT 학생.학번, 학생.학생이름, 동아리가입.동아리가입일
FROM 학생
         JOIN 동아리가입 ON 동아리가입.학번 = 학생.학번
         JOIN 동아리 ON 동아리.동아리번호 = 동아리가입.동아리번호
         JOIN 학과 ON 학과.학과번호 = 학생.학과번호
WHERE 학과.학과명 = '화학공학과'
  AND 동아리.동아리명 = '쉘위댄스';