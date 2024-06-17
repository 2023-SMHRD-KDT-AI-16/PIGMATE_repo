<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>home</title>
<link rel="shortcut icon" type="image/png"
	href="${pageContext.request.contextPath}/resources/img/logos/piglogos.png" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/styles.min.css" />
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/5.3.0/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
<style>
.sidebar-nav .sidebar-item .collapse .sidebar-item {
	padding-left: 20px;
}

body {
	color: #343a40;
	margin: 0;
	padding: 0;
}

.main-section {
	padding: 50px;
	max-width: 1200px;
	margin: auto;
	display: flex;
	align-items: center;
	justify-content: space-between;
}

.main-section .text-content {
	max-width: 600px;
}

.main-section h1 {
	font-size: 4.0rem;
	font-weight: bolder;
	margin-bottom: 20px;
}

.main-section p {
	font-size: 1.2rem;
	line-height: 1.8;
	margin-bottom: 20px;
}

.bold_ {
	font-weight: bold;
}

.main-section img {
	max-width: 100%;
	height: auto;
	border-radius: 10px;
	max-height: 400px; /* 이미지 최대 높이 설정 */
	width: auto; /* 너비는 자동 조정 */
}

.info-section {
	background-color: #ffffff;
	padding: 50px;
	text-align: center;
	margin-top: 30px;
	border-radius: 10px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.info-section h2 {
	font-size: 2.5rem;
	font-weight: bold;
	margin-bottom: 30px;
}

.info-section p {
	font-size: 1.0rem;
	margin-bottom: 20px;
}

.highlight {
	color: #28a745;
	font-weight: bold;
}

#dashboard-preview > p:nth-child(6) > span {
	color: #FF0000;
	font-weight: bold;
}
#dashboard-preview > p:nth-child(10) > span{
	color: #FF0000;
	font-weight: bold;
}
.main-content {
	padding: 20px;
}

.main-content .section {
	background-color: #ffffff;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	margin-bottom: 20px;
}

#home_example1 {
	max-width: 100%;
	height: auto;
	border-radius: 10px;
	max-height: 500px; /* 이미지 최대 높이 설정 */
	width: auto; /* 너비는 자동 조정 */
}

#home_example2 {
	max-width: 100%;
	height: auto;
	border-radius: 10px;
	max-height: 500px; /* 이미지 최대 높이 설정 */
	width: auto; /* 너비는 자동 조정 */
}

.dashboard-preview {
	display: flex;
	flex-direction: column;
	align-items: center;
	padding: 50px;
	margin-top: 30px;
	background-color: #f4f7fb;
	border-radius: 10px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.dashboard-preview img {
	max-width: 100%;
	height: auto;
	border-radius: 10px;
	max-height: 400px;
	width: auto;
}

.dashboard-preview h2 {
	font-size: 2.5rem;
	font-weight: bold;
	margin-bottom: 20px;
}

.dashboard-preview p {
	font-size: 1.0rem;
	margin-bottom: 20px;
}

.dashboard-details {
	display: flex;
	flex-wrap: wrap;
	justify-content: space-around;
	margin-top: 20px;
}

.dashboard-details .detail-item {
	flex: 1;
	min-width: 200px;
	margin: 10px;
	padding: 20px;
	background-color: #ffffff;
	border-radius: 10px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	text-align: center;
}
</style>
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
					<!-- Main Section -->
					<div class="main-section section" id="home">
						<div class="text-content">
							<h1>
								<span class="highlight">"피그메이트"</span>
							</h1>
							<br> <br>
							<p>
								<span class="highlight">딥러닝</span>기술을 통해 농장 내 <span
									class="highlight">돼지를 실시간으로 탐지하고</span> 돼지의 자세를 분석할 수 있습니다.<br>
								<br> 또한, 환경 데이터를 수집하여 축사 내 <span class="highlight">환경
									오염 문제를 신속히 파악</span>할 수 있습니다. <br> <br> <br> <span
									class="bold_">" 피그메이트는 <span class="highlight">최고
										품질의 돼지</span>를 생산할 수 있습니다. "
								</span>

							</p>

						</div>
						<img
							src="${pageContext.request.contextPath}/resources/img/logos/background-pig.png"
							alt="Pig Detection Technology">
					</div>

					<!-- Info Section -->
					<div class="info-section section" id="learn-more">
						<h2>Why Choose Our Technology?</h2>
						<p>"우리의 기술은 돼지를 정확하게 감지하도록 설계되어 농부와 연구원에게 안정적이고 효율적인 솔루션을
							제공합니다."</p>
						<p>"최첨단 AI를 활용해 실시간 모니터링과 데이터 수집을 보장해 의사결정 프로세스를 강화합니다."</p>
						<p>"직관적인 인터페이스와 강력한 기능을 통해 기존 시스템에 쉽게 통합할 수 있어 원활한 작동이 보장됩니다."
						</p>
						<br>
						<hr>
						<br>
						<h2>"피그메이트의 개발자들을 소개합니다!"</h2>
						<br> <img id="home_example2"
							src="${pageContext.request.contextPath}/resources/img/logos/our_team.jpg"
							alt="pigimages">
					</div>

					<!-- Dashboard Preview Section -->
					<div class="dashboard-preview" id="dashboard-preview">
						<h2>실시간 데이터 및 대시보드 미리보기</h2>
						<p>우리의 대시보드를 통해 돼지우리의 환경 및 돼지의 상태를 실시간으로 모니터링하세요.</p>

						<!-- 첫 번째 이미지와 설명 -->
						<img
							src="${pageContext.request.contextPath}/resources/img/logos/home_example01.png"
							alt="Dashboard Preview 1">
						<p>피그메이트는 돼지우리의 온도, 습도, 이산화탄소 및 암모니아 수치를 실시간으로 모니터링합니다.</p>
						<br>
						<p>
							수치가 환경 기준에서 벗어나면 <span class="highlight1">빨간색</span>으로 나타납니다.
						</p>


						<!-- 두 번째 이미지와 설명 -->
						<img
							src="${pageContext.request.contextPath}/resources/img/logos/home_example02.png"
							alt="Dashboard Preview 2">
							<p>돼지의 자세를 분석하여 누워있는 돼지와 서있는 돼지의 수를 보여주고</p>
							<br>
							<p>
								돼지의 체온을 측정하여 기준을 벗어나면 <span class="highlight1">빨간색</span>으로
								나타납니다.
							</p>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script
		src="${pageContext.request.contextPath}/resources/libs/jquery/dist/jquery.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/js/sidebarmenu.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/js/app.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/libs/apexcharts/dist/apexcharts.min.js"></script>
</body>
</html>
