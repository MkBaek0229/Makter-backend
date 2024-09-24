import axios from "axios";

const limitDecimals = (coord) => {
  return parseFloat(coord).toFixed(6); // 소수점 6자리로 제한
};

const getDirections = async (req, res) => {
  let { origin, destination } = req.query;
  const apiKey =
    process.env.VITE_KAKAO_REST_API_KEY || "92be558050bf327c8f008ccd01021afd";

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

export default getDirections;
