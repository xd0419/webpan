package webpan.dao;

import org.apache.ibatis.annotations.Param;

import webpan.model.File;

public interface FileDao 
{
	public int InsertFileInfo(@Param("name")String name, @Param("type")String type, @Param("size")double size, 
			@Param("time")String time, @Param("owner")int owner, @Param("hash")String hash, @Param("path")String path);
	public int SubStorage(@Param("owner")int owner, @Param("size")double size);
	public int DeleteFile(@Param("file_id")int file_id);
	public int AddStorage(@Param("owner")int owner,@Param("size")double size);
	public File GetFileById(@Param("file_id")int fileId);
	public File GetFileByName(@Param("file_name")String fileName,@Param("owner_id")String ownerId);
}
