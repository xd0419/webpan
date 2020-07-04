package webpan.controller;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.io.FileUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import tools.EncryptAndDecrypt;
import webpan.model.File;
import webpan.model.User;
import webpan.service.FileService;
import webpan.service.UserService;

@Controller
@RequestMapping("/file")
public class FileController 
{
	@Resource
	private FileService fileservice;
	@Resource
	private UserService uservice;
	@RequestMapping("/upload")
	@ResponseBody
	public String UpLoad(@RequestParam("upload_file")MultipartFile file,HttpServletRequest request) throws Exception
	{
		int result = 0;
		String name = file.getOriginalFilename();
		int indexOfPoint = name.lastIndexOf('.');
		if(indexOfPoint == -1) {
			indexOfPoint = name.length();
		}
		String fileName = name.substring(0,indexOfPoint);
		String fileType = name.substring(indexOfPoint+1);
		
		String ownerStr = request.getSession().getAttribute("ID").toString();
		int owner = Integer.parseInt(ownerStr);
		User u=uservice.GetUserbyid(owner);
		
		File exist_file = fileservice.GetFileByName(fileName,fileType,ownerStr);
		
		double size = (double)file.getSize()/1000000;
		
		if(exist_file != null) {
			double file_size = exist_file.getFileSize();
			
			if(u.getUserUsage() - file_size + size > u.getUserStorage())
				return "storage is not enough";
			
			if(file_size > u.getUserUsage()) {
				file_size = u.getUserUsage();
			}
			if(fileservice.SubStorage(u.getUserID(), file_size) == 0)
				return "false";
			if(fileservice.DeleteFile(exist_file.getFileID()) == 0)
				return "false";
		}
		
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date now = new Date();
		String time = sdf.format(now);
		
		String hash = DigestUtils.md5Hex(file.getBytes());
		String path = "C:\\webpan\\"+u.getUserName()+"\\"+name;
		if(u.getUserUsage()+size > u.getUserStorage())
		{
			result = 0;
			return "storage is not enough";
		}
		fileservice.AddStorage(owner, size);
		//java.io.File uploadpath = new java.io.File(path);
		EncryptAndDecrypt.DESEncrypt(file, path, u.getUserKey());
		result = fileservice.InsertFileInfo(fileName, fileType, size, time, owner, hash, path);
		return "" + (result == 1);
	}
	@RequestMapping("/uploadpage")
	@ResponseBody	
	public ModelAndView showupload(HttpServletRequest request)
	{
		ModelAndView modelview = new ModelAndView("/upload");
		Object o = request.getSession().getAttribute("ID");
		if (o != null)
		{
			String IDstr1 = o.toString();
			int myid = Integer.parseInt(IDstr1);
			User me=uservice.GetUserbyid(myid);
			List<File> file=uservice.GetFilebyid(myid);
			modelview.addObject("User",me);
			modelview.addObject("fileList",file);
			return modelview;
		}
		else
		{
			return new ModelAndView("/upload");
		}
	}
	
	@RequestMapping("/delete")
	@ResponseBody
	public String DeleteFile(HttpServletRequest request)
	{
		
		int userId = Integer.parseInt(request.getParameter("UserID"));
		User user=uservice.GetUserbyid(userId);
		int fileId = Integer.parseInt(request.getParameter("FileID"));
		File file = fileservice.GetFileById(fileId);
		double file_size = file.getFileSize();
		if(file_size<=0) return "delete failed!!";
		if(file_size > user.getUserUsage()) {
			file_size = user.getUserUsage();
		}
		if(fileservice.SubStorage(userId, file_size) == 0)
			return "change user's storage failed!!";
		if(fileservice.DeleteFile(fileId) == 0)
			return "delete from mysql failed!!";
		
		String path = "C:\\webpan\\"+user.getUserName()+"\\"+file.getFileName()+"."+file.getFileType();
		java.io.File local_file = new java.io.File(path);
		if(!local_file.delete())
			return "delete from service failed!!";
		return "Delete Successfully!!";
	}
	
	@RequestMapping("/changefilename")
	@ResponseBody
	public String ChangeFileName(HttpServletRequest request)
	{
		int fileId = Integer.parseInt(request.getParameter("FileID"));
		String new_filename = request.getParameter("newFileName");
		File file = fileservice.GetFileById(fileId);
		if(file == null) {
			return "failed...try again?";
		}
		if(new_filename.equals(file.getFileName()))
			return "file name repeat!";
		File exist_file = fileservice.GetFileByName(new_filename,file.getFileType(), file.getFileOwner()+"");
		if(exist_file!=null) {
			return new_filename+" already exists!";
		}
		int index = file.getFilePath().lastIndexOf("\\");
		String new_filepath = file.getFilePath().substring(0, index+1)+new_filename+"."+file.getFileType();
		java.io.File f = new java.io.File(file.getFilePath());
		if(!f.exists()) {
			return "file dose not exist!";
		}else {
			java.io.File nameto = new java.io.File(new_filepath);
            f.renameTo(nameto);
		}
		
		if(fileservice.ChangeFileName(fileId,new_filename,new_filepath) == 0)
			return "change from sql failed...";
		return "true";
	}
	
