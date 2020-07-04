<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>

<head>
    <meta charset="utf-8" />
    <title>消息管理</title>
	<link rel="stylesheet" type="text/css" href="/webpan/dist/css/homepage.css" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="/webpan/dist/js/logout.js"></script>
    
    <style>
		th,td{
			text-align:center;
			vertical-align:middle;
		}
	</style>
</head>

<body>
	<div class="container" id="side-box" style="width: 10%; float: left;">
		<ul class="nav nav-pills nav-stacked">
			<li><a href="/webpan/manager/manager_user">用户列表</a></li>
			<li class="active"><a href="/webpan/manager/manager_message">消息列表</a></li>
		</ul>
		<button type="button" class="btn" style="position: absolute;float: left;top: 80%;" onclick="logout();">
			<span class="glyphicon glyphicon-log-out"></span>&nbsp;
			<span style="font-size: 10px;">Log out</span>
		</button>
	</div>
	<div style="width: 88%;float: right;">
		<div class="input-group search">
			<span class="input-group-addon">
				<i class="material-icons" style="font-size: large;">search</i>
			</span> 
			<input type="text" class="form-control" placeholder="search for messages of user(s)" id="key" onkeydown="onSearch(this)">
		</div>
		<br /><br />
		<h3>
			Hi, Manager&nbsp;<span style="color:#0e90d2;">${User.getUserName()}</span>&nbsp;! &nbsp;&nbsp;
			<a href="/webpan/user/homepage" style="font-size: 15px;text-decoration:underline;">点击返回用户界面</a>
		</h3>
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
					<th style="width: 15%;">申请扩容</th>
					<th style="width: 25%;">消息处理</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach  items="${ApplyList}" var="apply" varStatus="status">
				<tr style="color: #000000;">
					<td style="text-align:center;vertical-align:middle;">${status.index + 1 }</td>
					<td style="text-align:center;vertical-align:middle;">${apply.getApplyUser()}</td>
					<td style="text-align:center;vertical-align:middle;">
						<div class="progress progress-striped active" style="float: left; width: 70%;">
							<div class="progress-bar progress-bar-success" role="progressbar"
								 aria-valuenow="50" aria-valuemin="0" aria-valuemax="100"
								 style="width: ${UserList[ApplyList.size()-status.index-1].getUserUsage()*100 / UserList[ApplyList.size()-status.index-1].getUserStorage()}%;">
							</div>
						</div>
						<span><strong>&nbsp;&nbsp;&nbsp;&nbsp;${UserList[ApplyList.size()-status.index-1].getUserUsage()}M / ${UserList[ApplyList.size()-status.index-1].getUserStorage()}M</strong></span>
					</td>
					<td style="text-align:center;vertical-align:middle;">
						${apply.getApplySize()}&nbsp;M
					</td>
					<td>
						<c:if test="${!apply.getApplyStatus()}">
							<button class="btn btn-primary btn-left" id="agree${apply.getApplyID()}" onclick="agree('${apply.getApplyID()}','${apply.getApplyUser()}','${apply.getApplySize()}');">
							<i class="material-icons icon" style="font-size: large;">assignment_turned_in</i>
							同意 </button>
							<button class="btn btn-danger" id="refuse${apply.getApplyID()}" onclick="refuse('${apply.getApplyID()}','${apply.getApplyUser()}');">
							<i class="material-icons icon" style="font-size: large;">cancel</i>
							拒绝</button>
						</c:if>
						<c:if test="${apply.getApplyStatus() && apply.getApplyResult()}">
							<button class="btn btn-primary btn-left" disabled="disabled">
							<i class="material-icons icon" style="font-size: large;">done</i>
							已同意 </button>
						</c:if>
						<c:if test="${apply.getApplyStatus() && !apply.getApplyResult()}">
							<button class="btn btn-primary btn-left" disabled="disabled">
							<i class="material-icons icon" style="font-size: large;">done</i>
							已拒绝 </button>
						</c:if>
						<c:if test="${apply.getApplyStatus()}">
							<button class="btn btn-warning" onclick="delete_apply('${apply.getApplyID()}');">
							<i class="material-icons icon" style="font-size: large;">delete_forever</i>
							删除 </button>
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
		function delete_apply(id) {
			if(confirm("确定删除此消息？")){
				var applyID = {"ApplyID":id};
				$.post("/webpan/manager/delete_apply",applyID,function(result){
					if(result.toString() == "true")
						alert("Delete Successfully!!")
					else
						alert("Fail to Delete...")
					location.reload();
				})
	    	 }
	    	 else{
	    		  return;
	    	 }
			
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
	
	<script type="text/javascript">
	function onSearch(obj){
		  setTimeout(function(){
		    var storeId = document.getElementById('notice-list');
		    var rowsLength = storeId.rows.length;
		    var key = obj.value;
		    var searchCol = 1;
		    for(var i=1;i<rowsLength;i++){
		      var searchText = storeId.rows[i].cells[searchCol].innerHTML;
		      if(searchText.match(key)){
		        storeId.rows[i].style.display='';
		      }else{
		        storeId.rows[i].style.display='none';
		      }
		    }
		  },200);//200为延时时间
		}
	
	</script>
	
	<!-- App scripts -->
	<script src="/webpan/dist/js/app.min.js"></script>
</body>
</html>
