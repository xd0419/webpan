package webpan.service;

import java.security.NoSuchAlgorithmException;

import webpan.model.User;

public interface UserService {
	public int register(String pass,String name,String email) throws NoSuchAlgorithmException;
	public User login(String name,String pass);
	public User GetUserbyid(int id);
	public int apply(String apply, String username);
	public int CheckName(String UserName);
}
