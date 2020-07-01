package webpan.controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import tools.EncryptAndDecrypt;
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
	public int UpLoad(@RequestParam("upload_file")MultipartFile file,HttpServletRequest request) throws Exception
	{
		int result = 0;
		String name = file.getOriginalFilename();
		String type = "doc";
		double size = (double)file.getSize()/1000000;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date now = new Date();
		String time = sdf.format(now);
		int owner = Integer.parseInt(request.getSession().getAttribute("ID").toString());
		String hash = DigestUtils.md5Hex(file.getBytes());
		User u=uservice.GetUserbyid(owner);
		String path = "C:\\webpan\\"+u.getUserName()+"\\"+name;
		if(u.getUserUsage()+size > u.getUserStorage())
		{
			result = 0;
			return result;
		}
		fileservice.AddStorage(owner, size);
		//java.io.File uploadpath = new java.io.File(path);
		EncryptAndDecrypt.DESEncrypt(file, path, u.getUserKey());
		result = fileservice.InsertFileInfo(name, type, size, time, owner, hash, path);
		return result;
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
			modelview.addObject("User",me);
			return modelview;
		}
		else
		{
			return new ModelAndView("/upload");
		}
	}
	
	@RequestMapping("/delete")
	@ResponseBody
	public int DeleteFile(HttpServletRequest request)
	{
		int result = 0;
		String DeleteId = request.getParameter("DeleteId");
		int owner = Integer.parseInt(request.getSession().getAttribute("ID").toString());
		int Delete = Integer.parseInt(DeleteId);
		double file_size = fileservice.GetSize(Delete);
		if(file_size<=0) return result;
		result = fileservice.DeleteFile(Delete);
		fileservice.SubStorage(owner, file_size);
		return result;
	}
}
