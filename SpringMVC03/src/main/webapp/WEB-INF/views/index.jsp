<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<!doctype html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>피그메이트</title>
<link rel="shortcut icon" type="image/png"
	href="${contextPath}/resources/img/logos/piglogos.png" />

<link rel="stylesheet"
	href="${contextPath}/resources/css/styles.min.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<link
	href="https://stackpath.bootstrapcdn.com/bootstrap/5.3.0/css/bootstrap.min.css"
	rel="stylesheet">
<!-- Iconify for icons -->
<script src="https://code.iconify.design/2/2.0.3/iconify.min.js"></script>

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
	border: 1px solid #fff;
	border-radius: 10px;
	background-color: #fff;
}

.env-info-box h6 {
	margin-bottom: 10px;
	font-size: 15px;
}

.envContent {
	display: block;
	font-size: 55px;
	margin-bottom: 5px;
}

.env-info-box .status {
	font-size: 18px;
}

.unitss {
	font-size: 20px;
	color: black;
}

.env-info-text {
	font-size: 30px;
}


.sidebar-nav .sidebar-item .collapse .sidebar-item {
	padding-left: 20px;
}



</style>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
 <script src="https://stackpath.bootstrapcdn.com/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
 
 
  <script>
    document.querySelectorAll('.sidebar-link').forEach(link => {
      link.addEventListener('click', function () {
        const target = this.getAttribute('href');
        const icon = this.querySelector('.iconify');

        if (target && icon) {
          const collapse = document.querySelector(target);
          if (collapse && collapse.classList.contains('show')) {
            icon.setAttribute('data-icon', 'mdi:chevron-down');
          } else {
            icon.setAttribute('data-icon', 'mdi:chevron-up');
          }
        }
      });
    });
  </script>

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
         temperature = latestEnv.temperature;
         humidity = latestEnv.humidity;
         co2 = latestEnv.co2;
         ammonia = latestEnv.ammonia;
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
						<div class="col-lg-3 d-flex align-items-stretch">
							<div class="card w-100">
								<div class="card-body1">

									<div class="env-info-box">
										<h6>온도</h6>
										<span id="temperature" class="envContent">N/A</span><span
											id="tem-text" class="unitss">°C</span>
										<div class="status">쾌적해요</div>
									</div>
								</div>

							</div>
						</div>
						<div class="col-lg-3 d-flex align-items-stretch">
							<div class="card w-100">
								<div class="card-body1">
									<div class="env-info-box">
										<h6>습도</h6>
										<span id="humidity" class="envContent">N/A</span> <span
											id="hum-text" class="unitss">%</span>
										<div class="status">쾌적해요</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-lg-3 d-flex align-items-stretch">
							<div class="card w-100">
								<div class="card-body1">
									<div class="env-info-box">
										<h6>이산화탄소</h6>
										<span id="co2" class="envContent">N/A</span> <span
											id="co2-text" class="unitss">ppm</span>
										<div class="status">쾌적해요</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-lg-3 d-flex align-items-stretch">
							<div class="card w-100">
								<div class="card-body1">
									<div class="env-info-box">
										<h6>암모니아</h6>
										<span id="ammonia" class="envContent">N/A</span> <span
											id="amm-text" class="unitss">mg/m³</span>
										<div class="status">쾌적해요</div>
									</div>
								</div>
							</div>
						</div>
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
													<iconify-icon icon="healthicons:animal-pig"
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
													<iconify-icon icon="healthicons:animal-pig"
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
					<div class="row">
						<!-- 한돈 뉴스-->
						<div class="col-lg-8 d-flex align-items-stretch">
							<div class="card w-100">
								<div class="card-body p-4">
									<h5 class="card-title fw-semibold mb-4">한돈 뉴스</h5>

								</div>
							</div>
						</div>
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

									<!-- 여기에 내용이 들어갑니다. -->


								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-12 d-flex align-items-strech">
							<div class="card w-100">
								<div class="card-body">
									<div>
										<canvas id="myChart1" width="4000" height="2000"></canvas>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-12 d-flex align-items-strech">
							<div class="card w-100">
								<div class="card-body">
									<div>
										<canvas id="myChart2" width="4000" height="2000"></canvas>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-12 d-flex align-items-strech">
							<div class="card w-100">
								<div class="card-body">
									<div>
										<canvas id="myChart3" width="4000" height="2000"></canvas>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-12 d-flex align-items-strech">
							<div class="card w-100">
								<div class="card-body">
									<div>
										<canvas id="myChart4" width="4000" height="2000"></canvas>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-12 d-flex align-items-strech">
							<div class="card w-100">
								<div class="card-body">
									<div>
										<canvas id="myChart5" width="4000" height="2000"></canvas>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
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
		        // created_at에서 날짜 부분만 추출
		        var date = this["created_at"].split(' ')[0];
		        dateList.push(date);
		        tempList.push(this["temperature"]);
		        humidList.push(this["humidity"]);
		        co2List.push(this["co2"]);
		        ammList.push(this["ammonia"]);
		        pmList.push(this["pm"]);
		    });

		    createChartTemp(dateList, tempList);
		    createChartHumid(dateList, humidList);
		    createChartCo2(dateList, co2List);
		    createChartAmm(dateList, ammList);
		    createChartPm(dateList, pmList);
		}
	</script>


	<script>
	
		// 그래프 1
