package webpan.service;

public interface FileService 
{
	public int InsertFileInfo(String name,String type,double size,String time,int owner,String hash,String path);
	public int SubStorage(int owner,double size);
	public double GetSize(int file_id);
	public int DeleteFile(int delete);
	public int AddStorage(int owner,double size);
}
