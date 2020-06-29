<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>

<head>
    <meta charset="utf-8" />
    <title>下载列表</title>
	<link rel="stylesheet" type="text/css" href="/webpan/dist/css/homepage.css" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
	<script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
	<style>
		
	</style>
</head>

<body>
	<div class="container" id="side-box" style="width: 10%; float: left;">
		<ul class="nav nav-pills nav-stacked">
			<li><a href="/webpan/user/homepage">文件列表</a></li>
			<li><a href="/webpan/user/upload">上传列表</a></li>
			<li class="active"><a href="/webpan/user/download">下载列表</a></li>
		</ul>
	</div>
	<div style="width: 88%;float: right;">
	<h4>Hi, ${User.getUserName()}!</h4>
	<h2>下载文件列表</h2>
	<!--
	<center><button class="list-title">文件列表</button></center>
	-->
	<table id="notice-list" class="table table-bordered">
		<thead>
			<tr style="color:Highlight">
				<th style="width: 10%;">序号</th>
				<th style="width: 30%;">文件名</th>
				<th style="width: 30%;">进度</th>
				<th style="width: 30%;">操作</th>
			</tr>
		</thead>
		<tbody>
			<tr style="color: #000000;">
				<td>1</td>
				<td>
					文件名<br />
					文件大小
				</td>
				<td>
					<div class="progress progress-striped active" style="float: left; width: 80%;">
						<div class="progress-bar progress-bar-info" role="progressbar"
							 aria-valuenow="50" aria-valuemin="0" aria-valuemax="100"
							 style="width: 30%;">
						</div>
					</div>
					<span><strong>&nbsp;&nbsp;&nbsp;30%</strong></span>
				</td>
				<td>
					<!--
					<button class="btn btn-primary" >
						<i class="material-icons icon" style="font-size: large;">play_arrow</i>
						继续 </button>
					-->
					<button class="btn btn-primary" >
						<i class="material-icons icon" style="font-size: large;">pause</i>
						暂停 </button>
					<button class="btn btn-danger">
						<i class="material-icons icon" style="font-size: large;">delete_forever</i>
						取消</button>
				</td>
			</tr>
			<tr style="color: #000000;">
				<td>2</td>
				<td>
					文件名<br />
					文件大小
				</td>
				<td>
					<div class="progress progress-striped active" style="float: left; width: 80%;">
						<div class="progress-bar progress-bar-info" role="progressbar"
							 aria-valuenow="50" aria-valuemin="0" aria-valuemax="100"
							 style="width: 90%;">
						</div>
					</div>
					<span><strong>&nbsp;&nbsp;&nbsp;90%</strong></span>
				</td>
				<td>
					<button class="btn btn-primary" >
						<i class="material-icons icon" style="font-size: large;">play_arrow</i>
						继续 </button>
						<!--
						<i class="material-icons icon" style="font-size: large;">pause</i>
						暂停 </button>
						-->
					<button class="btn btn-danger">
						<i class="material-icons icon" style="font-size: large;">delete_forever</i>
						取消</button>
				</td>
			</tr>
		</tbody>
	</table>
	</div>
</body>
</html>
