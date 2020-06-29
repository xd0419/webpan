package webpan.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import webpan.service.ManagerService;
import webpan.service.UserService;

@Controller
@RequestMapping("/manager")
public class ManagerController 
{
	@Resource
	private ManagerService mservice;

}
