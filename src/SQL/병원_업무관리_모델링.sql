CREATE DATABASE Joy_University_Hospital;

USE Joy_University_Hospital;

CREATE TABLE doctor -- 의사
(
    dID      INTEGER     NOT NULL, -- 의사 ID
    dCharge  CHAR(10)    NOT NULL, -- 담당진료과목
    dName    CHAR(8)     NOT NULL, -- 의사 성명
    dContact VARCHAR(20) NOT NULL, -- 의사 연락처
    dEmail   VARCHAR(40) NOT NULL, -- 의사 이메일
    dRank    CHAR(6)     NOT NULL  -- 의사 직급
); -- 환자 정보 검색 가능 및 프라이머리키 설정 ALTER
ALTER TABLE doctor
    ADD PRIMARY KEY (dID); -- dID PK 설정


CREATE TABLE nurse -- 간호사
(
    nID      INTEGER     NOT NULL, -- 간호사 ID
    nWork    CHAR(10)    NOT NULL, -- 담당 업무
    nName    CHAR(8)     NOT NULL, -- 간호사 성명
    nGender  CHAR(6)     NOT NULL, -- 간호사 성별
    nContact VARCHAR(20) NOT NULL, -- 간호사 연락처
    nEmail   VARCHAR(40) NOT NULL, -- 간호사 이메일
    nRank    CHAR(6)     NOT NULL  -- 간호사 직급
); -- 차트정보검색, 환자 관리, 차트 관리, 진료 접수 -> 환자 ID, 차트번호
ALTER TABLE nurse
    ADD PRIMARY KEY (nID); -- nID PK 설정


CREATE TABLE patient -- 환자
(
    pID        INTEGER     NOT NULL, -- 환자 ID
    pName      CHAR(8)     NOT NULL, -- 환자 이름
    pResidentN CHAR(13)    NOT NULL, -- 환자 주민번호
    pGender    CHAR(6)     NOT NULL, -- 환자 성별
    pAddress   VARCHAR(60) NOT NULL, -- 환자 주소
    pContact   VARCHAR(20) NOT NULL, -- 환자 연락처
    pEmail     VARCHAR(40) NOT NULL, -- 환자 이메일
    pJob       CHAR(10)              -- 환자 직업
); -- 담당의사조회, 진료 내용 검색 -> 의사 ID, 진료 ID
ALTER TABLE patient
    ADD PRIMARY KEY (pID); -- pID PK 설정
ALTER TABLE patient
    ADD COLUMN nID INTEGER; -- nID 컬럼 생성
ALTER TABLE patient
    ADD CONSTRAINT fk_patient_nurse FOREIGN KEY (nID) REFERENCES nurse (nID);
-- nurse 테이블의 nID 를 FK 지정
ALTER TABLE patient
    ADD COLUMN dID INTEGER; -- pID 컬럼 생성
ALTER TABLE patient
    ADD CONSTRAINT fk_patient_doctor FOREIGN KEY (dID) REFERENCES doctor (dID);
-- doctor 테이블의 dID 를 FK 지정

ALTER TABLE patient
    MODIFY COLUMN pResidentN VARCHAR(14) NOT NULL; -- 주민번호 길이 변경


CREATE TABLE medicalTreatment -- 진료
(
    mtID     INTEGER  NOT NULL, -- 진료 ID
    mtDate   DATETIME NOT NULL, -- 진료 날짜
    mtTurn   INT      NOT NULL, -- 진료 순번
    mtDetail TEXT     NOT NULL  -- 진료 내용
); -- 의사 ID, 환자 ID
ALTER TABLE medicalTreatment
    ADD COLUMN dID INTEGER NOT NULL,
    ADD COLUMN pID INTEGER NOT NULL;

ALTER TABLE medicalTreatment
    ADD PRIMARY KEY (mtID, dID, pID);


CREATE TABLE chart
(
    cID      INT  NOT NULL, -- 차트번호
    cDetail  TEXT NOT NULL, -- 환자에 대한 내용
    dOpinion TEXT NOT NULL  -- 의사 소견
); -- 의사 ID, 간호사 ID, 환자 ID
ALTER TABLE chart
    ADD COLUMN mtID INTEGER NOT NULL,
    ADD COLUMN dID  INTEGER NOT NULL,
    ADD COLUMN pID  INTEGER NOT NULL,
    ADD COLUMN nID  INTEGER NOT NULL;

ALTER TABLE chart
    ADD PRIMARY KEY (cID, mtID, dID, pID);

ALTER TABLE chart
    ADD CONSTRAINT fk_chart_nurse FOREIGN KEY (nID) REFERENCES nurse (nID);


########################### mock 데이터 #############################

