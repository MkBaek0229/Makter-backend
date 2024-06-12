import express from "express";
import cors from "cors";
import pkg from "pg";
import path from "path";
import { fileURLToPath } from "url";
import { dirname } from "path";

// 컨트롤러 임포트
import restCtrl from "./app/src/restaurants/restaurants.ctrl.js";
import reviewCtrl from "./app/src/Reviews/review.ctrl.js";
import CumintyCtrl from "./app/src/Cuminte/Cuminty.ctrl.js";
import CommentCtrl from "./app/src/Cuminte/Comments.ctrl.js";

const { Pool } = pkg;

// 현재 모듈의 URL 가져오기
const __filename = fileURLToPath(import.meta.url);
// 디렉토리 경로 가져오기
const __dirname = dirname(__filename);

// PostgreSQL Pool 설정
const pool = new Pool({
  user: "postgres",
  password: "yMuWQ6WSePBmnPc",
  host: "maketerbackendpostgre.flycast",
  database: "postgres",
  port: 5432,
});

const app = express();

app.use(express.json());

app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE"],
    credentials: true,
    allowedHeaders: ["Content-Type", "Authorization", "token"],
  })
);

// 정적 파일 제공 설정
app.use(express.static(path.join(__dirname, "public")));

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

// API 엔드포인트를 제외한 모든 경로에 대해 index.html 파일 서빙
app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

export { pool };