function createChartTemp(dateList, tempList) {
    const ctx = document.getElementById('myChart1').getContext('2d');

    // 온도에 따라 색상 구분
    const backgroundColors = tempList.map(temp => {
        if (temp <= 10) return '#1f77b4'; // 파란색
        else if (temp <= 26) return '#90be6d'; // 초록색
        else return '#FF8C8C'; // 노란색
    });

    const myChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: dateList,
            datasets: [{
                label: '시간별 온도',
                data: tempList,
                backgroundColor: backgroundColors,
                borderColor: backgroundColors,
                borderWidth: 1
            }]
        },
        options: {
            plugins: {
                title: {
                    display: true,
                    text: '시간별 온도',
                    align: 'start', // 제목을 왼쪽으로 정렬
                    font: {
                        size: 18 // 글자 크기를 크게 설정
                    },
                    padding: {
                        top: 10,
                        bottom: 30
                    }
                },
                legend: {
                    display: true,
                    labels: {
                        generateLabels: function(chart) {
                            return [
                                {
                                    text: '10°C 이하',
                                    fillStyle: '#1f77b4',
                                    strokeStyle: '#1f77b4',
                                    lineWidth: 1
                                },
                                {
                                    text: '10°C ~ 24°C',
                                    fillStyle: '#90be6d',
                                    strokeStyle: '#90be6d',
                                    lineWidth: 1
                                },
                                {
                                    text: '27°C 이상',
                                    fillStyle: '#FF8C8C',
                                    strokeStyle: '#FF8C8C',
                                    lineWidth: 1
                                }
                            ];
                        }
                    }
                }
            },
            scales: {
                x: {
                    ticks: {
                        maxRotation: 45, // 레이블 각도 조정
                        minRotation: 45
                    }
                },
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: '온도 (°C)' // y축 레이블에 단위 추가
                    }
                }
            }
        }
    });
}







		// 그래프 2
		function createChartHumid(dateList, humidList) {
    const ctx = document.getElementById('myChart2').getContext('2d');

    // 습도가 80을 초과하면 배경색과 테두리 색상을 변경
    const backgroundColors = humidList.map(humidity => humidity > 80 ? '#f9c74f' : 'rgba(144, 190, 109, 0.5)');
    const borderColors = humidList.map(humidity => humidity > 80 ? '#f9c74f' : '#90be6d');

    const myChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: dateList,
            datasets: [{
                label: '시간별 습도',
                data: humidList,
                backgroundColor: backgroundColors,
                borderColor: borderColors,
                borderWidth: 1
            }]
        },
        options: {
            plugins: {
                title: {
                    display: true,
                    text: '시간별 습도',
                    align: 'start', // 제목을 왼쪽으로 정렬
                    font: {
                        size: 18 // 글자 크기를 크게 설정
                    },
                    padding: {
                        top: 10,
                        bottom: 30
                    }
                },
                legend: {
                    display: true,
                    labels: {
                        generateLabels: function(chart) {
                            return [
                                {
                                    text: '80% 이하',
                                    fillStyle: 'rgba(144, 190, 109, 0.5)',
                                    strokeStyle: '#90be6d',
                                    lineWidth: 1
                                },
                                {
                                    text: '80% 이상',
                                    fillStyle: '#f9c74f',
                                    strokeStyle: '#f9c74f',
                                    lineWidth: 1
                                }
                            ];
                        }
                    }
                }
            },
            scales: {
                x: {
                    ticks: {
                        maxRotation: 45, // 레이블 각도 조정
                        minRotation: 45
                    }
                },
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: '습도 (%)' // y축 레이블에 단위 추가
                    }
                }
            }
        }
    });
}




		// 이산화 탄소 그래프3
