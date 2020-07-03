package webpan.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import webpan.dao.FileDao;
import webpan.model.File;
import webpan.service.FileService;

@Transactional
@Service("FileService")
public class FileServiceImpl implements FileService 
{
	@Resource
	private FileDao fdao;
	public int InsertFileInfo(String name, String type, double size, String time, int owner, String hash, String path) {
		return fdao.InsertFileInfo(name, type, size, time, owner, hash, path);
	}
	public int SubStorage(int owner, double size) {
		return fdao.SubStorage(owner, size);
	}
	public int DeleteFile(int file_id) {
		return fdao.DeleteFile(file_id);
	}
	public int AddStorage(int owner, double size) {
		return fdao.AddStorage(owner, size);
	}
	public File GetFileById(int fileId) {
		return fdao.GetFileById(fileId);
	}
	public File GetFileByName(String fileName,String ownerId) {
		return fdao.GetFileByName(fileName,ownerId);
	}
	
}
