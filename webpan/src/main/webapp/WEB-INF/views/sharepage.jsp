<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>

<head>
    <meta charset="utf-8" />
    <title>共享空间</title>
	<link rel="stylesheet" type="text/css" href="/webpan/dist/css/homepage.css" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
	<script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
	<script src="/webpan/dist/js/logout.js"></script>
	<style>
		th,td{
			text-align:center;
			vertical-align: middle;
		}
	</style>
</head>

<body>
	<div class="container" id="side-box" style="width: 10%; float: left;">
		<ul class="nav nav-pills nav-stacked">
			<li><a href="/webpan/user/homepage">文件列表</a></li>
			<li><a href="/webpan/file/uploadpage">上传文件</a></li>
			<li class="active"><a href="/webpan/file/sharepage">共享空间</a></li>
		</ul>
		<button type="button" class="btn" style="position: absolute;float: left;top: 80%;" onclick="logout();">
			<span class="glyphicon glyphicon-log-out"></span>&nbsp;
			<span style="font-size: 10px;">Log out</span>
		</button>
	</div>
	<div style="width: 88%;float: right;">
	<br/>
	<h3>
		Hi, <span style="color:#0e90d2;">${User.getUserName()}</span>!&nbsp;&nbsp;&nbsp;
		<c:if test="${User.getUserType()=='admin'}">
		<a href="/webpan/manager/manager_user" style="font-size: 15px;text-decoration:underline;">点击进入管理员界面</a>
		</c:if>
	</h3>
	<br />
	<h4>请输入分享码获取分享文件信息</h4>
	<br />
	<div class="input-group" style="width:50%;">
		<span class="input-group-addon">分享码</span>
		<input type="password" id="share_code" class="form-control title">
	</div>
	<br />
	<button type="button" class="btn btn-primary" id="submit" style="margin-left:45%;">提交</button>
	<br />

	<span style="float: left;font-size: 15px;color: blueviolet; display: none;" id="wrong">分享码错误或已过期，请重新输入</span>

	<span style="float: left;font-size: 15px;color: blueviolet; display: none;" id="right">请确认被分享文件的信息：</span>
	<br /><br />
	<div id="notice-list" style="display: none;width:80%">
	<table  class="table table-bordered">
		<thead>
			<tr style="color:Highlight;">
				<th style="width: 20%;">文件名</th>
				<th style="width: 10%;">文件类型</th>
				<th style="width: 15%;">文件大小</th>
				<th style="width: 15%;">分享者</th>
				<th style="width: 40%;">操作</th>
			</tr>
		</thead>
		<tbody>
			<tr style="color: #000000;">
				<td style="vertical-align:middle;" id="filename"> </td>
				<td style="vertical-align:middle;" id="filetype"> </td>
				<td style="vertical-align:middle;" id="filesize"> </td>
				<td style="vertical-align:middle;" id="fileowner"> </td>
				<td style="text-align:center;">
					<button class="btn btn-danger btn-left" id="download" onclick="download_file();">
						<i class="material-icons" style="font-size: large;top:5px;position: relative;">file_download</i>下载
					</button>
					<button class="btn btn-info" id="getfile2me">
						<i class="material-icons" style="font-size: large;top:5px;position: relative;">reply</i>转存
					</button>
				</td>
			</tr>
		</tbody>
	</table>
	</div>
	</div>
	<script type="application/javascript">
	var fileID;
	 $("#submit").click(function () {
			var share_code=document.getElementById("share_code").value;
			if(share_code.length == 0){
				alert("请输入分享码！");
				return;
			}
			var shareForm = {"ShareCode":share_code};
			$.post("/webpan/file/getsharedfile",shareForm,function(result){
				if(result.toString()=="false"){
					document.getElementById('wrong').style.display="block";
					document.getElementById('right').style.display="none";
	            	document.getElementById('notice-list').style.display="none";
	            }else{
	            	document.getElementById('wrong').style.display="none";
	            	document.getElementById('right').style.display="block";
	            	document.getElementById('notice-list').style.display="block";
	            	var data = result.toString().split(' ');
	            	fileID = data[0];
	            	document.getElementById('filename').innerHTML = data[1];
	            	document.getElementById('filetype').innerHTML = data[2];
	            	document.getElementById('filesize').innerHTML = data[3]+" M";
	            	document.getElementById('fileowner').innerHTML = data[4];
	            }
			})
        });
	 
	 $("#download").click(function () {
		 var form = $("<form>"); //定义一个form表单  
	        form.attr("id", "downloadform");
	        form.attr("style", "display:none");
	        form.attr("target", "");
	        form.attr("method", "post");
	        form.attr("action", "/webpan/file/download");

			var input2 = $("<input>");
            input2.attr("type", "hidden");
            input2.attr("name", "fileID");
            input2.attr("value", fileID);
            form.append(input2);
	
	        $("body").append(form);
	        form.submit();
     });
	 
	 $("#getfile2me").click(function () {
			var shareForm = {"fileID":fileID};
			$.post("/webpan/file/getsharedfile2me",shareForm,function(result){
				if(result.toString()=="false"){
					alert("转存失败");
	            }else if(result.toString()=="same"){
	            	alert("这是你自己的文件哦");
	            }else if(result.toString()=="true"){
	            	alert("转存成功!!");
	            }else if(result.toString()=="name"){
	            	alert("检测到同名文件，转存失败");
	            }
			})
     });
	 
	</script>
</body>
</html>