package webpan.service;

import java.util.List;

import webpan.model.Apply;
import webpan.model.User;

public interface ManagerService {
	public List<User> getAllUsers();
	public List<Apply> getAllApplies();
	public List<User> getApplyUsers();
	public int SetStorage(int ID, double size);
	public User GetUserbyid(int id);
	public int AgreeApply(int applyID,String userName,double size);
	public int RefuseApply(int applyID,String userName);
}
