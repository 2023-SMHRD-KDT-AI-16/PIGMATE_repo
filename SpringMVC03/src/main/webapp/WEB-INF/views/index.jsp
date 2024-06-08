<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>피그메이트</title>
<link rel="shortcut icon" type="image/png" href="${contextPath}/resources/img/logos/piglogos.png" />
<link rel="stylesheet" href="${contextPath}/resources/css/styles.min.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<link href="https://stackpath.bootstrapcdn.com/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
<!-- FullCalendar CSS 추가 -->
<link href='https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.10.2/fullcalendar.min.css' rel='stylesheet' />
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

#calendar {
    max-width: 900px;
    margin: 0 auto;
    padding: 20px;
}
</style>

<script src="${contextPath}/resources/libs/jquery/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<!-- FullCalendar JS 추가 -->
<script src='https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js'></script>
<script src='https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.10.2/fullcalendar.min.js'></script>
<script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
<script src="${contextPath}/resources/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
<script src="${contextPath}/resources/js/sidebarmenu.js"></script>
<script src="${contextPath}/resources/js/app.min.js"></script>
<script src="${contextPath}/resources/libs/apexcharts/dist/apexcharts.min.js"></script>
<script src="${contextPath}/resources/js/dashboard.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

<c:if test="${not empty sessionScope.mvo}">
    <script>
        var firstFarmId = "${sessionScope.mvo.farms[0].farm_idx}";
    </script>
</c:if>

<script>
var charts = {}; 

$(document).ready(function() {
    console.log("Document is ready");
    console.log("firstFarmId: ", firstFarmId);
    newsList();
    loadEnvInfo(firstFarmId);
    loadEnvCriteria();
    loadGraphData('daily', 'temperature', 'myChart1', firstFarmId);
    loadGraphData('daily', 'humidity', 'myChart2', firstFarmId);
    loadGraphData('daily', 'co2', 'myChart3', firstFarmId);
    loadGraphData('daily', 'ammonia', 'myChart4', firstFarmId);
    loadGraphData('daily', 'pm', 'myChart5', firstFarmId);

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
                url: '${contextPath}/getEvents', // 이벤트를 불러올 서버측 URL
                dataType: 'json',
                success: function(data) {
                    var events = [];
                    $(data).each(function() {
                        events.push({
                            id: this.id,
                            title: this.title,
                            start: this.start, // 날짜 형식: 2024-06-08T16:00:00
                            end: this.end,
                            description: this.description
                        });
                    });
                    callback(events);
                }
            });
        },
        selectable: true,
        selectHelper: true,
        select: function(start, end) {
            var title = prompt('Event Title:');
            var eventData;
            if (title) {
                eventData = {
                    title: title,
                    start: start,
                    end: end
                };
                $('#calendar').fullCalendar('renderEvent', eventData, true); // stick? = true
                // 서버에 새 이벤트 저장
                $.ajax({
                    url: '${contextPath}/addEvent',
                    data: {
                        title: title,
                        start: start.format(),
                        end: end.format()
                    },
                    type: 'POST',
                    success: function(response) {
                        console.log('Event added successfully');
                    },
                    error: function(e) {
                        console.log('Error while adding event');
                    }
                });
            }
            $('#calendar').fullCalendar('unselect');
        },
        eventClick: function(event) {
            if (confirm("Do you want to delete this event?")) {
                $('#calendar').fullCalendar('removeEvents', event._id);
                // 서버에서 이벤트 삭제
                $.ajax({
                    url: '${contextPath}/deleteEvent',
                    data: { id: event.id },
                    type: 'POST',
                    success: function(response) {
                        console.log('Event deleted successfully');
                    },
                    error: function(e) {
                        console.log('Error while deleting event');
                    }
                });
            }
        }
    });

    // 로그인 시 해야 할 일 모달 창 표시
    showPendingTasksModal();
});