	@RequestMapping(value="/download",method=RequestMethod.POST,produces = {"application/json;charset=UTF-8"}) //匹配的是href中的download请求
	public ResponseEntity<byte[]> DownloadFile(HttpServletRequest request, @RequestParam("fileID") String fileID) throws Exception {
		ResponseEntity<byte[]> responseEntity = null;
		
		int fileId = Integer.parseInt(request.getParameter("fileID").toString());
		File select_file = fileservice.GetFileById(fileId);
		
		String fileName = select_file.getFileName() + "." + select_file.getFileType();
		
        String myFileName=new String(fileName.getBytes("utf-8"),"iso-8859-1");
        
        int index = select_file.getFilePath().lastIndexOf("\\");
        String username = select_file.getFilePath().substring(10, index);
        
        User u=uservice.GetUserbyname(username);
        String path = "C:\\webpan\\" + u.getUserName() + java.io.File.separator + fileName;
        java.io.File file = new java.io.File(path);
        if(!file.exists()) {
        	return null;
        }
        java.io.File outFile = new java.io.File("C:\\webpan\\" + u.getUserName() + java.io.File.separator + "temp");
        if(!outFile.exists()) {
        	outFile.mkdir();
        }
        String outPath = "C:\\webpan\\" + u.getUserName() + java.io.File.separator + "temp\\" + fileName;		//解密后文件存放路径
		EncryptAndDecrypt.DESDecrypt(file, outPath, u.getUserKey());
		HttpHeaders headers=new HttpHeaders();
		headers.setContentDispositionFormData("attachment", myFileName);
		headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
		java.io.File de_file = new java.io.File(outPath);
		responseEntity = new ResponseEntity<byte[]>(FileUtils.readFileToByteArray(de_file),headers,HttpStatus.CREATED);
		de_file.delete();
		return responseEntity;
	}
	
	@RequestMapping("sharefile")
	@ResponseBody
	public String sharefile(HttpServletRequest request)
	{
		String share_str = "";
		String file_id = request.getParameter("FileId");
		share_str = EncryptAndDecrypt.EncryptFileId(file_id, "sharefile!");
		return share_str;
	}
	
	@RequestMapping("getsharedfile")
	@ResponseBody
	public String GetSharedFile(HttpServletRequest request) throws Exception
	{
		String share_code = request.getParameter("ShareCode");
		String file_id_str = EncryptAndDecrypt.DecryptFileId(share_code, "sharefile!");
		int file_id = 0;
		try {
			file_id = Integer.valueOf(file_id_str);
		}catch (NumberFormatException e){
		    return "false";
		}
		File f = fileservice.GetFileById(file_id);
		if(f == null)
			return "false";
		int index = f.getFilePath().lastIndexOf("\\");
        String username = f.getFilePath().substring(10, index);
		return f.getFileID()+" "+f.getFileName()+" "+f.getFileType()+" "+f.getFileSize()+" "+username;
	}

	@RequestMapping("getsharedfile2me")
	@ResponseBody
	public String GetSharedFileToMe(HttpServletRequest request) throws Exception
	{
		int my_id = Integer.parseInt(request.getSession().getAttribute("ID").toString());
		int file_id = Integer.valueOf(request.getParameter("fileID"));
		File f = fileservice.GetFileById(file_id);
		
		if(f == null)
			return "false";
		if(my_id == f.getFileOwner()) {
			return "same";
		}
		User src_user = fileservice.GetOwnerByFile(file_id);
		User dst_user = uservice.GetUserbyid(my_id);
		
		File same_f = fileservice.GetFileByName(f.getFileName(),f.getFileType(), my_id+"");
		if(same_f!=null) {
			return "name";
		}
		
		String hash = f.getFileHash();
		String src_path = "C:\\webpan\\"+src_user.getUserName();
		String dst_path = "C:\\webpan\\"+dst_user.getUserName();
		java.io.File src_file = new java.io.File(f.getFilePath());
		double size = (double)src_file.length()/1000000;
		if(dst_user.getUserUsage()+size<dst_user.getUserStorage())
		{
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date now = new Date();
			String time = sdf.format(now);
			EncryptAndDecrypt.DESDecrypt(src_file, src_path+"\\tmp\\"+f.getFileName()+"."+f.getFileType(), src_user.getUserKey());
			EncryptAndDecrypt.DESEncrypt(src_path+"\\tmp\\"+f.getFileName()+"."+f.getFileType(), dst_path+"\\"+f.getFileName()+"."+f.getFileType(), dst_user.getUserKey());
			fileservice.AddStorage(dst_user.getUserID(), size);
			fileservice.InsertFileInfo(f.getFileName(), f.getFileType(), size, time, dst_user.getUserID(), hash, dst_path+"\\"+f.getFileName()+"."+f.getFileType());
			java.io.File temp_file = new java.io.File(src_path+"\\tmp\\"+f.getFileName()+"."+f.getFileType());
			temp_file.delete();
			return "true";
		}
		return "false";
	}
}
