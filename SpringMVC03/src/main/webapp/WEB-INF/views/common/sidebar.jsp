<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<aside class="left-sidebar">
	<div>
		<div
			class="brand-logo d-flex align-items-center justify-content-between">
			<a href="${contextPath}/" class="text-nowrap logo-img">
				<img src="${contextPath}/resources/img/logos/pigmate_200x50.png"
				alt="" />
			</a>
			<div
				class="close-btn d-xl-none d-block sidebartoggler cursor-pointer"
				id="sidebarCollapse">
				<i class="ti ti-x fs-8"></i>
			</div>
		</div>
		<nav class="sidebar-nav scroll-sidebar" data-simplebar="">
			<ul id="sidebarnav">

				<li class="nav-small-cap"><iconify-icon
						icon="solar:menu-dots-linear" class="nav-small-cap-icon fs-4"></iconify-icon>
					<span class="hide-menu">Home</span></li>
				<li class="sidebar-item"><a class="sidebar-link"
					href="${contextPath}/" aria-expanded="false"> <iconify-icon
							icon="solar:widget-add-line-duotone"></iconify-icon> <span
						class="hide-menu">홈</span>
				</a></li>

				<li><span class="sidebar-divider lg"></span></li>
				<li class="nav-small-cap"><iconify-icon
						icon="solar:menu-dots-linear" class="nav-small-cap-icon fs-4"></iconify-icon>
					<span class="hide-menu">UI COMPONENTS</span></li>

				<li class="sidebar-item"><c:choose>
						<c:when test="${empty sessionScope.mvo}"><a class="sidebar-link" href="${contextPath}/loginForm.do"
					aria-expanded="false"> <iconify-icon
							icon="solar:layers-minimalistic-bold-duotone"></iconify-icon> <span
						class="hide-menu">돼지정보</span>
				</a>
				</c:when>
						<c:otherwise>
						<a class="sidebar-link" href="#"
					aria-expanded="false"> <iconify-icon
							icon="solar:layers-minimalistic-bold-duotone"></iconify-icon> <span
						class="hide-menu">돼지정보</span>
						</c:otherwise>
					</c:choose>
				</li>

				<li class="sidebar-item"><c:choose>
						<c:when test="${empty sessionScope.mvo}">
							<a class="sidebar-link" href="${contextPath}/loginForm.do"
								aria-expanded="false"> <iconify-icon
									icon="solar:danger-circle-line-duotone"></iconify-icon> <span
								class="hide-menu">환경정보</span>
							</a>
						</c:when>
						<c:otherwise>
							<a class="sidebar-link" href="./farmEnv.do" aria-expanded="false">
								<iconify-icon icon="solar:danger-circle-line-duotone"></iconify-icon>
								<span class="hide-menu">환경정보</span>
							</a>
						</c:otherwise>
					</c:choose></li>

				<li class="sidebar-item"><c:choose>
						<c:when test="${empty sessionScope.mvo}">
							<a class="sidebar-link" href="${contextPath}/loginForm.do"
								aria-expanded="false"> <iconify-icon
									icon="solar:bookmark-square-minimalistic-line-duotone"></iconify-icon>
								<span class="hide-menu">뉴스게시판</span>
							</a>
						</c:when>
						<c:otherwise>
							<a class="sidebar-link" href="${contextPath}/newsList.do"
								aria-expanded="false"> <iconify-icon
									icon="solar:bookmark-square-minimalistic-line-duotone"></iconify-icon>
								<span class="hide-menu">뉴스게시판</span>
							</a>
						</c:otherwise>
					</c:choose></li>

				<li class="sidebar-item"><c:choose>
						<c:when test="${empty sessionScope.mvo}">
							<a class="sidebar-link" href="${contextPath}/loginForm.do"
								aria-expanded="false"> <iconify-icon
									icon="solar:file-text-line-duotone"></iconify-icon> <span
								class="hide-menu">리포트</span>
							</a>
						</c:when>
						<c:otherwise>
							<a class="sidebar-link" href="${contextPath}/reportList.do"
								aria-expanded="false"> <iconify-icon
									icon="solar:file-text-line-duotone"></iconify-icon> <span
								class="hide-menu">리포트</span>
							</a>
						</c:otherwise>
					</c:choose></li>

				<li class="sidebar-item"><c:choose>
						<c:when test="${empty sessionScope.mvo}">
							<a class="sidebar-link" href="${contextPath}/loginForm.do"
								aria-expanded="false"> <iconify-icon
									icon="solar:text-field-focus-line-duotone"></iconify-icon> <span
								class="hide-menu">마이페이지</span>
							</a>
						</c:when>
						<c:otherwise>
							<a class="sidebar-link" href="${contextPath}/myPage.do"
								aria-expanded="false"> <iconify-icon
									icon="solar:text-field-focus-line-duotone"></iconify-icon> <span
								class="hide-menu">마이페이지</span>
							</a>
						</c:otherwise>
					</c:choose></li>

			</ul>
		</nav>
	</div>
</aside>