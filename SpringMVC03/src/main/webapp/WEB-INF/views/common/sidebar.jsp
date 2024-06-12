<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<aside class="left-sidebar">
    <div>
        <div class="brand-logo d-flex align-items-center justify-content-between">
            <a id="homeLogo" href="${contextPath}/" class="text-nowrap logo-img">
                <img src="${contextPath}/resources/img/logos/pigmate-logo.png" alt="" />
            </a>
            <div class="close-btn d-xl-none d-block sidebartoggler cursor-pointer" id="sidebarCollapse">
                <i class="ti ti-x fs-8"></i>
            </div>
        </div>
        <nav class="sidebar-nav scroll-sidebar" data-simplebar="">
            <ul id="sidebarnav">
                <li class="nav-small-cap"><iconify-icon icon="solar:menu-dots-linear" class="nav-small-cap-icon fs-4"></iconify-icon>
                    <span class="hide-menu">Home</span>
                </li>
                <li class="sidebar-item"><a class="sidebar-link home-link" href="${contextPath}/" aria-expanded="false">
                        <iconify-icon icon="solar:widget-add-line-duotone"></iconify-icon> <span class="hide-menu">홈</span>
                    </a></li>
                <li><span class="sidebar-divider lg"></span></li>
                <li class="nav-small-cap"><iconify-icon icon="solar:menu-dots-linear" class="nav-small-cap-icon fs-4"></iconify-icon>
                    <span class="hide-menu">FARM</span>
                </li>
                <c:if test="${not empty sessionScope.mvo}">
                    <c:set var="firstFarmId" value="${sessionScope.mvo.farms[0].farm_idx}" />
                    <c:forEach var="farm" items="${sessionScope.mvo.farms}">
                        <li class="sidebar-item">
                            <div class="d-flex align-items-center justify-content-between">
                                <a class="sidebar-link farm-link" href="${contextPath}/?farmId=${farm.farm_idx}" aria-expanded="false">
                                    <iconify-icon icon="solar:layers-minimalistic-bold-duotone"></iconify-icon>
                                    <span class="hide-menu1">${farm.farm_name}</span>
                                </a>
                                <iconify-icon icon="mdi:chevron-down" class="ms-auto cursor-pointer" onclick="toggleSubmenu('${farm.farm_idx}')"></iconify-icon>
                            </div>
                            <ul id="${farm.farm_idx}" class="collapse list-unstyled">
                                <li class="sidebar-item"><a class="sidebar-link env-link" href="${contextPath}/farmEnv.do?farmId=${farm.farm_idx}">
                                        <iconify-icon icon="mdi:leaf"></iconify-icon> <span class="hide-menu2">축사 정보</span>
                                    </a></li>
                                <li class="sidebar-item"><a class="sidebar-link report-link" href="${contextPath}/reportList.do?farmId=${farm.farm_idx}">
                                        <iconify-icon icon="mdi:file-document-outline"></iconify-icon> <span class="hide-menu2">리포트</span>
                                    </a></li>
                            </ul>
                        </li>
                    </c:forEach>
                </c:if>
                <li><span class="sidebar-divider lg"></span></li>
                <li class="sidebar-item">
                    <c:choose>
                        <c:when test="${empty sessionScope.mvo}">
                            <a class="sidebar-link" href="${contextPath}/loginForm.do" aria-expanded="false">
                                <iconify-icon icon="solar:bookmark-square-minimalistic-line-duotone"></iconify-icon>
                                <span class="hide-menu">뉴스게시판</span>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a class="sidebar-link" href="${contextPath}/newsList.do" aria-expanded="false">
                                <iconify-icon icon="solar:bookmark-square-minimalistic-line-duotone"></iconify-icon>
                                <span class="hide-menu">뉴스게시판</span>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </li>
            </ul>
        </nav>
    </div>
</aside>

<script>
    $(document).ready(function() {
        var currentUrl = window.location.pathname + window.location.search;

        // 활성화 초기화
        $(".sidebar-link").removeClass("active");
        $(".collapse").removeClass("show");

        // URL 정확히 일치하는 사이드바 항목 활성화
        $(".sidebar-link").each(function() {
            var linkUrl = $(this).attr("href");
            var pathName = new URL(linkUrl, window.location.origin).pathname;
            var searchParams = new URL(linkUrl, window.location.origin).search;
            if (currentUrl === pathName + searchParams && currentUrl !== "${contextPath}/") {
                $(this).addClass("active");
                $(this).closest(".collapse").addClass("show");
                $(this).closest(".sidebar-item").find("> .sidebar-link").addClass("active");
            }
        });

        // 로고 클릭 시 홈 활성화
        $("#homeLogo").on("click", function() {
            $(".sidebar-link").removeClass("active");
            $(".collapse").removeClass("show");
            $(".home-link").addClass("active");
        });

        // 홈을 클릭하면 다른 모든 항목을 비활성화
        $(".home-link").on("click", function() {
            $(".sidebar-link").removeClass("active");
            $(".collapse").removeClass("show");
            $(this).addClass("active");
        });

        // 농장 이름 클릭 시 하위 메뉴만 활성화
        $(".farm-link").on("click", function() {
            $(".sidebar-link").removeClass("active");
            $(".collapse").removeClass("show");
            $(this).addClass("active");
            $(this).siblings(".collapse").addClass("show");
        });

        // 하위 메뉴 클릭 시 해당 농장만 활성화
        $(".collapse .sidebar-link").on("click", function() {
            $(".sidebar-link").removeClass("active");
            $(this).addClass("active");
            $(this).closest(".collapse").addClass("show");
            $(this).closest(".sidebar-item").find("> .farm-link").addClass("active");
        });

        // 홈 페이지 로드 시 모든 메뉴 비활성화 및 접기
        if (currentUrl === "${contextPath}/") {
            $(".sidebar-link").removeClass("active");
            $(".collapse").removeClass("show");
            $(".home-link").addClass("active");
        }
    });

    function toggleSubmenu(id) {
        var submenu = document.getElementById(id);
        submenu.classList.toggle('show');
    }
</script>

<style>
    .sidebar-link.active {
        background-color: #6eb876;
        color: white;
        display: block;
        width: 100%;
    }
</style>