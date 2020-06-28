package webpan.service.impl;

import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

import javax.annotation.Resource;
import javax.crypto.KeyGenerator;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import webpan.dao.UserDao;
import webpan.model.User;
import webpan.service.UserService;
@Transactional
@Service("UserService")
public class UserServiceImpl implements UserService 
{
	@Resource
	private UserDao ud;
	public int register(String pass, String name, String email) throws NoSuchAlgorithmException {
		SecureRandom sr = new SecureRandom();
		KeyGenerator kg = KeyGenerator.getInstance("DES");
		kg.init(sr);
		Key key = kg.generateKey();
		String s = key.getEncoded().toString();
		int result = ud.register(pass, name, email,s);
		if(result==0)
			return 0;
		else
			return 1;
	}

	public User login(String name, String pass) {
		return null;
	}
}