package webpan.model;

import java.util.Date;

public class File 
{
	private int FileID;
	private String FileName;
	private String FileType;
	private double FileSize;
	private Date FileUploadTime;
	private int FileOwner;
	private String FileHash;
	private String FilePath;
	public int getFileID() {
		return FileID;
	}
	public void setFileID(int fileID) {
		FileID = fileID;
	}
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
	public Date getFileUploadTime() {
		return FileUploadTime;
	}
	public void setFileUpdateTime(Date fileUploadTime) {
		FileUploadTime = fileUploadTime;
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
