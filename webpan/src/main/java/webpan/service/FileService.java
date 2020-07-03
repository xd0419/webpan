package webpan.service;

import webpan.model.File;

public interface FileService 
{
	public int InsertFileInfo(String name,String type,double size,String time,int owner,String hash,String path);
	public int SubStorage(int owner,double size);
	public int DeleteFile(int delete);
	public int AddStorage(int owner,double size);
	public File GetFileById(int fileId);
	public File GetFileByName(String fileName,String ownerId);
}
