<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>

<head>
    <meta charset="utf-8" />
    <title>上传列表</title>
	<link rel="stylesheet" type="text/css" href="/webpan/dist/css/homepage.css" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
	<script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
</head>

<body>
	<div class="container" id="side-box" style="width: 10%; float: left;">
		<ul class="nav nav-pills nav-stacked">
			<li><a href="/webpan/user/homepage">文件列表</a></li>
			<li class="active"><a href="/webpan/file/uploadpage">上传列表</a></li>
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
			<div style="width:300px;text-align:left">
				<h4>选择要上传的文件</h4>
				<hr style="border:0.5px solid black;" />
			</div>
			<br />
			<form id="uploadform" enctype="multipart/form-data" method="post">
			<div class="form-group">
			   <div class="col-sm-4 control-label">选择文件</div>
			   <div class="col-sm-6">
			       <div class="input-group">
			       <input id='location' class="form-control" onclick="$('#i-file').click();">
			           <label class="input-group-btn">
			               <input type="button" id="i-check" value="浏览文件" class="btn btn-primary" onclick="$('#upload_file').click();">
			           </label>
			       </div>
			   </div>
			   <input type="file" name="upload_file" id='upload_file'  accept=".*" onchange="$('#location').val($('#upload_file').val());" style="display: none">
			</div>
			</form>
			<br />
			<br />
			<button type="button" class="btn btn-danger" style="width:100px" id="upload">上传</button>
		</div>
	</div>
	
	
	
	<br /><br />
	<h4>Hi, ${User.getUserName()}!</h4>
	<h2>上传文件列表</h2>
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
					<button class="btn btn-primary" >
						<i class="material-icons icon" style="font-size: large;">play_arrow</i>
						暂停 </button>
						<!--
						<i class="material-icons icon" style="font-size: large;">pause</i>
						继续 </button>
						-->
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
						暂停 </button>
						<!--
						<i class="material-icons icon" style="font-size: large;">pause</i>
						继续 </button>
						-->
					<button class="btn btn-danger">
						<i class="material-icons icon" style="font-size: large;">delete_forever</i>
						删除</button>
				</td>
			</tr>
		</tbody>
	</table>
	</div>
	<script src="https://cdn.bootcss.com/jquery/1.10.2/jquery.min.js"></script>
	<script type="text/javascript">
	$(function(){
		$("#upload").click(function ()
		{
            var formdata = new FormData($('#uploadform')[0]);
            $.ajax({
            	type : 'POST',
				url : 'upload',
				data : formdata,
				cache : false,
				processData : false,
				contentType : false,   	
            }).success(function(data) {
				var result = JSON.parse(data);
				alert(result.back);
			}).error(function() {
				alert("上传失败");
			});
		});
	})
	</script>
</body>
</html>
