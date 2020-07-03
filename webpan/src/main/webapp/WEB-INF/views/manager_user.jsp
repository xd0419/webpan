<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>

<head>
    <meta charset="utf-8" />
    <title>用户管理</title>
	<link rel="stylesheet" type="text/css" href="/webpan/dist/css/homepage.css" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
	<script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
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
			<li class="active"><a href="/webpan/manager/manager_user">用户列表</a></li>
			<li><a href="/webpan/manager/manager_message">消息列表</a></li>
		</ul>
	</div>
	<div style="width: 88%;float: right;">
		<div class="input-group search">
			<span class="input-group-addon">
				<i class="material-icons" style="font-size: large;">search</i>
			</span>
			<input type="text" class="form-control" placeholder="search for user(s)" id="key" onkeydown="onSearch(this)">
		</div>
		<br /><br />
		<h3>
			Hi, Manager&nbsp;<span style="color:#0e90d2;">${User.getUserName()}</span>&nbsp;! &nbsp;&nbsp;
			<a href="/webpan/user/homepage" style="font-size: 15px;text-decoration:underline;">点击返回用户界面</a>
		</h3>
		<br />
		<span style="float: left;font-size: 30px">用户列表</span>

		<!--
		<center><button class="list-title">文件列表</button></center>
		-->
		<table id="notice-list" class="table table-bordered">
			<thead>
				<tr style="color:Highlight;">
					<th style="width: 10%;">序号</th>
					<th style="width: 20%;">用户名</th>
					<th style="width: 50%;">空间使用</th>
					<th style="width: 20%;">容量管理</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="User" items="${UserList}" varStatus="idxStatus">
				
				<tr style="color: #000000;">
					<td style="text-align:center;vertical-align:middle;">${idxStatus.index + 1 }</td>
					<td style="text-align:center;vertical-align:middle;">${User.getUserName()}</td>
					<td style="text-align:center;vertical-align:middle;">
						<div class="progress progress-striped active" style="float: left; width: 70%;">
							<div class="progress-bar progress-bar-success" role="progressbar"
								aria-valuenow="50" aria-valuemin="0" aria-valuemax="100"
								style="width: ${ User.getUserUsage()*100 / User.getUserStorage()}%;">
							</div>
						</div>
						<span><strong>&nbsp;&nbsp;&nbsp;&nbsp;${User.getUserUsage()}M / ${User.getUserStorage()}M</strong></span>
					</td>
					<td>
						<button class="btn btn-primary" data-toggle="modal"  data-target="#mymodal${User.getUserID()}">
							<i class="material-icons icon" style="font-size: large;">settings</i>
							管理
						</button>
						<div class="modal fade" id="mymodal${User.getUserID()}">
							<div class="modal-dialog" style="width: 400px;">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">
											<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
										</button> 
										<h4 class="modal-title" style="float:left;">管理用户 “${User.getUserName()}” 的容量大小</h4>
									</div>
									<div class="modal-body">
										<br />
										<div class="input-group" style="width:80%;float:left;">
											<span class="input-group-addon">设定大小</span>
											<input type="text" required autofocus id="size${User.getUserID()}" class="form-control title">
										</div>
										<span style="float: left;font-size: 20px;">&nbsp;&nbsp;M</span>
										<br /><br />
									</div>
									<div class="modal-footer">
										<button type="button" class="btn btn-default" style="margin-right: 20px;" data-dismiss="modal">取 消</button>
										<button type="submit" class="btn btn-primary" onclick="set_storage(${User.getUserID()});">确 定</button>
									</div>
								</div><!-- /.modal-content -->
							</div><!-- /.modal-dialog -->
						</div><!-- /.modal -->
					</td>
				</tr>
				
				</c:forEach>
				
			</tbody>
		</table>
		
	</div>

	<script>
	function set_storage(id){
		var size = document.getElementById("size"+id).value;
		
		if(size.length == 0){
			alert("请输入要设置的内存大小");
			return;
		}else if(size.indexOf(" ")>=0){
			alert("内存大小中不能有空格");
			return;
		}else if(isNaN(size)){
			alert("输入有误，请重新输入");
			return;
		}
		var setStorageForm = {"UserId":id,"Size":size};
		$.post("/webpan/manager/setStorage",setStorageForm,function(result)
		{
			if(result.toString()=="true"){
				alert("Set Successfully!!!");
				location.reload();
			}
			else{
				alert("Try again??Fail to set...");
			}
		})
	}
	</script>
	<script>
		function change(id){
			var elem = "#mymodal"+id;
			alert(elem)
			document.getElementById("mymodal"+id).modal("toggle");
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
