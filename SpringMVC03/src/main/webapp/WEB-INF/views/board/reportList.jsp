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

.calendar-container .calendar-button {
    position: absolute;
    top: 10px;
    right: 10px;
    cursor: pointer;
    background-color: #007bff;
    color: white;
    border: none;
    padding: 10px;
    border-radius: 5px;
}

.calendar-container .calendar-button:hover {
    background-color: #0056b3;
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
                            </div>
                            <div class="row">
                                <div class="col-lg-8 d-flex align-items-stretch">
                                    <div class="graph-container">
                                        <h5 class="card-title fw-semibold mb-4">리포트 목록</h5>
                                        <!-- 그래프를 추가할 공간 -->
                                    </div>
                                </div>
                                <div class="col-lg-4 d-flex align-items-stretch">
                                    <div class="calendar-container">
                                        <button class="calendar-button" data-toggle="modal" data-target="#calendarModal">
                                            달력 열기
                                        </button>
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
            }

            $('#prev-day').on('click', function() {
                currentDate.subtract(1, 'days');
                updateDates();
            });

            $('#next-day').on('click', function() {
                currentDate.add(1, 'days');
                updateDates();
            });

            updateDates();

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
                    $('#calendarModal').modal('hide');
                },
                editable : true,
                events : []
                // 여기에서 서버에서 가져온 이벤트 데이터를 넣을 수 있습니다.
            });

            $('#reportForm').submit(function(event) {
                event.preventDefault();
                // 여기에서 폼 데이터를 서버로 전송하는 코드를 추가합니다.
                alert('리포트가 저장되었습니다.');
            });
        });
    </script>
</body>
</html>
