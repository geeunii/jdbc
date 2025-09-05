use
    bookmarketdb;

create table users
(
    userid       varchar(50) primary key,        -- 사용자아이디
    username     varchar(50) not null,           -- 사용자이름
    userpassword varchar(50) not null,           -- 비밀번호
    userage      numeric(3)  not null default 0, -- 나이
    useremail    varchar(50) not null            -- 이메일
);

create table boards
(
    bno       int primary key auto_increment, -- 글번호
    btitle    varchar(100) not null,          -- 글제목
    bcontent  longtext     not null,          -- 글내용
    bwriter   varchar(50)  not null,          -- 작성자
    bdate     datetime default now(),         -- 작성일
    bfilename varchar(50)  null,              -- 파일 이름
    bfiledata longblob     null               -- 첨부파일
);

create table accounts
(
    ano     varchar(20) primary key, -- 계좌번호
    owner   varchar(20) not null,    -- 계좌주
    balance numeric     not null     -- 잔액
);

insert into accounts (ano, owner, balance)
values ('111-111-1111', '나여름', 1000000);

insert into accounts (ano, owner, balance)
values ('222-222-2222', '한겨울', 0);

commit;

desc accounts;
desc users;
desc boards;
