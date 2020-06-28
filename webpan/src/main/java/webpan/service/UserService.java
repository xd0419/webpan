package webpan.service;

import java.security.NoSuchAlgorithmException;

import webpan.model.User;

public interface UserService {
	public int register(String pass,String name,String email) throws NoSuchAlgorithmException;
	public User login(String name,String pass);
}
