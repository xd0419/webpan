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
		List<User> results = mDao.getAllUsers();
		return results;
	}

	public List<Apply> getAllApplies() {
		List<Apply> results = mDao.getAllApplies();
		return results;
	}

	public List<User> getApplyUsers() {
		List<User> results = mDao.getApplyUsers();
		return results;
	}

	public int SetStorage(int ID, double size) {
		return mDao.setStorage(ID,size);
	}
	public User GetUserbyid(int id) 
	{
		return mDao.GetUserbyid(id);
	}

	public int AgreeApply(int applyID,String userName,double size,String manager) {
		return mDao.agreeApply(applyID,userName,size,manager)*mDao.agreeUser(applyID,userName,size);
	}

	public int RefuseApply(int applyID,String userName,String manager) {
		return mDao.refuseApply(applyID,userName,manager)*mDao.refuseUser(applyID,userName);
	}
	public int DeleteApply(int applyID) {
		return mDao.DeleteApply(applyID);
	}
}
