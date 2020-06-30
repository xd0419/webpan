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
import webpan.model.User;
import webpan.service.ManagerService;

@Controller
@RequestMapping("/manager")
public class ManagerController 
{
	@Resource
	private ManagerService mservice;
	@RequestMapping("/manager_user")
	@ResponseBody
	public ModelAndView getAllUsers(HttpServletRequest request) {
		ModelAndView modelview = new ModelAndView("/manager_user");
		List<User> allUserList = mservice.getAllUsers();
		modelview.addObject("UserList", allUserList);
		return modelview;
	}
	
	@RequestMapping("/manager_message")
	@ResponseBody
	public ModelAndView getAllUers(HttpServletRequest request) {
		ModelAndView modelview = new ModelAndView("/manager_message");
		List<Apply> allApplyList = mservice.getAllApplies();
		List<User> allUserList = mservice.getApplyUsers();
		modelview.addObject("ApplyList", allApplyList);
		modelview.addObject("UserList", allUserList);
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
		
		int result = mservice.AgreeApply(applyID,username,size);
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
		int result = mservice.RefuseApply(applyID,username);
		if (result != 0)
		{
			return "true";
		}
		else {
			return "false";
		}
	}
	
}
