package webpan.model;

public class User {
	private int UserID;
	private String UserName;
	private String UserPass;
	private int UserUsage;
	private int UserStorage;
	private String UserKey;
	private String UserEmail;
	
	public int getUserID() {
		return UserID;
	}
	public void setUserID(int userID) {
		UserID = userID;
	}
	public String getUserName() {
		return UserName;
	}
	public void setUserName(String userName) {
		UserName = userName;
	}
	public String getUserPass() {
		return UserPass;
	}
	public void setUserPass(String userPass) {
		UserPass = userPass;
	}
	public int getUserUsage() {
		return UserUsage;
	}
	public void setUserUsage(int userUsage) {
		UserUsage = userUsage;
	}
	public int getUserStorage() {
		return UserStorage;
	}
	public void setUserStorage(int userStorage) {
		UserStorage = userStorage;
	}
	public String getUserKey() {
		return UserKey;
	}
	public void setUserKey(String userKey) {
		UserKey = userKey;
	}
	public String getUserEmail() {
		return UserEmail;
	}
	public void setUserEmail(String userEmail) {
		UserEmail = userEmail;
	}
	
}
