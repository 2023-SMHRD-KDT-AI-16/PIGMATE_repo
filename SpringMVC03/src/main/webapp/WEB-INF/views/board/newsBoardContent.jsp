<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>뉴스</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/styles.min.css" />
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
<script type="text/javascript">
	
	function loadNews(news_idx){
		console.log("ready");
		$.ajax({
			url : "board/newsContent",
			type : "get",
			data : {news_idx : news_idx},
			// dataType : "json",
			success : makeView,
			error : function(){
				alert("error");
			} // error
		}); // ajax
	} // 함수
	
	function makeView(data){
		
		var newsHtml = "<table class='table table-hover' border='1'>";
		newsHtml += "<h1>"+data.news_title+"</h1>";
		newsHtml += "<h3>"+data.news_subtitle+"</h3>";
		newsHtml += "<span>"+data.pressed_at+"</span>";
		newsHtml += data.news_content;
		newsHtml += "<p>"+data.news_url+"</p>";
		newsHtml += "</table>";
			 
		$('#newsContent').html(newsHtml);
	}
	
	$(document).ready(function(){
		var urlParams = new URLSearchParams(window.location.search);
		var news_idx = urlParams.get('news_idx');
		loadNews(news_idx);
	})

</script>

<style>

#newsContent {
	color: black;
}

#news_body_area + p{
	display : none;
}
</style>

</head>

<body>
  <!--  Body Wrapper -->
  <div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full"
    data-sidebar-position="fixed" data-header-position="fixed">
    

<%@ include file="../common/sidebar.jsp"%>
		<div class="body-wrapper">
			<%@ include file="../common/header.jsp"%>

    <!--  Main wrapper -->
      <div class="body-wrapper-inner">
        <div class="container-fluid">
          <div class="card">
            <div class="card-body">
              <h5 class="card-title fw-semibold mb-4">뉴스</h5>
              <div class="table-responsive" id="newsContent">
               
              </div>
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