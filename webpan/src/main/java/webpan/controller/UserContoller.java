package webpan.controller;

import java.security.NoSuchAlgorithmException;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import webpan.model.User;
import webpan.service.UserService;

@Controller
@RequestMapping("/user")
public class UserContoller 
{
	@Resource
	private UserService uservice;
	@RequestMapping("/login")
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
		int result = uservice.register(Pass,UserName,Email);
		if(result==1) {
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
	
}
