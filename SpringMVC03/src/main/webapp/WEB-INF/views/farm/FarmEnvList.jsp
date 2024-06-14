<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>환경정보</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/accessibility.js"></script>
<link rel="shortcut icon" type="image/png"
	href="${pageContext.request.contextPath}/resources/img/logos/piglogos.png" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/styles.min.css" />
<script
	src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>

<style>
.chart-container {
	margin-bottom: 40px; /* 그래프 사이의 공백 추가 */
}

.active {
	background-color: #6EB876;
	color: white;
}

.sidebar-nav .sidebar-item .collapse .sidebar-item {
	padding-left: 20px;
}

.float-right {
	float: right;
}

.clearfix::after {
	content: "";
	clear: both;
	display: table;
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
										<div class="clearfix">
											<div>
												<button class="btn btn-outline-primary me-3"
													id="temperature">온도</button>
												<button class="btn btn-outline-primary me-3" id="humidity">습도</button>
												<button class="btn btn-outline-primary me-3" id="co2">이산화탄소</button>
												<button class="btn btn-outline-primary me-3" id="ammonia">암모니아</button>
												<button class="btn btn-outline-primary me-3" id="pm">이산화황</button>
											</div>
											<div class="float-right">
												<select class="form-select" id="periodSelect">
													<option value="daily">일별</option>
													<option value="weekly">주별</option>
													<option value="monthly">월별</option>
												</select>
											</div>
										</div>
										<div>
											<div id="myChart" style="width: 100%; height: 600px;"></div>
										</div>
									</div>
								</div>
							</div>
							<div class="col-lg-12 d-flex align-items-stretch">
								<div class="card w-100">
									<div class="card-body">
										<div class="clearfix">
											<div>
												<button class="btn btn-outline-primary me-3" id="lying">누워있는
													돼지 객체 수</button>
												<button class="btn btn-outline-primary me-3"
													id="abnormal">이상행동 객체 수</button>
											</div>
											<div class="float-right">
												<select class="form-select" id="pigSelect">
													<option value="time">시간별</option>
													<option value="day">일별</option>
												</select>
											</div>
										</div>
										<div>
											<div id="pigChart" style="width: 100%; height: 600px;"></div>
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
 var selectedButton = null;
 var selectedPigButton = null; // 초기 돼지 정보 선택 버튼 설정

 // 환경 + 돼지 선택 버튼 
 $(function() {
    console.log("ready!");
    selectedButton = $('#temperature');
    selectedButton.addClass('active');
    loadGraphData('daily', 'temperature', 'myChart');
    selectedPigButton = $('#lying');
    selectedPigButton.addClass('active');
    loadPigData('lying', 'time');

    $('button.btn-outline-primary').click(function() {
        if (this.id === 'temperature' || this.id === 'humidity' || this.id === 'co2' || this.id === 'ammonia' || this.id === 'pm') {
            if (selectedButton) {
                $(selectedButton).removeClass('active');
            }
            selectedButton = this;
            $(this).addClass('active');
            updateChart();
        } else if (this.id === 'lying' || this.id === 'abnormal') {
            if (selectedPigButton) {
                $(selectedPigButton).removeClass('active');
            }
            selectedPigButton = this;
            $(this).addClass('active');
            updatePigChart();
        } 
    });

    $('#periodSelect').change(function() {
        updateChart();
    });

    $('#pigSelect').change(function() {
        updatePigChart();
    });
});

 // 환경
 function updateChart() {
    if (!selectedButton) return;
    var type = $(selectedButton).attr('id');
    var period = $('#periodSelect').val();
    loadGraphData(period, type, 'myChart');
 }

 // 환경 그래프
 function loadGraphData(period, type, chartId) {
    const urlParams = new URLSearchParams(window.location.search);
    var farm_id = urlParams.get('farmId');

    console.log(`Requesting data for ${type} over ${period} for farm ${farm_id}`);

    $.ajax({
        url: "${pageContext.request.contextPath}/farm/env",
        type: "post",
        dataType: "json",
        data: { period: period, type: type, farm_id: farm_id },
        success: function(data) {
            console.log("Data received: ", data);
            makeData(data, period, type, chartId);
        },
        error: function(request, status, error) {
            console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
        }
    });
 }

 // 환경 그래프 데이터
 function makeData(data, period, type, chartId) {
    var dateList = [];
    var valueList = [];

    if (period === 'weekly') {
        const weeks = ['1주차', '2주차', '3주차', '4주차'];
        dateList = data.map((_, index) => weeks[index % 4]);
        valueList = data.map(item => item[type]);
    } else if (period === 'monthly') {
        dateList = data.map(item => item.created_at.split(' ')[0]);
        valueList = data.map(item => item[type]);
    } else {
        dateList = data.map(item => item.created_at.split(' ')[0]);
        valueList = data.map(item => item[type]);
    }

    if (charts[chartId]) {
        charts[chartId].destroy();
    }

    createCharts(dateList, valueList, chartId, type);
 }

 // 환경 그래프
 function createCharts(dateList, valueList, chartId, type) {
    const container = document.getElementById(chartId);

    let zones;
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
                rotation: 45,
                step: Math.max(1, Math.floor(dateList.length / 20))
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
            },
            marker: {
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
            enabled: false
        }
    });
 }
    
 function updatePigChart() {
	    var period = $('#pigSelect').val();
	    if (!selectedPigButton) return;
	    var type = $(selectedPigButton).attr('id');
	    loadPigData(type, period);
	}

	function loadPigData(type, period) {
	    const urlParams = new URLSearchParams(window.location.search);
	    var farm_id = urlParams.get('farmId');
	    var url;

	    if (type === 'lying') {
	        url = `${pageContext.request.contextPath}/farm/DetectionInfo`;
	    } else if (type === 'abnormal') {
	        url = `${pageContext.request.contextPath}/farm/PigInfo`;
	    }

	    $.ajax({
	        url: url,
	        type: "get",
	        dataType: "json",
	        data: { farm_idx: farm_id, period: period, type : type },
	        success: function(data) {
	            console.log("Received data for", type, ":", data);
	            if (type === 'lying') {
	                makeLyingPigData(data, type);
	            } else if (type === 'abnormal') {
	                makeAbnormalPigData(data, type);
	            }
	        },
	        error: function(request, status, error) {
	            console.log("Error fetching pig count data for", type, ":", status, error);
	        }
	    });
	}

	function makeAbnormalPigData(data, type) {
	    if (!data || data.length === 0) {
	        console.log("No data received for abnormal pigs.");
	        return;
	    }

	    var dateList = data.map(item => new Date(item.created_date).toLocaleDateString('ko-KR'));
	    var warnCountList = data.map(item => item.avg_warn_cnt);
	    var livestockCountList = data.map(item => item.avg_livestock_cnt);

	    if (charts['pigChart']) {
	        charts['pigChart'].destroy();
	    }

	    createPigCharts(dateList, warnCountList, livestockCountList, 'pigChart', type);
	}

	function makeLyingPigData(data, type) {
	    if (!data || data.length === 0) {
	        console.log("No data received for lying pigs.");
	        return;
	    }

	    // 데이터가 올바르게 전달되고 있는지 확인합니다.
	    console.log("Received data for lying:", data);

	    // 'created_date' 속성을 사용하여 날짜 리스트를 만듭니다.
	    var dateList = data.map(item => item.created_date);
	    var lyingCountList = data.map(item => item.avg_lying_cnt);  
	    var livestockCountList = data.map(item => item.avg_livestock_cnt);

	    console.log("Date List:", dateList);
	    console.log("Lying Count List:", lyingCountList);
	    console.log("Livestock Count List:", livestockCountList);

	    if (charts['pigChart']) {
	        charts['pigChart'].destroy();
	    }

	    createPigCharts(dateList, lyingCountList, livestockCountList, 'pigChart', type);
	}

	function createPigCharts(dateList, pigCountList, livestockCountList, chartId, type) {
	    // 데이터를 역순으로 정렬
	    dateList.reverse();
	    pigCountList.reverse();
	    livestockCountList.reverse();

	    const container = document.getElementById(chartId);

	    Highcharts.chart(container, {
	        chart: {
	            type: 'line'
	        },
	        title: {
	            text: type === 'lying' ? '누워있는 돼지 객체 수' : '이상행동 돼지 수',
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
	                text: '객체 수 (마리)'
	            },
	            min: 0
	        },
	        series: [{
	            type: 'line',
	            name: '전체 돼지 수',
	            data: livestockCountList
	        }, {
	            type: 'column',
	            name: type === 'lying' ? '누워있는 돼지 객체 수' : '이상행동 돼지 수',
	            data: pigCountList,
	            color: type === 'lying' ? '#3254a8' : '#e03db0'
	        }],
	        credits: {
	            enabled: false
	        }
	    });
	}

</script>
</body>
</html>