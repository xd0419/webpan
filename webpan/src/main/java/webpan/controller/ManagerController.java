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
	
	@RequestMapping("/agree")
	@ResponseBody
	public ModelAndView Agree(HttpServletRequest request) {
		String ApplyID = request.getParameter("ApplyID");
		
		return null;
	}
}
