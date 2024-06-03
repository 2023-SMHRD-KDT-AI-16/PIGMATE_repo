<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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
					<div class="row">
					<div class="col-lg-6 d-flex align-items-strech">
						<div class="card w-100">
							<div class="card-body">
								<div
									class="d-sm-flex d-block align-items-center justify-content-between mb-9">
									<div class="mb-3 mb-sm-0">
										<h6 class="card-title fw-semibold">h6</h6>
									</div>
								</div>
								<div>
									<canvas id="myChart1" width="4000" height="2000"></canvas>
								</div>
							</div>
						</div>
					</div>
					<div class="col-lg-6 d-flex align-items-strech">
						<div class="card w-100">
							<div class="card-body">
								<div
									class="d-sm-flex d-block align-items-center justify-content-between mb-9">
									<div class="mb-3 mb-sm-0">
										<h5 class="card-title fw-semibold">이 부분을 써야할까? h5태그</h5>
									</div>
								</div>
								<div>
									<canvas id="myChart2" width="4000" height="2000"></canvas>
								</div>
							</div>
						</div>
					</div>
					</div>
					<div class="row">
					<div class="col-lg-6 d-flex align-items-strech">
						<div class="card w-100">
							<div class="card-body">
								<div
									class="d-sm-flex d-block align-items-center justify-content-between mb-9">
									<div class="mb-3 mb-sm-0">
										<h6 class="card-title fw-semibold">h6</h6>
									</div>
								</div>
								<div>
									<!-- 캔바스 들어갈 자리 -->
								</div>
							</div>
						</div>
					</div>
					<div class="col-lg-6 d-flex align-items-strech">
						<div class="card w-100">
							<div class="card-body">
								<div
									class="d-sm-flex d-block align-items-center justify-content-between mb-9">
									<div class="mb-3 mb-sm-0">
										<h5 class="card-title fw-semibold">이 부분을 써야할까? h5태그</h5>
									</div>
								</div>
								<div>
									<!-- 캔바스 들어갈 자리 -->
								</div>
							</div>
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


	<script>
		$(function() {

			console.log("ready!");

			$.ajax({
				url : "farm/env",
				type : "post",
				dataType : "json",
				success : function(data) {
					console.log(data);
					makeData(data);
				},
				error : function(request, status, error) {
					console.log("code:" + request.status + "\n" + "message:"
							+ request.responseText + "\n" + "error:" + error);
				}
			}) // ajax
		}); // 함수

		function makeData(data) {

			var dateList = [];
			var tempList = [];
			var humidList = [];
			var co2List = [];
			var ammList = [];
			var pmList = [];

			$.each(data, function() {
				dateList.push(this["created_at"]);
				tempList.push(this["temperature"]);
				humidList.push(this["humidity"]);
				co2List.push(this["co2"]);
				ammList.push(this["ammonia"]);
				pmList.push(this["pm"]);

			});

			createChartTemp(dateList, tempList);
			createChartHumid(dateList, humidList);

		}
	</script>


	<script>
		// 그래프
		function createChartTemp(dateList, tempList) {
			const ctx = document.getElementById('myChart1').getContext('2d');

			const myChart = new Chart(ctx, {
				type : 'line',
				data : {
					labels : dateList,
					datasets : [ {
						label : '시간별 온도',
						data : tempList,
						backgroundColor : [ 'lightblue' ],
						borderColor : [ 'lightblue' ],
						borderWidth : 1
					} ]
				},
				options : {
					scales : {
						y : {
							beginAtZero : true
						}
					}
				//scales
				}
			// options
			}); //chart

		}
		function createChartHumid(dateList, humidList) {
			const ctx = document.getElementById('myChart2').getContext('2d');

			const myChart = new Chart(ctx, {
				type : 'bar',
				data : {
					labels : dateList,
					datasets : [ {
						label : '시간별 습도',
						data : humidList,
						backgroundColor : [ 'lightblue' ],
						borderColor : [ 'lightblue' ],
						borderWidth : 1
					} ]
				},
				options : {
					scales : {
						y : {
							beginAtZero : true
						}
					}
				//scales
				}
			// options
			}); //chart

		}
	</script>


</body>
</html>