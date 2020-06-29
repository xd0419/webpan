package webpan.dao;

import org.apache.ibatis.annotations.Param;

import webpan.model.User;

public interface UserDao {
	public int register(@Param("Password")String pass,@Param("UserName")String name,@Param("UserEmail")String email,@Param("UserKey")String key);
	public User login(@Param("User")String User,@Param("UserPass")String Password);
	public User GetUserbyid(@Param("Id")int id);
	public int apply(@Param("ApplySize")String ApplySize, @Param("UserName")String UserName);
	public int CheckName(@Param("UserName")String UserName);
}