// 뉴스 기사 가져오기
function newsList() {
    $.ajax({
        url : "board/newsList",
        type : "get",
        dataType : "json",
        success : function(data) {
            console.log("받은 데이터 구조:", data);
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
        $.each(data.newsList.slice(0, 8), function(index, obj) {
            console.log("뉴스 데이터 이동 성공");
            console.log("뉴스 객체:", obj);
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

// 환경 정보 가져오기
function loadEnvInfo(farmId) {
    if (!farmId) {
        farmId = getQueryStringParameter('farmId');
    }

    console.log("Loading environment info for farmId: ", farmId);

    $.ajax({
        url: "index/env",
        type: "post",
        data: { farm_id: farmId },
        dataType: "json",
        success: function(data) {
            console.log("환경 정보:", data);
            displayEnvInfo(data);
            if (data && data.length > 0) {
                loadEnvCriteria(data);
            } else {
                console.error("환경 데이터가 비어있습니다.");
            }
        },
        error: function(request, status, error) {
            console.error("환경 정보 로드 오류");
            console.log("Request: ", request);
            console.log("Status: ", status);
            console.log("Error: ", error);
        }
    });
}

// 환경 기준 가져오기
function loadEnvCriteria(envData) {
    $.ajax({
        url: "env/criteria",
        type: "get",
        dataType: "json",
        success: function(criteria) {
            console.log("환경 기준:", criteria);
            if (envData) {
                updateEnvStatus(envData, criteria);
            } else {
                console.error("환경 데이터가 비어있습니다.");
            }
        },
        error: function() {
            alert("환경 기준 정보 로드 오류");
        }
    });
}

// 환경 기준에 띄울 정보
function displayEnvInfo(data) {
    var temperature = "N/A";
    var humidity = "N/A";
    var co2 = "N/A";
    var ammonia = "N/A";

    if (data.length > 0) {
        var latestEnv = data[data.length - 1];
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

// 
function updateEnvStatus(envData, criteria) {
    var latestEnv = envData[envData.length - 1];

    var tempRange = { min: criteria.temperature * 0.9, max: criteria.temperature * 1.1 };
    var humidityRange = { min: criteria.humidity * 0.9, max: criteria.humidity * 1.1 };
    var co2Range = { min: criteria.co2 * 0.9, max: criteria.co2 * 1.1 };
    var ammoniaRange = { min: criteria.ammonia * 0.9, max: criteria.ammonia * 1.1 };

    updateStatus("#temperature", latestEnv.temperature, tempRange);
    updateStatus("#humidity", latestEnv.humidity, humidityRange);
    updateStatus("#co2", latestEnv.co2, co2Range);
    updateStatus("#ammonia", latestEnv.ammonia, ammoniaRange);
}

// 
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
                pointRadius: 0,
                pointHoverRadius: 0
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
                pointRadius: 0,
                pointHoverRadius: 0
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
                pointRadius: 0,
                pointHoverRadius: 0
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
                pointRadius: 0,
                pointHoverRadius: 0
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
                pointRadius: 0,
                pointHoverRadius: 0
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
    <div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full" data-sidebar-position="fixed" data-header-position="fixed">
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
                                        <span id="temperature" class="envContent">N/A</span><span id="tem-text" class="unitss">°C</span>
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
                                        <span id="humidity" class="envContent">N/A</span> <span id="hum-text" class="unitss">%</span>
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
                                        <span id="co2" class="envContent">N/A</span> <span id="co2-text" class="unitss">ppm</span>
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
                                        <span id="ammonia" class="envContent">N/A</span> <span id="amm-text" class="unitss">mg/m³</span>
                                        <div class="status">쾌적해요</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-8 d-flex align-items-stretch">
                            <div class="card w-100">
                                <div class="card-body">
                                    <div class="d-sm-flex d-block align-items-center justify-content-between mb-9">
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
                                                <span class="round-48 d-flex align-items-center justify-content-center rounded bg-secondary-subtle">
                                                    <iconify-icon icon="healthicons:animal-pig" class="fs-6 text-secondary"></iconify-icon>
                                                </span>
                                                <h6 class="mb-0 fs-4">앉아있는 돼지 수</h6>
                                            </div>
                                            <div class="d-flex align-items-center justify-content-between mb-6">
                                                <h6 class="mb-0 fw-medium">객체 탐지 결과</h6>
                                                <h6 class="mb-0 fw-medium">8두</h6>
                                            </div>
                                            <div class="progress" role="progressbar" aria-label="Basic example" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100" style="height: 7px;">
                                                <div class="progress-bar bg-secondary" style="width: 83%"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-12">
                                    <div class="card">
                                        <div class="card-body">
                                            <div class="d-flex align-items-center gap-6 mb-4 pb-3">
                                                <span class="round-48 d-flex align-items-center justify-content-center rounded bg-warning-subtle">
                                                    <iconify-icon icon="healthicons:animal-pig" class="fs-6 text-warning"></iconify-icon>
                                                </span>
                                                <h6 class="mb-0 fs-4">서 있는 돼지 수</h6>
                                            </div>
                                            <div class="d-flex align-items-center justify-content-between mb-6">
                                                <h6 class="mb-0 fw-medium">객체 탐지 결과</h6>
                                                <h6 class="mb-0 fw-medium">5두</h6>
                                            </div>
                                            <div class="progress" role="progressbar" aria-label="Basic example" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100" style="height: 7px;">
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
                                    <h5 class="card-title fw-semibold mb-4">환경 정보 요약</h5>
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
                                        <table class="table text-nowrap align-middle table-custom mb-0">
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
                    <div class="row">
                        <div class="col-lg-12 d-flex align-items-stretch">
                            <div class="card w-100">
                                <div class="card-body">
                                    <div>
                                        <canvas id="myChart1" width="4000" height="2000"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-12 d-flex align-items-stretch">
                            <div class="card w-100">
                                <div class="card-body">
                                    <div>
                                        <canvas id="myChart2" width="4000" height="2000"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-12 d-flex align-items-stretch">
                            <div class="card w-100">
                                <div class="card-body">
                                    <div>
                                        <canvas id="myChart3" width="4000" height="2000"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-12 d-flex align-items-stretch">
                            <div class="card w-100">
                                <div class="card-body">
                                    <div>
                                        <canvas id="myChart4" width="4000" height="2000"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-12 d-flex align-items-stretch">
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

    <!-- 해야 할 일 모달 창 -->
    <div class="modal fade" id="pendingTasksModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">해야 할 일</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <!-- 해야 할 일이 여기에 표시됩니다 -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>

</body>
</html>