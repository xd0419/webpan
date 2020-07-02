package webpan.controller;

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.FileChannel;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import tools.EncryptAndDecrypt;
import tools.FiletoByte;
import webpan.model.User;
import webpan.service.FileService;
import webpan.service.UserService;

@Controller
@RequestMapping("/bigfile")
public class BigFileController 
{
	@Resource
	private FileService fileservice;
	@Resource
	private UserService uservice;
	@RequestMapping("/upload")
	@ResponseBody
	public int upload(/*@RequestParam("upload_file")*/MultipartFile file,HttpServletRequest request) throws IllegalStateException, IOException
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
        java.io.File temp_file_path = new java.io.File("C:\\webpan\\"+u.getUserName()+"\\tmp\\"+chunk);
        file.transferTo(temp_file_path);
        return 1;
	}
	
	@RequestMapping("/check")
	@ResponseBody
	public int check(HttpServletRequest request)
	{
		int result = 0;
		String chunk = request.getParameter("chunk");
		String name = request.getParameter("filename");
		String chunkSize = request.getParameter("chunksize");
		int owner = Integer.parseInt(request.getSession().getAttribute("ID").toString());
		User u=uservice.GetUserbyid(owner);
		java.io.File chunkFile = new java.io.File("C:\\webpan\\"+u.getUserName()+"\\tmp\\"+chunk);
        if (chunkFile.exists() && chunkFile.length() == Integer.parseInt(chunkSize)) {
            result = 1;
        }
		return result;
	}
	
	@RequestMapping("/merge")
	@ResponseBody
	public int merge(HttpServletRequest request) throws Exception
	{
		int result = 0;
		String name = request.getParameter("filename");
		int indexOfPoint = name.lastIndexOf('.');
		if(indexOfPoint == -1) {
			indexOfPoint = name.length();
		}
		String fileName = name.substring(0,indexOfPoint);
		String fileType = name.substring(indexOfPoint+1);
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
                if (Integer.valueOf(o1.getName())< Integer.valueOf(o2.getName())) {
                    return -1;
                } else {
                    return 1;
                }
            }
        });
        java.io.File temp_file = new java.io.File("C:\\webpan\\"+u.getUserName()+"\\tmp\\"+name);
        /*合并文件操作*/
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
        String src_file = "C:\\webpan\\"+u.getUserName()+"\\tmp\\"+name;
        String dst_file = "C:\\webpan\\"+u.getUserName()+"\\"+name;
        double size = (double)temp_file.length()/1000000;
		if(u.getUserUsage()+size > u.getUserStorage())
		{
			result = -1;
			return result;
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date now = new Date();
		String time = sdf.format(now);
		String hash = DigestUtils.md5Hex(FiletoByte.getBytesByFile(src_file));
        result = fileservice.InsertFileInfo(fileName, fileType, size, time, owner, hash, dst_file);
        /*文件加密操作*/
        String key = u.getUserKey();
        EncryptAndDecrypt.DESEncrypt(src_file, dst_file, key);
        temp_file.delete();
		return result;
	}
	
}
