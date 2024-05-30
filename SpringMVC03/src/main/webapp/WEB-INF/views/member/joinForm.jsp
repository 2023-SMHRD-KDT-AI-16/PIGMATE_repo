<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Bootstrap Example</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="shortcut icon" type="image/png"
	href="../assets/images/logos/favicon.png" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/styles.css" />
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<script type="text/javascript">

	$(document).ready(function(){
		if(${not empty msgType}){
			if(${msgType eq "실패 메세지"}){ // msgType "실패 메세지"가 아닐 수도있기 때문
				$("#messageType").attr("class", "modal-content panel-warning");
			}
			$("#myMessage").modal("show");
		}
	});


	function idCheck() {
		// 아이디 중복체크
		var mem_id = $("#mem_id").val();
		console.log(mem_id); 
		$.ajax({
			url : "idCheck.do",
			type : "get",
			data : {
				"mem_id" : mem_id
			},
			success : function(data) {
				// data == 1 : 사용가능 or data == 0 : 사용 불가능
				console.log(data); 
				if(data == 1){
					$("#checkMessage").text("사용할 수 있는 아이디 입니다!");
					$("#checkType").attr("class", "modal-content panel-success");
				}else{
					$("#checkMessage").text("사용할 수 없는 아이디 입니다..");
					$("#checkType").attr("class", "modal-content panel-warning");
				}
				
				$("#myModal").modal("show");
				
			},
			error : function() {
				alert("error");
			}
		})
	}
	
	function passwordCheck(){
		var mem_pw1 = $("#mem_pw1").val();
		var mem_pw2 = $("#mem_pw2").val();
		
		if(mem_pw1 != mem_pw2){
			$("#passCheck").text("비밀번호가 서로 일치하지 않습니다.");
		}else{
			$("#passCheck").text("");
			$("#mem_pw").val(mem_pw1);
		}
	}
	
</script>



</head>
<body>

	<div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full"
    data-sidebar-position="fixed" data-header-position="fixed">
    <div
      class="position-relative overflow-hidden text-bg-light min-vh-100 d-flex align-items-center justify-content-center">
      <div class="d-flex align-items-center justify-content-center w-100">
        <div class="row justify-content-center w-100">
          <div class="col-md-8 col-lg-6 col-xxl-3">
            <a href="./index.html" class="text-nowrap logo-img text-center d-block py-3 w-100">
              <img src="../assets/images/logos/pigmate_200x50.png" alt="">
            </a>
            <div class="card mb-0">
              
              <div class="card-body">
                <form>
                  <div class="mb-3" style="height: 21px;">
                    <label for="exampleInputtext1" class="form-label">아이디</label>
                  </div>
                  <div class="mb-3 d-flex">
                    <input style="width: 320px;"   type="text" class="form-control" id="mem_id" name="mem_id" placeholder="아이디 입력(6자~20자)" >
                    <button type="button" class="btn btn-sm btn-primary" style="display: block; margin-left: 43px;" onclick="idCheck()">중복체크</button>
                  </div>
                  <div class="mb-3">
                    <label for="exampleInputEmail1" class="form-label">비밀번호</label>
                    <input type="password" class="form-control" id="mem_pw1" name="mem_pw2" placeholder="비밀번호 입력(문자,숫자,특수문자 포함 8자~20자)">
                  </div>
                  <div class="mb-4">
                    <label for="exampleInputPassword1" class="form-label">비밀번호 확인</label>
                    <input type="password" class="form-control" id="mem_pw2" name="mem_pw2" placeholder="비밀번호 재입력">
                  </div>
                  <div class="mb-3">
                    <label for="exampleInputtext1" class="form-label">사용자 이름</label>
                    <input type="text" class="form-control" id="mem_name" name="mem_name" placeholder="이름 입력" >
                  </div>
                  <div class="mb-3">
                    <label for="exampleInputtext1" class="form-label">전화번호</label>
                    <input type="text" class="form-control" id="mem_phone" name="mem_phone" placeholder="전화번호 입력 ('-'제외 11자리 입력)">
                  </div>
                  <div class="mb-3">
                    <label for="exampleInputtext1" class="form-label">이메일</label>
                    <input type="email" class="form-control" id="mem_email" name="mem_email" placeholder="example@gmail.com">
                  </div>
                   <div class="mb-3">
                    <label for="exampleInputtext1" class="form-label"></label>
                    <input type="submit" class="btn btn-outline-success" id="mem_email" value="회원가입">
                  </div>
                  <div class="d-flex align-items-center justify-content-center">
                    <p class="fs-4 mb-0 fw-bold">이미 계정이 있으신가요?</p>
                    <a class="text-primary fw-bold ms-2" href="/">로그인</a>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

	<!-- 아이디 중복체크를 위한 모달창 -->
	<!-- Modal -->
	<div class="modal fade" id="myModal" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div id="checkType" class="modal-content panel-info">
				<div class="modal-header panel-heading">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">메세지 확인</h4>
				</div>
				<div class="modal-body">
					<p id="checkMessage"></p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>

		</div>
	</div>

	<script src="../assets/libs/jquery/dist/jquery.min.js"></script>
	<script src="../assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
	<script src="../assets/js/sidebarmenu.js"></script>
	<script src="../assets/js/app.min.js"></script>
	<script src="../assets/libs/simplebar/dist/simplebar.js"></script>
	<!-- solar icons -->
	<script
		src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
</body>
</html>
