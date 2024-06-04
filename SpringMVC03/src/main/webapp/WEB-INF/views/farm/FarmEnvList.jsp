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