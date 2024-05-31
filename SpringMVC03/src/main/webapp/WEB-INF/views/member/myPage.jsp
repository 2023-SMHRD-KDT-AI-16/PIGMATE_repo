<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>피그메이트</title>
<link rel="shortcut icon" type="image/png"
	href="../assets/images/logos/favicon.png" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/styles.css" />
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<script src="../assets/libs/simplebar/dist/simplebar.js"></script>
<script src="../assets/js/sidebarmenu.js"></script>
<script src="../assets/js/app.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$("#editProfileBtn").click(function() {
			$("#inputInfo").toggle();
		});
		$("#addFarmBtn").click(function() {
			$("#addFarmForm").toggle();
		});
		$("#addFarmEndBtn").click(function(event) {
			event.preventDefault();
			addFarm();
		});
	});

	function addFarm() {
		var farmData = {
			farm_name : $("#farm_name").val(),
			farm_loc : $("#farm_loc").val(),
			farm_livestock_cnt : $("#farm_livestock_cnt").val()
		};

		$
				.ajax({
					url : "insertFarm.do",
					type : "post",
					data : farmData,
					success : function(response) {
					    // 농장 추가 성공 시 모달창 띄우기
					    $("#modalMessage").text("농장 추가가 완료되었습니다.");
					    $("#responseModal").modal("show");

					    // 새로운 농장 목록에 추가
					    var newFarmHTML = '<div class="farm-item row">';
					    newFarmHTML += '<div class="col-md-3"><label>농장 이름</label><input type="text" class="form-control farm-name" value="' + farmData.farm_name + '" readonly></div>';
					    newFarmHTML += '<div class="col-md-3"><label>농장 위치</label><input type="text" class="form-control" value="' + farmData.farm_loc + '" readonly></div>';
					    newFarmHTML += '<div class="col-md-3"><label>사육 두수</label><input type="text" class="form-control" value="' + farmData.farm_livestock_cnt + '" readonly></div>';
					    newFarmHTML += '<div class="col-md-3 text-right">';
					    newFarmHTML += '<button class="btn btn-outline-primary" onclick="editFarm(this)">수정</button>';
					    newFarmHTML += ' <button class="btn btn-outline-danger" onclick="deleteFarm(this)">삭제</button>';
					    newFarmHTML += '</div></div>';

					    $("#farmList").append(newFarmHTML);

					    // 폼 초기화
					    $("#addFarmForm")[0].reset();
					    $("#addFarmForm").hide();
					},

					error : function() {
						alert("농장 추가 중 오류가 발생했습니다.");
					}
				});
	}

	function editFarm(button) {
		// 수정 기능 구현
		alert('아직');
	}

	function deleteFarm(button) {
		var farmName = $(button).closest('.farm-item').find('.farm-name').val(); // 농장 이름을 가져옴

		$.ajax({
			url : 'deleteFarm.do',
			type : 'post',
			data : {
				farm_name : farmName
			},
			success : function(response) {
				// 농장 삭제 성공 시 화면에서도 제거
				$(button).closest('.farm-item').remove();

				// 성공 메시지 모달창 띄우기
				$("#modalMessage").text(response);
				$("#responseModal").modal("show");
			},
			error : function() {
				alert('농장 삭제 중 오류가 발생했습니다.');
			}
		});
	}
</script>
</head>

