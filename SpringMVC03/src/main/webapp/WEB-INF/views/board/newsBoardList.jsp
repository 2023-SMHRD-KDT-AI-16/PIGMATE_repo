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
.sidebar-nav .sidebar-item .collapse .sidebar-item {
	padding-left: 20px;
}

.news-list {
	display: flex;
	flex-direction: column;
}

.news-item {
	display: flex;
	margin-bottom: 30px;
	align-items: flex-start;
	border-bottom: 1px solid #ddd;
	padding-bottom: 15px;
}

.news-thumbnail {
	width: 150px;
	height: 150px;
	min-width: 150px;
	min-height: 150px;
	object-fit: cover;
	margin-right: 15px;
	border-radius: 8px;
}

.news-details {
	display: flex;
	flex-direction: column;
	flex-grow: 1;
}

.news-title {
	font-size: 1.4em;
	font-weight: bold;
	margin: 0;
	margin-top: 10px;
}

.news-subtitle {
	font-size: 1.1em;
	margin: 5px 0;
	margin-top: 10px; /* 뉴스 제목과 부제목 간격 넓히기 */
}

.news-content {
	font-size: 1.0em;
	margin: 10px 0; /* 본문과 다른 요소 사이의 간격 넓히기 */
	flex-grow: 1;
}

.news-date {
	font-size: 1.0em;
	color: gray;
	margin-top: 10px; /* 날짜와 다른 요소 사이의 간격 넓히기 */
}

.card-title.fw-semibold {
	font-size: 1.8em;
	color: #2c3e50;
	border-bottom: 2px solid #2c3e50;
	padding-bottom: 10px;
}
</style>
</head>

<body>
	<div class="page-wrapper" id="main-wrapper" data-layout="vertical"
		data-navbarbg="skin6" data-sidebartype="full"
		data-sidebar-position="fixed" data-header-position="fixed">
		<%@ include file="../common/sidebar.jsp"%>
		<div class="body-wrapper">
			<%@ include file="../common/header.jsp"%>
			<div class="body-wrapper-inner">
				<div class="container-fluid">
					<div class="card">
						<div class="card-body">
							<h5 class="card-title fw-semibold mb-4">뉴스 목록</h5>
							<div id="newsListView" class="table-responsive"></div>
							<div id="pagination"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript">
		$(document).ready(function() {
			newsList(1);
		});

		function newsList(page) {
			$.ajax({
				url : "${pageContext.request.contextPath}/board/newsList",
				type : "get",
				data : {
					page : page
				},
				dataType : "json",
				success : function(data) {
					makeView(data.newsList, data.pageMaker);
					makePagination(data.pageMaker);
				},
				error : function() {
					alert("error");
				}
			});
		}

		function makeView(newsList, pageMaker) {
			console.log(newsList);
			var listHtml = "<div class='news-list'>";
			$
					.each(
							newsList,
							function(index, obj) {
								var rowIndex = (pageMaker.cri.page - 1) * 10
										+ index + 1;
								var imageUrl = obj.image_url ? obj.image_url
										: '${pageContext.request.contextPath}/resources/img/default-image.jpg';
								var contentPreview = obj.news_content ? obj.news_content
										.replace(/<\/?[^>]+(>|$)/g, "")
										.replace(/[\r\n]/g, "").substring(0,
												150)
										+ "..."
										: ""; // 글자수 150자로 제한, HTML 태그 제거
								listHtml += "<div class='news-item'>";
								listHtml += "<img src='" + imageUrl + "' alt='News Image' class='news-thumbnail'>";
								listHtml += "<div class='news-details'>";
								listHtml += "<h2 class='news-title'><a href='news?news_idx="
										+ obj.news_idx
										+ "'>"
										+ obj.news_title
										+ "</a></h2>";
								listHtml += "<h4 class='news-subtitle'>"
										+ obj.news_subtitle + "</h4>";
								listHtml += "<p class='news-content'>"
										+ contentPreview + "</p>";
								listHtml += "<p class='news-date'>"
										+ obj.pressed_at.split(' ')[0] + "</p>";
								listHtml += "</div></div>";
							});
			listHtml += "</div>";
			$('#newsListView').html(listHtml);
		}

		function makePagination(pageMaker) {
			var paginationHtml = "<ul class='pagination justify-content-center'>";
			if (pageMaker.prev) {
				paginationHtml += "<li class='page-item'><a class='page-link' href='javascript:void(0);' onclick='newsList("
						+ (pageMaker.startPage - 1) + ")'>Previous</a></li>";
			}
			for (var i = pageMaker.startPage; i <= pageMaker.endPage; i++) {
				if (i === pageMaker.cri.page) {
					paginationHtml += "<li class='page-item active'><a class='page-link' href='javascript:void(0);'>"
							+ i + "</a></li>";
				} else {
					paginationHtml += "<li class='page-item'><a class='page-link' href='javascript:void(0);' onclick='newsList("
							+ i + ")'>" + i + "</a></li>";
				}
			}
			if (pageMaker.next) {
				paginationHtml += "<li class='page-item'><a class='page-link' href='javascript:void(0);' onclick='newsList("
						+ (pageMaker.endPage + 1) + ")'>Next</a></li>";
			}
			paginationHtml += "</ul>";
			$('#pagination').html(paginationHtml);
		}
	</script>

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