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
<!-- FullCalendar CSS 추가 -->
<link
    href='https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.10.2/fullcalendar.min.css'
    rel='stylesheet' />
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
    flex: 0 0 23%; /* 크기를 4열로 맞추기 위해 설정 */
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
    font-size: 53px;
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

#calendar {
    max-width: 900px;
    margin: 0 auto;
    padding: 20px;
}

.modal-body .alert-item {
    padding: 10px 0;
    border-bottom: 1px solid #ddd;
}

.modal-body .alert-item:last-child {
    border-bottom: none;
}

.fc-event-dot {
    width: 10px;
    height: 10px;
    border-radius: 50%;
    background-color: red;
    display: inline-block;
    margin-right: 5px;
}
</style>

<script src="${contextPath}/resources/libs/jquery/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<!-- FullCalendar JS 추가 -->
<script
    src='https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js'></script>
<script
    src='https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.10.2/fullcalendar.min.js'></script>
<script
    src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
<script
    src="${contextPath}/resources/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
<script src="${contextPath}/resources/js/sidebarmenu.js"></script>
<script src="${contextPath}/resources/js/app.min.js"></script>
<script
    src="${contextPath}/resources/libs/apexcharts/dist/apexcharts.min.js"></script>
<script src="${contextPath}/resources/js/dashboard.js"></script>
<script
    src="https://stackpath.bootstrapcdn.com/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

<c:if test="${not empty sessionScope.mvo}">
    <script>
    const urlParams = new URLSearchParams(window.location.search);
    var farmId = urlParams.get('farmId');
    console.log(farmId);
    </script>
</c:if>

<script>
var charts = {};
var alertCount = {}; // 날짜별 알림 개수 저장 객체

$(document).ready(function() {
    console.log("Document is ready");
    console.log("firstFarmId: ", farmId);
    newsList();
    loadEnvCriteria(farmId);

    initializeCalendar(farmId); // Initial calendar load

    // 사이드바에서 farm_id 선택 시, 알림 데이터를 갱신
    $('.sidebar-item').on('click', function() {
        farmId = $(this).data('farmId');
        loadEnvInfo(farmId);
        loadEnvCriteria(farmId);
        $('#calendar').fullCalendar('destroy'); // 기존 달력 제거
        initializeCalendar(farmId); // 새로운 farm_id로 달력 초기화
    });
});

function initializeCalendar(farmId) {
    // FullCalendar 초기화
    $('#calendar').fullCalendar({
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month'
        },
        editable: true,
        events: function(start, end, timezone, callback) {
            $.ajax({
                url: '${contextPath}/getAlerts', // 알림 데이터를 가져오는 서버측 URL
                data: { farmId: farmId }, // farmId를 파라미터로 추가
                dataType: 'json',
                success: function(data) {
                    console.log("Fetched alerts data: ", data); // 데이터를 확인하는 출력문
                    var events = [];
                    alertCount = {}; // 날짜별 알림 개수 저장 객체 초기화

                    $(data).each(function() {
                        var date = moment(this.alarmedAt).format('YYYY-MM-DD');
                        if (!alertCount[date]) {
                            alertCount[date] = {
                                count: 0,
                                alerts: []
                            };
                        }
                        alertCount[date].count += 1;
                        alertCount[date].alerts.push(this.alarmMsg);
                    });

                    // 알림 개수 표시
                    $.each(alertCount, function(date, details) {
                        events.push({
                            id: date,
                            title: '<span class="fc-event-dot"></span>' + details.count + '개',
                            start: date // 알림 날짜,
                        });
                    });

                    console.log("Events to display: ", events); // 이벤트 데이터를 확인하는 출력문
                    callback(events);
                },
                error: function(xhr, status, error) {
                    console.error("Failed to fetch alerts data: ", status, error); // 오류 메시지 출력
                }
            });
        },
        eventRender: function(event, element) {
            element.find('.fc-title').html(event.title); // 이벤트 타이틀 HTML 업데이트
        },
        eventClick: function(event) {
            var date = event.id;
            var alerts = alertCount[date] ? alertCount[date].alerts : [];
            var alertDetails = alerts.map(alert => {
                var parts = alert.split('내용:');
                return '내용:' + parts[1];
            }).join('<br><hr>'); // 각 알림 사이에 줄과 줄바꿈 추가
            $('#alertDetailsModal .modal-body').html(alertDetails); // 모달 창에 세부 사항 표시
            $('#alertDetailsModal').modal('show'); // 모달 창 표시
        }
    });

    // 로그인 시 해야 할 일 모달 창 표시
    showPendingTasksModal();
    
    // 모달 닫기 버튼 이벤트 리스너
    $('.modal .close, .modal .btn-secondary').on('click', function() {
        $(this).closest('.modal').modal('hide');
    });
}

// 뉴스 기사 가져오기
function newsList() {
    $.ajax({
        url : "board/newsList",
        type : "get",
        dataType : "json",
        success : function(data) {
            makeNews(data);
        },
        error : function() {
            alert("news error");
        }
    }); // ajax 끝
} // 함수

// 뉴스 기사 띄우기
function makeNews(data) {
    console.log("받은 데이터:", data);
    var listHtml = "";

    if (data.newsList) {
        $.each(data.newsList.slice(0, 11), function(index, obj) {
            console.log("뉴스 데이터 이동 성공");
            listHtml += "<tr>";
            listHtml += "<td colspan='2'>";
            listHtml += "<a href='news?news_idx=" + obj.news_idx + "' class='news-title'>" + obj.news_title + "</a>";
            listHtml += "</td>";
            listHtml += "</tr>";
        }); // 반복문 종료
    } else {
        console.error("뉴스 데이터를 찾을 수 없습니다.");
    }

    $("#index_newsList").html(listHtml);
} // 함수

