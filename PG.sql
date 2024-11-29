-- users 테이블 생성
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  full_name VARCHAR(100),
  phone_number VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- 추가 속성
ALTER TABLE users
ADD COLUMN reset_password_token VARCHAR(100),
ADD COLUMN reset_password_expiry TIMESTAMP;
SELECT * from users ;

SELECT * 
FROM LikeTable 
WHERE user_id = 1;





-- restaurants 테이블 생성
CREATE TABLE restaurants (
   restaurants_id SERIAL PRIMARY KEY,
   restaurants_name VARCHAR(100) NOT NULL,
   address VARCHAR(255) NOT NULL,
   phone VARCHAR(100) NOT NULL,
   opening_hours VARCHAR(100) NOT NULL,
   rating FLOAT NOT NULL,
   spicy FLOAT NOT NULL,
   sweet FLOAT NOT NULL,
   sour FLOAT NOT NULL,
   salty FLOAT NOT NULL,
   food_type VARCHAR(20) NOT NULL,
   image VARCHAR(500) NOT NULL,
   latitude DECIMAL(10, 8) NOT NULL,
   longitude DECIMAL(11, 8) NOT NULL,
   category VARCHAR(100),
   food_menu JSONB
);
-- 설문조사용 식당 카드
CREATE TABLE LikeTable (
   id SERIAL PRIMARY KEY,
   user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
   restaurants_id INT NOT NULL REFERENCES restaurants(restaurants_id) ON DELETE CASCADE,
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- reviews 테이블 생성
CREATE TABLE reviews (
   id SERIAL PRIMARY KEY,
   username VARCHAR(100) NOT NULL,
   contents text NOT NULL,
   date DATE NOT NULL,
   rating numeric not null,
   restaurant_id INT NOT NULL REFERENCES restaurants(restaurants_id)
);
-- 로그인한 사용자의 ID 정보도 같이저장 
ALTER TABLE reviews
ADD COLUMN author_id INT REFERENCES users(id);


-- hashtags(해시태그) 테이블 생성
CREATE TABLE hashtags (
  id SERIAL PRIMARY KEY,
  contents VARCHAR(32) NOT NULL
);

-- 리뷰-해시태그 매핑 테이블 생성
CREATE TABLE reviews_hashtags (
   reviews_id INT NOT NULL,
   hashtags_id INT NOT NULL,
   FOREIGN KEY (reviews_id) REFERENCES reviews(id) ON DELETE CASCADE,
   FOREIGN KEY (hashtags_id) REFERENCES hashtags(id) ON DELETE CASCADE
);

CREATE TABLE review_photos (
   id SERIAL PRIMARY KEY,
   review_id INT REFERENCES reviews(id) ON DELETE CASCADE,
   photo_url VARCHAR(255) NOT NULL
);


-- posts 테이블 생성
CREATE TABLE posts (
   post_id SERIAL PRIMARY KEY,
   title VARCHAR(100) NOT NULL,
   content TEXT NOT NULL,
   post_date TIMESTAMP NOT NULL
);
-- 게시물 작성자의 사용자 ID를 저장하기 위한 author_id 속성 추가
ALTER TABLE posts
ADD COLUMN author_id INT REFERENCES users(id);

-- 게시물 작성자의 이름을 저장하기 위한 username 속성 추가
ALTER TABLE posts
ADD COLUMN username VARCHAR(100) DEFAULT 'unknown' NOT NULL;



SHOW DATABASE 

CREATE TABLE questions (
  id SERIAL PRIMARY KEY,
  inquirer_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(100),
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  file_url VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- 댓글 테이블 생성
CREATE TABLE comments (
   id SERIAL PRIMARY KEY,
   comment_text CHAR(100) NOT NULL,
   comment_date CHAR(100) NOT NULL,
   username VARCHAR(100) NOT NULL,
   author_id INT REFERENCES users(id),
   post_id INT NOT NULL REFERENCES posts(post_id)
);

-- 인덱스 생성
CREATE INDEX idx_comments_post_id ON comments(post_id);
SELECT * FROM LikeTable;
-- restaurants 테이블에 데이터 삽입
INSERT INTO restaurants (restaurants_name, address, phone, opening_hours, rating, spicy, sweet, sour, salty, food_type, image, latitude, longitude, food_menu, category) 
VALUES 
('대전 성심당', '대전광역시 중구', '042-1234-5678', '07:00 - 22:00', 4.8, 5, 5, 4, 4, 'Korean', 'https://blog.lgchem.com/wp-content/uploads/2014/10/ssd_1030-1.jpg', 36.350412, 127.384548, '{"menus":[{"name":"튀김소보루"},{"name":"작은 메아리"}]}', '디저트'),
('이태리국시 본점', '대전 서구 둔산로31번길 31 2층', '042-485-0950', '11:30 - 22:00', 4.8, 5, 5, 4, 5, 'Western', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20230616_205%2F1686845894665KQdXt_JPEG%2FKakaoTalk_Photo_2023-06-16-01-17-32_007.jpeg', 36.353304, 127.377901, '{"menus":[{"name":"파스타"},{"name":"스테이크"}]}', '이탈리안'),
('신사우물갈비 대전점', '대전 서구 가장로87-1 1층', '042-522-3215', '12:00 - 23:00', 4.7, 5, 5, 4, 4, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fpup-review-phinf.pstatic.net%2FMjAyNDAzMzBfMjQ2%2FMDAxNzExNzcxNDQ2NTU5.-INp7BzOoFPEI3tWcty53yYvAKRvzIP5PNjbqznJYi4g.cBcCir2e9kIBJQ7SEPBZWkNMtlnkUWBxcHl9QZo7iiQg.JPEG%2F20240330_125938.jpg.jpg', 36.376282, 127.508940, '{"menus":[{"name":"갈비"},{"name":"고기류"}]}', '한식'),
('근돈', '대전 서구 도산로369번길 92 1층 근돈 본점', '0507-1392-5234', '16:00 - 23:30', 4.5, 4, 5, 5, 4, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20230815_270%2F1692109919279qU5kP_JPEG%2FKakaoTalk_20230815_233011659_01.jpg', 36.340565, 127.389010, '{"menus":[{"name":"삼겹살"},{"name":"목살"}]}', '한식'),
('대전 조개구이 무한리필', '대전 서구 계백로 1145 2층', '010-2022-6156', '12:00 - 24:00', 4.5, 4, 4, 5, 5, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20211102_119%2F1635825585194a7Ces_JPEG%2FlJp2-NP49hNlKp9aEn3jzrYs.jpg', 36.304876, 127.350764, '{"menus":[{"name":"조개구이"},{"name":"해산물"}]}', '한식'),
('온유', '대전 서구 괴정로 116번길44', '0507-1423-5658', '11:00 - 21:00', 4.7, 5, 5, 4, 4, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fpup-review-phinf.pstatic.net%2FMjAyNDAzMDJfMTY5%2FMDAxNzA5Mzg2OTc5NTEw.nJNkNi5Y5A88jNiqBs9eu3KoL2dSTfIGohCj0gsl7fQg.TyQDOQv4jP2OsFo_wZ_IIBkzLCD7xQ9yBN8YxcNmNg4g.JPEG%2F1000024695.jpg', 36.336191, 127.383620, '{"menus":[{"name":"비빔밥"},{"name":"된장찌개"}]}', '한식'),
('소나무풍경', '대전 서구 괴정로116번길 42 소나무풍경', '042-525-9925', '10:30 - 20:30', 4.6, 4, 4, 5, 5, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20230706_157%2F168861524446585z6s_JPEG%2FDSC00159-min_%25281%2529.jpg', 36.336243, 127.383670, '{"menus":[{"name":"불고기"},{"name":"된장찌개"}]}', '한식'),
('심미함박', '대전 서구 도솔로 302번길 25-2', '042-535-2891', '11:00 - 21:00', 4.6, 4, 4, 5, 5, 'Korean', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDAzMjZfMTgg%2FMDAxNzExNDE3NDUyNDk3.y9KoHd7la1xopWtqzfe1K6uU1C-Hei_iQvoZ0mFM6Wcg.H3LG07ZI0DuV1m1vDdujBnDKLTO6Itl_X_2ZGr0qhFcg.PNG%2FAsset_1064x-8.png', 36.334167, 127.383844, '{"menus":[{"name":"함박스테이크"},{"name":"돈까스"}]}', '한식'),
('박쉐프참치', '대전 서구 도솔로 302번길 23-2 1층', '0507-1357-7436', '12:00 - 23:30', 4.8, 5, 5, 4, 4, 'Japanese', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20240122_2%2F1705896586318MPmyw_JPEG%2FKakaoTalk_20240122_130319968.jpg', 36.334266, 127.383203, '{"menus":[{"name":"참치"},{"name":"회"}]}', '일식'),
('미나리솥뚜껑', '대전 서구 용문로 35-7 1층', '042-523-2352', '16:00 - 01:00', 4.4, 4, 4, 5, 5, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20221025_107%2F1666678468019v31QK_JPEG%2F285C2E80-515A-4DDD-A257-DD269985A1CF.jpeg', 36.339762, 127.387863, '{"menus":[{"name":"솥뚜껑삼겹살"},{"name":"돼지고기"}]}', '한식'),
('금복집', '대전 서구 도산로370번길 46', '???', '17:00 - 24:00', 4.3, 3, 4, 4, 4, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20200424_59%2F1587723787286umBH0_JPEG%2FKgIjZ-QqDw4_f-ooaRiW-GpG.jpg', 36.335789, 127.393761, '{"menus":[{"name":"육회"},{"name":"삼겹살"}]}', '한식'),
('모정득구미옛날고기집', '대전 서구 계룡로 620번길 23 1층', '0507-1454-0092', '17:00 - 23:30', 4.7, 5, 4, 4, 5, 'Korean', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDAzMjVfMjAw%2FMDAxNzExMzAzNjg5OTEz.v80WqhSnwzc7wy3dlAYUoZIMwhdUolrlDSDnpxO9W7Mg.CyC2glKQkEgGCBbfFWUCGMiLlCIzCbZ1eL7rTmrcqxIg.JPEG%2FIMG_9003.jpg', 36.338909, 127.390471, '{"menus":[{"name":"삼겹살"},{"name":"돼지갈비"}]}', '한식'),
('동방커피', '대전 서구 용문로41-26', '0507-1351-0633', '12:00 - 01:00', 4.7, 3, 4, 5, 4, 'Western', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20201119_252%2F1605766399761ktNIb_JPEG%2FvsKRf0qwOqzt0MYF6Rxul1DA.jpg', 36.338943, 127.388916, '{"menus":[{"name":"아메리카노"},{"name":"카페라떼"}]}', '카페'),
('오늘대패', '대전 서구 도솔로 377 1층', '0507-1389-9936', '11:00 - 07:00', 4.5, 5, 5, 5, 5, 'Chinese', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20231216_155%2F1702689329457kRi9x_JPEG%2FGettyImages-a11229268.jpg', 36.340430, 127.387505, '{"menus":[{"name":"대패삼겹살"},{"name":"중국식볶음밥"}]}', '중식'),
('바로그집', '대전 서구 도산로369번길 94', '042-534-6844', '09:30 - 22:30', 4.7, 3, 4, 5, 4, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20200703_159%2F15937729429067aLbW_JPEG%2Fc1xKh8mg1nj5FfeIwR6acY9_.JPG.jpg', 36.340777, 127.388611, '{"menus":[{"name":"국밥"},{"name":"육개장"}]}', '한식'),
('미도인', '대전 서구 둔산로 31번길 51', '042-472-9992', '11:00 - 20:20', 4.5, 3, 4, 5, 4, 'Japanese', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20210127_159%2F16117442764984Rgrh_JPEG%2FnpEwYcJWG0HRQ26uP46K5veg.jpg', 36.354021, 127.377347, '{"menus":[{"name":"덮밥"},{"name":"우동"}]}', '일식'),
('열혈충주갈비', '대전 서구 둔산중로40번길 31 102호', '0507-1439-8952', '11:00 - 23:00', 4.6, 5, 5, 4, 4, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20240218_107%2F1708252309562qMVId_JPEG%2FKakaoTalk_20240218_192230194_02.jpg', 36.988920, 127.929476, '{"menus":[{"name":"충주갈비"},{"name":"돼지갈비"}]}', '한식'),
('애프터글로우', '대전 서구 계룡로 391 201호', '0507-1460-0884', '11:30 - 21:00', 4.8, 5, 5, 4, 4, 'Western', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20230518_227%2F1684375622932f2qIx_JPEG%2F304BD82B-EA35-4487-A0E7-14C7640581D5.jpeg', 36.351607, 127.371710, '{"menus":[{"name":"파스타"},{"name":"스테이크"}]}', '카페'),
('해물상회 둔산시청점', '대전 서구 계룡로491번길 58 1층 해물상회 둔산점', '0507-1421-1115', '11:30 - 22:00', 3.9, 5, 4, 4, 5, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fpup-review-phinf.pstatic.net%2FMjAyNDA2MTdfNjAg%2FMDAxNzE4NjE0NDY1MTE0.9dZC7g8UHzjYyvipEAekoCvOksC0Rv2d1vXSenOKVAMg.k2gK7pkHz1TpM1aHDLLpH3cI4AiqMNiWPID6PF42hlIg.JPEG%2F87AA111C-B4EC-4C46-B915-A16E73A0F028.jpeg%3Ftype%3Dw1500_60_sharpen', 36.351160, 127.378540, '{"menus":[{"name":"조개"},{"name":"삼합"}]}', '한식'),
('화원짚불구이 둔산점', '대전 서구 둔산중로46번길 30 1층 102호', '0507-1353-9992', '11:30 - 24:00', 4.6, 4, 5, 5, 4, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20240119_286%2F1705600875721YbNnS_JPEG%2F%25C8%25AD%25BF%25F8%25C2%25A4%25BA%25D2%25B1%25B8%25C0%25CC_%25283%2529.jpg', 36.350631, 127.388715, '{"menus":[{"name":"갈비"},{"name":"삼겹살"}]}', '한식'),
('태평소국밥', '대전 유성구 온천동로65번길 50', '042-525-5820', '00:00 - 24:00', 4.8, 5, 4, 4, 5, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20191030_49%2F1572425181372hmIyq_JPEG%2FRIOQnCCRml9FnGc8_5pmMirH.jpeg.jpg', 36.357444, 127.350242, '{"menus":[{"name":"소국밥"},{"name":"매운 소갈비찜"}]}', '한식'),
('경성삼겹살', '대전 유성구 문화원로 90 유성구 봉명동 621-1 2층 경성삼겹살', '0507-1420-5392', '17:00 - 24:00', 4.7, 5, 4, 4, 5, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20191112_293%2F1573550762685euwWH_JPEG%2Fimage.jpg', 36.328734, 127.421059, '{"menus":[{"name":"갈비탕"},{"name":"김치찌개"}]}', '한식'),
('풍바오 봉명점', '대전 유성구 온천북로33번길 21-12 1층', '0507-1359-0161', '16:00 - 03:00', 4.8, 5, 4, 4, 5, 'Japanese', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fnaverbooking-phinf.pstatic.net%2F20240502_110%2F1714607046970oFVjA_JPEG%2FKakaoTalk_20240214_135849294_07.jpg', 36.358841, 127.345972, '{"menus":[{"name":"대창소고기나배"},{"name":"모둠꼬치"}]}', '일식'),
('데판유우', '둔산동 1100', '0507-1448-3402', '17:00 - 02:00', 4.6, 5, 4, 4, 4, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20201207_48%2F1607329927100ubppI_JPEG%2F4vHeN85fwqiQNY1Pih1TsmBK.jpg', 36.350798, 127.374648, '{"menus":[{"name":"호르몬구이"},{"name":"토시살"}]}', '한식'),
('온천칼국수', '대전 유성구 온천북로 61', '042-824-6668', '11:00 - 21:30', 4.4, 5, 4, 4, 5, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20220922_277%2F166385324039002Lnv_JPEG%2F20220809_185503.jpg', 36.356494, 127.349900, '{"menus":[{"name":"물총칼 칼국수"},{"name":"쭈꾸미볶음"}]}', '한식'),
('초미당 세번째', '대전 동구 백룡로 32-1 1층', '0507-1357-2860', '11:30 - 21:00', 4.8, 4, 5, 4, 4, 'Japanese', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20230906_202%2F16939871524708QFGq_JPEG%2FKakaoTalk_20230906_164922762_05.jpg', 36.334849, 127.450185, '{"menus":[{"name":"초미당 스페셜초밥"},{"name":"초밥"}]}', '일식'),
('대전 동구 옥천로176번길 8', '대전 동구 옥천로176번길 8', '0507-1413-9007', '11:00 - 20:00', 4.5, 5, 4, 4, 5, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20210104_146%2F1609739683715TU7SF_JPEG%2FBsScOg6ZrBtxS2ZijTRTskIH.jpg', 36.316614, 127.459401, '{"menus":[{"name":"밀면"},{"name":"만두"}]}', '한식'),
('백송한우 대전유성', '대전 유성구 월드컵대로275번길 49 B동 지상1층 백송', '0507-1343-9305', '11:30 - 22:00', 4.8, 4, 5, 4, 5, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fpup-review-phinf.pstatic.net%2FMjAyNDA2MTdfMjc1%2FMDAxNzE4NjE5MjkxMTY0.gSR6ZvPf4PvJVUTHyOJLlIpdevreksyS1gHO9L-XOMwg.6klDRN0-J52Nu35n_69vNY6hQrgeBe7BgvXcqsX-Su0g.JPEG%2F20240617_191140.jpg.jpg%3Ftype%3Dw1500_60_sharpen', 36.350611, 127.331634, '{"menus":[{"name":"갈빗살"},{"name":"서대살"}]}', '한식'),
('보끄미 둔산점', '둔산동 1352', '0507-1476-8918', '11:00 - 21:30', 4.4, 5, 4, 4, 4, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20151110_193%2F1447156973375XBSJg_JPEG%2F166775545241272_4.jpg', 36.354431, 127.380679, '{"menus":[{"name":"쭈꾸미"},{"name":"쭈꾸미세트"}]}', '한식'),
('조선무쇠삼겹살', '대흥동 215', '042-482-5555', '16:00 - 02:00', 4.7, 4, 5, 4, 4, 'Korean', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20231017_286%2F1697524979632aB8MB_JPEG%2FKakaoTalk_20231014_005629314_02.jpg', 36.322386, 127.425108, '{"menus":[{"name":"생삼겹살"},{"name":"대패삼겹살"}]}', '한식'),
('후지산', '대전 서구 둔산로137번길 21', '042-471-6300', '11:00 - 23:00', 4.8, 4, 5, 4, 4, 'Japanese', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20230104_278%2F1672807414150JQoV2_JPEG%2F56.jpg', 36.352248, 127.388991, '{"menus":[{"name":"사시미"},{"name":"회정식"}]}', '일식'),
('몽상', '둔산동 1015', '0507-1323-1190', '11:20 - 20:30', 4.7, 5, 4, 4, 5, 'Japanese', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20230524_129%2F1684917856681m72zI_JPEG%2FB0EF56DE-D661-4225-A4B7-A08AFD40AA58.jpeg', 36.353212, 127.378273, '{"menus":[{"name":"사쿠라 직화 부타동"},{"name":"사케동"}]}', '일식'),
('바다황제 횟집 일식집', '대흥동 458-1', '0507-1411-5665', '11:30 - 22:00', 4.6, 4, 5, 4, 4, 'Japanese', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20231130_100%2F1701307590427qU0bU_JPEG%2F20231121_183828-01.jpeg', 36.325252, 127.424474, '{"menus":[{"name":"해물탕"},{"name":"황제물회"}]}', '일식'),
('연이자카야 본점', '은행동 65-5', '0507-1351-7648', '11:00 - 22:00', 4.7, 4, 5, 4, 4, 'Japanese', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20240613_138%2F1718276607453jm6qV_JPEG%2FIMG_9173.jpeg', 36.328464, 127.429483, '{"menus":[{"name":"연어초밥"},{"name":"연어사시미"}]}', '일식'),
('스시정', '상대동 471-8', '0507-1393-3691', '11:30 - 22:00', 4.6, 5, 4, 4, 4, 'Japanese', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fpup-review-phinf.pstatic.net%2FMjAyNDA2MDZfMTc4%2FMDAxNzE3NjY4NzU5MzUw.EO4Uy4w4G67b799c0xcGbDUL1HnXvZI4Etkb-uFHI4kg.7nRVe-3oixa2YWk9do6phSbMBkH5A66NTbX0E_zHPO4g.JPEG%2F17176687499148234119565745312390.jpg%3Ftype%3Dw1500_60_sharpen', 36.346364, 127.339209, '{"menus":[{"name":"모둠초밥 세트"},{"name":"반반초밥세트"}]}', '일식'),
('갓포회담 대전봉명점', '봉명동 675-3', '0507-1485-6334', '11:30 - 22:00', 4.8, 5, 4, 4, 5, 'Japanese', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fnaverbooking-phinf.pstatic.net%2F20240422_38%2F1713781858406mw2XF_JPEG%2F230701_%25C7%25C1%25B7%25D2%25B4%25F5%25C7%25E3%25B5%25E9_4.jpg', 36.357971, 127.350346, '{"menus":[{"name":"런치스페셜코스"},{"name":"모둠회"}]}', '일식'),
('고래밥', '관저동 1215', '0507-1354-3353', '11:30 - 23:00', 4.7, 4, 5, 4, 4, 'Japanese', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20240318_3%2F171075544252016NSJ_JPEG%2F20220408_212611.jpg', 36.301293, 127.338680, '{"menus":[{"name":"고래모듬장정식"},{"name":"미너스페셜"}]}', '일식'),
('아비꼬 롯데백화점 대전점', '괴정동 423-1', '0507-1317-2992', '10:30 - 20:00', 4.4, 5, 4, 4, 5, 'Japanese', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20240418_132%2F1713404743755KSWG4_JPEG%2F1KakaoTalk_Photo_2023-01-31-12-21-34_003.jpeg', 36.340594, 127.389583, '{"menus":[{"name":"100시간카레"},{"name":"버섯카레"}]}', '일식'),
('상하이양꼬치 반석점', '반석동 630-2', '0507-1442-9092', '17:00 - 23:00', 4.5, 5, 5, 5, 5, 'Chinese', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20230623_69%2F16875019445094JCFl_JPEG%2FIMG_2597.JPG', 36.393094, 127.312142, '{"menus":[{"name":"고급양고기"},{"name":"모둠꼬치"}]}', '중식'),
('태원', '대전 서구 문정로 19', '0507-1436-8838', '10:30 - 21:15', 4.3, 5, 5, 5, 5, 'Chinese', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20150825_20%2F1440480335175wqJrc_JPEG%2F166775545553271_0.jpg', 36.346165, 127.381724, '{"menus":[{"name":"등심탕수육"},{"name":"삼선짬뽕"}]}', '중식'),
('진신', '원신흥동 508-9', '0507-1412-5089', '11:00 - 21:00', 4.5, 5, 5, 5, 5, 'Chinese', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fpup-review-phinf.pstatic.net%2FMjAyNDA2MDdfMTc4%2FMDAxNzE3NzMzMzYyMjA1.weOyDuVKUTlGFq-3RQ76ENocHK8ACVODyGz3ET-npgAg.Ngx0hAEbW42oKZYLvtHpMPdYwlqMqv0_TksW4W-Wi90g.JPEG%2F94CEB657-1B05-47A7-91FC-570AEE87DF2E.jpeg%3Ftype%3Dw1500_60_sharpen', 36.338889, 127.344254, '{"menus":[{"name":"짜장면"},{"name":"짬뽕"}]}', '중식'),
('조기종의 향미각', '용문동 275-3', '042-536-8252', '10:30 - 21:00', 4.5, 5, 5, 5, 5, 'Chinese', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20220711_176%2F1657519512775gdI9C_JPEG%2F20220223_075910.jpg', 36.335487, 127.389166, '{"menus":[{"name":"짜장면"},{"name":"새우볶음밥"}]}', '중식'),
('학짬뽕 대전점', '대전 서구 월평로 94-1', '0507-1440-0420', '10:30 - 20:00', 4.5, 5, 5, 5, 5, 'Chinese', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20230503_281%2F16831217790282neT1_JPEG%2F20230417_114845.jpg', 36.355917, 127.367521, '{"menus":[{"name":"짬뽕"},{"name":"중화볶음밥"}]}', '중식');




-- 테이블 삭제 (CASCADE 옵션을 사용하여 연관된 외래키를 가진 테이블도 함께 삭제)
DROP TABLE comments CASCADE;
DROP TABLE posts CASCADE;
DROP TABLE reviews CASCADE;
DROP TABLE restaurants CASCADE;
DROP TABLE reviews_hashtags CASCADE;
DROP TABLE hashtags CASCADE;
DROP TABLE users CASCADE;
-- users 테이블 삭제 (IF EXISTS 옵션 사용하여 테이블이 존재하는 경우에만 삭제)
DROP TABLE IF EXISTS users CASCADE;

-- restaurants 테이블 업데이트
UPDATE restaurants
SET phone = '042-539-8148'
WHERE restaurants_name = '금복집';


SELECT 
    r.id AS review_id,
    r.contents AS review_content,
    r.date AS review_date,
    r.rating,
    res.restaurants_name AS restaurant_name, -- 컬럼 이름 수정
    array_agg(h.contents) AS hashtags
FROM 
    reviews r
JOIN 
    restaurants res ON r.restaurant_id = res.restaurants_id
LEFT JOIN 
    reviews_hashtags rh ON r.id = rh.reviews_id
LEFT JOIN 
    hashtags h ON rh.hashtags_id = h.id
WHERE 
    r.author_id = 1 -- 적절한 author_id 값으로 수정 (정수 값이므로 따옴표 제거)
GROUP BY 
    r.id, res.restaurants_name, r.contents, r.date, r.rating;
