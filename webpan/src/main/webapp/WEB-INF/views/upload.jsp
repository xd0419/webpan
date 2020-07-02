	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<html>

	<head>
		<meta charset="utf-8" />
		<title>上传列表</title>
		<link rel="stylesheet" type="text/css" href="/webpan/dist/css/homepage.css" />
		<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
		<link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
		<script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
		<link rel="stylesheet" href="/webpan/dist/webuploader/webuploader.css"/>
		<script src="/webpan/dist/webuploader/webuploader.js"></script>
		<script src="/webpan/dist/webuploader/webuploader.min.js"></script>
		<link rel="stylesheet" href="/webpan/dist/jquery-ui/jquery-ui.min.css">
		<script src="/webpan/dist/jquery-ui/jquery-ui.min.js"></script>
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
				<br/><br/>
				上传进度：
				<progress></progress>
				<br/>
				<p id="progress">0 bytes</p>
				<p id="info"></p>
				
			</div>
		</div>
		<br /><br />
		<h4>Hi, ${User.getUserName()}!</h4>
		<h2>上传文件列表</h2>
		<!--
		<center><button class="list-title">文件列表</button></center>
		-->
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
		</div>
		<table id="notice-list" class="table table-bordered">
			<thead>
				<tr style="color:Highlight">
					<th style="width: 10%;">序号</th>
					<th style="width: 40%;">文件名</th>
					<th style="width: 35%;">进度</th>
					<th style="width: 15%;">操作</th>
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
							<i class="material-icons icon" style="font-size: middle;">play_arrow</i>
							暂停 </button>
							<!--
							<i class="material-icons icon" style="font-size: large;">pause</i>
							继续 </button>
							-->
						<button class="btn btn-danger">
							<i class="material-icons icon" style="font-size: middle;">delete_forever</i>
							删除</button>
					</td>
				</tr>
			</tbody>
		</table>
		<br/>
		<%-- <div id="uploader-container" style="width: 100%">
		<div id="upInfo"></div>
			<h2>大文件断点续传</h2>
			<div id="filePicker" style="float: right;">
				<i class="material-icons icon" style="font-size: large;">file_upload</i>
				上传文件
			</div>
			<table id="notice-list"  class="upload table table-bordered">
				<thead>
					<tr style="color:Highlight">
						<th style="width: 10%;">序号</th>
						<th style="width: 40%;">文件名</th>
						<th style="width: 35%;">进度</th>
						<th style="width: 15%;">操作</th>
					</tr>
				</thead>
				<tbody id="fileList" class="uploader-list">
					
				</tbody>
			</table>
			<input type="button" class="btnSave btn btn-success" id="btnUpload" value="上传" margin="2px" padding="3px"/>
			<input type="button" class="btnSave btn btn-danger" id="btnReset" value="清空" margin="2px" padding="3px"/>
		</div> --%>
		<div id="uploadfile">
		<h3>断点续传</h3>
			<div id="picker">选择文件</div>
			<!--用来存放文件信息-->
			<div class="uploader-list">
				<table id="thelist" class="table table-bordered" border="1" cellpadding="0" cellspacing="0" width="100%">
					<tr class="filelist-head">
						<th width="5%" class="file-num">序号</th>
						<th class="file-name">文件名</th>
						<th class="file-size">大小</th>
						<th width="20%" class="file-pro">进度</th>
						<th class="file-status">状态</th>
						<th width="20%" class="file-manage">操作</th>
					</tr>
				</table>
			</div>
			<div id="ctlBtn" class="btn btn-default">开始上传</div>
		</div>
		<script type="text/javascript">
		$(function() {
			var $chunkSize = 10*1024*1024, // 分片尺寸 10M
			$maxSingleSize = 1024*1024*1024, // 单文件最大尺寸
			$maxSize = 10*1024*1024*1024; // 所有文件最大尺寸
			var $list = $('#thelist'), // 页面展示的文件列表
			$btn = $('ctlBtn'),
			$fileArray = new Array(), // 要上传的文件列表
			$md5Array = new Array(), // 文件的MD5
			$nameArray = new Array(), // 文件名称
			count = 0, // 正在上传的文件在上传列表中的位置
			uploader; // Web Uploader实例
			
			// 监听分块上传的三个事件
			WebUploader.Uploader.register({
				"before-send-file" : "beforeSendFile", // 所有分块上传之前
				"before-send" : "beforeSend", // 每个分块上传之前
				"after-send-file" : "afterSendFile" // 所有分块上传完成后
			},{
				beforeSendFile : function(file){
					var deferred = WebUploader.Deferred();
					// 计算文件的MD5
					(new WebUploader.Uploader()).md5File(file,0,10*1024*1024)
					// 及时显示进度
					.progress(function(percentage) {})
					// 计算完成，继续下一步
					.then(function(val) {
						$md5Array.push(val);
						$nameArray.push(file.name);
						deferred.resolve();
					});
					return deferred.promise();
				},
				beforeSend : function(block){
					var deferred = WebUploader.Deferred();
					// 每个分块上传之前校验是否已上传
					var url = "/webpan/bigfile/check",
					param = {
						filename : $nameArray[count],
						fileMd5 : $md5Array[count],
						chunk : block.chunk,
						chunksize : block.end - block.start
					};
					// 同步校验，防止没校验完就上传了
					$.ajaxSetup({async : false});
					$.post(url,param,function(data){
						// 已上传则跳过，否则继续上传
						if(1 == data){
							deferred.reject();
						}else{
							deferred.resolve();
						}
					});
					$.ajaxSetup({async : true});
					return deferred.promise();
				},
				afterSendFile : function(){
					// 所有分块上传完毕，通知后台合并分块
					var url = "/webpan/bigfile/merge",
					// 上传前设置其它参数
					param = {
						fileMd5 : $md5Array[count],
						filename : $nameArray[count]
					};
					$.ajaxSetup({async : false});
					$.post(url,param,function(data){
						count++;
						if(count<=$fileArray.length-1){
							uploader.upload($fileArray[count].id);
						}
					});
					$.ajaxSetup({async : true});
				}
			});
			
			// 初始化Web Uploader PS:IE使用的flash上传，真心慢，大文件还是用Chrome上传比较靠谱
			uploader = WebUploader.create({
					// resize : false,
					// auto : false, // 手动上传
					// swf : '/webpan/dist/webuploader/Uploader.swf',
					// server : '/webpan/bigfile/upload', // 文件接收服务端
					// threads : 1, // 只运行1个线程传输
					// duplicate : false, // 是否重复上传（单次选择同样的文件）
					// prepareNextFile : true, // 允许在文件传输时提前把下一个文件准备好
					// chunked : true, // 是否要分片处理大文件上传
					// chunkSize : $chunkSize, // 如果要分片，分多大一片？ 10M默认大小为5M
					// fileNumLimit : 1, // 文件总数量 
					// fileSingleSizeLimit : $maxSingleSize, // 单个文件大小限制
					
					// pick : {
					// 	id : '#filePicker', // 选择文件的按钮
					// 	multiple : false // 允许同时选择多个文件
					// },
					// compress: false, // 不压缩文件
					// accept : {
					// 	// TODO:待确认上传文件的格式和大小
					// 	// 常见视频文件格式：avi,wmv,mpeg,mp4,mov,mkv,flv,f4v,m4v,rmvb,rm,3gp,dat,ts,mts,vob
					// 	extensions: "txt,gif,jpg,jpeg,bmp,png,zip,rar,war,pdf,cebx,doc,docx,ppt,pptx,xls,xlsx",
					// 	mimeTypes: '.txt,.gif,.jpg,.jpeg,.bmp,.png,.zip,.rar,.war,.pdf,.cebx,.doc,.docx,.ppt,.pptx,.xls,.xlsx',
					// }
				resize: false, // 不压缩image     
				swf: '/webpan/dist/webuploader/Uploader.swf', // swf文件路径
				server: '/webpan/bigfile/upload', // 文件接收服务端。
				pick: '#picker', // 选择文件的按钮。可选
				chunked: true, //是否要分片处理大文件上传
				chunkSize: $chunkSize, //分片上传10M
				threads : 1,
				auto: false, //选择文件后是否自动上传
				chunkRetry : 2, //如果某个分片由于网络问题出错，允许自动重传次数
				runtimeOrder: 'html5,flash',
				accept: {
				   	extensions: "txt,gif,jpg,jpeg,bmp,png,zip,rar,war,pdf,cebx,doc,docx,ppt,pptx,xls,xlsx",
					mimeTypes: '.txt,.gif,.jpg,.jpeg,.bmp,.png,.zip,.rar,.war,.pdf,.cebx,.doc,.docx,.ppt,.pptx,.xls,.xlsx',
				},
				duplicate: false //是否支持重复上传
				});

			// 当有文件添加进来的时候 
			uploader.on('fileQueued', function(file) {
				alert("sorry!");
				if((file.size <= $chunkSize) || (file.size > $maxSingleSize)){
					return;
				}
				alert("hello!");
				$list.append('<tr id="'+ file.id 
							+ '" class="file-item">'
							+ '<td width="5%" class="file-num">111</td>'
							+ '<td class="file-name">'+ file.name +'</td>'
							+ '<td width="20%" class="file-size">'
							+ file.size +'</td>' 
							+ '<td width="20%" class="file-pro">0%</td>'
							+ '<td class="file-status">等待上传</td>'
							+ '<td width="20%" class="file-manage">' 
							+ '<a class="stop-btn" href="javascript:;">暂停</a>'
							+ '<a class="remove-this" href="javascript:;">取消</a>' 
							+ '</td>'
							+'</tr>');

				$fileArray.push(file);
				//暂停上传的文件
				$list.on('click','.stop-btn',function() {
					uploader.stop(true);
				})
				//删除上传的文件
				$list.on('click','.remove-this',function(){
					if ($(this).parents(".file-item").attr('id') == file.id) {
						uploader.removeFile(file);
						$(this).parents(".file-item").remove();
					}
				})
			});
			
			
			// 对于太小的文件进行提示
			uploader.on('filesQueued',function (files){
				var smallFiles = '';
				for(i=0;i<files.length;i++){
					var name = files[i].name,
					size = files[i].size;
					if(size <= $chunkSize){
						smallFiles += name + ','
					}
				}
				var msg = '';
				if(''!=smallFiles){
					msg += "文件" + smallFiles + "小于10M,";
					alert(msg);
				}
				
				if('' != msg){
					msg+="系统不支持上传这些文件!";
					showTipsMsg(msg,3000,3);
					alert(msg);
					return;
				}
			});
			
			// 上传中
			// 文件上传过程中创建进度条实时显示
		    uploader.on( 'uploadProgress', function( file, percentage ) {
		    	$("td.file-pro").text("");
		        var $li = $( '#'+file.id ).find('.file-pro'),
		            $percent = $li.find('.file-progress .progress-bar');

		        // 避免重复创建
		        if ( !$percent.length ) {
		            $percent = $('<div class="file-progress progress-striped active">' +
		              '<div class="progress-bar" role="progressbar" style="width: 0%">' +
		              '</div>' +
		            '</div>' + '<div class="per">0%</div>').appendTo( $li ).find('.progress-bar');
		        }

		        $li.siblings('.file-status').text('上传中');
		        $li.find('.per').text((percentage * 100).toFixed(2) + '%');

		        $percent.css( 'width', percentage * 100 + '%' );
		    });

		 	// 文件上传成功
		    uploader.on( 'uploadSuccess', function( file ) {
		        $( '#'+file.id ).find('.file-status').text('已上传');
		    });
			// 手动上传
			// 文件上传失败，显示上传出错
		    uploader.on( 'uploadError', function( file ) {
		        $( '#'+file.id ).find('.file-status').text('上传出错');
		    });

			$("#ctlBtn").click(function() {
				// 执行上传操作
				uploader.upload();
			});
			
		});
		</script>
		</div>
		<script type="text/javascript">
		//绑定所有type=file的元素的onchange事件的处理函数
		$(':file').change(function () {
			file = this.files[0]; //假设file标签没打开multiple属性，那么只取第一个文件就行了
			var Name = file.name;
			var Size = file.size;
			var Type = file.type;
			var url = window.URL.createObjectURL(file); //获取本地文件的url，如果是图片文件，可用于预览图片
			$("#info").html("文件名：" + Name + "<br/>" + " 文件类型：" + Type+ "<br/>" + " 文件大小：" + Size+ " Bytes<br/>" + " url: " + url+ "<br/>");
		});
		$(function(){
			$("#upload").click(function ()
			{
				var formdata = new FormData($('#uploadform')[0]);
				$.ajax({
					type : 'POST',
					url : '/webpan/file/upload',
					data : formdata,
					cache : false,
					processData : false,
					contentType : false,
					xhr: function () { //获取ajaxSettings中的xhr对象，为它的upload属性绑定progress事件的处理函数
						var myXhr = $.ajaxSettings.xhr();
						if (myXhr.upload) { //检查upload属性是否存在
							//绑定progress事件的回调函数
							myXhr.upload.addEventListener('progress', progressHandlingFunction, false);
						}
						return myXhr; //xhr对象返回给jQuery使用
					},
				}).success(function(data) {
					var result = JSON.parse(data);
					alert("上传成功！");
				}).error(function() {
					alert("上传失败！");
				});	
			});
		})
		//上传进度回调函数：
		function progressHandlingFunction(e) {
			if (e.lengthComputable) {
				$('progress').attr({value: e.loaded, max: e.total}); //更新数据到进度条
				var percent = e.loaded / e.total * 100;
				$('#progress').html(e.loaded + "/" + e.total + " bytes. " + percent.toFixed(2) + "%");
			}
		}
		</script>
	</body>
	</html>
