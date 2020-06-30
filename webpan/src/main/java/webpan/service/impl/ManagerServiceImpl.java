package webpan.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.mapping.ResultMap;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import webpan.dao.ManagerDao;
import webpan.model.User;
import webpan.model.Apply;
import webpan.service.ManagerService;

@Transactional
@Service("ManagerService")
public class ManagerServiceImpl implements ManagerService 
{
	@Resource
	private ManagerDao mDao;

	public List<User> getAllUsers() {
		// TODO Auto-generated method stub
		List<User> results = mDao.getAllUsers();
		return results;
	}

	public List<Apply> getAllApplies() {
		// TODO Auto-generated method stub
		List<Apply> results = mDao.getAllApplies();
		return results;
	}

	public List<User> getApplyUsers() {
		// TODO Auto-generated method stub
		List<User> results = mDao.getApplyUsers();
		return results;
	}
}