-- 의사 데이터
INSERT INTO doctor (dID, dCharge, dName, dContact, dEmail, dRank)
VALUES (1, '피부과', '홍길동', '010-1234-5678', 'hgd@joyhospital.com', '과장'), -- 문제의 '홍길동' 의사
       (2, '외과', '이서연', '010-2222-2222', 'lsy@joyhospital.com', '전문의'),
       (3, '소아과', '박도윤', '010-3333-3333', 'pdy@joyhospital.com', '전문의'),
       (4, '내과', '최지우', '010-4444-4444', 'cjw@joyhospital.com', '전문의'),
       (5, '정형외과', '정하준', '010-5555-5555', 'jhj@joyhospital.com', '레지던트'),
       (6, '내과', '윤서아', '010-6666-6666', 'ysa@joyhospital.com', '전문의'),
       (7, '외과', '강시우', '010-7777-7777', 'ksw@joyhospital.com', '인턴'),
       (8, '소아과', '송하윤', '010-8888-8888', 'shy@joyhospital.com', '레지던트'),
       (9, '피부과', '한지안', '010-9999-9999', 'hja@joyhospital.com', '전문의'),
       (10, '정형외과', '임도현', '010-1010-1010', 'ldh@joyhospital.com', '과장');

-- 간호사 데이터
INSERT INTO nurse (nID, nWork, nName, nGender, nContact, nEmail, nRank)
VALUES (1, '외래', '김수진', '여자', '010-1212-1212', 'ksj@joyhospital.com', '책임간호사'),
       (2, '병동', '이수지', '여자', '010-8765-4321', 'lsj@joyhospital.com', '일반간호사'), -- 문제의 '이수지' 간호사
       (3, '수술실', '박지영', '여자', '010-3434-3434', 'pjy@joyhospital.com', '수간호사'),
       (4, '응급실', '최현우', '남자', '010-4545-4545', 'chw@joyhospital.com', '일반간호사'),
       (5, '외래', '정유미', '여자', '010-5656-5656', 'jym@joyhospital.com', '일반간호사'),
       (6, '병동', '윤지훈', '남자', '010-6767-6767', 'yjh@joyhospital.com', '책임간호사'),
       (7, '수술실', '강민서', '여자', '010-7878-7878', 'kms@joyhospital.com', '일반간호사'),
       (8, '응급실', '송은지', '여자', '010-8989-8989', 'sej@joyhospital.com', '수간호사'),
       (9, '외래', '한서준', '남자', '010-9090-9090', 'hsj@joyhospital.com', '일반간호사'),
       (10, '병동', '임나영', '여자', '010-0101-0101', 'lny@joyhospital.com', '책임간호사');

-- 환자 데이터
INSERT INTO patient (pID, pName, pResidentN, pGender, pAddress, pContact, pEmail, pJob, nID, dID)
VALUES (1, '김영수', '900101-1234567', '남자', '서울시 강남구', '010-1111-2222', 'kys@email.com', '회사원', 1, 1), -- 홍길동 의사 담당
       (2, '박철민', '920304-1345678', '남자', '서울시 서초구', '010-2222-3333', 'pcm@email.com', '교사', 2, 3),  -- 이수지 간호사 담당
       (3, '이하나', '850715-2876543', '여자', '경기도 성남시', '010-3333-4444', 'lhn@email.com', '자영업', 3, 4),
       (4, '최지연', '951120-2123456', '여자', '인천시 연수구', '010-4444-5555', 'cjy@email.com', '학생', 4, 5),
       (5, '윤도현', '780505-1987654', '남자', '서울시 마포구', '010-5555-6666', 'ydh@email.com', '가수', 2,
        1),                                                                                          -- 홍길동 의사, 이수지 간호사 담당
       (6, '정수정', '010210-2012345', '여자', '경기도 수원시', '010-6666-7777', 'jsj@email.com', '학생', 6, 6),
       (7, '유재석', '720814-1122334', '남자', '서울시 강남구', '010-7777-8888', 'yjs@email.com', '방송인', 7, 2),
       (8, '장원영', '040831-2334455', '여자', '서울시 용산구', '010-8888-9999', 'jwy@email.com', '가수', 8, 8),
       (9, '마동석', '710518-1445566', '남자', '서울시 금천구', '010-9999-0000', 'mds@email.com', '배우', 9, 10),
       (10, '김연아', '900905-2556677', '여자', '경기도 군포시', '010-0000-1111', 'kya@email.com', '운동선수', 10, 5);

