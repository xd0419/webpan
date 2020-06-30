<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>

<head>
    <meta charset="utf-8" />
    <title>消息管理</title>
	<link rel="stylesheet" type="text/css" href="/webpan/dist/css/homepage.css" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
</head>

<body>
	<div class="container" id="side-box" style="width: 10%; float: left;">
		<ul class="nav nav-pills nav-stacked">
			<li><a href="/webpan/manager/manager_user">用户列表</a></li>
			<li class="active"><a href="/webpan/manager/manager_message">消息列表</a></li>
		</ul>
	</div>
	<div style="width: 88%;float: right;">
		<div class="input-group search">
			<span class="input-group-addon">
				<i class="material-icons icon" style="font-size: large;">search</i>
			</span>
			<input type="text" class="form-control" placeholder="search for messages">
		</div>
		<br /><br />
		<h3>Hi！Manager！</h3>
		<br />
		<span style="float: left;font-size: 30px">消息列表</span>

		<!--
		<center><button class="list-title">文件列表</button></center>
		-->
		<table id="notice-list" class="table table-bordered">
			<thead>
				<tr style="color:Highlight">
					<th style="width: 8%;">序号</th>
					<th style="width: 12%;">用户名</th>
					<th style="width: 40%;">空间使用</th>
					<th style="width: 10%;">申请扩容</th>
					<th style="width: 30%;">消息处理</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach  items="${ApplyList}" var="apply" varStatus="status">
				<tr style="color: #000000;">
					<td>${apply.getApplyID()}</td>
					<td>
						${apply.getApplyUser()}
					</td>
					<td>
						<div class="progress progress-striped active" style="float: left; width: 70%;">
							<div class="progress-bar progress-bar-success" role="progressbar"
								 aria-valuenow="50" aria-valuemin="0" aria-valuemax="100"
								 style="width: ${UserList[status.index].getUserUsage()*100 / UserList[status.index].getUserStorage()}%;">
							</div>
						</div>
						<span><strong>&nbsp;&nbsp;&nbsp;&nbsp;${UserList[status.index].getUserUsage()}M / ${UserList[status.index].getUserStorage()}M</strong></span>
					</td>
					<td>
						${apply.getApplySize()}
					</td>
					<td>
						<c:if test="${!apply.getApplyStatus()}">
							<button class="btn btn-primary" id="agree${apply.getApplyID()}" onclick="agree('${apply.getApplyID()}','${apply.getApplyUser()}','${apply.getApplySize()}');">
							<i class="material-icons icon" style="font-size: large;">assignment_turned_in</i>
							同意 </button>
							<button class="btn btn-danger" id="refuse${apply.getApplyID()}" onclick="refuse('${apply.getApplyID()}','${apply.getApplyUser()}');">
							<i class="material-icons icon" style="font-size: large;">cancel</i>
							拒绝</button>
						</c:if>
						<c:if test="${apply.getApplyStatus()}">
							<button type="button" class="btn btn-primary btn-lg" disabled="disabled">
							<i class="material-icons icon" style="font-size: large;">done</i>
							已处理 </button>
						</c:if>
					</td>
				</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	<!-- Bundle -->
	<script src="https://www.jq22.com/jquery/jquery-3.3.1.js"></script>
	<script src="/webpan/vendor/bundle.js"></script>
	<script src="/webpan/vendor/feather.min.js"></script>
	<script type="text/javascript">
		function agree(id,user,size) {
			var applyID = {"ApplyID":id,"UserName":user,"Size":size};
			$.post("/webpan/manager/agree",applyID,function(result){
				if(result.toString() == "true")
					alert("Agree!")
				else
					alert("Fail to Agree!")
				location.reload();
			})
		}
		
		
	</script>
	<script type="text/javascript">
		function refuse(id,user) {
			var applyID = {"ApplyID":id,"UserName":user};
			$.post("/webpan/manager/refuse",applyID,function(result){
				if(result.toString() == "true")
					alert("Refuse!")
				else
					alert("Fail to Refuse!")
				location.reload();
			})
		}
	</script>
	
	<!-- App scripts -->
	<script src="/webpan/dist/js/app.min.js"></script>
</body>
</html>
