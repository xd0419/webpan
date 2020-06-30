package webpan.dao;

import java.util.List;

import webpan.model.Apply;
import webpan.model.User;

public interface ManagerDao {
	public List<User> getAllUsers();
	public List<Apply> getAllApplies();
	public List<User> getApplyUsers();
}
