<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>뉴스 목록</title>
<link rel="shortcut icon" type="image/png"
	href="${pageContext.request.contextPath}/resources/images/person.png" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/styles.min.css" />
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		newsList(1);
	});

	// 뉴스 데이터 가져오는 함수
	function newsList(page) {

		$.ajax({
			url : "board/newsList",
			type : "get",
			data: { page: page },
			dataType : "json",
			success : function(data){
				makeView(data.newsList);
				makePagination(data.pageMaker);
			},
			error : function() {
				alert("error");
			} // 에러

		}); // ajax
	}

	// 뉴스 불러와서 목록으로 띄워주는 함수
	function makeView(newsList) {
		console.log(newsList);
		var listHtml = "<table class='table  table-hover' border='1'>";
		listHtml += "<thead class='table-info' style='font-size: smaller;'>";
		listHtml += "<tr>";
		listHtml += "<th scope='col'></th>";
		listHtml += "<th scope='col'>제목</th>";
		listHtml += "<th scope='col'>등록일자</th>";
		listHtml += "</tr>";
		listHtml += "</thead>";
		listHtml += "<tbody style='font-size: smaller;'>";

		// jQuery 반복문
		$.each(newsList, function(index, obj) {
			listHtml += "<tr>";
			listHtml += "<th scope='row'>" + (index + 1) + "</th>";
			listHtml += "<td id='t"+obj.news_idx+"'><a href='news?news_idx="
					+ obj.news_idx + "'>" + obj.news_title + "</a></td>";
			listHtml += "<td>" + obj.pressed_at.split(' ')[0] + "</td>";
			listHtml += "</tr>";

		}) // 반복문

		listHtml += "</tbody>";
		listHtml += "</table>";

		$('#newsListView').html(listHtml);

	} // 함수
	
	function makePagination(pageMaker) {
	    var paginationHtml = "<ul class='pagination justify-content-center'>"; // 부트스트랩 클래스를 사용하여 페이지 버튼을 가운데 정렬
	    
	    if (pageMaker.prev) {
	        paginationHtml += "<li class='page-item'><a class='page-link' href='#' onclick='newsList(" + (pageMaker.startPage - 1) + ")'>Previous</a></li>";
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