<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>PigMate</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/5.3.0/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/styles.css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

<style>
  @keyframes walk {
    0% { transform: translateX(-100%); }
    100% { transform: translateX(100%); }
  }

  .pig {
    position: absolute;
    bottom: 10%;
    width: 50px;
    height: 50px;
    background: url('${pageContext.request.contextPath}/resources/img/logos/piglogos.png') no-repeat center center;
    background-size: contain;
    animation: walk 5s linear infinite;
  }

  .pig:nth-child(2) {
    animation-delay: 2s;
  }

  .pig:nth-child(3) {
    animation-delay: 4s;
  }

  .logo-container {
      display: flex;
      justify-content: center;
  }

  .logo-image {
      display: block;
      margin: 0 auto;
  }
</style>

<script type="text/javascript">
    $(document).ready(function(){
      if(${not empty msgType}){
        if(${msgType eq "실패 메세지"}){
          $("#messageType").attr("class", "modal-content panel-warning");
        }
        $("#myMessage").modal("show");
      }

      // 돼지 애니메이션 요소를 추가합니다
      for (let i = 0; i < 3; i++) {
        let pig = $('<div class="pig"></div>');
        $('body').append(pig);
      }
    });
</script>

</head>
<body>

	<!--  Body Wrapper 바디를 감싸는 부분 -->
	<div class="page-wrapper" id="main-wrapper" data-layout="vertical"
		data-navbarbg="skin6" data-sidebartype="full"
		data-sidebar-position="fixed" data-header-position="fixed">
		<div
			class="position-relative overflow-hidden text-bg-light min-vh-100 d-flex align-items-center justify-content-center">
			<div class="d-flex align-items-center justify-content-center w-100">
				<div class="row justify-content-center w-100">
					<div class="col-md-8 col-lg-6 col-xxl-3">
						<a href="${contextPath}/index.html"
							class="text-nowrap logo-img text-center d-block py-3 w-100 logo-container">
							<img width="450" height="120"
							src="${pageContext.request.contextPath}/resources/img/logos/pigmate_small.png"
							alt="" class="logo-image">
						</a>
						<div class="card mb-0">
							<div class="card-body">
								<p class="text-center">피그메이트에 오신걸 환영해요</p>

								<!-- form 태그 시작 -->
								<form action="${contextPath}/login.do" method="post">
									<div class="mb-3">
										<label for="mem_id" class="formw-label">아이디</label> <input
											type="text" class="form-control" id="mem_id" name="mem_id"
											placeholder="아이디를 입력하세요." maxlength="20">
									</div>

									<div class="mb-4">
										<label for="mem_pw" class="form-label">비밀번호</label> <input
											type="password" class="form-control" id="mem_pw"
											name="mem_pw" placeholder="비밀번호를 입력하세요." maxlength="20">
									</div>
									<input type="submit"
										class="btn btn-outline-primary w-100 py-8 fs-4 mb-4 rounded-2"
										value="로그인">
									<div class="d-flex align-items-center justify-content-center">
										<p class="fs-4 mb-0 fw-bold">피그메이트가 처음이신가요?</p>
										<a class="text-primary fw-bold ms-2"
											href="${contextPath}/joinForm.do">회원가입</a>
									</div>
								</form>
								<!-- form태그 끝-->



							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 다이얼로그창(모달) -->
	<!-- 회원가입 실패시 나오게될 모달창 -->
	<!-- Modal -->
	<div class="modal fade" id="myMessage" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<!-- Modal content-->
			<div id="messageType" class="modal-content panel-info">
				<div class="modal-header panel-heading">
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					<h4 class="modal-title">${msgType}</h4>
				</div>
				<div class="modal-body">
					<p id="">${msg}</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-bs-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>

	<script
		src="${contextPath}/resources/libs/jquery/dist/jquery.min.js"></script>
	<script
		src="${contextPath}/resources/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
	<script
		src="${contextPath}/resources/js/app.min.js"></script>
	<script
		src="${contextPath}/resources/libs/apexcharts/dist/apexcharts.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
</body>
</html>