function createChartCo2(dateList, co2List) {
    const ctx = document.getElementById('myChart3').getContext('2d');

    const myChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: dateList,
            datasets: [{
                label: '이산화탄소',
                data: co2List,
                backgroundColor: '#f94144',
                borderColor: '#f94144',
                borderWidth: 1,
                pointRadius: 1, // 점 크기 설정
                pointHoverRadius: 6,
                fill: false // 영역을 채우지 않음
            }]
        },
        options: {
            plugins: {
                title: {
                    display: true,
                    text: '시간별 이산화탄소 농도',
                    align: 'start', // 제목을 왼쪽으로 정렬
                    font: {
                        size: 18 // 글자 크기를 크게 설정
                    },
                    padding: {
                        top: 10,
                        bottom: 30
                    }
                }
            },
            scales: {
                x: {
                    ticks: {
                        maxRotation: 45, // 레이블 각도 조정
                        minRotation: 45
                    }
                },
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'CO2 농도 (ppm)' // y축 레이블에 단위 추가
                    }
                }
            }
        }
    });
}


		// 그래프4
function createChartAmm(dateList, ammList) {
    const ctx = document.getElementById('myChart4').getContext('2d');

    const myChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: dateList,
            datasets: [{
                label: '시간별 암모니아',
                data: ammList,
                backgroundColor: '#f3722c',
                borderColor: '#f3722c',
                borderWidth: 1,
                pointRadius: 1, // 점 크기 설정
                pointHoverRadius: 6,
                fill: false // 영역을 채우지 않음
            }]
        },
        options: {
            plugins: {
                title: {
                    display: true,
                    text: '시간별 암모니아 수치',
                    align: 'start', // 제목을 왼쪽으로 정렬
                    font: {
                        size: 18 // 글자 크기를 크게 설정
                    },
                    padding: {
                        top: 10,
                        bottom: 30
                    }
                }
            },
            scales: {
                x: {
                    ticks: {
                        maxRotation: 45, // 레이블 각도 조정
                        minRotation: 45
                    }
                },
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: '암모니아 수치 (ppm)' // y축 레이블에 단위 추가
                    }
                }
            }
        }
    });
}


		// 그래프 5
function createChartPm(dateList, pmList) {
    const ctx = document.getElementById('myChart5').getContext('2d');

    const myChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: dateList,
            datasets: [{
                label: '미세먼지',
                data: pmList,
                backgroundColor: '#f9c74f',
                borderColor: '#f9c74f',
                borderWidth: 1,
                pointRadius: 1, // 점 크기 설정
                pointHoverRadius: 6,
                fill: false // 영역을 채우지 않음
            }]
        },
        options: {
            plugins: {
                title: {
                    display: true,
                    text: '시간별 미세먼지 수치',
                    align: 'start', // 제목을 왼쪽으로 정렬
                    font: {
                        size: 18 // 글자 크기를 크게 설정
                    },
                    padding: {
                        top: 10,
                        bottom: 30
                    }
                }
            },
            scales: {
                x: {
                    ticks: {
                        maxRotation: 45, // 레이블 각도 조정
                        minRotation: 45
                    }
                },
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: '미세먼지 수치 (µg/m³)' // y축 레이블에 단위 추가
                    }
                }
            }
        }
    });
}

	</script>
</body>

</html>