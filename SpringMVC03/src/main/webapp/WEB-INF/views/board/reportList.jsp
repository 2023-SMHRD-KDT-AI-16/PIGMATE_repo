<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>리포트 목록</title>
<link rel="shortcut icon" type="image/png"
    href="${pageContext.request.contextPath}/resources/img/logos/piglogos.png" />
<link rel="stylesheet"
    href="${pageContext.request.contextPath}/resources/css/styles.min.css" />
<link rel="stylesheet"
    href="https://maxcdn.bootstrapcdn.com/bootstrap/5.3.0/css/bootstrap.min.css">
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.10.2/fullcalendar.min.css" />
<script
    src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
<script
    src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
<script
    src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.10.2/fullcalendar.min.js"></script>
<script
    src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/accessibility.js"></script>
<style>
.sidebar-nav .sidebar-item .collapse .sidebar-item {
    padding-left: 20px;
}

#calendar {
    display: none;
}

#reportForm {
    display: none;
    margin-top: 20px;
}

.fc button, .fc table, body .fc {
    font-size: 0.9em;
}

.fc-toolbar .fc-button-group {
    margin-right: 10px; /* 버튼 그룹 간격 */
}

#calendar>div.fc-toolbar.fc-header-toolbar>div.fc-center>h2 {
    font-size: 0.9rem;
}

.calendar-container {
    position: relative;
}

.calendar-container .calendar-button:hover {
    background-color: #677B69;
}

#calendarModal .modal-dialog {
    max-width: 400px;
}

#calendarModal .modal-body {
    padding: 0;
}

.graph-container {
    flex: 1;
    margin-right: 20px;
}

.horizontal-dates {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-bottom: 20px;
}

.horizontal-dates button {
    background-color: transparent;
    border: none;
    font-size: 1.2em;
    cursor: pointer;
    margin: 0 10px;
}

.date-item {
    margin: 0 10px;
    font-size: 1.2em;
}

.current-date {
    color: red;
    font-weight: bold;
}

#main-wrapper > div > div > div > div > div > div.horizontal-dates > button.calendar-button {
    position: relative;
    cursor: pointer;
    background-color: #6EB876;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 5px;
    margin-left: 10px;
}
</style>
</head>
<body>
    <!--  Body Wrapper -->
    <div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full" data-sidebar-position="fixed" data-header-position="fixed">
        <!--  Main wrapper -->
        <%@ include file="../common/sidebar.jsp"%>
        <div class="body-wrapper">
            <%@ include file="../common/header.jsp"%>
            <div class="body-wrapper-inner">
                <div class="container-fluid">
                    <div class="card">
                        <div class="card-body">
                            <div class="horizontal-dates">
                                <button id="prev-day">&lt;</button>
                                <span id="dates"></span>
                                <button id="next-day">&gt;</button>
                                <button class="calendar-button" data-toggle="modal" data-target="#calendarModal">달력 열기</button>
                            </div>
                            <div class="row">
                                <div class="col-lg-12 d-flex align-items-stretch">
                                    <div class="graph-container">
                                        <!-- 그래프를 추가할 공간 -->
                                        <div id="everyPigChart" style="width: 100%; height: 400px;"></div>
                                        <div id="everyEnvChart" style="width: 100%; height: 400px;"></div>
                                        <div id="everyAlertChart" style="width: 100%; height: 400px;"></div>
                                    </div>
                                    <div class="calendar-container">
                                        <!-- 날짜를 선택했을 때 나타나는 입력 폼 -->
                                        <form id="reportForm">
                                            <div class="form-group mb-3">
                                                <label for="reportDate">등록일자</label>
                                                <input type="text" class="form-control" id="reportDate" name="reportDate" readonly>
                                            </div>
                                            <div class="form-group mb-3">
                                                <label for="reportContent">내용</label>
                                                <input type="text" class="form-control" id="reportContent" name="reportContent">
                                            </div>
                                            <div class="row">
                                                <input type="submit" class="btn btn-outline-success pull-right" value="저장">
                                            </div>
                                        </form>
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

    <!-- 모달 -->
    <div class="modal fade" id="calendarModal" tabindex="-1" role="dialog" aria-labelledby="calendarModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="calendarModalLabel">달력</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="calendarMini"></div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/sidebarmenu.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/app.min.js"></script>
