<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>환경정보</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/accessibility.js"></script>
<link rel="shortcut icon" type="image/png" href="${pageContext.request.contextPath}/resources/img/logos/piglogos.png" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/styles.min.css" />
<script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>

<style>
.chart-container {
	margin-bottom: 40px; /* 그래프 사이의 공백 추가 */
}
</style>

</head>
<body>

	<!--  Body Wrapper -->
	<div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full" data-sidebar-position="fixed" data-header-position="fixed">

		<%@ include file="../common/sidebar.jsp"%>
		<div class="body-wrapper">
			<%@ include file="../common/header.jsp"%>

			<!--  Main wrapper -->
			<div class="body-wrapper-inner">
				<div class="container-fluid">
					<div id="chartsContainer">
						<div class="row chart-container">
							<div class="col-lg-12 d-flex align-items-stretch">
								<div class="card w-100">
									<div class="card-body">
										<div>
											<button class="btn btn-outline-primary" onclick="loadGraphData('daily', 'temperature', 'myChart1')">온도</button>
											<button class="btn btn-outline-primary" onclick="loadGraphData('daily', 'humidity', 'myChart1')">습도</button>
											<button class="btn btn-outline-primary" onclick="loadGraphData('daily', 'co2', 'myChart1')">이산화탄소</button>
											<button class="btn btn-outline-primary" onclick="loadGraphData('daily', 'ammonia', 'myChart1')">암모니아</button>
											<button class="btn btn-outline-primary" onclick="loadGraphData('daily', 'pm', 'myChart1')">이산화황</button>
										</div>
										<div>
										
											<button class="btn btn-text-only" onclick="loadGraphData('daily', 'temperature', 'myChart1')">일별</button>
											<button class="btn btn-text-only" onclick="loadGraphData('latest-weekly', 'temperature', 'myChart1')">주별</button>
											<button class="btn btn-text-only" onclick="loadGraphData('latest-monthly', 'temperature', 'myChart1')">월별</button>
										</div>
										<div>
											<div id="myChart1" style="width: 100%; height: 400px;"></div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row chart-container">
							<div class="col-lg-12 d-flex align-items-stretch">
								<div class="card w-100">
									<div class="card-body">
											
										<div>
											<button class="btn btn-outline-primary" onclick="loadGraphData('daily', 'humidity', 'myChart2')">일별</button>
											<button class="btn btn-outline-primary" onclick="loadGraphData('latest-weekly', 'humidity', 'myChart2')">주별</button>
											<button class="btn btn-outline-primary" onclick="loadGraphData('latest-monthly', 'humidity', 'myChart2')">월별</button>
										</div>
										<div>
											<div id="myChart2" style="width: 100%; height: 400px;"></div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row chart-container">
							<div class="col-lg-12 d-flex align-items-stretch">
								<div class="card w-100">
									<div class="card-body">
										<div>
											<button class="btn btn-outline-primary" onclick="loadGraphData('daily', 'co2', 'myChart3')">일별</button>
											<button class="btn btn-outline-primary" onclick="loadGraphData('latest-weekly', 'co2', 'myChart3')">주별</button>
											<button class="btn btn-outline-primary" onclick="loadGraphData('latest-monthly', 'co2', 'myChart3')">월별</button>
										</div>
										<div>
											<div id="myChart3" style="width: 100%; height: 400px;"></div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row chart-container">
							<div class="col-lg-12 d-flex align-items-stretch">
								<div class="card w-100">
									<div class="card-body">
										<div>
											<button class="btn btn-outline-primary" onclick="loadGraphData('daily', 'ammonia', 'myChart4')">일별</button>
											<button class="btn btn-outline-primary" onclick="loadGraphData('latest-weekly', 'ammonia', 'myChart4')">주별</button>
											<button class="btn btn-outline-primary" onclick="loadGraphData('latest-monthly', 'ammonia', 'myChart4')">월별</button>
										</div>
										<div>
											<div id="myChart4" style="width: 100%; height: 400px;"></div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row chart-container">
							<div class="col-lg-12 d-flex align-items-stretch">
								<div class="card w-100">
									<div class="card-body">
										<div>
											<button class="btn btn-outline-primary" onclick="loadGraphData('daily', 'pm', 'myChart5')">일별</button>
											<button class="btn btn-outline-primary" onclick="loadGraphData('latest-weekly', 'pm', 'myChart5')">주별</button>
											<button class="btn btn-outline-primary" onclick="loadGraphData('latest-monthly', 'pm', 'myChart5')">월별</button>
										</div>
										<div>
											<div id="myChart5" style="width: 100%; height: 400px;"></div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script src="${pageContext.request.contextPath}/resources/libs/jquery/dist/jquery.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/sidebarmenu.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/app.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/libs/apexcharts/dist/apexcharts.min.js"></script>

	<script>
