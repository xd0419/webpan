<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>

<head>
    <meta charset="utf-8" />
    <title>文件管理</title>
	<link rel="stylesheet" type="text/css" href="/webpan/dist/css/homepage.css" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
</head>

<body>
	<div class="container" id="side-box" style="width: 10%; float: left;">
		<ul class="nav nav-pills nav-stacked">
			<li class="active"><a href="/webpan/user/homepage">文件列表</a></li>
			<li><a href="/webpan/user/upload">上传列表</a></li>
			<li><a href="/webpan/user/download">下载列表</a></li>
		</ul>
	</div>
	<div style="width: 88%;float: right;">
		<div class="input-group search">
			<span class="input-group-addon">
				<i class="material-icons icon" style="font-size: large;">search</i>
			</span>
			<input type="text" class="form-control" placeholder="search">
		</div>
		<div>
			<a href="javascript:void(0)"
			   onclick="document.getElementById('id-upload-box').style.display='block';
						document.getElementById('fade').style.display='block'">
				<button type="button" id="create-group-button" class="btn btn-primary"
						style="float: right;">
					<i class="material-icons icon" style="font-size: large;">file_upload</i>
					上传文件
				</button>
			</a>
			<div id="id-upload-box" class="upload-box">
				<a href="javascript:void(0)" onclick="document.getElementById('id-upload-box').style.display='none';
					document.getElementById('fade').style.display='none'" style="float: right;">
					取消
				</a>
				<form action="" method="post" class="bs-example bs-example-form" role="form">
					<div style="width:300px;text-align:left">
						<h4>选择要上传的文件</h4>
						<hr style="border:0.5px solid black;" />
					</div>
					<br />
					<div class="form-group">
					   <div class="col-sm-4 control-label">选择文件</div>
					   <div class="col-sm-6">
					       <div class="input-group">
					       <input id='location' class="form-control" onclick="$('#i-file').click();">
					           <label class="input-group-btn">
					               <input type="button" id="i-check" value="浏览文件" class="btn btn-primary" onclick="$('#i-file').click();">
					           </label>
					       </div>
					   </div>
					   <input type="file" name="file" id='i-file'  accept=".*" onchange="$('#location').val($('#i-file').val());" style="display: none">
					</div>
					<br />
					<br />
					<button type="submit" class="btn btn-danger" style="width:100px">上传</button>
				</form>
			</div>
		</div>
		
		<br /> <br />
		<h3>
			Hi, ${User.getUserName()}!&nbsp;&nbsp;&nbsp;
			<a href="manager_user.jsp" style="font-size: 15px;text-decoration:underline;">点击进入管理员界面</a>
		</h3>
		
		<span style="float: left;font-size: 30px">文件列表</span>
		<div class="progress progress-striped active" style="float: left;width: 40%;margin-left: 50px;margin-top: 10px;">
			<div class="progress-bar progress-bar-info" role="progressbar"
				 aria-valuenow="50" aria-valuemin="0" aria-valuemax="100"
				 style="width: ${ User.getUserUsage()*100 / User.getUserStorage() }%;">
			</div>
		</div>
		<span style="margin-top: 10px;float: left;"><strong>&nbsp;&nbsp; ${User.getUserUsage()}M / ${User.getUserStorage()}M &nbsp;&nbsp;</strong></span>
		<div>
			<a href="javascript:void(0)"
			   onclick="document.getElementById('id-apply-box').style.display='block';
						document.getElementById('fade').style.display='block'">
				<button class="btn btn-success" style="float: left;">
					申请扩容
				</button>
			</a>
			<div id="id-apply-box" class="upload-box">
				<a href="javascript:void(0)" onclick="document.getElementById('id-apply-box').style.display='none';
					document.getElementById('fade').style.display='none'" style="float: right;">
					取消
				</a>
				
					<div style="width:300px;text-align:left">
						<h4>申请扩容</h4>
						<hr style="border:0.5px solid black;" />
					</div>
					<br />
					<div class="input-group" style="width:80%;float:left;">
						<span class="input-group-addon">申请大小</span>
						<input type="text" required autofocus id="applySize" class="form-control title">
					</div>
					<span style="float: left;font-size: 20px;">&nbsp;&nbsp;M</span>
					<br /> <br /> <br />
					<button id="apply" class="btn btn-danger" style="width:100px">确定</button>
				
			</div>
		</div>
		<!--
		<center><button class="list-title">文件列表</button></center>
		-->
		<table id="notice-list" class="table table-bordered">
			<thead>
				<tr style="color:Highlight">
					<th style="width: 10%;">序号</th>
					<th style="width: 60%;">文件名</th>
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
						<button class="btn btn-primary" >
							<i class="material-icons icon" style="font-size: large;">file_download</i>
							下载 </button>
						<button class="btn btn-danger">
							<i class="material-icons icon" style="font-size: large;">delete_forever</i>
							删除</button>
					</td>
				</tr>
				<tr style="color: #000000;">
					<td>2</td>
					<td>
						文件名<br />
						文件大小
					</td>
					<td>
						<button class="btn btn-primary" >
							<i class="material-icons icon" style="font-size: large;">file_download</i>
							下载 </button>
						<button class="btn btn-danger">
							<i class="material-icons icon" style="font-size: large;">delete_forever</i>
							删除</button>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<!-- Bundle -->
	<script src="https://www.jq22.com/jquery/jquery-3.3.1.js"></script>
	<script src="/webpan/vendor/bundle.js"></script>
	<script src="/webpan/vendor/feather.min.js"></script>
	<script type="application/javascript">
	 $("#apply").click(function () {
			var applySize=document.getElementById("applySize").value;
			var userName="${User.getUserName()}";
			var applyForm = {"ApplySize":applySize, "UserName":userName};
			$.post("/webpan/user/apply",applyForm,function(result){
				if(result.toString()=="true"){//申请成功
	            	alert("Apply successfully!!");
	            }else{
					alert("Apply Failed, try again?");
	            }
			})
        });

	</script>
	<!-- App scripts -->
	<script src="/webpan/dist/js/app.min.js"></script>
	
</body>
</html>