<body>
	<!--  Body Wrapper -->
	<div class="page-wrapper" id="main-wrapper" data-layout="vertical"
		data-navbarbg="skin6" data-sidebartype="full"
		data-sidebar-position="fixed" data-header-position="fixed">
		<!-- Sidebar Start -->
		<aside class="left-sidebar">
			<!-- Sidebar scroll-->
			<div>
				<div
					class="brand-logo d-flex align-items-center justify-content-between">
					<a href="${contextPath}/index.jsp" class="text-nowrap logo-img">
						<img src="../assets/images/logos/pigmate_200x50.png" alt="" />
					</a>
					<div
						class="close-btn d-xl-none d-block sidebartoggler cursor-pointer"
						id="sidebarCollapse">
						<i class="ti ti-x fs-8"></i>
					</div>
				</div>
				<!-- Sidebar navigation-->
				<nav class="sidebar-nav scroll-sidebar" data-simplebar="">
					<ul id="sidebarnav">
						<li class="nav-small-cap"><iconify-icon
								icon="solar:menu-dots-linear" class="nav-small-cap-icon fs-4"></iconify-icon>
							<span class="hide-menu">Home</span></li>
						<li class="sidebar-item"><a class="sidebar-link"
							href="${pageContext.request.contextPath}/" aria-expanded="false">
								<iconify-icon icon="solar:widget-add-line-duotone"></iconify-icon>
								<span class="hide-menu">홈</span>
						</a></li>
						<li><span class="sidebar-divider lg"></span></li>
						<li class="nav-small-cap"><iconify-icon
								icon="solar:menu-dots-linear" class="nav-small-cap-icon fs-4"></iconify-icon>
							<span class="hide-menu">UI COMPONENTS</span></li>
						<li class="sidebar-item"><a class="sidebar-link"
							href="./ui-buttons.html" aria-expanded="false"> <iconify-icon
									icon="solar:layers-minimalistic-bold-duotone"></iconify-icon> <span
								class="hide-menu">돼지 정보</span>
						</a></li>
						<li class="sidebar-item"><a class="sidebar-link"
							href="./ui-alerts.html" aria-expanded="false"> <iconify-icon
									icon="solar:danger-circle-line-duotone"></iconify-icon> <span
								class="hide-menu">환경 정보</span>
						</a></li>
						<li class="sidebar-item"><a class="sidebar-link"
							href="${pageContext.request.contextPath}/newsBoardList.do"
							aria-expanded="false"> <iconify-icon
									icon="solar:bookmark-square-minimalistic-line-duotone"></iconify-icon>
								<span class="hide-menu">뉴스 게시판</span>
						</a></li>
						<li class="sidebar-item"><a class="sidebar-link"
							href="${pageContext.request.contextPath}/reportList.do"
							aria-expanded="false"> <iconify-icon
									icon="solar:file-text-line-duotone"></iconify-icon> <span
								class="hide-menu">리포트</span>
						</a></li>
						<li class="sidebar-item"><a class="sidebar-link"
							aria-expanded="false"
							href="${pageContext.request.contextPath}/myPage.do"> <iconify-icon
									icon="solar:text-field-focus-line-duotone"></iconify-icon> <span
								class="hide-menu">마이페이지</span>
						</a></li>
					</ul>
					<div>
						<ul>
							<li><a href="login.html" class="btn btn-outline-success ">로그아웃</a>
							</li>
						</ul>

					</div>
				</nav>
				<!-- End Sidebar navigation -->
			</div>
			<!-- End Sidebar scroll-->
		</aside>
		<!--  Sidebar End -->

		<!--  Main wrapper -->
		<div class="body-wrapper">
			<!--  Header Start -->
			<header class="app-header">
				<nav class="navbar navbar-expand-lg navbar-light">
					<ul class="navbar-nav">
						<li class="nav-item d-block d-xl-none"><a
							class="nav-link sidebartoggler " id="headerCollapse"
							href="javascript:void(0)"> <i class="ti ti-menu-2"></i>
						</a></li>
						<li class="nav-item"><a class="nav-link "
							href="javascript:void(0)"> <iconify-icon
									icon="solar:bell-linear" class="fs-6"></iconify-icon>
								<div class="notification bg-primary rounded-circle"></div>
						</a></li>
					</ul>
					<div class="navbar-collapse justify-content-end px-0"
						id="navbarNav">
						<ul
							class="navbar-nav flex-row ms-auto align-items-center justify-content-end">
							<li class="nav-item dropdown"><a class="nav-link "
								href="javascript:void(0)" id="drop2" data-bs-toggle="dropdown"
								aria-expanded="false"> <img
									src="../assets/images/profile/user-1.jpg" alt="" width="35"
									height="35" class="rounded-circle">
							</a>
								<div
									class="dropdown-menu dropdown-menu-end dropdown-menu-animate-up"
									aria-labelledby="drop2">
									<div class="message-body">
										<a href="javascript:void(0)"
											class="d-flex align-items-center gap-2 dropdown-item"> <i
											class="ti ti-user fs-6"></i>
											<p class="mb-0 fs-3">My Profile</p>
										</a> <a href="javascript:void(0)"
											class="d-flex align-items-center gap-2 dropdown-item"> <i
											class="ti ti-mail fs-6"></i>
											<p class="mb-0 fs-3">My Account</p>
										</a> <a href="javascript:void(0)"
											class="d-flex align-items-center gap-2 dropdown-item"> <i
											class="ti ti-list-check fs-6"></i>
											<p class="mb-0 fs-3">My Task</p>
										</a> <a href="./login.html"
											class="btn btn-outline-primary mx-3 mt-2 d-block">Logout</a>
									</div>
								</div></li>
						</ul>
					</div>
				</nav>
			</header>
			<!--  Header End -->

			<div class="body-wrapper-inner">
				<div class="container-fluid">
					<div class="card">
						<div class="card-body">
							<h5 class="card-title fw-semibold mb-4">개인정보 > 내 정보</h5>
							<div class="card">
								<div class="card-body p-4">
									<h5>프로필</h5>
									<hr>
									<div class="row">
										<div class="col-lg-4">
											<img src="../assets/images/profile/user-1.jpg"
												class="rounded-circle" width="100px" height="100px "
												style="padding: 20px;" alt=""> <span
												style="color: black;">${member.mem_name}</span>
										</div>
										<div class="row">
											<input type="button"
												class="btn btn-outline-success pull-right" value="수정"
												id="editProfileBtn">
										</div>
									</div>
								</div>
							</div>

							<div id="inputInfo" style="display: none;">
								<h5 class="card-title fw-semibold mb-4"></h5>
								<div class="card mb-0">
									<div class="card-body p-4">
										<form action="update.do" method="post">
											<input type="hidden" name="mem_id" value="${member.mem_id}">
											<h5>입력 정보</h5>
											<hr>
											<p style="color: black;">이름
											<p>
											<div class="form-floating mb-3">
												<input value="${member.mem_name}" type="text"
													class="form-control" id="floatingInput" name="mem_name"
													placeholder="name@example.com"> <label
													for="floatingInput">이름 입력</label>
											</div>
											<p style="color: black;">휴대폰 번호
											<p>
											<div class="form-floating mb-3">
												<input value="${member.mem_phone}" type="text"
													class="form-control" id="floatingInput" name="mem_phone"
													placeholder="name@example.com"> <label
													for="floatingInput">'-'를 포함한 13자리 숫자 입력</label>
											</div>
											<p style="color: black;">이메일
											<p>
											<div class="form-floating mb-3">
												<input value="${member.mem_email}" type="text"
													class="form-control" id="floatingInput" name="mem_email"
													placeholder="name@example.com"> <label
													for="floatingInput">이메일 입력</label>
											</div>
											<div class="row">
												<input type="submit"
													class="btn btn-outline-success pull-right" value="수정 완료">
											</div>
										</form>
									</div>
								</div>
							</div>

							<div class="card mb-0">
								<div class="card-body p-4">
									<h5>농장 정보</h5>
									<hr>
									<div id="farmList">
										<!-- 여기에 농장 목록 추가 -->
									</div>
									<div class="row">
										<input type="button"
											class="btn btn-outline-success pull-right" value="추가"
											id="addFarmBtn">
									</div>

									<div id="addFarmForm" style="display: none;">
										<h5 class="card-title fw-semibold mb-4"></h5>
										<form id="addFarmFormAjax">
											<div class="form-floating mb-3">
												<input type="text" class="form-control" id="farm_name"
													name="farm_name" placeholder="농장 이름"> <label
													for="farm_name">농장 이름</label>
											</div>
											<div class="form-floating mb-3">
												<input type="text" class="form-control" id="farm_loc"
													name="farm_loc" placeholder="농장 위치"> <label
													for="farm_loc">농장 위치</label>
											</div>
											<div class="form-floating mb-3">
												<input type="text" class="form-control"
													id="farm_livestock_cnt" name="farm_livestock_cnt"
													placeholder="사육 두수"> <label
													for="farm_livestock_cnt">사육 두수</label>
											</div>
											<div class="row">
												<input type="submit"
													class="btn btn-outline-success pull-right" value="추가 완료"
													id="addFarmEndBtn">
											</div>
										</form>
									</div>
								</div>
							</div>

							<h5 class="card-title fw-semibold mb-4"></h5>
							<div class="card mb-0">
								<div class="card-body p-4 ">
									<h5>농장별 환경 기준</h5>
									<hr>
									<form action="updateFarmEnvironment.do" method="post">
										<div class="d-flex">
											<p style="color: black;">온도</p>
											<div class="form-floating mb-3">
												<input type="text" class="form-control" id="temperature"
													name="temperature">
												<label for="temperature">숫자 입력</label>
											</div>
											<p style="color: black;">습도</p>
											<div class="form-floating mb-3">
												<input type="text" class="form-control" id="humidity"
													name="humidity" > <label
													for="humidity">숫자 입력</label>
											</div>
											<p style="color: black;">이산화탄소</p>
											<div class="form-floating mb-3">
												<input type="text" class="form-control" id="co2" name="co2"
													> <label for="co2">숫자
													입력</label>
											</div>
											<p style="color: black;">암모니아</p>
											<div class="form-floating mb-3">
												<input type="text" class="form-control" id="ammonia"
													name="ammonia" > <label
													for="ammonia">숫자 입력</label>
											</div>
											<p style="color: black;">미세먼지</p>
											<div class="form-floating mb-3">
												<input type="text" class="form-control" id="pm" name="pm"
													> <label for="pm">숫자
													입력</label>
											</div>
											<div class="row">
												<input type="submit"
													class="btn btn-outline-success pull-right" value="완료">
											</div>
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

	<!-- 완료 메세지를 위한 모달 -->
	<div class="modal fade" id="responseModal" tabindex="-1" role="dialog"
		aria-labelledby="responseModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="responseModalLabel">알림</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<p id="modalMessage"></p>
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
