package webpan.dao;

import org.apache.ibatis.annotations.Param;

public interface UserDao {
	public int register(@Param("Password")String pass,@Param("UserName")String name,@Param("UserEmail")String email,@Param("UserKey")String key);

}
