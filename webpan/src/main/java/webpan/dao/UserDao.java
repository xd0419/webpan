package webpan.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import webpan.model.File;
import webpan.model.User;

public interface UserDao {
	public int register(@Param("Password")String pass,@Param("UserName")String name,@Param("UserEmail")String email,@Param("UserKey")String key);
	public User login(@Param("User")String User,@Param("UserPass")String Password);
	public User GetUserbyid(@Param("Id")int id);
	public User GetUserbyname(@Param("UserName")String UserName);
	public User GetUserbyemail(@Param("UserEmail")String UserEmail);
	public int applyApply(@Param("ApplySize")String ApplySize, @Param("UserName")String UserName);
	public int applyUser(@Param("ApplySize")String ApplySize, @Param("UserName")String UserName);
	public int CheckName(@Param("UserName")String UserName);
	public List<File> getFilebyid(@Param("Id")int id);
	
}
