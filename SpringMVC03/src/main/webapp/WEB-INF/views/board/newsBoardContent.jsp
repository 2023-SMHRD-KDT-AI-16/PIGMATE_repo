<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>뉴스 상세</title>
  <link rel="shortcut icon" type="image/png" href="${pageContext.request.contextPath}/resources/img/logos/piglogos.png" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/styles.min.css" />
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/5.3.0/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>

  <style>
    .news-content-wrapper {
      margin: 20px;
    }

    .news-title {
      font-size: 2em;
      font-weight: bold;
      margin-bottom: 10px;
    }

    .news-subtitle {
      font-size: 1.4em;
      margin-bottom: 15px;
    }

    .news-date {
      font-size: 1.0em;
      color: gray;
      margin-bottom: 20px;
    }

    .news-content {
      font-size: 1.2em;
      line-height: 1.6;
      color: black; /* 글씨체를 검정색으로 설정 */
    }

    .news-thumbnail {
      width: 100%;
      max-width: 600px;
      height: auto;
      margin-bottom: 20px;
    }
    .sidebar-nav .sidebar-item .collapse .sidebar-item {
    padding-left: 20px;
}
    
  </style>
</head>

<body>
  <div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full" data-sidebar-position="fixed" data-header-position="fixed">
    <%@ include file="../common/sidebar.jsp"%>
    <div class="body-wrapper">
      <%@ include file="../common/header.jsp"%>
      <div class="body-wrapper-inner">
        <div class="container-fluid">
          <div class="card">
            <div class="card-body news-content-wrapper" id="newsContent">
              <h5 class="card-title fw-semibold mb-4">뉴스</h5>
              <!-- 뉴스 상세 내용이 여기에 로드됩니다 -->
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script type="text/javascript">
    $(document).ready(function () {
      var urlParams = new URLSearchParams(window.location.search);
      var news_idx = urlParams.get('news_idx');
      loadNews(news_idx);
    });

    function loadNews(news_idx) {
      $.ajax({
        url: "${pageContext.request.contextPath}/board/newsContent",
        type: "get",
        data: { news_idx: news_idx },
        dataType: "json",
        success: function (data) {
          makeView(data);
        },
        error: function () {
          alert("error");
        }
      });
    }

    function makeView(data) {
      var newsHtml = "<h1 class='news-title'>" + data.news_title + "</h1>";
      newsHtml += "<h3 class='news-subtitle'>" + data.news_subtitle + "</h3>";
      newsHtml += "<p class='news-date'>" + data.pressed_at + "</p>";
      if (data.image_url) {
        newsHtml += "<img src='" + data.image_url + "' alt='News Image' class='news-thumbnail'>";
      }
      var contentWithoutImages = data.news_content.replace(/<img[^>]*>/g, ""); // 본문 내용에서 이미지 태그 제거
      newsHtml += "<div class='news-content'>" + contentWithoutImages + "</div>";
      $('#newsContent').html(newsHtml);
    }
  </script>

  <script src="${pageContext.request.contextPath}/resources/libs/jquery/dist/jquery.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/sidebarmenu.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/app.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/libs/apexcharts/dist/apexcharts.min.js"></script>
</body>

</html>