<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<!doctype html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Matdash Free</title>
<link rel="shortcut icon" type="image/png"
	href="${contextPath}/resources/img/logos/favicon.png" />

<link rel="stylesheet"
	href="${contextPath}/resources/css/styles.min.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

<style>
.news-title {
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	display: block;
	max-width: 300px; /* 필요에 따라 조정 가능 */
}

.table-custom tbody td {
	max-width: 200px; /* 필요에 따라 조정 가능 */
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.env-info-container {
	display: flex;
	flex-wrap: wrap;
	justify-content: space-between;
	margin: 20px 0;
}

.env-info-box {
	flex: 0 0 48%; /* 크기를 2열로 맞추기 위해 설정 */
	text-align: center;
	padding: 20px;
	margin: 10px 0;
	border: 1px solid #ddd;
	border-radius: 10px;
	background-color: #f9f9f9;
}

.env-info-box h6 {
	margin-bottom: 5px;
}

.env-info-box span {
	display: block;
	font-size: 50px;
	margin-bottom: 5px;
}

.env-info-box .status {
	font-size: 18px;
}
</style>

<script
	src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
<script src="${contextPath}/resources/libs/jquery/dist/jquery.min.js"></script>
<script
	src="${contextPath}/resources/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
<script src="${contextPath}/resources/js/sidebarmenu.js"></script>
<script src="${contextPath}/resources/js/app.min.js"></script>
<script
	src="${contextPath}/resources/libs/apexcharts/dist/apexcharts.min.js"></script>
<script src="${contextPath}/resources/js/dashboard.js"></script>

<script type="text/javascript">
   $(document).ready(function() {
      console.log("Document is ready");
      newsList();
      loadEnvInfo();
      loadEnvCriteria(); // 환경 기준 데이터를 로드합니다.
   });

   function newsList() {
      $.ajax({
         url : "board/newsList",
         type : "get",
         dataType : "json",
         success : function(data) {
            console.log("받은 데이터 구조:", data); // 데이터 구조 확인
            makeView(data);
         },
         error : function() {
            alert("news error");
         }
      });
   }

   function makeView(data) {
      console.log("받은 데이터:", data); // 데이터 구조 확인
      var listHtml = "";

      // 서버에서 반환된 데이터 구조에 맞게 경로 수정
      if (data.newsList) {
         $.each(data.newsList.slice(0, 8), function(index, obj) { // 첫 8개 항목만 처리
            console.log("뉴스 데이터 이동 성공");
            console.log("뉴스 객체:", obj); // 각 뉴스 객체 확인
            listHtml += "<tr>";
            listHtml += "<td colspan='2'>";
            listHtml += "<a href='news?news_idx=" + obj.news_idx
                  + "' class='news-title'>" + obj.news_title + "</a>";
            listHtml += "</td>";
            listHtml += "</tr>";
         });
      } else {
         console.error("뉴스 데이터를 찾을 수 없습니다.");
      }

      $("#index_newsList").html(listHtml);
   }

   function loadEnvInfo() {
      $.ajax({
         url : "index/env",
         type : "post",
         dataType : "json",
         success : function(data) {
            console.log("환경 정보:", data);
            displayEnvInfo(data);
            loadEnvCriteria(data); // 환경 정보를 로드한 후 환경 기준 데이터를 로드합니다.
         },
         error : function() {
            alert("환경 정보 로드 오류");
         }
      });
   }

   function loadEnvCriteria(envData) {
      $.ajax({
         url: "env/criteria",
         type: "get",
         dataType: "json",
         success: function(criteria) {
            console.log("환경 기준:", criteria);
            updateEnvStatus(envData, criteria); // 환경 기준 데이터를 사용하여 상태 업데이트
         },
         error: function() {
            alert("환경 기준 정보 로드 오류");
         }
      });
   }

   function displayEnvInfo(data) {
      var temperature = "N/A";
      var humidity = "N/A";
      var co2 = "N/A";
      var ammonia = "N/A";

      if (data.length > 0) {
         var latestEnv = data[data.length - 1]; // 최신 데이터 사용
         temperature = latestEnv.temperature + "°C";
         humidity = latestEnv.humidity + "%";
         co2 = latestEnv.co2 + "ppm";
         ammonia = latestEnv.ammonia + "mg/m³";
      }

      $("#temperature").text(temperature);
      $("#humidity").text(humidity);
      $("#co2").text(co2);
      $("#ammonia").text(ammonia);
   }

   function updateEnvStatus(envData, criteria) {
      var latestEnv = envData[envData.length - 1];

      // 오차 범위 10% 계산
      var tempRange = { min: criteria.temperature * 0.9, max: criteria.temperature * 1.1 };
      var humidityRange = { min: criteria.humidity * 0.9, max: criteria.humidity * 1.1 };
      var co2Range = { min: criteria.co2 * 0.9, max: criteria.co2 * 1.1 };
      var ammoniaRange = { min: criteria.ammonia * 0.9, max: criteria.ammonia * 1.1 };

      // 환경 정보 상태 업데이트
      updateStatus("#temperature", latestEnv.temperature, tempRange);
      updateStatus("#humidity", latestEnv.humidity, humidityRange);
      updateStatus("#co2", latestEnv.co2, co2Range);
      updateStatus("#ammonia", latestEnv.ammonia, ammoniaRange);
   }

   function updateStatus(elementId, value, range) {
      var element = $(elementId);
      var statusElement = element.siblings(".status");

      if (value < range.min || value > range.max) {
         element.css("color", "red");
         statusElement.text("위험해요").css("color", "red");
      } else {
         element.css("color", "green");
         statusElement.text("쾌적해요").css("color", "green");
      }
   }
</script>

</head>

<body>
	<div class="page-wrapper" id="main-wrapper" data-layout="vertical"
		data-navbarbg="skin6" data-sidebartype="full"
		data-sidebar-position="fixed" data-header-position="fixed">
		<%@ include file="common/sidebar.jsp"%>
		<div class="body-wrapper">
			<%@ include file="common/header.jsp"%>
			<div class="body-wrapper-inner">
				<div class="container-fluid">
					<!--  Row 1 -->
					<div class="row">
						<div class="col-lg-8 d-flex align-items-stretch">
							<div class="card w-100">
								<div class="card-body">
									<div
										class="d-sm-flex d-block align-items-center justify-content-between mb-9">
										<div class="mb-3 mb-sm-0">
											<h5 class="card-title fw-semibold">축사환경</h5>
										</div>
										<div>
											<select class="form-select">
												<option value="1">March 2024</option>
												<option value="2">April 2024</option>
												<option value="3">May 2024</option>
												<option value="4">June 2024</option>
											</select>
										</div>
									</div>
									<!-- 축사환경 영상 -->
								</div>
							</div>
						</div>

						<div class="col-lg-4">
							<div class="row">
								<div class="col-lg-12">
									<div class="card">
										<div class="card-body">
											<div class="d-flex align-items-center gap-6 mb-4 pb-3">
												<span
													class="round-48 d-flex align-items-center justify-content-center rounded bg-secondary-subtle">
													<iconify-icon icon="solar:football-outline"
														class="fs-6 text-secondary"></iconify-icon>
												</span>
												<h6 class="mb-0 fs-4">앉아있는 돼지 수</h6>
											</div>
											<div
												class="d-flex align-items-center justify-content-between mb-6">
												<h6 class="mb-0 fw-medium">객체 탐지 결과</h6>
												<h6 class="mb-0 fw-medium">8두</h6>
											</div>
											<div class="progress" role="progressbar"
												aria-label="Basic example" aria-valuenow="25"
												aria-valuemin="0" aria-valuemax="100" style="height: 7px;">
												<div class="progress-bar bg-secondary" style="width: 83%"></div>
											</div>
										</div>
									</div>
								</div>
								<div class="col-lg-12">
									<div class="card">
										<div class="card-body">
											<div class="d-flex align-items-center gap-6 mb-4 pb-3">
												<span
													class="round-48 d-flex align-items-center justify-content-center rounded bg-warning-subtle">
													<iconify-icon icon="solar:football-outline"
														class="fs-6 text-warning"></iconify-icon>
												</span>
												<h6 class="mb-0 fs-4">서 있는 돼지 수</h6>
											</div>
											<div
												class="d-flex align-items-center justify-content-between mb-6">
												<h6 class="mb-0 fw-medium">객체 탐지 결과</h6>
												<h6 class="mb-0 fw-medium">5두</h6>
											</div>
											<div class="progress" role="progressbar"
												aria-label="Basic example" aria-valuenow="25"
												aria-valuemin="0" aria-valuemax="100" style="height: 7px;">
												<div class="progress-bar bg-warning" style="width: 53%"></div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>

					<!-- 환경 정보 요약 -->

					<div class="row">
						<div class="col-lg-8 d-flex align-items-stretch">
							<div class="card w-100">
								<div class="card-body">
									<h5 class="card-title fw-semibold mb-4">환경 정보 요약</h5>
									<div class="env-info-container">
										<div class="env-info-box">
											<h6>온도</h6>
											<span id="temperature">N/A</span>
											<div class="status"></div>
										</div>
										<div class="env-info-box">
											<h6>습도</h6>
											<span id="humidity">N/A</span>
											<div class="status"></div>
										</div>
										<div class="env-info-box">
											<h6>이산화탄소</h6>
											<span id="co2">N/A</span>
											<div class="status"></div>
										</div>
										<div class="env-info-box">
											<h6>암모니아</h6>
											<span id="ammonia">N/A</span>
											<div class="status"></div>
										</div>
									</div>
								</div>
							</div>
						</div>

						<!-- 한돈 뉴스-->

						<div class="col-lg-4 d-flex align-items-stretch">
							<div class="card w-100">
								<div class="card-body p-4">
									<h5 class="card-title fw-semibold mb-4">한돈 뉴스</h5>
									<div class="table-responsive" data-simplebar>
										<table
											class="table text-nowrap align-middle table-custom mb-0">
											<thead>
												<tr>
													<th scope="col" class="text-dark fw-normal ps-0"></th>
												</tr>
											</thead>
											<tbody id="index_newsList">
												<!-- 뉴스 -->
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>

				</div>
			</div>
		</div>
	</div>
</body>

</html>