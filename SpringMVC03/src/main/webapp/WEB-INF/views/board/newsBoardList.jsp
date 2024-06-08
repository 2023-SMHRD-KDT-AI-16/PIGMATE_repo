<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>뉴스 목록</title>
<link rel="shortcut icon" type="image/png"
   href="${pageContext.request.contextPath}/resources/img/logos/piglogos.png" />
<link rel="stylesheet"
   href="${pageContext.request.contextPath}/resources/css/styles.min.css" />
<link rel="stylesheet"
   href="https://maxcdn.bootstrapcdn.com/bootstrap/5.3.0/css/bootstrap.min.css">
<script
   src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
<script
   src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
<style>
.news-list {
    display: flex;
    flex-direction: column;
}
.news-item {
    display: flex;
    margin-bottom: 15px;
}
.news-thumbnail {
    width: 100px;
    height: 100px;
    object-fit: cover;
    margin-right: 15px;
    border-radius: 8px; /* 이미지 라운드 처리 */
}
.news-details {
    display: flex;
    flex-direction: column;
}
.news-title {
    font-size: 1.5em; /* 제목 크기 조정 */
    margin: 0;
}
.news-subtitle {
    font-size: 1.0em; /* 부제목 크기 조정 */
    margin: 0;
}
.news-date {
    font-size: 0.8em;
    color: gray;
}
</style>

<script type="text/javascript">
   $(document).ready(function() {
      newsList(1);
   });

   // 뉴스 데이터 가져오는 함수
   function newsList(page) {

      $.ajax({
         url : "board/newsList",
         type : "get",
         data : {
            page : page
         },
         dataType : "json",
         success : function(data) {
            makeView(data.newsList, data.pageMaker); // 추가: pageMaker 데이터 전달
            makePagination(data.pageMaker);
         },
         error : function() {
            alert("error");
         } // 에러

      }); // ajax
   }

   // 뉴스 불러와서 목록으로 띄워주는 함수
   function makeView(newsList, pageMaker) { // 추가: pageMaker 매개변수 추가
       console.log(newsList);
       var listHtml = "<div class='news-list'>";
       $.each(newsList, function(index, obj) {
           var rowIndex = (pageMaker.cri.page - 1) * 10 + index + 1;
           var imageUrl = obj.news_url ? obj.news_url : 'path/to/default/image.jpg';
           listHtml += "<div class='news-item'>";
           listHtml += "<img src='" + imageUrl + "' alt='News Image' class='news-thumbnail'>";
           listHtml += "<div class='news-details'>";
           listHtml += "<h2 class='news-title'><a href='news?news_idx=" + obj.news_idx + "'>" + obj.news_title + "</a></h2>";
           listHtml += "<h4 class='news-subtitle'>" + obj.news_subtitle + "</h4>";
           listHtml += "<p class='news-date'>" + obj.pressed_at.split(' ')[0] + "</p>";
           listHtml += "</div></div>";
       });
       listHtml += "</div>";

      $('#newsListView').html(listHtml);

   } // 함수

   function makePagination(pageMaker) {
      var paginationHtml = "<ul class='pagination justify-content-center'>"; // 부트스트랩 클래스를 사용하여 페이지 버튼을 가운데 정렬

      if (pageMaker.prev) {
         paginationHtml += "<li class='page-item'><a class='page-link' href='javascript:void(0);' onclick='newsList("
               + (pageMaker.startPage - 1) + ")'>Previous</a></li>";
      }

      for (var i = pageMaker.startPage; i <= pageMaker.endPage; i++) {
         if (i === pageMaker.cri.page) {
            paginationHtml += "<li class='page-item active'><a class='page-link' href='javascript:void(0);'>" + i + "</a></li>";
         } else {
            paginationHtml += "<li class='page-item'><a class='page-link' href='javascript:void(0);' onclick='newsList(" + i + ")'>" + i + "</a></li>";
         }
      }

      if (pageMaker.next) {
         paginationHtml += "<li class='page-item'><a class='page-link' href='javascript:void(0);' onclick='newsList(" + (pageMaker.endPage + 1) + ")'>Next</a></li>";
      }

      paginationHtml += "</ul>";

      $('#pagination').html(paginationHtml);
   }
</script>
</head>

<body>
   <!--  Body Wrapper -->
   <div class="page-wrapper" id="main-wrapper" data-layout="vertical"
      data-navbarbg="skin6" data-sidebartype="full"
      data-sidebar-position="fixed" data-header-position="fixed">


      <%@ include file="../common/sidebar.jsp"%>
      <div class="body-wrapper">
         <%@ include file="../common/header.jsp"%>

         <!--  Main wrapper -->

         <div class="body-wrapper-inner">
            <div class="container-fluid">
               <div class="card">
                  <div class="card-body">
                     <h5 class="card-title fw-semibold mb-4">뉴스 목록</h5>
                     <div class="table-responsive" id="newsListView"></div>
                     <div id="pagination"></div>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </div>
   <script
      src="${pageContext.request.contextPath}/resources/libs/jquery/dist/jquery.min.js"></script>
   <script
      src="${pageContext.request.contextPath}/resources/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
   <script
      src="${pageContext.request.contextPath}/resources/js/sidebarmenu.js"></script>
   <script
      src="${pageContext.request.contextPath}/resources/js/app.min.js"></script>
   <script
      src="${pageContext.request.contextPath}/resources/libs/apexcharts/dist/apexcharts.min.js"></script>

</body>

</html>