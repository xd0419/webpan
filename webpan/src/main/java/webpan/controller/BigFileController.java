package webpan.controller;

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import webpan.model.User;
import webpan.service.UserService;

@Controller
@RequestMapping("/bigfile")
public class BigFileController 
{
	@Resource
	private UserService uservice;
	@RequestMapping("/upload")
	public void upload(/*@RequestParam("upload_file")*/MultipartFile file,HttpServletRequest request) throws IllegalStateException, IOException
	{
		String chunk = request.getParameter("chunk");
		String name = file.getOriginalFilename();
		int indexOfPoint = name.lastIndexOf('.');
		if(indexOfPoint == -1) {
			indexOfPoint = name.length();
		}
		String fileName = name.substring(0,indexOfPoint);
		String fileType = name.substring(indexOfPoint+1);
		int owner = Integer.parseInt(request.getSession().getAttribute("ID").toString());
		User u=uservice.GetUserbyid(owner);
        java.io.File temp_path = new java.io.File("C:\\webpan\\"+u.getUserName()+"\\tmp");
        if(!temp_path.exists())
        {
        	temp_path.mkdir();
        }
        java.io.File temp_file_path = new java.io.File("C:\\webpan\\"+u.getUserName()+"\\tmp\\"+fileName+chunk+"."+fileType);
        file.transferTo(temp_file_path);	
	}
	
	@RequestMapping("/check")
	@ResponseBody
	public int check(HttpServletRequest request)
	{
		int result = 0;
		String chunk = request.getParameter("chunk");
		String name = request.getParameter("filename");
		int indexOfPoint = name.lastIndexOf('.');
		String fileName = name.substring(0,indexOfPoint);
		String fileType = name.substring(indexOfPoint+1);
		String chunkSize = request.getParameter("chunksize");
		int owner = Integer.parseInt(request.getSession().getAttribute("ID").toString());
		User u=uservice.GetUserbyid(owner);
		java.io.File chunkFile = new java.io.File("C:\\webpan\\"+u.getUserName()+"\\tmp\\"+fileName+chunk+"."+fileType);
        if (chunkFile.exists() && chunkFile.length() == Integer.parseInt(chunkSize)) {
            result = 1;
        }
		return result;
	}
	
	@RequestMapping("/merge")
	@ResponseBody
	public int merge(HttpServletRequest request)
	{
		int result = 0;
		String name = request.getParameter("fileName");
		int owner = Integer.parseInt(request.getSession().getAttribute("ID").toString());
		User u=uservice.GetUserbyid(owner);
		java.io.File temp_dir = new java.io.File("C:\\webpan\\"+u.getUserName()+"\\tmp\\");
        //获取tmp文件夹中所有文件
		File[] fileArray = temp_dir.listFiles(new FileFilter() {
        	public boolean accept(File pathname) {
                if (pathname.isDirectory()) {
                    return false;
                } else {
                    return true;
                }
            }
        });
        List<File> fileList = new ArrayList<File>(Arrays.asList(fileArray));
        Collections.sort(fileList, new Comparator<File>() {
            // 按文件名升序排列
            public int compare(File o1, File o2) {
                if (Integer.parseInt(o1.getName()) < Integer.parseInt(o2.getName())) {
                    return -1;
                } else {
                    return 1;
                }
            }
        });
        java.io.File temp_file = new java.io.File("C:\\webpan\\"+u.getUserName()+"\\tmp\\"+name);
        try {
            temp_file.createNewFile();
        } catch (IOException e) {
            System.out.println("创建目标文件出错：" + e.getMessage());
            e.printStackTrace();
        }
        FileChannel outChannel = null;
        FileChannel inChannel;
        try {
            outChannel = new FileOutputStream(temp_file).getChannel();
            for (File file : fileList) 
            {
                inChannel = new FileInputStream(file).getChannel();
                inChannel.transferTo(0, inChannel.size(), outChannel);
                inChannel.close();
                file.delete();
            }
            outChannel.close();
        } catch (FileNotFoundException e) {
        	 System.out.println("合并分片文件出错：" + e.getMessage());
            e.printStackTrace();
        } catch (IOException e) {
        	 System.out.println("合并分片文件出错：" + e.getMessage());
            e.printStackTrace();
        }
		return result;
	}
	
}
