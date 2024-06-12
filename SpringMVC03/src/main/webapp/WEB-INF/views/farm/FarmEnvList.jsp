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
                                            <button class="btn btn-outline-primary me-3" id="temperature">온도</button>
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
                                        <div class="float-right">
                                            <select class="form-select" id="pigSelect">
                                                <option value="sit">앉아있는 돼지 객체 수</option>
                                                <option value="abnormal">이상행동 객체 수</option>
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

<script src="${pageContext.request.contextPath}/resources/libs/jquery/dist/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/sidebarmenu.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/app.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/libs/apexcharts/dist/apexcharts.min.js"></script>

<script>
    var charts = {};
    var selectedButton = null;
    var selectedPigType = 'sit';

    $(function() {
        console.log("ready!");
        selectedButton = $('#temperature');
        selectedButton.addClass('active');
        loadGraphData('daily', 'temperature', 'myChart');
        loadPigData('sit');
    
        // 환경 그래프 버튼 클릭 이벤트 핸들러
        $('button.btn-outline-primary').click(function() {
            if ($(this).attr('id').startsWith('pig')) {
                return;
            }
            if (selectedButton) {
                $(selectedButton).removeClass('active');
            }
            selectedButton = this;
            $(this).addClass('active');
            updateChart();
        });

        // 돼지 선택 변경 이벤트 핸들러
        $('#pigSelect').change(function() {
            selectedPigType = $(this).val();
            updatePigChart();
        });
        
        // 기간 선택 변경 이벤트 핸들러
        $('#periodSelect').change(function() {
            updateChart();
        });
    });

    function updateChart() {
        if (!selectedButton) return;
        var type = $(selectedButton).attr('id');
        var period = $('#periodSelect').val();
        loadGraphData(period, type, 'myChart');
    }

    function updatePigChart() {
        loadPigData(selectedPigType);
    }

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

    function loadPigData(type) {
        const urlParams = new URLSearchParams(window.location.search);
        var farm_id = urlParams.get('farmId');

        $.ajax({
            url: "${pageContext.request.contextPath}/farm/DetectionInfo",
            type: "get",
            dataType: "json",
            data: { farm_idx: farm_id, type: type },
            success: function(data) {
                makePigData(data, type);
            },
            error: function(request, status, error) {
                console.log("Error fetching pig count data: ", status, error);
            }
        });
    }

    function makePigData(data, type) {
        var dateList = data.map(item => new Date(item.created_at).toLocaleDateString('ko-KR'));
        var pigCountList = data.map(item => item[type + '_cnt']);
        var livestockCountList = data.map(item => item.livestock_cnt); // 전체 돼지 수 데이터

        if (charts['pigChart']) {
            charts['pigChart'].destroy();
        }

        createPigCharts(dateList, pigCountList, livestockCountList, 'pigChart', type);
    }

    function createPigCharts(dateList, pigCountList, livestockCountList, chartId, type) {
        const container = document.getElementById(chartId);

        Highcharts.chart(container, {
            chart: {
                type: 'line'
            },
            title: {
                text: type === 'sit' ? '앉아있는 돼지 객체 수' : '이상행동 객체 수',
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
                    text: type === 'sit' ? '객체 수 (마리)' : '객체 수 (마리)'
                },
                min: 0
            },
            series: [{
                name: '전체 돼지 수',
                data: livestockCountList,
                dataLabels: {
                    enabled: false
                },
                marker: {
                    enabled: false
                }
            }, {
                name: type === 'sit' ? '앉아있는 돼지 객체 수' : '이상행동 객체 수',
                data: pigCountList,
                dataLabels: {
                    enabled: false
                },
                marker: {
                    enabled: false
                }
            }],
            tooltip: {
                shared: true,
                formatter: function () {
                    var s = Highcharts.dateFormat('%Y-%m-%d', this.x);
                    this.points.forEach(function (point) {
                        s += '<br/><span style="color:' + point.series.color + '">\u25CF</span> ' + point.series.name + ': <b>' + point.y + '</b>';
                    });
                    return s;
                }
            },
            credits: {
                enabled: false
            }
        });
    }
</script>
</body>
</html>