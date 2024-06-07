<!-- sidebar.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath }" />
<style>
.hide-menu1 {
	font-size: 1rem;
}

.hide-menu2 {
	font-size: 0.755rem;
}

/* 기본 상태 */
.sidebar-link {
  color: #333;
  text-decoration: none;
}


/* 하위 메뉴 */
.collapse {
  transition: max-height 0.5s ease-in-out;
  max-height: 0;
  overflow: hidden;
}

/* 활성화된 부모 메뉴 */
.collapse.show {
  max-height: 500px; /* 충분히 큰 값으로 설정 */
}

</style>
<aside class="left-sidebar">
	<div>
		<div class="brand-logo d-flex align-items-center justify-content-between">
			<a href="${contextPath}/" class="text-nowrap logo-img"> <img src="${contextPath}/resources/img/logos/pigmate_200x50.png" alt="" />
			</a>
			<div class="close-btn d-xl-none d-block sidebartoggler cursor-pointer" id="sidebarCollapse">
				<i class="ti ti-x fs-8"></i>
			</div>
		</div>
		<nav class="sidebar-nav scroll-sidebar" data-simplebar="">
			<ul id="sidebarnav">
				<li class="nav-small-cap">
					<iconify-icon icon="solar:menu-dots-linear" class="nav-small-cap-icon fs-4"></iconify-icon>
					<span class="hide-menu">Home</span>
				</li>
				<li class="sidebar-item"><a class="sidebar-link" href="${contextPath}/" aria-expanded="false"> <iconify-icon icon="solar:widget-add-line-duotone"></iconify-icon> <span class="hide-menu">홈</span></a></li>
				<li><span class="sidebar-divider lg"></span></li>
				<li class="nav-small-cap">
					<iconify-icon icon="solar:menu-dots-linear" class="nav-small-cap-icon fs-4"></iconify-icon>
					<span class="hide-menu">UI COMPONENTS</span>
				</li>
				<!-- 농장 리스트 -->
				<c:if test="${not empty sessionScope.mvo}">
					<c:forEach var="farm" items="${sessionScope.mvo.farms}">
						<li class="sidebar-item">
							<div class="d-flex align-items-center justify-content-between">
								<a class="sidebar-link" href="${contextPath}/?farmId=${farm.farm_idx}" aria-expanded="false"> <iconify-icon icon="solar:layers-minimalistic-bold-duotone"></iconify-icon>
									<span class="hide-menu1">${farm.farm_name}</span>
								</a>
								<iconify-icon icon="mdi:chevron-down" class="ms-auto cursor-pointer" onclick="toggleSubmenu('${farm.farm_idx}')"></iconify-icon>
							</div>
							<ul id="${farm.farm_idx}" class="collapse list-unstyled">
								<li class="sidebar-item"><a class="sidebar-link" href="${contextPath}/#.do?farmId=${farm.farm_idx}"> <iconify-icon icon="mdi:pig"></iconify-icon> <span class="hide-menu2">돼지정보</span></a></li>
								<li class="sidebar-item"><a class="sidebar-link" href="${contextPath}/farmEnv.do?farmId=${farm.farm_idx}"> <iconify-icon icon="mdi:leaf"></iconify-icon> <span class="hide-menu2">환경정보</span></a></li>
								<li class="sidebar-item"><a class="sidebar-link" href="${contextPath}/?farmId=${farm.farm_idx}">
										<iconify-icon icon="mdi:file-document-outline"></iconify-icon>
										<span class="hide-menu2">리포트</span>
									</a></li>
							</ul>
						</li>
					</c:forEach>
				</c:if>
				<!-- 뉴스게시판 -->
				<li class="sidebar-item">
					<c:choose>
						<c:when test="${empty sessionScope.mvo}">
							<a class="sidebar-link" href="${contextPath}/loginForm.do" aria-expanded="false"> <iconify-icon icon="solar:bookmark-square-minimalistic-line-duotone"></iconify-icon>
								<span class="hide-menu">뉴스게시판</span>
							</a>
						</c:when>
						<c:otherwise>
							<a class="sidebar-link" href="${contextPath}/newsList.do" aria-expanded="false"> <iconify-icon icon="solar:bookmark-square-minimalistic-line-duotone"></iconify-icon>
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
	function toggleSubmenu(id) {
		var submenu = document.getElementById(id);
		submenu.classList.toggle('show');
	}
</script>