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
	
</script>

<body>
</body>
</html>