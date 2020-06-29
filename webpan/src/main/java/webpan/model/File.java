package webpan.model;

import java.util.Date;

public class File 
{
	private String FileName;
	private String FileType;
	private double FileSize;
	private Date FileUpdateTime;
	private int FileOwner;
	private String FileHash;
	private String FilePath;
	public String getFileName() {
		return FileName;
	}
	public void setFileName(String fileName) {
		FileName = fileName;
	}
	public String getFileType() {
		return FileType;
	}
	public void setFileType(String fileType) {
		FileType = fileType;
	}
	public double getFileSize() {
		return FileSize;
	}
	public void setFileSize(double fileSize) {
		FileSize = fileSize;
	}
	public Date getFileUpdateTime() {
		return FileUpdateTime;
	}
	public void setFileUpdateTime(Date fileUpdateTime) {
		FileUpdateTime = fileUpdateTime;
	}
	public int getFileOwner() {
		return FileOwner;
	}
	public void setFileOwner(int fileOwner) {
		FileOwner = fileOwner;
	}
	public String getFileHash() {
		return FileHash;
	}
	public void setFileHash(String fileHash) {
		FileHash = fileHash;
	}
	public String getFilePath() {
		return FilePath;
	}
	public void setFilePath(String filePath) {
		FilePath = filePath;
	}
	
	
}
