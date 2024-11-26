import express from "express";
import cors from "cors";
import pkg from "pg";
import path from "path";
import { fileURLToPath } from "url";
import { dirname } from "path";
import getDirections from "./app/src/Map/map.ctrl.js";
import session from "express-session";
import restCtrl from "./app/src/restaurants/restaurants.ctrl.js";
import reviewCtrl from "./app/src/Reviews/review.ctrl.js";
import CumintyCtrl from "./app/src/Cuminte/Cuminty.ctrl.js";
import CommentCtrl from "./app/src/Cuminte/Comments.ctrl.js";
import userCtrl from "./app/src/Users/user.ctrl.js";

const { Pool } = pkg;

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const pool = new Pool({
  user: "postgres",
  password: "vDSPz2FG01dQkXA",
  host: "maketerbackendtest.flycast",
  database: "postgres",
  port: 5432,
});
/*
Postgres cluster maketerbackendtest created
  Username:    postgres
  Password:    vDSPz2FG01dQkXA
  Hostname:    maketerbackendtest.internal
  Flycast:     fdaa:5:35ca:0:1::6d
  Proxy port:  5432
  Postgres port:  5433
  Connection string: postgres://postgres:vDSPz2FG01dQkXA@maketerbackendtest.flycast:5432
*/
const app = express();

app.use(express.json());

app.use(
  cors({
    origin: "http://localhost:5173",
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

app.use(
  session({
    secret: process.env.SESSION_SECRET || "your-secret-key",
    resave: false,
    saveUninitialized: false,
    cookie: {
      secure: process.env.NODE_ENV === "production",
      httpOnly: false,
      sameSite: process.env.NODE_ENV === "production" ? "none" : "lax",
      maxAge: 1000 * 60 * 60 * 24 * 7,
    },
  })
);

app.set("trust proxy", 1);

app.use(express.static(path.join(__dirname, "public")));

app.get("/api/directions", getDirections);

// 식당 관련 API
app.get("/api/v1/restaurants", restCtrl.restrs);
app.get("/api/v1/restaurants/:restaurants_id", restCtrl.restr);
app.get("/api/v1/restaurants/category/:category", restCtrl.restc);

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
app.get("/api/v1/profile", isLoggedIn, userCtrl.getProfile);
app.put("/api/v1/profile", isLoggedIn, userCtrl.updateProfile);
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
