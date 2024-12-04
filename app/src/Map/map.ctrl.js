import axios from "axios";

import dotenv from "dotenv";

dotenv.config(); // .env 파일의 환경 변수를 로드합니다.

const limitDecimals = (coord) => {
  return parseFloat(coord).toFixed(6); // 소수점 6자리로 제한
};

const getDirections = async (req, res) => {
  let { origin, destination } = req.query;
  const apiKey = process.env.VITE_KAKAO_REST_API_KEY;

  // 소수점 이하 자릿수를 제한
  const originCoords = origin.split(",");
  const destinationCoords = destination.split(",");

  origin = `${limitDecimals(originCoords[0])},${limitDecimals(
    originCoords[1]
  )}`;
  destination = `${limitDecimals(destinationCoords[0])},${limitDecimals(
    destinationCoords[1]
  )}`;

  try {
    const response = await axios.get(
      "https://apis-navi.kakaomobility.com/v1/directions",
      {
        headers: { Authorization: `KakaoAK ${apiKey}` },
        params: { origin, destination },
      }
    );

    console.log("Kakao Directions API 응답:", response.data);

    res.json({
      resultCode: "S-1",
      msg: "성공",
      data: response.data,
    });
  } catch (error) {
    console.error("Kakao Directions API 호출 실패:", error.message);

    res.status(500).json({
      resultCode: "F-1",
      msg: "Kakao Directions API 호출 실패",
      error: error.message,
    });
  }
};
const tashu = async (req, res) => {
  console.log("tashu 함수 시작");
  try {
    const apiUrl = "https://bikeapp.tashu.or.kr:50041/v1/openapi/station";
    const apiToken = process.env.TASHU_API_TOKEN;

    console.log("Tashu API 요청 시작");
    const response = await axios.get(apiUrl, {
      headers: {
        "api-token": apiToken,
      },
      timeout: 10000,
    });
    console.log("Tashu API 응답 받음:", response.data);

    res.json({
      resultCode: "S-1",
      msg: "성공",
      data: response.data,
    });
  } catch (error) {
    console.error("Tashu API 호출 실패:", error);
    res.status(500).json({
      resultCode: "F-1",
      msg: "Tashu API 호출 실패",
      error: error.message,
    });
  }
  console.log("tashu 함수 종료");
};
export { getDirections, tashu };
