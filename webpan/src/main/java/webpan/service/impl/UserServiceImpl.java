package webpan.service.impl;

import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.List;

import javax.annotation.Resource;
import javax.crypto.KeyGenerator;

import org.apache.commons.codec.binary.Hex;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import webpan.dao.UserDao;
import webpan.model.File;
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
		byte[] encoded = kg.generateKey().getEncoded();
		String key = Hex.encodeHexString(encoded);
		int result = ud.register(pass, name, email,key);
		if(result==0)
			return 0;
		else
			return 1;
	}
	public User login(String UserNameOrUserEmail, String Password) 
	{
		User u = ud.login(UserNameOrUserEmail, Password);
		return u;
	}
	public User GetUserbyid(int id) 
	{
		return ud.GetUserbyid(id);
	}
	public User GetUserbyname(String name) 
	{
		return ud.GetUserbyname(name);
	}
	public int apply(String apply, String username) {
		return ud.applyApply(apply,username)*ud.applyUser(apply,username);
	}
	public int CheckName(String UserName)
	{
		return ud.CheckName(UserName);
	}
	public List<File> GetFilebyid(int id) 
	{
		List<File> f = ud.getFilebyid(id);
		return f;
	}
	public User GetUserbyemail(String UserEmail) {
		return ud.GetUserbyemail(UserEmail);
	}
	public int CheckEmail(String UserEmail) {
		return ud.CheckEmail(UserEmail);
	}
	
}