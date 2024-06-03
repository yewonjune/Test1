<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.net.URLEncoder, java.util.*, org.json.simple.*, org.json.simple.parser.JSONParser, org.json.simple.parser.ParseException" %>
<!DOCTYPE html>
<html>
<head>
    <title>JYW</title>
    <style>
        .tour-container {
            display: flex;
            flex-wrap: nowrap;
        }
        .tour-item {
            margin: 5px;
            text-align: center;
        }
        .tour-image {
            width: 150px; 
            height: 100px; 
        }
    </style>
</head>
<body>
    <h2>이런 여행 코스는 어떠세요?</h2>
    <%!
        public String readFile(String filePath) throws IOException {
            BufferedReader reader = new BufferedReader(new FileReader(filePath));
            StringBuilder stringBuilder = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                stringBuilder.append(line);
            }
            reader.close();
            return stringBuilder.toString();
        }
    %>
    <%
        String filePath = request.getRealPath("/w/data.json");
        
        String jsonData = readFile(filePath);
        JSONParser parser = new JSONParser();
        try {
            Object obj = parser.parse(jsonData);
            JSONArray jsonArray = (JSONArray) obj;
            JSONArray tourData = new JSONArray();
            int count = 0;
            for (Object entry : jsonArray) {
                JSONObject jsonObject = (JSONObject) entry;
                
                if (jsonObject.get("관광지명") != null) {
                    String tourName = (String) jsonObject.get("관광지명");
                    
                    if (tourName.contains("인천")) {
                        tourData.add(jsonObject);
                        count++;
                    }
                }
                if (count >= 6) {
                    break;
                }
            }
            out.println("<div class='tour-container'>");
            for (Object entry : tourData) {
                JSONObject jsonObject = (JSONObject) entry;
                String tourCity = (String) jsonObject.get("관광지명");
                String imagePath = "./image/" + tourCity + ".jpg";
                String encodedTourCity = URLEncoder.encode(tourCity, "UTF-8");
                
                out.println("<div class='tour-item'>");
                out.println("<a href='detailedPage.jsp?tourCity=" + encodedTourCity + "'>");
                out.println("<img class='tour-image' src='" + imagePath + "' alt='" + tourCity + " 이미지'>");
                out.println("</a>");
                out.println("<p>" + tourCity + "</p>");
                out.println("</div>");
            }
            out.println("</div>");
        } catch (ParseException e) {
            e.printStackTrace();
        }
    %>
</body>
</html>
