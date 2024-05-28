<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Join</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>
<script type="text/javascript">

	$(document).ready(function(){
		// html 파일을 다 읽은 후 함수 실행
		if(${not empty msgType}){
			if(${msgType eq "실패 메세지"}){
				// msgType"실패 메세지"가 아닐 수도 있기 때문에
				// eq = equal
				$("#messageType").attr("class", "modal-content panel-danger");
			}
			$("#myMessage").modal("show");
		}
	});

	function idCheck() {
		// 아이디 중복체크 
		var memId = $("#mem_id").val();
		console.log(mem_id); 

		$
				.ajax({
					url : "idCheck.do",
					type : "get",
					data : {
						"mem_id" : mem_id
					},
					success : function(data) {
						// data == 1 or data == 0 : 사용 불가능
						// console.log(data);
						if (data == 1) {
							$("#checkMessage").text("사용할 수 있는 아이디입니다.");
							$("#checkType").attr("class",
									"modal-content panel-success");
						} else {
							$("#checkMessage").text("중복된 아이디입니다.");
							$("#checkType").attr("class",
									"modal-content panel-danger");
						}

						// 모달창 띄우기
						$("#myModal").modal("show");
					},
					error : function() {
						alert("error");
					}
				})
	}

	function passwordCheck() {

		var memPassword1 = $("#mem_pw1").val();
		var memPassword2 = $("#mem_pw2").val();

		if (mem_pw1 != mem_pw2) {
			$("#passCheck").text("비밀번호가 일치하지 않습니다.");
		} else {
			$("#passCheck").text("");
			$("#mem_pw").val(mem_pw1);
		}
	}
</script>

<body>
</body>
</html>