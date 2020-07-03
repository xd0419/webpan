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
		
		File exist_file = fileservice.GetFileByName(fileName,ownerStr);
		
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
	
	@RequestMapping(value="/download",method=RequestMethod.POST,produces = {"application/json;charset=UTF-8"}) //匹配的是href中的download请求
	public ResponseEntity<byte[]> DownloadFile(HttpServletRequest request,@RequestParam("userID") int owner, @RequestParam("fileID") String fileID) throws Exception {
		ResponseEntity<byte[]> responseEntity = null;
		
		int fileId = Integer.parseInt(request.getParameter("fileID").toString());
		File select_file = fileservice.GetFileById(fileId);
		
		String fileName = select_file.getFileName() + "." + select_file.getFileType();
		
        String myFileName=new String(fileName.getBytes("utf-8"),"iso-8859-1");
        User u=uservice.GetUserbyid(owner);
        String path = "C:\\webpan\\" + u.getUserName() + java.io.File.separator + fileName;
        java.io.File file = new java.io.File(path);
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

}
