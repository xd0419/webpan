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
		</tbody>
	</table>
	<table class="upload">
		<thead>
			<tr>
				<td>
					断点续传
				</td>
			</tr>
		</thead>
        <tbody>
            <tr>
                <td height="200px">
                	<h3>分片上传的文件大小需在10M到1G之间</h3>
                    <div id="uploader-container" style="width: 100%">
                        <div id="fileList" class="uploader-list">
                        </div>
                        <div id="upInfo"></div>
                        <div id="filePicker">选择文件</div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <input type="button" class="btnSave" id="btnUpload" value="上传"/>
                    <input type="button" class="btnSave" id="btnReset" value="重置"/>
                    <input type="button" class="btnSave" value="取消" οnclick="javascript:closeDialog();"/>
                </td>
            </tr>
        </tbody>
	</table>
    <script type="text/javascript">
    $(function() {
    	var $chunkSize = 10*1024*1024, // 分片尺寸 10M
        $maxSingleSize = 1024*1024*1024, // 单文件最大尺寸
        $maxSize = 10*1024*1024*1024; // 所有文件最大尺寸
        var $list = $('#fileList'), // 页面展示的文件列表
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
                alert("文件发送前的准备已经完成");
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
                alert("共有" + (count+1) + "个文件");
                alert("这个文件分块已经完成，即将开始检查分块并上传至服务器");
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
                this.owner.options.formData.fileMd5 = $md5Array[count];
                deferred.resolve();
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
                alert("文件发送结束了");
                $.ajaxSetup({async : true});
            }
        });
        
        // 初始化Web Uploader PS:IE使用的flash上传，真心慢，大文件还是用Chrome上传比较靠谱
        uploader = WebUploader.create({
                auto : false, // 手动上传
                swf : '/webpan/dist/webuploader/Uploader.swf',
                server : '/webpan/bigfile/upload', // 文件接收服务端
                threads : 1, // 只运行1个线程传输
                duplicate : false, // 是否重复上传（单次选择同样的文件）
                prepareNextFile : true, // 允许在文件传输时提前把下一个文件准备好
                chunked : true, // 是否要分片处理大文件上传
                chunkSize : $chunkSize, // 如果要分片，分多大一片？ 10M默认大小为5M
                fileNumLimit : 1, // 文件总数量 
                fileSingleSizeLimit : $maxSingleSize, // 单个文件大小限制
                
                pick : {
                    id : '#filePicker', // 选择文件的按钮
                    multiple : false // 允许同时选择多个文件
                },
                compress: false, // 不压缩文件
                accept : {
                    // TODO:待确认上传文件的格式和大小
                    // 常见视频文件格式：avi,wmv,mpeg,mp4,mov,mkv,flv,f4v,m4v,rmvb,rm,3gp,dat,ts,mts,vob
                    extensions: "txt,gif,jpg,jpeg,bmp,png,zip,rar,war,pdf,cebx,doc,docx,ppt,pptx,xls,xlsx",
                    mimeTypes: '.txt,.gif,.jpg,.jpeg,.bmp,.png,.zip,.rar,.war,.pdf,.cebx,.doc,.docx,.ppt,.pptx,.xls,.xlsx',
                }
            });

        // 当有文件添加进来的时候 
        uploader.on('fileQueued', function(file) {
        	alert("文件成功添加至页面！");
            if((file.size <= $chunkSize) || (file.size > $maxSingleSize)){
                return;
            }
            alert("这个文件大小正合适~");
            var $li = $('<div id="' + file.id + '" class="file-item">'
                    + '<span class="info">' + file.name + '</span>'
                    + '<span class="state">等待上传</span>'
                    + '</div>');
            $list.append($li);
            $fileArray.push(file);
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
        uploader.on('uploadProgress', function (file, percentage) {
            var $li = $('#' + file.id);
            var $state = $li.find('span.state');
            $state.html("<font color='#330033'>上传中...</font>");
        });

        // 文件上传成功
        uploader.on('uploadSuccess', function(file, response) {
            var $li = $('#' + file.id);
            var $state = $li.find('span.state');
            $state.html("<font color='green'>上传成功！</font>");
        });

        // 文件上传失败
        uploader.on('uploadError', function(file, code) {
            var $li = $('#' + file.id);
            var $state = $li.find('span.state');
            $state.html("<font color='red'>上传失败！</font>");
        });

        // 手动上传
        $("#btnUpload").click(function() {
            // 执行上传操作
            uploader.upload();
        });
        
        // 重置
        $("#btnReset").click(function() {
            // 清空文件列表，重置上传控件
            $list.html('');
            $fileArray = new Array();
            $md5Array = new Array();
            $nameArray = new Array();
            count = 0;
            uploader.reset();
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
   				alert("上传成功！"");
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
