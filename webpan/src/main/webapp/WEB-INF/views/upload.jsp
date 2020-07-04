<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>

<head>
	<meta charset="utf-8" />
    <title>上传列表</title>
	<link rel="stylesheet" type="text/css" href="/webpan/dist/css/homepage.css" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
	<script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
	<script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="/webpan/dist/webuploader/webuploader.css"/>
	<script src="/webpan/dist/webuploader/webuploader.js"></script>
	<script src="/webpan/dist/webuploader/webuploader.min.js"></script>
	<link rel="stylesheet" href="/webpan/dist/jquery-ui/jquery-ui.min.css">
	<script src="/webpan/dist/jquery-ui/jquery-ui.min.js"></script>
	<script src="/webpan/dist/js/logout.js"></script>
</head>

<body>
	<div class="container" id="side-box" style="width: 10%; float: left;">
		<ul class="nav nav-pills nav-stacked">
			<li><a href="/webpan/user/homepage">文件列表</a></li>
			<li class="active"><a href="/webpan/file/uploadpage">上传文件</a></li>
			<li><a href="/webpan/user/sharepage">共享空间</a></li>
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
		<input type="text" class="form-control" placeholder="search">
	</div>
	
	<button type="button" class="btn btn-primary" style="float: right" data-toggle="modal" data-target="#mymodal_upload">
		<i class="material-icons icon" style="font-size: large;">file_upload</i>
		上传文件
	</button>
	<div class="modal fade" id="mymodal_upload">
		<div class="modal-dialog" style="width: 400px;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
					</button>
					<h4 class="modal-title">选择要上传的文件</h4>
				</div>
				<div class="modal-body">
					<br />
					<form id="uploadform" enctype="multipart/form-data" method="post">
						<div class="input-group">
							<input id='location' class="form-control" onclick="$('#i-file').click();">
							<label class="input-group-btn">
								<input type="button" id="i-check" value="浏览文件" class="btn btn-primary" onclick="$('#upload_file').click();">
							</label>
						</div>
						<input type="file" name="upload_file" id='upload_file'  accept=".*" onchange="$('#location').val($('#upload_file').val());" style="display: none">			
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default"  data-dismiss="modal" style="margin-right: 20px;">关闭</button>
					<button type="button" class="btn btn-primary" onclick="upload();">上传</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	
	
	<br /><br />
	<h3>
		Hi, <span style="color:#0e90d2;">${User.getUserName()}</span>!&nbsp;&nbsp;&nbsp;
		<c:if test="${User.getUserType()=='admin'}">
		<a href="/webpan/manager/manager_user" style="font-size: 15px;text-decoration:underline;">点击进入管理员界面</a>
		</c:if>
	</h3>
	<h2>大文件上传</h2>
	<!--
	<center><button class="list-title">文件列表</button></center>
	-->
	<br/>

	<div id="uploadfile">
		<div id="picker" style="margin-bottom:10px;float:left;">选择文件</div>
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
		<div id="ctlBtn" class="btn btn-info" style="float:right;">开始上传</div>
	</div>
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
		file_count = 0,
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
			   	extensions: "txt,gif,jpg,jpeg,bmp,png,zip,rar,war,pdf,cebx,doc,docx,ppt,pptx,xls,xlsx,mp4,flv",
				mimeTypes: '.txt,.gif,.jpg,.jpeg,.bmp,.png,.zip,.rar,.war,.pdf,.cebx,.doc,.docx,.ppt,.pptx,.xls,.xlsx,.mp4,.flv',
			},
			duplicate: false //是否支持重复上传
			});

		// 当有文件添加进来的时候 
		uploader.on('fileQueued', function(file) {
			if((file.size <= $chunkSize) || (file.size > $maxSingleSize) ){
				return;
			}
			if(file.size/1000000 + ${User.getUserUsage()} > ${User.getUserStorage()}){
				alert("storage is not enough");
				return;
			}
			$list.append('<tr id="'+ file.id 
						+ '" class="file-item">'
						+ '<td class="file-num">'+ (++file_count) +'</td>'
						+ '<td class="file-name">'+ file.name +'</td>'
						+ '<td class="file-size">'
						+ file.size/1000000 +' M</td>' 
						+ '<td class="file-pro">0%</td>'
						+ '<td class="file-status">等待上传</td>'
						+ '<td class="file-manage">' 
						+ '<a class="stop-btn" href="javascript:;">暂停</a>'
						+ '<span>&nbsp;&nbsp;&nbsp;&nbsp;</span>'
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
	        $li.find('.per').text('100%');
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

	//上传进度回调函数：
	function progressHandlingFunction(e) {
		if (e.lengthComputable) {
			$('progress').attr({value: e.loaded, max: e.total}); //更新数据到进度条
			var percent = e.loaded / e.total * 100;
			$('#progress').html(e.loaded + "/" + e.total + " bytes. " + percent.toFixed(2) + "%");
		}
	}
	</script>
	
	<script type="text/javascript">
		function upload(){
			var flag = 1;
			var filePath=document.getElementById("location").value;
			
			if(filePath.length == 0){
				alert("请先选择一个文件");
				return;
			}
			
			var lastBackslashIndex = filePath.lastIndexOf('\\');
			var lastPointIndex = filePath.lastIndexOf('.');
			
			var fileName = filePath.substring(lastBackslashIndex+1,lastPointIndex);
			var fileType = filePath.substring(lastPointIndex+1);
			
		    var names = new Array();
		    var types = new Array();
		    <c:forEach items="${fileList}" var="a"> 
		    	names.push('${a.getFileName()}');
		    	types.push('${a.getFileType()}');
		    </c:forEach>
		    
		    for(var i=0;i<names.length;i++){
		    	if(fileName == names[i] && fileType == types[i]){
			    	  if(confirm("检测到文件重复，是否覆盖原来文件？")){
			    	  }
			    	  else{
			    		  flag = 0;
			    	  }
			    	  break;
			     }
		    	
		    }
		    if(flag == 1){
		    	var formdata = new FormData($('#uploadform')[0]);
	              $.ajax({
	              	type : 'POST',
	  				url : '/webpan/file/upload',
	  				data : formdata,
	  				cache : false,
	  				processData : false,
	  				contentType : false,   	
		           }).success(function(data) {
		  				var result = JSON.parse(data);
		  				alert("上传成功！");
		  				location.reload();
		  			}).error(function() {
		  				alert("上传失败！");
		  				location.reload();
		  		});
		    }
		}
	</script>
	
</body>
</html>