-- 진료 데이터
INSERT INTO medicalTreatment (mtID, dID, pID, mtDate, mtTurn, mtDetail)
VALUES (1, 1, 1, '2023-11-15 09:10:00', 1, '피부 트러블 상담'),    -- 11월 진료
       (2, 3, 2, '2023-11-21 10:30:00', 2, '소아 예방 접종'),     -- 11월 진료
       (3, 4, 3, '2023-12-05 11:00:00', 1, '만성 소화 불량 진료'),  -- 12월 진료
       (4, 5, 4, '2023-12-10 14:00:00', 1, '손목 통증 물리치료'),   -- 12월 진료
       (5, 1, 5, '2023-12-18 15:20:00', 3, '알레르기성 피부염 진료'), -- 12월 진료, 홍길동 의사
       (6, 6, 6, '2024-01-05 09:00:00', 1, '감기 및 발열 증상'),
       (7, 2, 7, '2024-01-08 10:00:00', 2, '수술 부위 경과 확인'),
       (8, 8, 8, '2024-01-10 11:30:00', 3, '성장통 관련 상담'),
       (9, 10, 9, '2024-01-12 14:30:00', 4, '어깨 근육 통증 진료'),
       (10, 5, 10, '2024-01-15 16:00:00', 5, '무릎 재활 치료');

-- 차트 데이터
INSERT INTO chart (cID, mtID, dID, pID, nID, cDetail, dOpinion)
VALUES (1, 1, 1, 1, 1, '환자는 최근 스트레스로 인한 피부 트러블을 호소함.', '생활 습관 개선 및 연고 처방'),
       (2, 2, 3, 2, 2, '필수 예방 접종 완료. 특이사항 없음.', '다음 접종 일정 안내'),
       (3, 3, 4, 3, 3, '불규칙한 식사로 인한 위염 소견.', '약물 치료 및 식단 조절 권장'),
       (4, 4, 5, 4, 4, '반복적인 손목 사용으로 인한 염증 발생.', '보호대 착용 및 물리치료 병행'),
       (5, 5, 1, 5, 2, '건조한 날씨로 인한 피부염 악화.', '보습제 사용 및 약물 복용 안내'),
       (6, 6, 6, 6, 6, '고열 및 인후통으로 내원.', '해열제 및 항생제 처방'),
       (7, 7, 2, 7, 7, '수술 부위 염증 없이 양호한 상태.', '일주일 후 실밥 제거 예정'),
       (8, 8, 8, 8, 8, '야간에 무릎 성장통을 자주 느낌.', '마사지 및 스트레칭 교육 시행'),
       (9, 9, 10, 9, 9, '영화 촬영 중 발생한 어깨 근육 파열.', '주사 치료 및 재활 프로그램 안내'),
       (10, 10, 5, 10, 10, '재활 치료 후 무릎 가동 범위 크게 향상됨.', '점진적 근력 운동 시작');


-- 데이터 초기화
DELETE
FROM chart;
DELETE
FROM medicalTreatment;
DELETE
FROM patient;
DELETE
FROM nurse;
DELETE
FROM doctor;
###########################################

-- 1. 홍길동 의사가 맡고 있던 담당 진료과목이 피부과에서 소아과로 변경되어 내일부터 진료를 시작할 예정이다.
-- 해당 정보를 변경하시오. 홍길동 의사 정보를 입력하여 쿼리문 실행
UPDATE doctor
SET dCharge = '소아과'
WHERE dName = '홍길동';

SELECT *
FROM doctor
WHERE dName = '홍길동';


-- 2. 이수지 간호사는 대학원 진학으로 오늘까지만 근무하고 퇴사.
-- 해당 정보에 대한 테이블 정보를 변경하시오.

-- patient 테이블에서 '이수지' 간호사(nID=2)를 다른 간호사(nID=1)로 변경
UPDATE patient
SET nID = 1
WHERE nID = 2;

-- chart 테이블에서도 '이수지' 간호사(nID=2)를 다른 간호사(nID=1)로 변경
UPDATE chart
SET nID = 1
WHERE nID = 2;

-- 이제 참조하는 곳이 없으므로 '이수지' 간호사 정보 삭제
DELETE
FROM nurse
WHERE nName = '이수지';

-- 삭제 확인
SELECT *
FROM nurse
WHERE nName = '이수지';


-- 3. 담당진료과목이 '소아과' 의사에 대한 정보를 출력하시오.
SELECT *
FROM doctor
WHERE dCharge = '소아과';


-- 4. 홍길동 의사에게 진료 받은 환자에 대한 정보를 출력하시오.
SELECT DISTINCT p.*
FROM patient p
         JOIN medicalTreatment mt ON p.pID = mt.pID
         JOIN doctor d ON mt.dID = d.dID
WHERE d.dName = '홍길동';

select p.*
from patient p,
     doctor d
where p.dID = d.dID and d.dname = '홍길동';

-- 5. 진료날짜가 2023년 11월에서 2023년 12월에 진료받은 환자에 대한 모든 정보를 오름차순 정렬하여 출력
SELECT p.*, mt.mtDate, mt.mtDetail -- 환자 정보, 진료 날짜, 진료 내용
FROM patient p
         JOIN medicalTreatment mt ON p.pID = mt.pID
WHERE mt.mtDate BETWEEN '2023-11-01' AND '2023-12-31'
ORDER BY mt.mtDate DESC;
