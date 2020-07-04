package webpan.service;

import java.security.NoSuchAlgorithmException;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import webpan.model.File;
import webpan.model.User;

public interface UserService {
	public int register(String pass,String name,String email) throws NoSuchAlgorithmException;
	public User login(String name,String pass);
	public User GetUserbyid(int id);
	public User GetUserbyemail(String UserEmail);
	public User GetUserbyname(String UserName);
	public int apply(String apply, String username);
	public int CheckName(String UserName);
	public int CheckEmail(String UserEmail);
	public List<File> GetFilebyid(int id);
}
