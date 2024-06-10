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

    <!-- Iconify for icons -->
    <script src="https://code.iconify.design/2/2.0.3/iconify.min.js"></script>

    <style>
        .sidebar-nav .sidebar-item .collapse .sidebar-item {
            padding-left: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
    </style>

    <script src="${contextPath}/resources/libs/jquery/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
    <script src="${contextPath}/resources/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${contextPath}/resources/js/sidebarmenu.js"></script>
    <script src="${contextPath}/resources/js/app.min.js"></script>
    <script src="${contextPath}/resources/js/dashboard.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full" data-sidebar-position="fixed" data-header-position="fixed">
        <%@ include file="../common/sidebar.jsp" %>
        <div class="body-wrapper">
            <%@ include file="../common/header.jsp" %>
            <div class="body-wrapper-inner">
                <div class="container-fluid">
                    <!--  Row 1 -->
                    <div class="row">
                        <div class="col-lg-8 d-flex align-items-stretch">
                            <div class="card w-100">
                                <div class="card-body">
                                    <div class="d-sm-flex d-block align-items-center justify-content-between mb-9">
                                        <div class="mb-3 mb-sm-0">
                                            <h5 class="card-title fw-semibold">축사환경</h5>
                                        </div>
                                        <div>
                                            <select class="form-select">
                                                <option value="1">우리1</option>
                                                <option value="2">우리2</option>
                                                <option value="3">우리3</option>
                                                <option value="4">우리4</option>
                                            </select>
                                        </div>
                                    </div>
                                    <!-- 실시간 영상이 들어가는 곳 -->
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

                    <!-- Pen Info Table -->
                    <div class="row">
                        <div class="col-lg-12 d-flex align-items-stretch">
                            <div class="card w-100">
                                <div class="card-body">
                                    <h5 class="card-title fw-semibold mb-4">Pen Info</h5>
                                    <c:if test="${empty penInfoList}">
                                        <p></p>
                                    </c:if>
                                    <c:if test="${not empty penInfoList}">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Farm ID</th>
                                                    <!-- 추가 필드들 -->
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="penInfo" items="${penInfoList}">
                                                    <tr>
                                                        <td>${penInfo.id}</td>
                                                        <td>${penInfo.farmIdx}</td>
                                                        <!-- 추가 필드들 -->
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- 그래프 들어가는 곳 -->
                    <div class="row">
                        <div class="col-lg-12 d-flex align-items-stretch">
                            <div class="card w-100">
                                <div class="card-body">
                                    <div>
                                        <!-- 그래프 들어갈 자리 -->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>