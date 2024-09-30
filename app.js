import express from "express";
import cors from "cors";
import pkg from "pg";
import path from "path";
import { fileURLToPath } from "url";
import { dirname } from "path";
import getDirections from "./app/src/Map/map.ctrl.js"; // Kakao Directions API 컨트롤러 임포트
import session from "express-session";
import restCtrl from "./app/src/restaurants/restaurants.ctrl.js";
import reviewCtrl from "./app/src/Reviews/review.ctrl.js";
import CumintyCtrl from "./app/src/Cuminte/Cuminty.ctrl.js";
import CommentCtrl from "./app/src/Cuminte/Comments.ctrl.js";
import userCtrl from "./app/src/Users/user.ctrl.js";

const { Pool } = pkg;

// 현재 모듈의 URL 가져오기
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// PostgreSQL Pool 설정
const pool = new Pool({
  user: "postgres",
  password: "SxTxKggFywCiaFt",
  host: "makterbackend.flycast",
  database: "postgres",
  port: 5432,
});

const app = express();

app.use(express.json());

app.use(
  cors({
    origin: "http://localhost:5173", // 클라이언트 URL
    methods: ["GET", "POST", "PUT", "DELETE"],
    credentials: true, // 쿠키 허용
  })
);

const isLoggedIn = (req, res, next) => {
  if (req.session && req.session.userId) {
    next();
  } else {
    res.status(401).json({
      resultCode: "F-2",
      msg: "로그인이 필요합니다.",
    });
  }
};

app.use(
  session({
    secret: process.env.SESSION_SECRET || "your-secret-key",
    resave: false,
    saveUninitialized: false,
    cookie: {
      secure: process.env.NODE_ENV === "production", // HTTPS에서만 작동
      httpOnly: true,
      sameSite: "none",
      maxAge: 1000 * 60 * 60 * 24 * 7, // 1주일
    },
  })
);

app.set("trust proxy", 1); // 프록시 신뢰 설정
// 정적 파일 제공 설정
app.use(express.static(path.join(__dirname, "public")));

// Kakao Directions API 호출
app.get("/api/directions", getDirections); // Kakao Directions API 호출 엔드포인트 추가

// 식당 정보 다건 조회
app.get("/api/v1/restaurants", restCtrl.restrs);

// 식당 단건 조회
app.get("/api/v1/restaurants/:restaurants_id", restCtrl.restr);

// 예시 : 특정 카테고리의 식당 정보 조회
app.get("/api/v1/restaurants/category/:category", restCtrl.restc);

// 예시: 리뷰 생성
app.post("/api/v1/reviews", reviewCtrl.createreview);

// 예시: 리뷰 삭제
app.delete("/api/v1/reviews/:review_id", reviewCtrl.deletereview);

// 식당별 리뷰 조회
app.get("/api/v1/reviews/:restaurant_id", reviewCtrl.getReviews);

// 예시: 특정 식당의 리뷰 목록 조회
app.get("/api/v1/restaurants/reviews", reviewCtrl.restreview);

app.get("/api/tags", reviewCtrl.getHashtags);

// 커뮤니티 포스트 다건 조회
app.get("/api/v1/posts", CumintyCtrl.posts);

// 커뮤니티 포스트 단건 조회
app.get("/api/v1/post/:post_id", CumintyCtrl.post);

// 커뮤니티 포스트 생성
app.post("/api/v1/post", CumintyCtrl.createpost);

// 커뮤니티 포스트 수정
app.put("/api/v1/post/:post_id", CumintyCtrl.remotepost);

// 커뮤니티 포스트 삭제
app.delete("/api/v1/post/:post_id", CumintyCtrl.deletepost);

// 댓글 다건 조회
app.get("/api/v1/comments", CommentCtrl.comments);

// 댓글 단건 조회
app.get("/api/v1/comments/:commentId", CommentCtrl.comment);

// 댓글 생성
app.post("/api/v1/post/:post_id/comments", CommentCtrl.createcomment);

// 댓글 삭제
app.delete(
  "/api/v1/post/:post_id/comments/:commentid",
  CommentCtrl.deletecomment
);

// 특정 포스트에 대한 댓글 조회
app.get("/api/v1/post/:postId/comments", CommentCtrl.getCommentsByPostId);

app.get("/", (req, res) => {
  res.send("Hello World!");
});

// 새로운 프론트엔드 경로 추가
app.get("/food", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

app.get("/service", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

app.get("/review", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

app.get("/review/:id", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

app.get("/MainListPage", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

app.get("/MainWritePage", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

app.get("/category/:category", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

app.get("/EditPage/:postId", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

app.get("/Post/:postId", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

app.post("/api/v1/register", userCtrl.register); // 회원가입
app.post("/api/v1/login", userCtrl.login); // 로그인
app.post("/api/v1/logout", userCtrl.logout); // 로그아웃
app.post("/api/v1/reset-password", userCtrl.requestPasswordReset); // 비밀번호 재설정 요청
app.post("/api/v1/reset-password/:token", userCtrl.resetPassword); // 비밀번호 재설정
app.get("/api/v1/check-session", userCtrl.checkSession); // 세션 상태 확인
app.get("/api/v1/profile", isLoggedIn, userCtrl.getProfile); // 프로필 조회 (로그인 필요)
app.put("/api/v1/profile", isLoggedIn, userCtrl.updateProfile); // 프로필 수정 (로그인 필요)

app.post("/api/v1/send-verification-code", userCtrl.sendVerificationCode); // SMS 인증코드 전송
app.post("/api/v1/verify-code", userCtrl.verifyCode); // SMS 인증코드 확인
// API 엔드포인트를 제외한 모든 경로에 대해 index.html 파일 서빙
app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

export { pool };
