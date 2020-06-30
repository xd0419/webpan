package webpan.dao;

import org.apache.ibatis.annotations.Param;

public interface FileDao 
{
	public int InsertFileInfo(@Param("name")String name, @Param("type")String type, @Param("size")double size, 
			@Param("time")String time, @Param("owner")int owner, @Param("hash")String hash, @Param("path")String path);
	public int SubStorage(@Param("owner")int owner, @Param("size")double size);
	public double GetSize(@Param("file_id")int file_id);
	public int DeleteFile(@Param("file_id")int file_id);
	public int AddStorage(@Param("owner")int owner,@Param("size")double size);
}
