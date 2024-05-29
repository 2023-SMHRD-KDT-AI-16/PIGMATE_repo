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
<link rel="shortcut icon" type="image/png"
	href="${pageContext.request.contextPath}/resources/images/person.png" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/styles.css" />
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
      if(${not empty msgType}){
        if(${msgType eq "실패 메세지"}){
          $("#messageType").attr("class", "modal-content panel-warning");
        }
        $("#myMessage").modal("show");
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
							class="text-nowrap logo-img text-center d-block py-3 w-100">
							<!-- 로고 이미지 --> <img width="100" height = "100"
							src="${pageContext.request.contextPath}/resources/images/person.png"
							alt="">
						</a>
						<div class="card mb-0">
							<div class="card-body">
								<p class="text-center">피그메이트에 오신걸 환영해요</p>

								<!-- form 태그 시작 -->
								<form action="${contextPath}/login.do" method="post">
									<div class="mb-3">
										<label for="mem_id" class="form-label">아이디</label> <input
											type="text" class="form-control" id="mem_id" name="mem_id"
											placeholder="아이디를 입력하세요." maxlength="20">
									</div>

									<div class="mb-4">
										<label for="mem_pw" class="form-label">비밀번호</label> <input
											type="password" class="form-control" id="mem_pw"
											name="mem_pw" placeholder="비밀번호를 입력하세요." maxlength="20">
									</div>
									<input type="submit"
										class="btn btn-primary w-100 py-8 fs-4 mb-4 rounded-2"
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
	<div class="modal fade" id="myMessage" role="dialog">
		<div class="modal-dialog">
			<!-- Modal content-->
			<div id="messageType" class="modal-content panel-info">
				<div class="modal-header panel-heading">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">${msgType}</h4>
				</div>
				<div class="modal-body">
					<p id="">${msg}</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>

	
</body>
</html>
