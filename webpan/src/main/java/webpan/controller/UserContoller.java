package webpan.controller;

import java.security.NoSuchAlgorithmException;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import webpan.model.File;
import webpan.model.User;
import webpan.service.UserService;

import java.security.MessageDigest;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.codec.binary.Hex;

@Controller
@RequestMapping("/user")
public class UserContoller 
{
	@Resource
	private UserService uservice;
	@RequestMapping("/login")
	@ResponseBody
	public String Login(HttpServletRequest request)
	{
		String name = request.getParameter("UserName");
		String pass = request.getParameter("Password");
		
		User me=uservice.GetUserbyname(name);
		if(me == null)
			me=uservice.GetUserbyemail(name);

		if(me != null && me.getUserPass().length() == 48 && verify(pass, me.getUserPass())){
			HttpSession session = request.getSession();
			session.setAttribute("ID",me.getUserID());
			return "true";
		}
        return "false";
	}
	@RequestMapping("/loginpage")
	public ModelAndView showLogin(HttpServletRequest request)
	{
		ModelAndView modelview = new ModelAndView("/loginpage");
		return modelview;
	}
	
	@RequestMapping("/logout")
	@ResponseBody
	public ModelAndView Logout(HttpServletRequest request)
	{
		request.getSession().invalidate();
		ModelAndView modelview = new ModelAndView("/loginpage");
		return modelview;
	}
	
	@RequestMapping("/register")
	@ResponseBody
	public String Register(HttpServletRequest request) throws NoSuchAlgorithmException
	{
		
		String UserName = request.getParameter("UserName");
		String Pass = request.getParameter("UserPass");
		String Email = request.getParameter("UserEmail");
		int CheckName = uservice.CheckName(UserName);
		int CheckEmail = uservice.CheckEmail(Email);
		String regEx = "[ _`~!@#$%^&*()+=|{}':;',/\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]|\n|\r|\t";
        Pattern p = Pattern.compile(regEx);
        Matcher m = p.matcher(UserName);
        if(m.find() || UserName.indexOf("\\") >=0) {
			return "usernamebad";
		}
		if (!Email.matches("[\\w\\.\\-]+@([\\w\\-]+\\.)+[\\w\\-]+")) 
		{
			return "emailfalse";
		}
		else if( CheckName != 0) {
			return "namerepeat";
		}else if( CheckEmail != 0) {
			return "emailrepeat";
		}else if (Pass.length()<6||Pass.length()>16){
			return "passflase";
		}
		m = p.matcher(Pass);
		if(m.find() || Pass.indexOf("\\") >=0) {
			return "passbad";
		}
		String md5Pass = generate(Pass);
		int result = uservice.register(md5Pass,UserName,Email);
		if(result==1) {
			java.io.File file=new java.io.File("C:\\webpan\\"+UserName);
			java.io.File tmpfile=new java.io.File("C:\\webpan\\"+UserName+"\\tmp");
			if(!file.exists())
			{
				file.mkdir();
				tmpfile.mkdir();
			}
			return "true";
		}
		return "false";		
	}
	@RequestMapping("/registerpage")
	public ModelAndView showRegister(HttpServletRequest request)
	{
		ModelAndView modelview = new ModelAndView("/registerpage");
		return modelview;
	}
	
	@RequestMapping("/homepage")
	public ModelAndView showHome(HttpServletRequest request)
	{
		ModelAndView modelview = new ModelAndView("/homepage");
		Object o = request.getSession().getAttribute("ID");
		if (o != null)
		{
			String IDstr1 = o.toString();
			int myid = Integer.parseInt(IDstr1);
			User me=uservice.GetUserbyid(myid);
			List<File> file=uservice.GetFilebyid(myid);
			modelview.addObject("User",me);
			modelview.addObject("fileList",file);
			return modelview;
		}
		else
		{
			return new ModelAndView("/loginpage");
		}
	}
	
	
	@RequestMapping("/sharepage")
	public ModelAndView showDownload(HttpServletRequest request)
	{
		ModelAndView modelview = new ModelAndView("/sharepage");
		Object o = request.getSession().getAttribute("ID");
		if (o != null)
		{
			String IDstr1 = o.toString();
			int myid = Integer.parseInt(IDstr1);
			User me=uservice.GetUserbyid(myid);
			modelview.addObject("User",me);
			return modelview;
		}
		else
		{
			return new ModelAndView("/sharepage");
		}
	}
	
	@RequestMapping("/apply")
	@ResponseBody
	public String Apply(HttpServletRequest request)
	{
		String applyStr = request.getParameter("ApplySize");
		String username = request.getParameter("UserName");
		
		User me=uservice.GetUserbyname(username);
		if(me.getUserMessageStatus()) {
			return "false";
		}
		
		int result = uservice.apply(applyStr, username);
		if(result == 1)
		{
			return "true";
		}
		return "false";
	}
	
    /** 普通MD5，可以删了 *//*
    public String MD5(String input) {
        MessageDigest md5 = null;
        try {
            md5 = MessageDigest.getInstance("MD5");
        } catch (NoSuchAlgorithmException e) {
            return "check jdk";
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
        char[] charArray = input.toCharArray();
        byte[] byteArray = new byte[charArray.length];

        for (int i = 0; i < charArray.length; i++)
            byteArray[i] = (byte) charArray[i];
        byte[] md5Bytes = md5.digest(byteArray);
        StringBuffer hexValue = new StringBuffer();
        for (int i = 0; i < md5Bytes.length; i++) {
            int val = ((int) md5Bytes[i]) & 0xff;
            if (val < 16)
                hexValue.append("0");
            hexValue.append(Integer.toHexString(val));
        }
        return hexValue.toString();

    }*/

    /** 加盐MD5 */
    public String generate(String password) {
        Random r = new Random();
        StringBuilder sb = new StringBuilder(16);
        sb.append(r.nextInt(99999999)).append(r.nextInt(99999999));
        int len = sb.length();
        if (len < 16) {
            for (int i = 0; i < 16 - len; i++) {
                sb.append("0");
            }
        }
        String salt = sb.toString();
        password = md5Hex(password + salt);
        char[] cs = new char[48];
        for (int i = 0; i < 48; i += 3) {
            cs[i] = password.charAt(i / 3 * 2);
            char c = salt.charAt(i / 3);
            cs[i + 1] = c;
            cs[i + 2] = password.charAt(i / 3 * 2 + 1);
        }
        return new String(cs);
    }

    /** 校验加盐后是否和原文一致 */
    public boolean verify(String password, String md5) {
        char[] cs1 = new char[32];
        char[] cs2 = new char[16];
        for (int i = 0; i < 48; i += 3) {
            cs1[i / 3 * 2] = md5.charAt(i);
            cs1[i / 3 * 2 + 1] = md5.charAt(i + 2);
            cs2[i / 3] = md5.charAt(i + 1);
        }
        String salt = new String(cs2);
        return md5Hex(password + salt).equals(new String(cs1));
    }

    /** 获取十六进制字符串形式的MD5摘要 */
    private String md5Hex(String src) {
        try {
            MessageDigest md5 = MessageDigest.getInstance("MD5");
            byte[] bs = md5.digest(src.getBytes());
            return new String(new Hex().encode(bs));
        } catch (Exception e) {
            return null;
        }
    }


}
