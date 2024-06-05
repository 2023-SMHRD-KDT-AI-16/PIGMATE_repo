<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>환경정보</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<link rel="shortcut icon" type="image/png"
<href="${pageContext.request.contextPath}/resources/img/logos/piglogos.png" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/styles.min.css" />
<script
	src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>

<style>
.chart-container {
	margin-bottom: 40px; /* 그래프 사이의 공백 추가 */
}
</style>

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
					<div id="chartsContainer">
						<div class="row chart-container">
							<div class="col-lg-12 d-flex align-items-stretch">
								<div class="card w-100">
									<div class="card-body">
										<div>
											<button class="btn btn-outline-primary"
												onclick="loadGraphData('daily', 'temperature', 'myChart1')">일별</button>
											<button class="btn btn-outline-primary"
												onclick="loadGraphData('latest-weekly', 'temperature', 'myChart1')">주별</button>
										</div>
										<div>
											<canvas id="myChart1" width="4000" height="2000"></canvas>
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
											<button class="btn btn-outline-primary"
												onclick="loadGraphData('daily', 'humidity', 'myChart2')">일별</button>
											<button class="btn btn-outline-primary"
												onclick="loadGraphData('latest-weekly', 'humidity', 'myChart2')">주별</button>
										</div>
										<div>
											<canvas id="myChart2" width="4000" height="2000"></canvas>
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
											<button class="btn btn-outline-primary"
												onclick="loadGraphData('daily', 'co2', 'myChart3')">일별</button>
											<button class="btn btn-outline-primary"
												onclick="loadGraphData('latest-weekly', 'co2', 'myChart3')">주별</button>
										</div>
										<div>
											<canvas id="myChart3" width="4000" height="2000"></canvas>
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
											<button class="btn btn-outline-primary"
												onclick="loadGraphData('daily', 'ammonia', 'myChart4')">일별</button>
											<button class="btn btn-outline-primary"
												onclick="loadGraphData('latest-weekly', 'ammonia', 'myChart4')">주별</button>
										</div>
										<div>
											<canvas id="myChart4" width="4000" height="2000"></canvas>
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
											<button class="btn btn-outline-primary"
												onclick="loadGraphData('daily', 'pm', 'myChart5')">일별</button>
											<button class="btn btn-outline-primary"
												onclick="loadGraphData('latest-weekly', 'pm', 'myChart5')">주별</button>
										</div>
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
var charts = {};

