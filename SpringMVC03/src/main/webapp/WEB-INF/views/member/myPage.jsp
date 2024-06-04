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
	href="https://maxcdn.bootstrapcdn.com/bootstrap/5.3.0/css/bootstrap.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/styles.min.css" />
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	

<script type="text/javascript">
	$(document).ready(function() {
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

		$("#saveEnvBtn").click(function(event) {
			event.preventDefault();
			saveEnvCriteria();
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
		listHtml += "<td>관리</td>";
		listHtml += "</tr>";

		$
				.each(
						data,
						function(index, obj) {
							listHtml += "<tr>";
							listHtml += "<td><input type='text' class='form-control' value='" + obj.farm_name + "' data-old-value='" + obj.farm_name + "' readonly></td>";
							listHtml += "<td><input type='text' class='form-control farm-address' value='"
									+ obj.farm_loc
									+ "' readonly onclick='sample6_execDaumPostcode(this)'></td>";
							listHtml += "<td><input type='text' class='form-control' value='" + obj.farm_livestock_cnt + "' readonly></td>";
							listHtml += "<td>";
							listHtml += "<button class='btn btn-outline-primary' onclick='editFarm(this)'>수정</button> ";
							listHtml += "<button class='btn btn-outline-success' onclick='saveFarm(this)' style='display:none'>저장</button> ";
							listHtml += "<button class='btn btn-outline-danger' onclick='deleteFarm(this)'>삭제</button> ";
							listHtml += "<button class='btn btn-outline-dark' onclick='editEnv(this)' data-farm-id='"
									+ obj.farm_idx
									+ "' data-farm-name='"
									+ obj.farm_name + "'>환경 기준</button>";
							listHtml += "</td>";
							listHtml += "</tr>";
						});

		listHtml += "</table>";
		$("#farmList").html(listHtml);
	}

	function sample6_execDaumPostcode(element) {
		new daum.Postcode(
				{
					oncomplete : function(data) {
						var addr = ''; // 주소 변수
						if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
							addr = data.roadAddress;
						} else { // 사용자가 지번 주소를 선택했을 경우(J)
							addr = data.jibunAddress;
						}
						$(element).val(addr);
						$(element).data('zonecode', data.zonecode); // 우편번호 저장
						$(element)
								.closest('td')
								.append(
										'<input type="text" class="form-control" placeholder="상세주소" id="sample6_detailAddress">');
						$(element)
								.closest('td')
								.append(
										'<button class="btn btn-outline-primary" onclick="saveAddress(this)">저장</button>');
					}
				}).open();
	}

	function saveAddress(button) {
		var row = $(button).closest('tr');
		var addressField = row.find('.farm-address');
		var detailAddress = row.find('#sample6_detailAddress').val();
		var fullAddress = addressField.val() + ' ' + detailAddress;

		addressField.val(fullAddress);
		row.find('#sample6_detailAddress').remove();
		$(button).remove();
	}

	function addFarm() {
		var farmData = {
			farm_name : $("#farm_name").val(),
			farm_loc : $("#farm_loc").val(),
			farm_livestock_cnt : $("#farm_livestock_cnt").val()
		};

		$.ajax({
			url : "insertFarm.do",
			type : "post",
			data : farmData,
			success : function(response) {
				$("#modalMessage").text("농장 추가가 완료되었습니다.");
				$("#responseModal").modal("show");
				appendFarmToList(farmData); // 새로운 농장을 목록에 추가
				$("#addFarmForm")[0].reset();
				$("#addFarmForm").hide();
			},
			error : function() {
				alert("농장 추가 중 오류가 발생했습니다.");
			}
		});
	}

	function appendFarmToList(farmData) {
		var newRow = "<tr>";
		newRow += "<td><input type='text' class='form-control' value='" + farmData.farm_name + "' data-old-value='" + farmData.farm_name + "' readonly></td>";
		newRow += "<td><input type='text' class='form-control farm-address' value='"
				+ farmData.farm_loc
				+ "' readonly onclick='sample6_execDaumPostcode(this)'></td>";
		newRow += "<td><input type='text' class='form-control' value='" + farmData.farm_livestock_cnt + "' readonly></td>";
		newRow += "<td>";
		newRow += "<button class='btn btn-outline-primary' onclick='editFarm(this)'>수정</button> ";
		newRow += "<button class='btn btn-outline-success' onclick='saveFarm(this)' style='display:none'>저장</button> ";
		newRow += "<button class='btn btn-outline-danger' onclick='deleteFarm(this)'>삭제</button> ";
		newRow += "<button class='btn btn-outline-dark' onclick='editEnv(this)' data-farm-id='"
				+ farmData.farm_idx
				+ "' data-farm-name='"
				+ farmData.farm_name
				+ "'>환경 기준</button>";
		newRow += "</td>";
		newRow += "</tr>";

		$("#farmList table").append(newRow); // 테이블에 새로운 행 추가
	}

	function editFarm(button) {
		var row = $(button).closest('tr');
		row.find('input').removeAttr('readonly');
		$(button).hide();
		row.find('.btn-outline-success').show();
	}

	function saveFarm(button) {
		var row = $(button).closest('tr');
		var oldFarmName = row.find('td:eq(0) input').data('old-value');
		var newFarmName = row.find('td:eq(0) input').val();
		var farmLoc = row.find('td:eq(1) input').val();
		var farmLivestockCnt = row.find('td:eq(2) input').val();

		$.ajax({
			url : 'editFarm.do',
			type : 'post',
			data : {
				old_farm_name : oldFarmName,
				new_farm_name : newFarmName,
				farm_loc : farmLoc,
				farm_livestock_cnt : farmLivestockCnt
			},
			success : function(response) {
				row.find('input').attr('readonly', 'readonly');
				row.find('.btn-outline-success').hide();
				row.find('.btn-outline-primary').show();
				$("#modalMessage").text(response);
				$("#responseModal").modal("show");
			},
			error : function() {
				alert('농장 수정 중 오류가 발생했습니다.');
			}
		});
	}

	function deleteFarm(button) {
		var farmName = $(button).closest('tr').find('td:first input').val();

		$.ajax({
			url : 'deleteFarm.do',
			type : 'post',
			data : {
				farm_name : farmName
			},
			success : function(response) {
				$(button).closest('tr').remove();
				$("#modalMessage").text(response);
				$("#responseModal").modal("show");
			},
			error : function() {
				alert('농장 삭제 중 오류가 발생했습니다.');
			}
		});
	}

	function editEnv(button) {
		var farmId = $(button).data('farm-id');
		var farmName = $(button).data('farm-name');
		$("#envCriteriaFormTitle").text(farmName + "님의 환경 기준 설정");
		$("#farm_idx").val(farmId);
		console.log("Farm ID:", farmId);

		var $addEnvForm = $("#addEnvForm");

		if ($addEnvForm.is(":visible")) {
			$addEnvForm.hide();
		} else {
			$.ajax({
				url : 'getEnvCriteria.do',
				type : 'get',
				data : {
					farm_idx : farmId
				},
				success : function(response) {
					$("#temperature").val(response.temperature);
					$("#humidity").val(response.humidity);
					$("#co2").val(response.co2);
					$("#ammonia").val(response.ammonia);
					$("#pm").val(response.pm);
					$addEnvForm.show();
				},
				error : function() {
					alert('환경 기준 데이터를 불러오는 중 오류가 발생했습니다.');
				}
			});
		}
	}

	function saveEnvCriteria() {
		var envData = {
			farm_idx : $("#farm_idx").val(),
			temperature : $("#temperature").val(),
			humidity : $("#humidity").val(),
			co2 : $("#co2").val(),
			ammonia : $("#ammonia").val(),
			pm : $("#pm").val()
		};

		console.log("Env Data:", envData);

		$.ajax({
			url : 'insertEnvCri.do',
			type : 'post',
			data : envData,
			success : function(response) {
				console.log("서버 응답:", response);
				$("#modalMessage").text(response);
				$("#responseModal").modal("show");
				$("#addEnvForm").hide();
				alert("환경 기준이 저장되었습니다."); // 완료 알림창
			},
			error : function(xhr, status, error) {
				alert('환경 기준 저장 중 오류가 발생했습니다.');
			}
		});
	}
</script>
</style>
</head>
<body>
	

	<div class="page-wrapper" id="main-wrapper" data-layout="vertical"
		data-navbarbg="skin6" data-sidebartype="full"
		data-sidebar-position="fixed" data-header-position="fixed">
		
		<%@ include file="../common/sidebar.jsp"%>
		<div class="body-wrapper">
	<%@ include file="../common/header.jsp"%>
	
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
											<img src="${pageContext.request.contextPath}/resources/img/profile/user-1.jpg"
												class="rounded-circle" width="100px" height="100px"
												style="padding: 20px;" alt=""> <span
												style="color: black;">${member.mem_name}</span>
										</div>
										<div class="row">
											<input type="button"
												class="btn btn-outline-success" value="수정"
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
											<div class="form-group mb-3">
												<label for="mem_name">이름 입력</label> <input
													value="${member.mem_name}" type="text" class="form-control"
													id="mem_name" name="mem_name">
											</div>
											<p style="color: black;">휴대폰 번호</p>
											<div class="form-group mb-3">
												<label for="mem_phone">'-'를 포함한 13자리 숫자 입력</label> <input
													value="${member.mem_phone}" type="text"
													class="form-control" id="mem_phone" name="mem_phone">
											</div>
											<p style="color: black;">이메일</p>
											<div class="form-group mb-3">
												<label for="mem_email">이메일 입력</label> <input
													value="${member.mem_email}" type="text"
													class="form-control" id="mem_email" name="mem_email">
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
									<div id="farmList"></div>
									<div class="row">
										<input type="button"
											class="btn btn-outline-success pull-right" value="추가"
											id="addFarmBtn">
									</div>

									<div id="addFarmForm" style="display: none;">
										<h5 class="card-title fw-semibold mb-4"></h5>
										<form id="addFarmFormAjax">
											<div class="form-group mb-3">
												<label for="farm_name">농장 이름</label> <input type="text"
													class="form-control" id="farm_name" name="farm_name"
													placeholder="농장 이름">
											</div>
											<div class="form-group mb-3">
												<label for="farm_loc">농장 위치</label> <input type="text"
													class="form-control" id="farm_loc" name="farm_loc"
													placeholder="농장 위치">
											</div>
											<div class="form-group mb-3">
												<label for="farm_livestock_cnt">사육 두수</label> <input
													type="text" class="form-control" id="farm_livestock_cnt"
													name="farm_livestock_cnt" placeholder="사육 두수">
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
							<div class="card mb-0" id="addEnvForm" style="display: none;">
								<div class="card-body p-4">
									<h5 id="envCriteriaFormTitle">농장별 환경 기준</h5>
									<hr>
									<form id="envCriteriaForm">
										<input type="hidden" id="farm_idx" name="farm_idx">
										<div class="form-group mb-3">
											<label for="temperature">온도</label> <input type="text"
												class="form-control" id="temperature" name="temperature">
										</div>
										<div class="form-group mb-3">
											<label for="humidity">습도</label> <input type="text"
												class="form-control" id="humidity" name="humidity">
										</div>
										<div class="form-group mb-3">
											<label for="co2">이산화탄소</label> <input type="text"
												class="form-control" id="co2" name="co2">
										</div>
										<div class="form-group mb-3">
											<label for="ammonia">암모니아</label> <input type="text"
												class="form-control" id="ammonia" name="ammonia">
										</div>
										<div class="form-group mb-3">
											<label for="pm">미세먼지</label> <input type="text"
												class="form-control" id="pm" name="pm">
										</div>
										<div class="row">
											<input type="submit"
												class="btn btn-outline-success pull-right" value="저장"
												id="saveEnvBtn">
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
