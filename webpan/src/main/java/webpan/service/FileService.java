package webpan.service;

import org.apache.ibatis.annotations.Param;

import webpan.model.File;
import webpan.model.User;

public interface FileService 
{
	public int InsertFileInfo(String name,String type,double size,String time,int owner,String hash,String path);
	public int SubStorage(int owner,double size);
	public int DeleteFile(int delete);
	public int AddStorage(int owner,double size);
	public File GetFileById(int fileId);
	public File GetFileByName(String fileName,String fileType,String ownerId);
	public User GetOwnerByFile(int fileId);
	public int ChangeFileName(int fileId,String new_filename,String new_filepath);
}
