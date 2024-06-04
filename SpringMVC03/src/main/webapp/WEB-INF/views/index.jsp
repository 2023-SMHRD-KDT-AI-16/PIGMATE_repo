<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<!doctype html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Matdash Free</title>
<link rel="shortcut icon" type="image/png"
    href="${contextPath}/resources/img/logos/favicon.png" />

<link rel="stylesheet"
    href="${contextPath}/resources/css/styles.min.css" />
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
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
</style>
<script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
<script src="${contextPath}/resources/libs/jquery/dist/jquery.min.js"></script>
<script src="${contextPath}/resources/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
<script src="${contextPath}/resources/js/sidebarmenu.js"></script>
<script src="${contextPath}/resources/js/app.min.js"></script>
<script src="${contextPath}/resources/libs/apexcharts/dist/apexcharts.min.js"></script>
<script src="${contextPath}/resources/js/dashboard.js"></script>

<script type="text/javascript">
    $(document).ready(function() {
        console.log("Document is ready");
        newsList();
    });

    function newsList() {
        $.ajax({
            url: "board/newsList",
            type: "get",
            dataType: "json",
            success: function(data) {
                console.log("받은 데이터 구조:", data); // 데이터 구조 확인
                makeView(data);
            },
            error: function() {
                alert("news error");
            }
        });
    }

    function makeView(data) {
        console.log("받은 데이터:", data); // 데이터 구조 확인
        var listHtml = "";

        // 서버에서 반환된 데이터 구조에 맞게 경로 수정
        if (data.newsList) {
            $.each(data.newsList.slice(0, 8), function(index, obj) { // 첫 7개 항목만 처리
                console.log("뉴스 데이터 이동 성공");
                console.log("뉴스 객체:", obj); // 각 뉴스 객체 확인
                listHtml += "<tr>";
                listHtml += "<td colspan='2'>";
                listHtml += "<a href='news?news_idx=" + obj.news_idx + "' class='news-title'>" + obj.news_title + "</a>";
                listHtml += "</td>";
                listHtml += "</tr>";
            });
        } else {
            console.error("뉴스 데이터를 찾을 수 없습니다.");
        }

        $("#index_newsList").html(listHtml);
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
                                    <!-- 여기에 축사환경 영상이 들어갑니다.-->
                                </div>
                            </div>
                        </div>
                        <!--여기에 환경 정보 요약이 들어갑니다.-->
                        <div class="col-lg-4">
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="card">
                                        <div class="card-body">
                                            <div class="d-flex align-items-center gap-6 mb-4 pb-3">
                                                <span class="round-48 d-flex align-items-center justify-content-center rounded bg-secondary-subtle">
                                                    <iconify-icon icon="solar:football-outline" class="fs-6 text-secondary"></iconify-icon>
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
                                                    <iconify-icon icon="solar:football-outline" class="fs-6 text-warning"></iconify-icon>
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
                        <div class="col-lg-8 d-flex align-items-stretch">
                            <div class="card w-100">
                                <div class="card-body p-4">
                                    <h5 class="card-title fw-semibold mb-4">환경 정보 요약</h5>
                                    <div class="table-responsive" data-simplebar>
                                        <table class="table text-nowrap align-middle table-custom mb-0">
                                            <thead>
                                                <tr>
                                                    <th scope="col" class="text-dark fw-normal ps-0">구분</th>
                                                    <th scope="col" class="text-dark fw-normal">상태</th>
                                                    <th scope="col" class="text-dark fw-normal">중요도</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td class="ps-0">
                                                        <div class="d-flex align-items-center gap-6">
                                                            <img src="${contextPath}/resources/img/products/dash-prd-1.jpg" alt="prd1" width="48" class="rounded" />
                                                            <div>
                                                                <h6 class="mb-0">온도</h6>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span>24.5%</span></td>
                                                    <td><span class="badge bg-success-subtle text-success">낮음</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="ps-0">
                                                        <div class="d-flex align-items-center gap-6">
                                                            <img src="${contextPath}/resources/img/products/dash-prd-2.jpg" alt="prd1" width="48" class="rounded" />
                                                            <div>
                                                                <h6 class="mb-0">습도</h6>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span>65.2%</span></td>
                                                    <td><span class="badge bg-success-subtle text-success">낮음</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="ps-0">
                                                        <div class="d-flex align-items-center gap-6">
                                                            <img src="${contextPath}/resources/img/products/dash-prd-3.jpg" alt="prd1" width="48" class="rounded" />
                                                            <div>
                                                                <h6 class="mb-0">암모니아</h6>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span>75㎍/dL</span></td>
                                                    <td><span class="badge bg-secondary-subtle text-secondary">중간</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="ps-0">
                                                        <div class="d-flex align-items-center gap-6">
                                                            <img src="${contextPath}/resources/img/products/dash-prd-4.jpg" alt="prd1" width="48" class="rounded" />
                                                            <div>
                                                                <h6 class="mb-0">이산화탄소</h6>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span>700ppm</span></td>
                                                    <td><span class="badge bg-danger-subtle text-danger">높음</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="ps-0">
                                                        <div class="d-flex align-items-center gap-6">
                                                            <img src="${contextPath}/resources/img/products/s4.jpg" alt="prd1" width="48" class="rounded" />
                                                            <div>
                                                                <h6 class="mb-0">미세먼지</h6>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span>17㎍/m³</span></td>
                                                    <td><span class="badge bg-danger-subtle text-danger">높음</span></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 여기에 한돈 뉴스가 들어갑니다.-->
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
                                                <!-- 뉴스 들어감 -->
                                            </tbody>
                                        </table>
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