<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Bootstrap Example</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<link rel="shortcut icon" type="image/png"
	href="../assets/images/logos/favicon.png" />
<link rel="stylesheet" href="./styles.min.css" />
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

	<div class="container">

		<jsp:include page="../common/header.jsp" />
		<h2>Spring MVC03</h2>
		<div class="panel panel-default">
			<div class="panel-heading">회원가입</div>
			<div class="panel-body">

				<form action="join.do" method="post">

					<input type="hidden" id="mem_pw" name="mem_pw" value="">

					<table class="table table-bordered"
						style="border: 1px solid #dddddd; text-align: center;">

						<tr>
							<td style="vertical-align: middle; width: 110px;">아이디</td>
							<td><input type="text" name="mem_id" id="mem_id"
								class="form-control" placeholder="아이디를 입력하세요." maxlength="20"></td>
							<td style="width: 110px">
								<button type="button" class="btn btn-sm btn-primary"
									onclick="idCheck()">중복체크</button>
							</td>
						</tr>

						<tr>
							<td style="vertical-align: middle; width: 110px;">비밀번호</td>
							<td colspan="2"><input type="password" maxlength="20"
								onkeyup="passwordCheck()" name="mem_pw1" id="mem_pw1"
								class="form-control" placeholder="비밀번호를 입력하세요."></td>
						</tr>
						<tr>
							<td style="vertical-align: middle; width: 110px;">비밀번호확인</td>
							<td colspan="2"><input type="password" maxlength="20"
								onkeyup="passwordCheck()" name="mem_pw2" id="mem_pw2"
								class="form-control" placeholder="비밀번호를 입력하세요."></td>
						</tr>
						<tr>
							<td style="vertical-align: middle; width: 110px;">사용자이름</td>
							<td colspan="2"><input type="text" maxlength="20"
								name="mem_name" id="mem_name" class="form-control"
								placeholder="이름을 입력하세요."></td>
						</tr>
						<tr>
							<td style="vertical-align: middle; width: 110px;">전화번호</td>
							<td colspan="2"><input type="text" maxlength="50"
								name="mem_phone" id="mem_phone" class="form-control"
								placeholder="전화번호를 입력하세요."></td>
						</tr>
						<tr>
							<td style="vertical-align: middle; width: 110px;">이메일</td>
							<td colspan="2"><input type="email" maxlength="50"
								name="mem_email" id="mem_email" class="form-control"
								placeholder="이메일을 입력하세요."></td>
						</tr>

						<tr>
							<td colspan="3"><span id="passCheck" style="color: red;"></span>
								<input type="submit" class="btn btn-sm btn-primary" value="회원가입">
								<input type="reset" class="btn btn-sm btn-warning" value="초기화">
							</td>
						</tr>


					</table>

				</form>

			</div>
			<div class="panel-footer"></div>
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


</body>
</html>
