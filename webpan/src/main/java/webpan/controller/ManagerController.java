package webpan.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import webpan.model.Apply;
import webpan.model.File;
import webpan.model.User;
import webpan.service.ManagerService;
import webpan.service.UserService;

@Controller
@RequestMapping("/manager")
public class ManagerController 
{
	@Resource
	private ManagerService mservice;
	@Resource
	private UserService uservice;
	@RequestMapping("/manager_user")
	@ResponseBody
	public ModelAndView getAllUsers(HttpServletRequest request) {
		ModelAndView modelview = new ModelAndView("/manager_user");
		Object o = request.getSession().getAttribute("ID");
		if (o != null){
			String IDstr1 = o.toString();
			int myid = Integer.parseInt(IDstr1);
			User me=uservice.GetUserbyid(myid);
			List<User> allUserList = mservice.getAllUsers();
			modelview.addObject("UserList", allUserList);
			modelview.addObject("User",me);
		}
		return modelview;
	}
	
	@RequestMapping("/manager_message")
	@ResponseBody
	public ModelAndView getAllUers(HttpServletRequest request) {
		ModelAndView modelview = new ModelAndView("/manager_message");
		Object o = request.getSession().getAttribute("ID");
		if (o != null){
			String IDstr1 = o.toString();
			int myid = Integer.parseInt(IDstr1);
			User me=uservice.GetUserbyid(myid);
			modelview.addObject("User",me);
			List<Apply> allApplyList = mservice.getAllApplies();
			List<User> allUserList = mservice.getApplyUsers();
			modelview.addObject("ApplyList", allApplyList);
			modelview.addObject("UserList", allUserList);
		}
		return modelview;
	}
	
	@RequestMapping("/setStorage")
	@ResponseBody
	public String Deletefile(HttpServletRequest request)
	{
		String sizeStr = request.getParameter("Size");
		String IDStr = request.getParameter("UserId");
		
		double size = Double.parseDouble(sizeStr);
		int ID = Integer.parseInt(IDStr);
		User me=mservice.GetUserbyid(ID);

		if(size < me.getUserUsage())
			return "false";
		
		int result = mservice.SetStorage(ID,size);

		if (result != 0)
		{
			return "true";
		}
		else {
			return "false";
		}
	}
	
	@RequestMapping("/agree")
	@ResponseBody
	public String Agree(HttpServletRequest request) {
		String applyIDStr = request.getParameter("ApplyID");
		String username = request.getParameter("UserName");
		String sizeStr = request.getParameter("Size");
		double size = Double.parseDouble(sizeStr);
		int applyID = Integer.parseInt(applyIDStr);
		
		Object o = request.getSession().getAttribute("ID");
		User me=uservice.GetUserbyid(Integer.parseInt(o.toString()));
		
		int result = mservice.AgreeApply(applyID,username,size,me.getUserName());
		if (result != 0)
		{
			return "true";
		}
		else {
			return "false";
		}
	}
	
	@RequestMapping("/refuse")
	@ResponseBody
	public String Refuse(HttpServletRequest request) {
		String applyIDStr = request.getParameter("ApplyID");
		String username = request.getParameter("UserName");
		int applyID = Integer.parseInt(applyIDStr);
		
		Object o = request.getSession().getAttribute("ID");
		User me=uservice.GetUserbyid(Integer.parseInt(o.toString()));
		
		int result = mservice.RefuseApply(applyID,username,me.getUserName());
		if (result != 0)
		{
			return "true";
		}
		else {
			return "false";
		}
	}
	
	@RequestMapping("/delete_apply")
	@ResponseBody
	public String DeleteApply(HttpServletRequest request) {
		
		int result = mservice.DeleteApply(Integer.parseInt(request.getParameter("ApplyID")));
		if (result != 0)
		{
			return "true";
		}
		else {
			return "false";
		}
	}
	
}
