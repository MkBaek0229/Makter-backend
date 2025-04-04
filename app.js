import express from "express";
import cors from "cors";
import pkg from "pg";
import path from "path";
import { fileURLToPath } from "url";
import { dirname } from "path";
import { getDirections, tashu } from "./app/src/Map/map.ctrl.js";
import session from "express-session";
import restCtrl from "./app/src/restaurants/restaurants.ctrl.js";
import reviewCtrl from "./app/src/Reviews/review.ctrl.js";
import CumintyCtrl from "./app/src/Cuminte/Cuminty.ctrl.js";
import CommentCtrl from "./app/src/Cuminte/Comments.ctrl.js";
import userCtrl from "./app/src/Users/user.ctrl.js";
import dotenv from "dotenv"; // 추가

dotenv.config(); // 추가: .env 파일의 환경 변수를 로드합니다.
const { Pool } = pkg;

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const pool = new Pool({
  user: "postgres",
  password: "VlZW9G1lIUthvV9",
  host: "makterdb.internal",
  database: "postgres",
  port: 5432,
});

// CORS 설정 업데이트
let allowedOrigins = [
  "http://localhost:5173", // 로컬 개발환경
];

// FRONTEND_URL 환경 변수에서 URL 추출하여 추가
if (process.env.FRONTEND_URL) {
  // 쉼표로 구분된 URL 목록을 배열로 변환
  const frontendUrls = process.env.FRONTEND_URL.split(",").map((url) =>
    url.trim()
  );
  allowedOrigins = [...allowedOrigins, ...frontendUrls];
}

const app = express();

app.use(express.json());

app.use(
  cors({
    origin: function (origin, callback) {
      console.log("Request origin:", origin); // 요청 출처 로깅 (중요)
      console.log("Allowed origins:", allowedOrigins); // 허용된 출처 목록 로깅

      // 요청 출처가 없거나 허용 목록에 있으면 허용
      if (!origin || allowedOrigins.includes(origin)) {
        callback(null, true);
      } else {
        console.log(`Origin ${origin} not allowed by CORS`);
        callback(new Error("CORS policy violation"));
      }
    },
    methods: ["GET", "POST", "PUT", "DELETE"],
    credentials: true,
  })
);

app.set("trust proxy", 1);

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

const isProduction = process.env.NODE_ENV === "production";

app.use(
  session({
    secret: process.env.SESSION_SECRET || "your-secret-key",
    resave: false,
    saveUninitialized: false,
    cookie: {
      secure: isProduction, // 개발환경에서는 HTTP 허용
      httpOnly: true,
      sameSite: isProduction ? "none" : "lax",
      maxAge: 1000 * 60 * 60 * 24 * 7,
    },
  })
);

app.set("trust proxy", 1);

app.use(express.static(path.join(__dirname, "public")));

app.get("/", (req, res) => {
  res.send("Hello World");
});

app.get("/api/directions", getDirections);
app.get("/api/tashu", tashu);
// 식당 관련 API
app.get("/api/v1/restaurants", restCtrl.restrs);
app.get("/api/v1/restaurants/id/:restaurants_id", restCtrl.restr);
app.get("/api/v1/restaurants/category/:category", restCtrl.restc);
app.post("/api/v1/restaurants/likes", restCtrl.saveLikes); // 선호 식당 저장
app.get("/api/v1/restaurants/getlikes", restCtrl.getLikes); // 선호 식당 조회
// 리뷰 관련 API
app.post("/api/v1/reviews", reviewCtrl.createreview);
app.delete("/api/v1/reviews/:review_id", reviewCtrl.deletereview);
app.get("/api/v1/reviews/:restaurant_id", reviewCtrl.getReviews);
app.get("/api/v1/restaurants/reviews", reviewCtrl.restreview);
app.get("/api/tags", reviewCtrl.getHashtags);
app.get("/api/v1/user-reviews", isLoggedIn, reviewCtrl.userReviews); // 사용자 리뷰 조회

// 커뮤니티 관련 API
app.get("/api/v1/posts", CumintyCtrl.posts);
app.get("/api/v1/post/:post_id", CumintyCtrl.post);
app.post("/api/v1/post", CumintyCtrl.createpost);
app.put("/api/v1/post/:post_id", CumintyCtrl.remotepost);
app.delete("/api/v1/post/:post_id", CumintyCtrl.deletepost);
app.get("/api/v1/user-posts", isLoggedIn, CumintyCtrl.userPosts); // 유저 커뮤니티 글 조회

// 댓글 관련 API
app.get("/api/v1/comments", CommentCtrl.comments);
app.get("/api/v1/comments/:commentId", CommentCtrl.comment);
app.post("/api/v1/post/:post_id/comments", CommentCtrl.createcomment);
app.delete(
  "/api/v1/post/:post_id/comments/:commentid",
  CommentCtrl.deletecomment
);
app.get("/api/v1/post/:postId/comments", CommentCtrl.getCommentsByPostId);

// 사용자 관련 API
app.post("/api/v1/register", userCtrl.register);
app.post("/api/v1/login", userCtrl.login);
app.post("/api/v1/logout", userCtrl.logout);
app.post("/api/v1/reset-password", userCtrl.requestPasswordReset);
app.post("/api/v1/reset-password/:token", userCtrl.resetPassword);
app.get("/api/v1/check-session", userCtrl.checkSession);
app.get("/api/v1/getprofile", isLoggedIn, userCtrl.getProfile);
app.put("/api/v1/updateprofile", isLoggedIn, userCtrl.updateProfile);
app.post("/api/v1/send-verification-code", userCtrl.sendVerificationCode);
app.post("/api/v1/verify-code", userCtrl.verifyCode);

// 새로운 프론트엔드 경로 추가
app.get("/food", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

export { pool };