function getQueryStringParameter(name) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
}

// 기준
function loadEnvCriteria(farmId) {
    if (!farmId) {
        farmId = getQueryStringParameter('farmId');
    }
    console.log("loadEnvCriteria farmId: ", farmId);
    $.ajax({
        url: "env/cri",
        type: "get",
        data: { farmId: farmId },
        dataType: "json",
        success: function(criteria) {
            console.log("환경 기준:", criteria);
            loadEnvInfo(criteria);
            console.log(criteria);
        },
        error: function() {
            // alert("환경 기준 정보 로드 오류");
        }
    });
}

function generateRandomFloat(baseValue) {
    let range = baseValue * 0.15; // 기준 값의 20%

    let min = baseValue - range;
    let max = baseValue + range;

    let randomFloatInRange = Math.random() * (max - min) + min;
    let formattedFloatInRange = parseFloat(randomFloatInRange.toFixed(1));
    return formattedFloatInRange;
}

// 실시간 정보 가져오기
function loadEnvInfo(criteria) {
    if (!farmId) {
        farmId = getQueryStringParameter('farmId');
    }
    console.log("loadEnvInfo farmId: ", farmId);
    var cri = criteria;
    
    var amm = generateRandomFloat(cri.ammonia);
    var co = Math.round(generateRandomFloat(cri.co2));
    var createdAt = generateRandomFloat(cri.created_at);
    var criteriaIdx = generateRandomFloat(cri.criteria_idx);
    var farmIdx = generateRandomFloat(cri.farm_idx);
    var humiditY = generateRandomFloat(cri.humidity);
    var pM = generateRandomFloat(cri.pm);
    var temperaturE = generateRandomFloat(cri.temperature);
    
    var now_data = {
            "ammonia": amm,
            "co2": co,
            "created_at": createdAt,
            "criteria_idx": criteriaIdx,
            "farm_idx": farmIdx,
            "humidity": humiditY,
            "pm": pM,
            "temperature": temperaturE
        };
    
    console.log("랜덤 데이터",now_data);
    
    displayEnvInfo(now_data);
    updateEnvStatus(now_data, criteria);

}


//환경 기준에 띄울 정보
function displayEnvInfo(data) {
    var temperature = "N/A";
    var humidity = "N/A";
    var co2 = "N/A";
    var ammonia = "N/A";

    if (Object.keys(data).length > 0) {
        var latestEnv = data;
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

// 환경 정보 요약 카드
function updateEnvStatus(envData, criteria) {
    if (!criteria) {
        console.warn("Criteria is undefined or null");
        return;
    }

    var latestEnv = envData;
    console.log("Latest Environment Data: ", latestEnv);
    console.log("Criteria: ", criteria);

    var tempRange = { min: criteria.temperature * 0.9, max: criteria.temperature * 1.1 };
    var humidityRange = { min: criteria.humidity * 0.9, max: criteria.humidity * 1.1 };
    var co2Range = { min: criteria.co2 * 0.9, max: criteria.co2 * 1.1 };
    var ammoniaRange = { min: criteria.ammonia * 0.9, max: criteria.ammonia * 1.1 };

    updateStatus("#temperature", latestEnv.temperature, tempRange);
    updateStatus("#humidity", latestEnv.humidity, humidityRange);
    updateStatus("#co2", latestEnv.co2, co2Range);
    updateStatus("#ammonia", latestEnv.ammonia, ammoniaRange);
}

// 상태 업데이트(안전, 위험)
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

// 그래프 데이터 가져오는 함수
function loadGraphData(period, type, chartId, farmId) {
    $.ajax({
        url: "${contextPath}/farm/env",
        type: "post",
        dataType: "json",
        data: { period: period, type: type, farmId: farmId },
        success: function(data) {
            console.log("Received data: ", data);
            makeData(data, type, chartId);
        },
        error: function(request, status, error) {
            console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
        }
    });
}

function makeData(data, type, chartId) {
    var dateList = [];
    var valueList = [];

    dateList = data.map(item => item.created_at);
    valueList = data.map(item => item[type]);

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

// 해야 할 일 모달 창 표시 함수
function showPendingTasksModal() {
    $.ajax({
        url: 'getPendingTasks',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            if (data.length > 0) {
                var tasks = '<ul>';
                $.each(data, function(index, task) {
                    tasks += '<li>' + task.description + '</li>';
                });
                tasks += '</ul>';
                $('#pendingTasksModal .modal-body').html(tasks);
                $('#pendingTasksModal').modal('show');
            }
        },
        error: function() {
            console.log('Error while fetching pending tasks');
        }
    });
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
                                    <img src="http://localhost:5000/video_feed" width="600" />
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
                                                <h6 class="mb-0 fs-4">누워있는 돼지 수</h6>
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
                                    <h5 class="card-title fw-semibold mb-4"></h5>
                                    <!-- FullCalendar 추가 -->
                                    <div id="calendar"></div>
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
                                </div>
                            </div>
                        </div>
                    </div>

    <!-- 해야 할 일 모달 창 -->
    <div class="modal fade" id="pendingTasksModal" tabindex="-1"
        role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">해야 할 일</h5>
                    <button type="button" class="close" data-dismiss="modal"
                        aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <!-- 해야 할 일이 여기에 표시됩니다 -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary"
                        data-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 알림 세부 사항 모달 창 -->
    <div class="modal fade" id="alertDetailsModal" tabindex="-1"
        role="dialog" aria-labelledby="alertDetailsModalLabel"
        aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="alertDetailsModalLabel">알림 세부 사항</h5>
                    <button type="button" class="close" data-dismiss="modal"
                        aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <!-- 알림 세부 사항이 여기에 표시됩니다 -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary"
                        data-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>

</body>
</html>