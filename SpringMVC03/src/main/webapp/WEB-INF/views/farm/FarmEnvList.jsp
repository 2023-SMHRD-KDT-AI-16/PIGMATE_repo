<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

	<h1>env</h1>
	
	<div>
        <canvas id="myChart" width="4000" height="2000"></canvas>
    </div>
	
	<script>

	
		$(function(){
			
			console.log("ready!");
			
			$.ajax({
				url : "farm",
				type : "post",
				dateType : "json",
				success : makeData,
				error : function(){
					alert("error")
					}
			}) // ajax
		}); // 함수
		
		function makeData(data){
			
			var dateList = [];
			var tempList = [];
			
			$.each(data, function(){
				dateList.push(this["created_at"]);
				tempList.push(this["temperature"]);
			});
			
			createChart(dateList, tempList);
			
		}
		
	</script>

	
		<script>
		
			// 그래프
			function createChart(dateList, tempList) {
			const ctx = document.getElementById('myChart').getContext('2d');
			
			const myChart = new Chart(ctx, {
				type : 'line',
				data : {
					labels : dateList,
					datasets : [{
						label : '시간별 온도',
						data : tempList,
						backgroundColor : [
							'lightblue'
						],
						borderColor : [
							'lightblue'
						],
						borderWidth : 3
					}]
				},
				options : {
					scales :{
						y: {
							beginAtZero : true
						}
					} //scales
				} // options
			}); //chart
		
		}
		
		</script>


</body>
</html>