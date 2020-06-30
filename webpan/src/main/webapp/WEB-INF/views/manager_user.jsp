<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8" />
    <title>用户管理</title>
	<link rel="stylesheet" type="text/css" href="homepage.css" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
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
				<i class="material-icons icon" style="font-size: large;">search</i>
			</span>
			<input type="text" class="form-control" placeholder="search for users">
		</div>
		<br /><br />
		<h3>
			Hi, Manager! &nbsp;&nbsp;
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

				<c:forEach var="User" items="${UserList}">
					<tr style="color: #000000;">
						<td>${User.getUserID()}</td>
						<td>
							${User.getUserName()}
						</td>
						<td>
							<div class="progress progress-striped active" style="float: left; width: 70%;">
								<div class="progress-bar progress-bar-success" role="progressbar"
									aria-valuenow="50" aria-valuemin="0" aria-valuemax="100"
									style="width: ${ User.getUserUsage()*100 / User.getUserStorage()}%;">
								</div>
							</div>
							<span><strong>&nbsp;&nbsp;&nbsp;&nbsp;${User.getUserUsage()}M / ${User.getUserStorage()}M</strong></span>
						</td>
						<td>
							<a href="javascript:void(0)"
								onclick="document.getElementById('id-apply-box${User.getUserID()}').style.display='block';
										document.getElementById('fade${User.getUserID()}').style.display='block';function()">
								<button class="btn btn-primary">
									<i class="material-icons icon" style="font-size: large;">settings</i>
									管理
								</button>
							</a>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<!-- 这里是容量管理的弹出框 -->
		<div id="id-apply-box" class="upload-box">
			<a href="javascript:void(0)" onclick="document.getElementById('id-apply-box').style.display='none';
				document.getElementById('fade').style.display='none'" style="float: right;">
				取消
			</a>
			<form action="" method="post" class="bs-example bs-example-form" role="form">
				<div style="width:300px;text-align:left">
					<h4>容量管理</h4>
					<hr style="border:0.5px solid black;" />
				</div>
				<br />
				<div class="input-group" style="width:80%;float:left;">
					<span class="input-group-addon">设定大小</span>
					<input type="text" name="points_now" class="form-control title">
				</div>
				<span style="float: left;font-size: 20px;">&nbsp;&nbsp;M</span>
				<br />
				<br />
				<br />
				<button type="submit" class="btn btn-danger" style="width:100px">确定</button>
			</form>
		</div>
	</div>
</body>
</html>