var charts = {};

$(function() {
    console.log("ready!");
    loadGraphData('daily', 'temperature', 'myChart1');
});


function loadGraphData(period, type, chartId) {
    $.ajax({
        url: "${pageContext.request.contextPath}/farm/env",
        type: "post",
        dataType: "json",
        data: { period: period, type: type },
        success: function(data) {
            console.log(data);
            makeData(data, period, type, chartId);
        },
        error: function(request, status, error) {
            console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
        }
    });
}

function makeData(data, period, type, chartId) {
    var dateList = [];
    var valueList = [];

    if (period === 'latest-weekly') {
        // 주별 데이터일 경우 주차를 라벨로 사용
        const weeks = ['1주차', '2주차', '3주차', '4주차'];
        dateList = data.map((_, index) => weeks[index % 4]);
        valueList = data.map(item => item[type]);
    } else if (period === 'latest-monthly') {
        // 월별 데이터일 경우 월을 라벨로 사용
        dateList = data.map(item => item.created_at.substr(0, 7)); // 월까지만 표시
        valueList = data.map(item => item[type]);
    } else {
        // 일별 데이터일 경우 날짜를 라벨로 사용
        dateList = data.map(item => item.created_at);
        valueList = data.map(item => item[type]);
    }

    console.log("dateList: ", dateList);
    console.log("valueList: ", valueList);

    if (charts[chartId]) {
        charts[chartId].destroy();
    }

    createHighcharts(dateList, valueList, chartId, type);
}

function createHighcharts(dateList, valueList, chartId, type) {
    const container = document.getElementById(chartId);

    let zones;
    let backgroundColors;
    if (type === 'temperature') {
    	 zones = [
             { value: 10, color: '#1f77b4' },
             { value: 26, color: '#90be6d' },
             { color: '#FF8C8C' }
         ];
    } else if (type === 'humidity') {
    	 zones = [
             { value: 80, color: '#90be6d' },
             { color: '#f9c74f' }
         ];
    } else {
    	 zones = [{ color: '#f94144' }];
    }

    Highcharts.chart(container, {
        chart: {
            type: 'line' 
        },
        title: {
            text: type.charAt(0).toUpperCase() + type.slice(1),
            align: 'left',
            style: {
                fontSize: '18px'
            },
            margin: 30
        },
        xAxis: {
            categories: dateList,
            labels: {
                rotation: 45
            }
        },
        yAxis: {
            title: {
                text: type.charAt(0).toUpperCase() + type.slice(1) + (type === 'temperature' ? ' (°C)' : type === 'humidity' ? ' (%)' : ' (ppm)')
            },
            min: 0
        },
        series: [{
            name: type.charAt(0).toUpperCase() + type.slice(1),
            data: valueList,
            zones: zones,
            dataLabels: {
                enabled: false
            }
        }],
        legend: {
            enabled: true,
            labelFormatter: function() {
                if (type === 'temperature') {
                    return [
                        '<span style="color:#1f77b4">10°C 이하</span>',
                        '<span style="color:#90be6d">10°C ~ 26°C</span>',
                        '<span style="color:#FF8C8C">27°C 이상</span>'
                    ].join('<br/>');
                } else if (type === 'humidity') {
                    return [
                        '<span style="color:#90be6d">80% 이하</span>',
                        '<span style="color:#f9c74f">80% 이상</span>'
                    ].join('<br/>');
                }
            }
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.y}</b>'
        },
        credits: {
            enabled: false  // Highcharts.com 크레딧 비활성화
        }
    });
}
	</script>
</body>
</html>
