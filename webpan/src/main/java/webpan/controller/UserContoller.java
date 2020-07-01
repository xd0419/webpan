package webpan.controller;

import java.security.NoSuchAlgorithmException;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import webpan.model.File;
import webpan.model.User;
import webpan.service.UserService;

@Controller
@RequestMapping("/user")
public class UserContoller 
{
	@Resource
	private UserService uservice;
	@RequestMapping("/login")
	@ResponseBody
	public String Login(HttpServletRequest request)
	{
		String name = request.getParameter("UserName");
		String pass = request.getParameter("Password");
		User u = uservice.login(name, pass);
		if(u != null)
		{
			HttpSession session = request.getSession();
			session.setAttribute("ID",u.getUserID());
			return "true";
		}
		return "false";
	}
	@RequestMapping("/loginpage")
	public ModelAndView showLogin(HttpServletRequest request)
	{
		ModelAndView modelview = new ModelAndView("/loginpage");
		return modelview;
	}
	
	@RequestMapping("/register")
	@ResponseBody
	public String Register(HttpServletRequest request) throws NoSuchAlgorithmException
	{
		
		String UserName = request.getParameter("UserName");
		String Pass = request.getParameter("UserPass");
		String Email = request.getParameter("UserEmail");
		int CheckName = uservice.CheckName(UserName);
		if (!Email.matches("[\\w\\.\\-]+@([\\w\\-]+\\.)+[\\w\\-]+")) 
		{
			return "emailfalse";
		}
		else if( CheckName != 0) {
			return "namerepeat";
		}
		else if (Pass == "")
		{
			return "passflase";
		}
		int result = uservice.register(Pass,UserName,Email);
		if(result==1) {
			java.io.File file=new java.io.File("C:\\webpan\\"+UserName);
			if(!file.exists())
			{
				file.mkdir();
			}
			return "true";
		}
		return "false";		
	}
	@RequestMapping("/registerpage")
	public ModelAndView showRegister(HttpServletRequest request)
	{
		ModelAndView modelview = new ModelAndView("/registerpage");
		return modelview;
	}
	
	@RequestMapping("/homepage")
	public ModelAndView showHome(HttpServletRequest request)
	{
		ModelAndView modelview = new ModelAndView("/homepage");
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
			return new ModelAndView("/loginpage");
		}
	}
	
	
	@RequestMapping("/download")
	public ModelAndView showDownload(HttpServletRequest request)
	{
		ModelAndView modelview = new ModelAndView("/download");
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
			return new ModelAndView("/download");
		}
	}
	
	@RequestMapping("/apply")
	@ResponseBody
	public String Apply(HttpServletRequest request)
	{
		String applyStr = request.getParameter("ApplySize");
		String username = request.getParameter("UserName");
		
		User me=uservice.GetUserbyname(username);
		if(me.getUserMessageStatus()) {
			return "false";
		}
		
		int result = uservice.apply(applyStr, username);
		if(result == 1)
		{
			return "true";
		}
		return "false";
	}
	
	
	
}
