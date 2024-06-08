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

.active {
    background-color: #6EB876;
    color: white;
}
</style>
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
											<button class="btn btn-outline-primary" id="temperature">온도</button>
                                            <button class="btn btn-outline-primary" id="humidity">습도</button>
                                            <button class="btn btn-outline-primary" id="co2">이산화탄소</button>
                                            <button class="btn btn-outline-primary" id="ammonia">암모니아</button>
                                            <button class="btn btn-outline-primary" id="pm">이산화황</button>
											<select class="form-select" id="periodSelect">
                                               <option value="daily">일별</option>
                                                <option value="weekly">주별</option>
                                                <option value="monthly">월별</option>
                                            </select>
										</div>
										<div>
											<div id="myChart" style="width: 100%; height: 400px;"></div>
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
		var selectedButton = null;

		$(function() {
		    console.log("ready!");
		    selectedButton = $('#temperature');
		    selectedButton.addClass('active');
		    loadGraphData('daily', 'temperature', 'myChart');
	    
	 		// 버튼 클릭 이벤트 핸들러
		    $('button.btn-outline-primary').click(function() {
		        // 이전에 선택된 버튼이 있다면 active 클래스를 제거합니다.
		        if (selectedButton) {
		            $(selectedButton).removeClass('active');
		        }
		        // 선택된 버튼에 active 클래스를 추가합니다.
		        selectedButton = this;
		        $(this).addClass('active');
		        updateChart();
    		});
	 		
		 	// 기간 선택 변경 이벤트 핸들러
	        $('#periodSelect').change(function() {
	            updateChart();
	        });
	 		
		});
		
		// 새로운 버튼 누를때마다 버튼에 대한 값 전달
		function updateChart() {
		    if (!selectedButton) return;

		    var type = $(selectedButton).attr('id');
		    console.log("타입 : " + type)
		    var period = $('#periodSelect').val();
		    console.log("기간 : " + period);

		    // 차트 업데이트를 위해 데이터 로드 함수 호출
		    loadGraphData(period, type, 'myChart');
		}

		// 차트에 들어갈 데이터 가져오기
		function loadGraphData(period, type, chartId) {
			
			console.log("hi");
			
			const urlParams = new URLSearchParams(window.location.search);
			
			var farm_id = urlParams.get('farmId');
			
			console.log(farm_id);
			
		    $.ajax({
		        url: "${pageContext.request.contextPath}/farm/env",
		        type: "post",
		        dataType: "json",
		        data: { period: period, type: type, farm_id: farm_id},
		        success: function(data) {
		            console.log(chartId);
		            makeData(data, period, type, chartId);
		        },
		        error: function() {
		            console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
		        }
		    }); // ajax
		}// 함수

		// 가져온 데이터 차트에 넣을 형태로 처리
		function makeData(data, period, type, chartId) {
			
		    var dateList = [];
		    var valueList = [];
		
		    if (period === 'weekly') {
		        // 주별 데이터일 경우 주차를 라벨로 사용
		        const weeks = ['1주차', '2주차', '3주차', '4주차'];
		        dateList = data.map((_, index) => weeks[index % 4]);
		        valueList = data.map(item => item[type]);
		    } else if (period === 'monthly') {
		        // 월별 데이터일 경우 월을 라벨로 사용
		        dateList = data.map(item => item.created_at); // 월까지만 표시
		        valueList = data.map(item => item[type]);
		    } else {
		        // 일별 데이터일 경우 날짜를 라벨로 사용
		        dateList = data.map(item => item.created_at);
		        valueList = data.map(item => item[type]);
		    } //if문 끝
		
		    console.log("dateList: ", dateList.length);
		    console.log("valueList: ", valueList.length);
		
		    if (charts[chartId]) {
		        charts[chartId].destroy();
		    }
		
		    createCharts(dateList, valueList, chartId, type);
		} // 함수
		
		// 차트 만드는 함수
		function createCharts(dateList, valueList, chartId, type) {
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
		    } // if문 끝
		
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
		        }, // title
		        xAxis: {
		            categories: dateList,
		            labels: {
		                rotation: 45
		            }
		        }, // xAxis
		        yAxis: {
		            title: {
		                text: type.charAt(0).toUpperCase() + type.slice(1) + (type === 'temperature' ? ' (°C)' : type === 'humidity' ? ' (%)' : ' (ppm)')
		            },
		            min: 0
		        }, // yAxis
		        series: [{
		            name: type.charAt(0).toUpperCase() + type.slice(1),
		            data: valueList,
		            zones: zones,
		            dataLabels: {
		                enabled: false
		            }
		        }], // series
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
		                } //if문 끝
		            }
		        }, // legend
		        tooltip: {
		            pointFormat: '{series.name}: <b>{point.y}</b>'
		        },
		        credits: {
		            enabled: false  // Highcharts.com 크레딧 비활성화
		        }
		    });
		} // 함수
	
	</script>
</body>
</html>