<script>
$(document).ready(function() {
    var currentDate = moment();
    var currentDateIndex = 0;
    updateDates();
    var date = moment().format('YYYY-MM-DD'); // 초기 날짜값
    var farmId = getQueryStringParameter('farmId');
    DailyData(date, farmId); // 초기 데이터 로드

    function updateDates() {
        var dates = [];
        for (var i = -1; i <= 1; i++) {
            var date = currentDate.clone().add(i, 'days');
            var dateItem = $('<span class="date-item"></span>').text(date.format('MM/DD'));
            if (i === 0) {
                dateItem.addClass('current-date');
            }
            dates.push(dateItem);
        }
        $('#dates').empty().append(dates);
    };

    $('#prev-day').on('click', function() {
        currentDate.subtract(1, 'days');
        updateDates();
        DailyData(currentDate.format('YYYY-MM-DD'), farmId); // 이전 날짜 데이터 로드
    });

    $('#next-day').on('click', function() {
        currentDate.add(1, 'days');
        updateDates();
        DailyData(currentDate.format('YYYY-MM-DD'), farmId); // 다음 날짜 데이터 로드
    });

    $('#calendarMini').fullCalendar({
        header : {
            left : 'prev,next today',
            center : 'title',
            right : 'month'
        },
        selectable : true,
        selectHelper : true,
        select : function(start, end) {
            var date = moment(start).format('YYYY-MM-DD');
            $('#reportDate').val(date);
            currentDate = moment(start); // 선택한 날짜로 업데이트
            updateDates(); // 선택한 날짜로 가로 날짜 업데이트
            DailyData(date, farmId); // 선택한 날짜의 데이터 가져오기
            $('#calendarModal').modal('hide');
        },
        editable : true,
        events : []
    });

    $('#reportForm').submit(function(event) {
        event.preventDefault();
        // 여기에서 폼 데이터를 서버로 전송하는 코드를 추가합니다.
        alert('리포트가 저장되었습니다.');
    });

    $('.calendar-button').click(function() {
        $('#calendarModal').modal('show');
    });

    function getQueryStringParameter(name) {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get(name);
    }

    
	var envDateList = [];
	var ammList = [];
	var tempList = [];
	var humidList = [];
	var co2List = [];
	var pmList = [];
	var pigDateList = [];
	var livestocks = [];
	var lyingPigs = [];
	var standingPigs = [];
	var warnPigs = [];
	var alertDateList = [];
	var envList = [];
    var pigList = [];
	
	
    function DailyData(date, farmId) {

        console.log(farmId);
        // 환경 데이터 가져옴
        const envPromise = $.ajax({
            url: "${pageContext.request.contextPath}/farm/env/date",
            type: "get",
            dataType: "json",
            data: { farm_id: farmId, date: date }
        });
        
        // 객체 탐지 정보 가져옴
        const detectionPromise = $.ajax({
            url: "${pageContext.request.contextPath}/farm/DetectionInfo/date",
            type: "get",
            dataType: "json",
            data: { farm_id: farmId, date: date }
        });
        
        // 돼지 이상 탐지 정보 가져옴
        const abnormalPromise = $.ajax({
            url: "${pageContext.request.contextPath}/farm/AbnormalInfo/date",
            type: "get",
            dataType: "json",
            data: { farm_id: farmId, date: date }
        });
        
        const alertPromise = $.ajax({
        	 url: "${pageContext.request.contextPath}/farm/alertDate",
             type: "get",
             dataType: "json",
             data: { farm_id: farmId, date: date }
        })
        
        // 모든 프로미스가 완료되었을 때 차트 생성
        Promise.all([envPromise, detectionPromise, abnormalPromise, alertPromise])
            .then(function (responses) {
                // 각각의 AJAX 응답 처리
                const envData = responses[0];
                const detectionData = responses[1];
                const abnormalData = responses[2];
                const alertData = responses[3];

                console.log("날짜별 환경 데이터 " + date + ": ", envData);
                const uniqueEnvDates = new Set(envData.map(item => item.created_at.split(' ')[1].split(':')[0]));
                envDateList = [...uniqueEnvDates];
                console.log(envDateList);
                ammList = envData.map(item => item.ammonia);
                tempList = envData.map(item => item.temperature);
                humidList = envData.map(item => item.humidity);
                co2List = envData.map(item => item.co2);
                pmList = envData.map(item => item.pm);

                console.log("날짜별 탐지 정보 " + date + ": ", detectionData);
                pigDateList = detectionData.map(item => item.created_date.split(' ')[1].split(':')[0]);
                lyingPigs = detectionData.map(item => item.avg_lying_cnt);

                console.log("날짜별 이상 탐지 정보 " + date + ": ", abnormalData);
                warnPigs = abnormalData.map(item => item.avg_warn_cnt);
                livestocks = abnormalData.map(item => item.avg_livestock_cnt);
                standingPigs = livestocks.map((livestock, index) => livestock - lyingPigs[index]);
                
                console.log("날짜별 알림 정보" + date + ': ', alertData);
                const uniqueAlertDates = new Set(alertData.map(item => item.created_at.split(' ')[1].split(':')[0]));
                alertDateList = [...uniqueAlertDates];
                console.log("알람 날짜" + alertDateList);
                envList = [];
                pigList = [];
                alertData.forEach(item => {
                	if (item.type === "env") {
                		envList.push(item.count);
                	} else if (item.type === "pig") {
                		pigList.push(item.count);
                	}
                });

                // 모든 데이터가 준비되면 차트 생성
                createPigCharts(date, pigDateList, livestocks, lyingPigs, warnPigs)
                createEnvCharts(date, envDateList, ammList, tempList, humidList, co2List, pmList);
                createAlertCharts(date, alertDateList, envList, pigList);
            })
    } // 함수

    
    // 돼지 관련 모든 정보 보여주는 bar 그래프
    function createPigCharts(date, pigDateList, livestocks, lyingPigs, warnPigs) {
    	console.log("이상 객체 차트 함수 도착");
        const container = document.getElementById("everyPigChart");

        Highcharts.chart(container, {
            chart: {
                type: 'column'
            },
            title: {
                text: date+' 돼지 정보',
                align: 'left'
            },
            xAxis: {
                categories: pigDateList,
                crosshair: true,
                accessibility: {
                    description: 'hour'
                }
            },
            yAxis: {
                min: 0,
                title: {
                    text: '돼지 수 (마리)'
                }
            },
            tooltip: {
                valueSuffix: ' (마리)'
            },
            credits: {
                enabled: false
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
            series: [
                {
                    name: '전체 돼지 수',
                    data: livestocks,
                },
                {
                	name : '누워 있는 돼지 수',
                	data: lyingPigs,
                },
                {
                    name: '이상 돼지 수',
                    data: warnPigs
                }
                
            ],
            responsive: {
                rules: [{
                    condition: {
                        maxWidth: 500
                    },
                    chartOptions: {
                        legend: {
                            align: 'center',
                            verticalAlign: 'bottom',
                            layout: 'horizontal'
                        },
                        yAxis: {
                            labels: {
                                align: 'left',
                                x: 0,
                                y: -5
                            },
                            title: {
                                text: ''
                            }
                        },
                        subtitle: {
                            text: null
                        },
                        credits: {
                            enabled: false
                        }
                    }
                }]
            }
        }); // 차트
    } // 차트 함수

    if (alertDateList.length !== envList.length || alertDateList.length !== pigList.length) {
        console.error("데이터 리스트의 길이가 일치하지 않습니다.");
        return;
    }
    // 모든 환경 정보 보여주는 그래프
    function createEnvCharts(date, envDateList, ammList, tempList, humidList, co2List, pmList) {
    	console.log("환경 차트 함수 도착");
        const container = document.getElementById("everyEnvChart");

        Highcharts.chart(container, {
            chart: {
                type: 'line'
            },
            title: {
                text: date+' 환경 정보',
                align: 'left'
            },
            xAxis: {
                categories: pigDateList,
                crosshair: true,
                accessibility: {
                    description: 'hour'
                }
            },
            yAxis: {
                min: 0,
                title: {
                    text: ''
                }
            },
            tooltip: {
                valueSuffix: ''
            },
            credits: {
                enabled: false
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
            series: [
                {
                	name : '온도',
                	data: tempList
                },
                {
                    name: '습도',
                    data: humidList
                },
                {
                    name: '암모니아',
                    data: ammList
                },
                {
                	name: '이산화탄소',
                	data: co2List
                },
                {
                	name: '이산화황',
                	data: pmList
                }
                
            ],
            responsive: {
                rules: [{
                    condition: {
                        maxWidth: 500
                    },
                    chartOptions: {
                        legend: {
                            align: 'center',
                            verticalAlign: 'bottom',
                            layout: 'horizontal'
                        },
                        yAxis: {
                            labels: {
                                align: 'left',
                                x: 0,
                                y: -5
                            },
                            title: {
                                text: ''
                            }
                        },
                        subtitle: {
                            text: null
                        },
                        credits: {
                            enabled: false
                        }
                    }
                }]
            }
        }); // 차트
    } // 차트 함수
    
    function createAlertCharts(date, alertDateList, envList, pigList) {
    	console.log("알림 차트 함수 도착");
    	console.log(alertDateList);
    	console.log("envList", envList);
    	console.log("pigList", pigList);
        const container = document.getElementById("everyAlertChart");

        Highcharts.chart(container, {
            chart: {
                type: 'column'
            },
            title: {
                text: date+' 알림 정보',
                align: 'left'
            },
            xAxis: {
                categories: alertDateList,
                crosshair: true,
                accessibility: {
                    description: 'hour'
                }
            },
            yAxis: {
                min: 0,
                title: {
                    text: '수 (개수)'
                }
            },
            tooltip: {
                valueSuffix: ' (개)'
            },
            credits: {
                enabled: false
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
            series: [
                {
                    name: '이상 환경 알림 수',
                    data: envList
                },
                {
                	name : '이상 돼지 알림 수',
                	data: pigList
                }
                
            ],
            responsive: {
                rules: [{
                    condition: {
                        maxWidth: 500
                    },
                    chartOptions: {
                        legend: {
                            align: 'center',
                            verticalAlign: 'bottom',
                            layout: 'horizontal'
                        },
                        yAxis: {
                            labels: {
                                align: 'left',
                                x: 0,
                                y: -5
                            },
                            title: {
                                text: ''
                            }
                        },
                        subtitle: {
                            text: null
                        },
                        credits: {
                            enabled: false
                        }
                    }
                }]
            }
        }); // 차트
    } // 차트 함수
    
   
    
}); // ready 함수 

</script>
</body>
</html>
