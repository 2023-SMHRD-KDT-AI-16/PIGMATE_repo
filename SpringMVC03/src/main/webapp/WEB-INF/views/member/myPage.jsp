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
	src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
	
	
	
	
<script type="text/javascript">


	$(document).ready(function() {
		// 페이지 로드 시 농장 목록 가져오기
		getFarm();

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

	function getFarm() {
		$.ajax({
			url : "all",
			type : "get", 
			dataType : "json",
			success : function(data) {
				console.log("AJAX 요청 성공:", data);
				if (data.length === 0) {
					console.warn("서버에서 반환된 데이터가 없습니다.");
				} else {
					makeView(data);
				}
			},
			error : function(xhr, status, error) {
				console.error("AJAX 요청 실패:", status, error); // 오류 로그
				console.error("응답 텍스트:", xhr.responseText); // 응답 텍스트 로그
				alert("농장 데이터를 불러오는 중 오류가 발생했습니다. 상태: " + status + ", 오류: "
						+ error);
			}
		});
	}

	function makeView(data) {
		console.log("makeView 함수 실행:", data);
		var listHtml = "<table class='table table-bordered'>";
		listHtml += "<tr>";
		listHtml += "<td>농장 이름</td>";
		listHtml += "<td>농장 주소</td>";
		listHtml += "<td>사육 두수</td>";
		listHtml += "<td>환경 기준</td>";
		listHtml += "<td>수정</td>";
		listHtml += "<td>삭제</td>";
		listHtml += "</tr>";

		$.each(data, function(index, obj) {
			listHtml += "<tr>";
			listHtml += "<td>" + obj.farm_name + "</td>";
			listHtml += "<td>" + obj.farm_loc + "</td>";
			listHtml += "<td>" + obj.farm_livestock_cnt + "</td>";
			listHtml += "<td><a href='javascript:goContent(" + obj.farm_idx + ")'>" + obj.farm_env_criteria + "</a></td>";
			listHtml += "<td><button class='btn btn-outline-primary' onclick='editFarm(this)'>수정</button></td>";
			listHtml += "<td><button class='btn btn-outline-danger' onclick='deleteFarm(this)'>삭제</button></td>";
			listHtml += "</tr>";
		});

		listHtml += "</table>";
		$("#farmList").html(listHtml);
	}

	function addFarm() {
		var farmData = {
			farm_name: $("#farm_name").val(),
			farm_loc: $("#farm_loc").val(),
			farm_livestock_cnt: $("#farm_livestock_cnt").val()
		};

		$.ajax({
			url: "insertFarm.do",
			type: "post",
			data: farmData,
			success: function(response) {
				$("#modalMessage").text("농장 추가가 완료되었습니다.");
				$("#responseModal").modal("show");
				appendFarmToList(farmData); // 새로운 농장을 목록에 추가
				$("#addFarmForm")[0].reset();
				$("#addFarmForm").hide();
			},
			error: function() {
				alert("농장 추가 중 오류가 발생했습니다.");
			}
		});
	}

	function appendFarmToList(farmData) {
		var newRow = "<tr>";
		newRow += "<td>" + farmData.farm_name + "</td>";
		newRow += "<td>" + farmData.farm_loc + "</td>";
		newRow += "<td>" + farmData.farm_livestock_cnt + "</td>";
		newRow += "<td><a href='javascript:goContent(NEW_IDX)'>" + "환경 기준" + "</a></td>"; // NEW_IDX는 실제 환경 기준의 인덱스로 변경 필요
		newRow += "<td><button class='btn btn-outline-primary' onclick='editFarm(this)'>수정</button></td>";
		newRow += "<td><button class='btn btn-outline-danger' onclick='deleteFarm(this)'>삭제</button></td>";
		newRow += "</tr>";

		$("#farmList table").append(newRow); // 테이블에 새로운 행 추가
	}

	function editFarm(button) {
		alert('아직 구현 안 함');
	}

	function deleteFarm(button) {
		var farmName = $(button).closest('tr').find('td:first').text(); // 농장 이름을 가져옴

		$.ajax({
			url: 'deleteFarm.do',
			type: 'post',
			data: {
				farm_name: farmName
			},
			success: function(response) {
				$(button).closest('tr').remove();
				$("#modalMessage").text(response);
				$("#responseModal").modal("show");
			},
			error: function() {
				alert('농장 삭제 중 오류가 발생했습니다.');
			}
		});
	}
</script>
</head>
<body>



	<%@ include file="../common/sidebar.jsp"%>
		<%@ include file="../common/header.jsp"%>

	<!--  Body Wrapper -->

	<div class="page-wrapper" id="main-wrapper" data-layout="vertical"
		data-navbarbg="skin6" data-sidebartype="full"
		data-sidebar-position="fixed" data-header-position="fixed">

		
		<!--  Main wrapper -->

		<div class="body-wrapper">

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
											<p style="color: black;">이름</p>
											<div class="form-floating mb-3">
												<input value="${member.mem_name}" type="text"
													class="form-control" id="floatingInput" name="mem_name"
													placeholder="name@example.com"> <label
													for="floatingInput">이름 입력</label>
											</div>
											<p style="color: black;">휴대폰 번호</p>
											<div class="form-floating mb-3">
												<input value="${member.mem_phone}" type="text"
													class="form-control" id="floatingInput" name="mem_phone"
													placeholder="name@example.com"> <label
													for="floatingInput">'-'를 포함한 13자리 숫자 입력</label>
											</div>
											<p style="color: black;">이메일</p>
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
									<div id="farmList"></div> <!-- 농장 목록을 표시할 영역 -->
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
								<div class="card-body p-4">
									<h5>농장별 환경 기준</h5>
									<hr>
									<form action="insertEnvCri.do" method="post">
										<div class="form-floating mb-3">
											<label for="farm">Select Farm:</label> <select
												name="farm_idx" id="farm" class="form-control">
												<c:forEach var="farm" items="${farms}">
													<option value="${farm.farm_idx}">${farm.farm_name}</option>
												</c:forEach>
											</select>
										</div>
										<div class="form-floating mb-3">
											<label for="temperature">온도</label> <input type="text"
												class="form-control" id="temperature" name="temperature">
										</div>
										<div class="form-floating mb-3">
											<label for="humidity">습도</label> <input type="text"
												class="form-control" id="humidity" name="humidity">
										</div>
										<div class="form-floating mb-3">
											<label for="co2">이산화탄소</label> <input type="text"
												class="form-control" id="co2" name="co2">
										</div>
										<div class="form-floating mb-3">
											<label for="ammonia">암모니아</label> <input type="text"
												class="form-control" id="ammonia" name="ammonia">
										</div>
										<div class="form-floating mb-3">
											<label for="pm">미세먼지</label> <input type="text"
												class="form-control" id="pm" name="pm">
										</div>
										<div class="row">
											<input type="submit"
												class="btn btn-outline-success pull-right" value="완료">
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

	<!-- 완료 메시지를 위한 모달 -->
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
