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
												<button class="btn btn-outline-primary me-3" id="sit">앉아있는
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
		    selectedPigButton = $('#sit');
		    selectedPigButton.addClass('active');
		    loadPigData('sit', 'time');

		    $('button.btn-outline-primary').click(function() {
		        if (this.id === 'temperature' || this.id === 'humidity' || this.id === 'co2' || this.id === 'ammonia' || this.id === 'pm') {
		            if (selectedButton) {
		                $(selectedButton).removeClass('active');
		            }
		            selectedButton = this;
		            $(this).addClass('active');
		            updateChart();
		        } else if (this.id === 'sit' || this.id === 'abnormal') {
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

        $.ajax({
            url: "${pageContext.request.contextPath}/farm/env",
            type: "post",
            dataType: "json",
            data: { period: period, type: type, farm_id: farm_id },
            success: function(data) {
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
    
    // 돼지정보 업데이트
    function updatePigChart() {
        var period = $('#pigSelect').val();
        if (period === 'time') {
            if (charts['pigChart']) {
                charts['pigChart'].destroy();
            }
            return;
        }
        if (selectedPigButton.attr('id') === 'sitPigs') {
            loadPigData('sit', period);
        } else if (selectedPigButton.attr('id') === 'abnormalPigs') {
            loadPigData('abnormal', period);
        }
    }

    
    // 돼지 그래프
	function loadPigData(type, period) {
	    if (period === 'time') {
	        if (charts['pigChart']) {
	            charts['pigChart'].destroy();
	        }
	        return;
	    }

    const urlParams = new URLSearchParams(window.location.search);
    var farm_id = urlParams.get('farmId');
    var url;

    if (type === 'sit') {
        url = `${pageContext.request.contextPath}/farm/DetectionInfo`;
    } else if (type === 'abnormal') {
        url = `${pageContext.request.contextPath}/farm/PigInfo`;
    }

    $.ajax({
        url: url,
        type: "get",
        dataType: "json",
        data: { farm_idx: farm_id, period: period },
        success: function(data) {
            console.log("Received data for", type, ":", data);
            if (type === 'sit') {
                makeSitPigData(data, type);
            } else if (type === 'abnormal') {
                makeAbnormalPigData(data, type);
            }
        },
        error: function(request, status, error) {
            console.log("Error fetching pig count data for", type, ":", status, error);
        }
    });
}
    
//돼지 그래프 데이터 - 이상있는 돼지 수
function makeAbnormalPigData(data, type) {
    console.log("Loaded data for abnormal pigs:", data);  

    var dateList = data.map(item => new Date(item.created_at).toLocaleDateString('ko-KR'));
    var warnCountList = data.map(item => item.warn_cnt);  
    var livestockCountList = data.map(item => item.livestock_cnt); // 전체 돼지 수 데이터

    console.log("Date List:", dateList);
    console.log("Warn Count List:", warnCountList);
    console.log("Livestock Count List:", livestockCountList);

    if (charts['pigChart']) {
        charts['pigChart'].destroy();
    }

    createPigCharts(dateList, warnCountList, livestockCountList, 'pigChart', type);
}

// 앉아있는 돼지 정보를 가져오는 함수
function makeSitPigData(data, type) {
    console.log("Loaded data for sit pigs:", data);  
    var dateList = data.map(item => new Date(item.created_at).toLocaleDateString('ko-KR'));
    var sitCountList = data.map(item => item.sit_cnt);  // 앉아있는 돼지 수 데이터
    var livestockCountList = data.map(item => item.livestock_cnt); // 전체 돼지 수 데이터

    if (charts['pigChart']) {
        charts['pigChart'].destroy();
    }

    createPigCharts(dateList, sitCountList, livestockCountList, 'pigChart', type);
}

// 돼지정보 그래프 생성 함수 
function createPigCharts(dateList, pigCountList, livestockCountList, chartId, type) {
    const container = document.getElementById(chartId);

    Highcharts.chart(container, {
        chart: {
            type: 'line'  
        },
        title: {
            text: type === 'sit' ? '앉아있는 돼지 객체 수' : '이상행동 돼지 수',
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
            type: type === 'sit' ? 'column' : 'column',  
            name: type === 'sit' ? '앉아있는 돼지 객체 수' : '이상행동 돼지 수',
            data: pigCountList,
            color: type === 'sit' ? '#3254a8' : '#e03db0'
        }],
        credits: {
            enabled: false
        }
    });
}

// 앉아있는 돼지정보차트 업데이트 함수 
function updatePigChart() {
    var type = $(selectedPigButton).attr('id');
    console.log(type);
    loadPigData(type); 
}

// 이상행동 돼지정보차트 업데이트 함수
function updateAbnormalPigChart() {
    loadPigData('abnormal'); 
    var type = $(selectedPigButton).attr('id');
    var period = $('#periodSelect').val();
}

// 돼지 그래프 데이터 로드 함수 
function loadPigData(type) {
    const urlParams = new URLSearchParams(window.location.search);
    var farm_id = urlParams.get('farmId');
    var url;

    if (type === 'sit') {
        url = `${pageContext.request.contextPath}/farm/DetectionInfo`;
    } else if (type === 'abnormal') {
        url = `${pageContext.request.contextPath}/farm/PigInfo`;
    }

    $.ajax({
        url: url,
        type: "get",
        dataType: "json",
        data: { farm_idx: farm_id, type: type },
        success: function(data) {
            console.log("Received data for", type, ":", data);
            if (type === 'sit') {
                makeSitPigData(data, type);  // 앉아있는 돼지 데이터 처리
            } else if (type === 'abnormal') {
                makeAbnormalPigData(data, type);  // 이상행동 돼지 데이터 처리
            }
        },
        error: function(request, status, error) {
            console.log("Error fetching pig count data for", type, ":", status, error);
        }
    });
}

</script>
</body>
</html>
