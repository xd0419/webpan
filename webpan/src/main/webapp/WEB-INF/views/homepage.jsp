<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>

<head>
    <meta charset="utf-8" />
    <title>文件管理</title>
	<link rel="stylesheet" type="text/css" href="/webpan/dist/css/homepage.css" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
	<script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<script src="/webpan/dist/js/logout.js"></script>
</head>

<body>
	<div class="container" id="side-box" style="width: 10%; float: left;">
		<ul class="nav nav-pills nav-stacked">
			<li class="active"><a href="/webpan/user/homepage">文件列表</a></li>
			<li><a href="/webpan/file/uploadpage">上传文件</a></li>
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
			<input type="text" class="form-control" placeholder="search" id="key" onkeydown="onSearch(this)">
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
						<button type="button" class="btn btn-primary" id="upload">上传</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->
		</div><!-- /.modal -->
		
		<br /> <br />
		<h3>
			Hi, <span style="color:#0e90d2;">${User.getUserName()}</span>!&nbsp;&nbsp;&nbsp;
			<c:if test="${User.getUserType()=='admin'}">
			<a href="/webpan/manager/manager_user" style="font-size: 15px;text-decoration:underline;">点击进入管理员界面</a>
			</c:if>
		</h3>
		<br/>
		<span style="float: left;font-size: 20px;margin-top: 5px;">网盘容量</span>
		<div class="progress progress-striped active" style="float: left;width: 40%;margin-left: 10px;margin-top: 10px;">
			<div class="progress-bar progress-bar-info" role="progressbar"
				 aria-valuenow="50" aria-valuemin="0" aria-valuemax="100"
				 style="width: ${ User.getUserUsage()*100 / User.getUserStorage() }%;">
			</div>
		</div>
		<span style="margin-top: 10px;float: left;"><strong>&nbsp;&nbsp; ${User.getUserUsage()}M / ${User.getUserStorage()}M &nbsp;&nbsp;</strong></span>

		<button class="btn btn-success" style="float: left;" data-toggle="modal" data-target="#mymodal_apply">申请扩容</button>

		<div class="modal fade" id="mymodal_apply">
			<div class="modal-dialog" style="width: 400px;">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">输入申请内存的大小</h4>
					</div>
					<div class="modal-body">
						<br />
						<div class="input-group" style="width:80%;float:left;">
							<span class="input-group-addon">申请大小</span>
							<input type="text" id="applySize" class="form-control title">
						</div>
						<span style="float: left;font-size: 20px;">&nbsp;&nbsp;M</span>
						<br /><br />
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" style="margin-right: 20px;" data-dismiss="modal">关 闭</button>
						<button type="button" class="btn btn-primary" id="apply">确 定</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->
		</div><!-- /.modal -->
		<br /><br /><br />
		<div class="form-group">
			<label for="name" style="float:left;margin-top:5px;margin-right:10px;">筛选文件</label>
			<select id="select" onchange="selectFile()" class="form-control" style="float:left;width:15%;">
				<option value="AllFiles">AllFiles</option>
				<option value="Documents">Documents</option>
				<option value="Media">Media</option>
				<option value="CompressedFile">CompressedFile</option>
				<option value="Picture">Picture</option>
				<option value="System">System</option>
				<option value="Code">Code</option>
				<option value="Others">Others</option>
			</select>
		</div>
		<div class="list-title">文件列表</div>
		
		<c:if test="${fileList.size() != 0}">
		<table id="notice-list" class="table table-bordered">
			<thead>
				<tr style="color:Highlight;text-align:center;">
					<th style="width: 10%;text-align:center;">序号</th>
					<th style="width: 50%;">文件名</th>
					<th style="width: 10%;text-align:center;">文件类型</th>
					<th style="width: 30%;text-align:center;">操作</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${fileList}" var="f" varStatus="idxStatus">
					<tr style="color: #000000;">
						<td style="text-align:center;vertical-align:middle;">${idxStatus.index + 1 }</td>
						<td style="font-size:25px;">
							${f.getFileName()}&nbsp;&nbsp;
							<button style="background: none;border:none;outline:none;" data-toggle="modal" data-target="#mymodal_change${f.getFileID()}">
								<span class="glyphicon glyphicon-edit" style="font-size:20px;color:#6495ED;"></span>
							</button>
							<br/>
							<span style="font-size:10px;color:blue">${f.getFileSize()}M</span>
						</td>
						<td style="text-align:center;vertical-align:middle;">${f.getFileType()}</td>
						<td style="text-align:center;padding-top:15px;">
							<button class="btn btn-success btn-left" data-toggle="modal" data-target="#mymodal_detail${f.getFileID()}">
								<i class="material-icons" style="font-size: large;">zoom_in</i>
							</button>
							<button class="btn btn-primary btn-left" id="download${f.getFileID()}" onclick="download_file('${f.getFileID()}','${User.getUserID()}');">
								<i class="material-icons" style="font-size: large;">file_download</i>
							</button>
							<button class="btn btn-warning btn-left" data-toggle="modal" data-target="#mymodal_share${f.getFileID()}">
								<i class="material-icons" style="font-size: large;">share</i>
							</button>
							<button class="btn btn-danger" data-toggle="modal" data-target="#mymodal${f.getFileID()}">
								<i class="material-icons" style="font-size: large;">delete_forever</i>
							</button>
							
							<div class="modal fade" id="mymodal_change${f.getFileID()}">
								<div class="modal-dialog" style="width: 400px;">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal">
												<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
											</button>
											<h4 class="modal-title" style="float:left;">输入新的文件名</h4>
										</div>
										<div class="modal-body">
											<br />
											<div class="input-group" style="float:left;width:90%">
												<span class="input-group-addon">文件名</span>
												<input type="text" id="new_file_name${f.getFileID()}" class="form-control title" placeholder="${f.getFileName()}">
											</div><span style="float:left;margin-top:5px;"> .${f.getFileType()}</span>
											<br /><br />
										</div>
										<div class="modal-footer">
											<button type="button" class="btn btn-default" style="margin-right: 20px;" data-dismiss="modal">关 闭</button>
											<button type="button" class="btn btn-primary" onclick="change_file_name(${f.getFileID()});">确 定</button>
										</div>
									</div><!-- /.modal-content -->
								</div><!-- /.modal-dialog -->
							</div><!-- /.modal -->
							
							<div class="modal fade" id="mymodal_detail${f.getFileID()}">
								<div class="modal-dialog" style="width: 500px;">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal">
												<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
											</button> 
											<h4 class="modal-title" style="float:left;">文件详情</h4>
										</div>
										<div class="modal-body" style="text-align:left;">
											文件名称：${f.getFileName()}<br>
											文件类型：${f.getFileType()}<br>
											文件大小：${f.getFileSize()}&nbsp;M<br>
											文件所有者：${User.getUserName()}<br>
											文件hash值：${f.getFileHash()}<br>
											上传时间：${f.getFileUploadTime()}<br>
										</div>
									</div><!-- /.modal-content -->
								</div><!-- /.modal-dialog -->
							</div><!-- /.modal -->
							
							<div class="modal fade" id="mymodal_share${f.getFileID()}">
								<div class="modal-dialog" style="width: 400px;">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal">
												<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
											</button> 
											<span class="modal-title" style="float:left;">
											<i class="material-icons icon" style="font-size: x-large;color:blue">warning</i>
											点击获取分享码：</span>
											<button class="btn btn-primary" onclick="get_share('${f.getFileID()}');" style="float:left;">获 取</button>
										</div>
										<div class="modal-body">
												文件 “${f.getFileName()}” 的分享码：<br>
												<textarea style="color:blue;resize:none;text-align:center;" id="share${f.getFileID()}" disabled="disabled"></textarea>
												<br>
										</div>
										<div class="modal-footer">
											<button class="btn btn-primary" style="float:left" onclick="copy_share(${f.getFileID()});">复制分享码</button>
											<button class="btn btn-default" data-dismiss="modal">关闭窗口</button>
											
										</div>
									</div><!-- /.modal-content -->
								</div><!-- /.modal-dialog -->
							</div><!-- /.modal -->
							
							<div class="modal fade" id="mymodal${f.getFileID()}">
								<div class="modal-dialog" style="width: 400px;">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal">
												<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
											</button> 
											<h4 class="modal-title" style="float:left;">
											<i class="material-icons icon" style="font-size: x-large;color:blue">warning</i>
											警告!!</h4>
										</div>
										<div class="modal-body">
											您正在执行删除 “
											<span style="color:blue">${f.getFileName()}.${f.getFileType()}</span>” ，<br />
											该删除不可恢复，是否继续？
										</div>
										<div class="modal-footer">
											<button type="button" class="btn btn-default" style="margin-right: 20px;" data-dismiss="modal">取 消</button>
											<button type="submit" class="btn btn-primary" onclick="file_delete('${f.getFileID()}','${User.getUserID()}');">确 定</button>
										</div>
									</div><!-- /.modal-content -->
								</div><!-- /.modal-dialog -->
							</div><!-- /.modal -->
							
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		</c:if>
		<c:if test="${fileList.size() == 0}">
		<div style="text-align:center;left:10%;margin-top:5%;">
			<img src="/webpan/dist/media/img/nothing.png" style="width:30%;">
			<h4>这里什么都没有呢，试试右上角上传文件吧</h4>
		</div>
		</c:if>
	</div>
	
	<script type="text/javascript">
		function selectFile() {
			var arr = {
				'Documents':['doc','docx','ppt','pptx','xls','xlsx','pdf','txt'],
				'Media':['mp3','mp4','avi','wav','au','wma','amr','mmf','swf','mov','ram','flv'],
				'CompressedFile':['rar','zip','gz','arj','z'],
				'Picture':['png','jpg','jpeg','gif','bmp','pic','tif'],
				'System':['int','dll','adt','sys'],
				'Code' : ['c','cpp','html','jsp','py','java','class','css','js','obj','msg','exe','com'],
				'Others' : ['bak','map','tmp','dot','cmd']
			}
			
			var myselect = document.getElementById("select");
			var index=myselect.selectedIndex; 
		    var key = myselect.options[index].value;
			
			var storeId = document.getElementById('notice-list');
		    var rowsLength = storeId.rows.length;
		    var searchCol = 2;
			if(key=="AllFiles"){
				for(var i=1;i<rowsLength;i++){
				    storeId.rows[i].style.display='';
				}
			}else{
				for(var i=1;i<rowsLength;i++){
				      var searchText = storeId.rows[i].cells[searchCol].innerHTML;

				      if(arr[key].includes(searchText)){
				        storeId.rows[i].style.display='';
				      }else{
				        storeId.rows[i].style.display='none';//隐藏行
				      }
				 }
			}
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
		      var index = searchText.indexOf('<');
		      var text = searchText.substring(8,index);
		      if(text.match(key)){
		        storeId.rows[i].style.display='';
		      }else{
		        storeId.rows[i].style.display='none';
		      }
		    }
		  },200);//200为延时时间
		}
	
	</script>

	<script type="application/javascript">
	 $("#apply").click(function () {
			var applySize=document.getElementById("applySize").value;
			if(applySize.length == 0){
				alert("请输入申请的内存大小");
				return;
			}else if(applySize.indexOf(" ")>=0){
				alert("内存大小中不能有空格");
				return;
			}else if(isNaN(applySize)){
				alert("输入有误，请重新输入");
				return;
			}
			var userName="${User.getUserName()}";
			var applyForm = {"ApplySize":applySize, "UserName":userName};
			$.post("/webpan/user/apply",applyForm,function(result){
				if(result.toString()=="true"){//申请成功
	            	alert("申请成功，请等待管理员处理！");
	            }else{
					alert("申请失败，你已经申请，请等待管理员处理后再次申请。");
	            }
				location.reload();
			})
        });
	</script>
	
	<script type="application/javascript">
	function download_file(fileID){
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

	}
	</script>
	
	
	<script>
	function file_delete(fileid,userid){
		var DeleteForm = {"FileID":fileid,"UserID":userid};
		$.post("/webpan/file/delete",DeleteForm,function(result)
		{
			alert(result)
			location.reload();
		})
	}
	</script>
	
	<script type="text/javascript">
	$(function(){
		$("#upload").click(function (){
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
		           }).success(function(result) {
		        	   if(result.toString() == "true"){
		        		   alert("上传成功");
		        		   location.reload();
		        	   }else if(result.toString() == "false"){
		        		   alert("上传失败");
		        	   }else
		  					alert(result);
		  			}).error(function() {
		  				alert("上传失败！");
		  				location.reload();
		  		});
		    }
		});
	})
	</script>
	
	
	
	<script type="text/javascript">
		function get_share(id){
			var applyForm = {"FileId":id};
			$.post("/webpan/file/sharefile",applyForm,function(result){
				var share_id = "share" + id;
				document.getElementById(share_id).value = result.toString();
			})
		}
	</script>
	
	<script type="text/javascript">
		function copy_share(id){
			var share_id = "share" + id;
			var text = document.getElementById(share_id).value;
			if(text.length == 0){
				alert("请先获取分享码");
				return;
			}
			var tag = document.createElement('input');
			tag.setAttribute('id', 'cp_zdy_input');
			tag.value = text;
			document.getElementsByTagName('body')[0].appendChild(tag);
			document.getElementById('cp_zdy_input').select();
			document.execCommand('copy');
			document.getElementById('cp_zdy_input').remove();
			alert("复制成功，快去分享给你的小伙伴吧！");
		}
	</script>
	
	<script type="text/javascript">
		function change_file_name(id){
			var newFileName=document.getElementById("new_file_name" + id).value;
			var pattern = new RegExp("[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]");
			if(newFileName.length == 0){
				alert("文件名不能为空");
				return;
			}else if(pattern.test(newFileName) || newFileName.indexOf("\\") >=0){
				alert("文件名非法，请重新输入");
				return;
			}
			var fileForm = {"FileID":id,"newFileName":newFileName};
			$.post("/webpan/file/changefilename",fileForm,function(result){
				if(result.toString()=="true"){
					alert("修改成功");
					location.reload();
				}else{
					alert(result);
					return;
				}
					
			})
		}
	
	</script>
	
</body>
</html>
