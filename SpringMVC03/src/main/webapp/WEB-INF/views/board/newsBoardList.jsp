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
		newsList();
	});

	function newsList() {

		$.ajax({
			url : "board/newsList",
			type : "get",
			dataType : "json",
			success : makeView,
			error : function() {
				alert("error");
			} // 에러

		}); // ajax
	}

	function makeView(data) {
		console.log(data);
		var listHtml = "<table class='table  table-hover' border='1' >";
		listHtml += "<thead class='table-info' style='font-size: smaller;'>";
		listHtml += "<tr>";
		listHtml += "<th scope='col'>#</th>";
		listHtml += "<th scope='col'>제목</th>";
		listHtml += "<th scope='col'>등록일자</th>";
		listHtml += "</tr>";
		listHtml += "</thead>";
		listHtml += "<tbody style='font-size: smaller;'>";

		// jQuery 반복문
		$.each(data, function(index, obj) {
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