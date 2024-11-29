import pkg from "pg";
import { pool } from "../../../app.js";

//다건
const restrs = async (req, res) => {
  try {
    const { rows } = await pool.query("SELECT * FROM restaurants");
    console.log(rows);
    res.json({
      resultCode: "S-1",
      msg: "성공",
      data: rows,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      resultCode: "F-1",
      msg: "에러 발생",
    });
  }
};
// 단건
const restr = async (req, res) => {
  try {
    const id = req.params.restaurants_id;
    const { rows } = await pool.query(
      "SELECT * FROM restaurants WHERE restaurants_id = $1",
      [id]
    );
    res.json({
      resultCode: "S-1",
      msg: "성공",
      data: rows[0],
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      resultCode: "F-1",
      msg: "에러 발생",
    });
  }
}; // 특정 카테고리의 식당 데이터를 반환하는 엔드포인트
const restc = async (req, res) => {
  const category = req.params.category;

  try {
    const { rows } = await pool.query(
      "SELECT * FROM restaurants WHERE category = $1::text",
      [category]
    );

    res.json({
      resultCode: "S-1",
      msg: "성공",
      data: rows,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      resultCode: "F-1",
      msg: "에러 발생",
    });
  }
};
//식당 저장 테이블
const saveLikes = async (req, res) => {
  const userId = req.session.userId; // 로그인된 사용자 ID
  const { restaurantIds } = req.body; // 클라이언트에서 보내온 식당 ID 배열

  if (!userId) {
    return res.status(401).json({
      resultCode: "F-1",
      msg: "로그인이 필요합니다.",
    });
  }

  if (!Array.isArray(restaurantIds) || restaurantIds.length === 0) {
    return res.status(400).json({
      resultCode: "F-2",
      msg: "식당 ID 배열이 필요합니다.",
    });
  }

  try {
    // 기존 데이터 삭제
    await pool.query("DELETE FROM LikeTable WHERE user_id = $1", [userId]);

    // 새 데이터 삽입
    const values = restaurantIds.map((id) => `(${userId}, ${id})`).join(", ");
    const query = `INSERT INTO LikeTable (user_id, restaurants_id) VALUES ${values}`;
    await pool.query(query);

    return res.json({
      resultCode: "S-1",
      msg: "선호 식당이 성공적으로 저장되었습니다.",
    });
  } catch (error) {
    console.error("Error saving likes:", error);
    res.status(500).json({
      resultCode: "F-3",
      msg: "서버 오류가 발생했습니다.",
    });
  }
};
// 선호식당 가져오기
const getLikes = async (req, res) => {
  try {
    const userId = req.session?.userId; // 세션에서 userId 가져오기
    console.log("userId:", userId); // 디버깅

    if (!userId || isNaN(userId)) {
      // userId가 숫자가 아닌 경우 처리
      return res.status(400).json({
        resultCode: "F-2",
        msg: "유효한 사용자 ID가 필요합니다.",
      });
    }

    const query = `
      SELECT r.restaurants_id, r.restaurants_name, r.address, r.phone, r.opening_hours, r.rating,
             r.spicy, r.sweet, r.sour, r.salty, r.food_type, r.image, r.latitude, r.longitude
      FROM LikeTable l
      JOIN restaurants r ON l.restaurants_id = r.restaurants_id
      WHERE l.user_id = $1;
    `;
    console.log("Executing query:", query); // SQL 디버깅
    const { rows } = await pool.query(query, [userId]);

    res.json({
      resultCode: "S-1",
      msg: "선호 식당 데이터를 성공적으로 조회했습니다.",
      data: rows,
    });
  } catch (error) {
    console.error("선호 식당 조회 중 오류:", error.message);
    res.status(500).json({
      resultCode: "F-1",
      msg: "선호 식당 데이터를 조회하는 중 오류가 발생했습니다.",
      error: error.message,
    });
  }
};

export default {
  restrs,
  restr,
  restc,
  saveLikes,
  getLikes,
};
