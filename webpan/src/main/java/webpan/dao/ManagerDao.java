package webpan.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import webpan.model.Apply;
import webpan.model.User;

public interface ManagerDao {
	public List<User> getAllUsers();
	public List<Apply> getAllApplies();
	public List<User> getApplyUsers();
	public int setStorage(@Param("UserID")int ID, @Param("Size")double size);
	public User GetUserbyid(@Param("UserID")int id);
	public int refuseApply(@Param("ApplyID")int applyID,@Param("UserName")String userName,@Param("Manager")String manager);
	public int refuseUser(@Param("ApplyID")int applyID,@Param("UserName")String userName);
	public int agreeApply(@Param("ApplyID")int applyID,@Param("UserName")String userName,@Param("Size")double size,@Param("Manager")String manager);
	public int agreeUser(@Param("ApplyID")int applyID,@Param("UserName")String userName,@Param("Size")double size);
	public int DeleteApply(@Param("ApplyID")int applyID);
}