$(function() {
    console.log("ready!");
    loadGraphData('daily', 'temperature', 'myChart1');
    loadGraphData('daily', 'humidity', 'myChart2');
    loadGraphData('daily', 'co2', 'myChart3');
    loadGraphData('daily', 'ammonia', 'myChart4');
    loadGraphData('daily', 'pm', 'myChart5');
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

    if (type === 'temperature') {
        charts[chartId] = createChartTemp(dateList, valueList, chartId);
    } else if (type === 'humidity') {
        charts[chartId] = createChartHumid(dateList, valueList, chartId);
    } else if (type === 'co2') {
        charts[chartId] = createChartCo2(dateList, valueList, chartId);
    } else if (type === 'ammonia') {
        charts[chartId] = createChartAmm(dateList, valueList, chartId);
    } else if (type === 'pm') {
        charts[chartId] = createChartPm(dateList, valueList, chartId);
    }
}

function createChartTemp(dateList, tempList, chartId) {
    const ctx = document.getElementById(chartId).getContext('2d');

    const backgroundColors = tempList.map(temp => {
        if (temp <= 10) return '#1f77b4';
        else if (temp <= 26) return '#90be6d';
        else return '#FF8C8C';
    });

    return new Chart(ctx, {
        type: 'bar',
        data: {
            labels: dateList,
            datasets: [{
                label: '온도',
                data: tempList,
                backgroundColor: backgroundColors,
                borderColor: backgroundColors,
                borderWidth: 1,
                pointRadius: 0,  // 동그라미 표시 제거
                pointHoverRadius: 0  // 마우스 오버 시 동그라미 표시 제거
            }]
        },
        options: {
            plugins: {
                title: {
                    display: true,
                    text: '온도',
                    align: 'start',
                    font: {
                        size: 18
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
                                    text: '10°C ~ 26°C',
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
                        maxRotation: 45,
                        minRotation: 45
                    }
                },
                y: {
                    beginAtZero: false,
                    title: {
                        display: true,
                        text: '온도 (°C)'
                    }
                }
            }
        }
    });
}

function createChartHumid(dateList, humidList, chartId) {
    const ctx = document.getElementById(chartId).getContext('2d');

    const backgroundColors = humidList.map(humidity => humidity > 80 ? '#f9c74f' : 'rgba(144, 190, 109, 0.5)');
    const borderColors = humidList.map(humidity => humidity > 80 ? '#f9c74f' : '#90be6d');

    return new Chart(ctx, {
        type: 'bar',
        data: {
            labels: dateList,
            datasets: [{
                label: '습도',
                data: humidList,
                backgroundColor: backgroundColors,
                borderColor: borderColors,
                borderWidth: 1,
                pointRadius: 0,  // 동그라미 표시 제거
                pointHoverRadius: 0  // 마우스 오버 시 동그라미 표시 제거
            }]
        },
        options: {
            plugins: {
                title: {
                    display: true,
                    text: '습도',
                    align: 'start',
                    font: {
                        size: 18
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
                        maxRotation: 45,
                        minRotation: 45
                    }
                },
                y: {
                    beginAtZero: false,
                    title: {
                        display: true,
                        text: '습도 (%)'
                    }
                }
            }
        }
    });
}

function createChartCo2(dateList, co2List, chartId) {
    const ctx = document.getElementById(chartId).getContext('2d');

    return new Chart(ctx, {
        type: 'line',
        data: {
            labels: dateList,
            datasets: [{
                label: '이산화탄소',
                data: co2List,
                backgroundColor: '#f94144',
                borderColor: '#f94144',
                pointRadius: 0,  // 동그라미 표시 제거
                pointHoverRadius: 0  // 마우스 오버 시 동그라미 표시 제거
            }]
        },
        options: {
            plugins: {
                title: {
                    display: true,
                    text: '이산화탄소',
                    align: 'start',
                    font: {
                        size: 18
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
                        maxRotation: 45,
                        minRotation: 45
                    }
                },
                y: {
                    beginAtZero: false,
                    title: {
                        display: true,
                        text: 'CO2 농도 (ppm)'
                    }
                }
            }
        }
    });
}

function createChartAmm(dateList, ammList, chartId) {
    const ctx = document.getElementById(chartId).getContext('2d');

    return new Chart(ctx, {
        type: 'line',
        data: {
            labels: dateList,
            datasets: [{
                label: '암모니아',
                data: ammList,
                backgroundColor: '#f3722c',
                borderColor: '#f3722c',
                borderWidth: 1,
                pointRadius: 0,  // 동그라미 표시 제거
                pointHoverRadius: 0  // 마우스 오버 시 동그라미 표시 제거
            }]
        },
        options: {
            plugins: {
                title: {
                    display: true,
                    text: '암모니아',
                    align: 'start',
                    font: {
                        size: 18
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
                        maxRotation: 45,
                        minRotation: 45
                    }
                },
                y: {
                    beginAtZero: false,
                    title: {
                        display: true,
                        text: '암모니아 (ppm)'
                    }
                }
            }
        }
    });
}

function createChartPm(dateList, pmList, chartId) {
    const ctx = document.getElementById(chartId).getContext('2d');

    return new Chart(ctx, {
        type: 'line',
        data: {
            labels: dateList,
            datasets: [{
                label: '미세먼지',
                data: pmList,
                backgroundColor: '#f9c74f',
                borderColor: '#f9c74f',
                borderWidth: 1,
                pointRadius: 0,  // 동그라미 표시 제거
                pointHoverRadius: 0  // 마우스 오버 시 동그라미 표시 제거
            }]
        },
        options: {
            plugins: {
                title: {
                    display: true,
                    text: '미세먼지',
                    align: 'start',
                    font: {
                        size: 18
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
                        maxRotation: 45,
                        minRotation: 45
                    }
                },
                y: {
                    beginAtZero: false,
                    title: {
                        display: true,
                        text: '미세먼지 (µg/m³)'
                    }
                }
            }
        }
    });
}
</script>
</body>
</html>