package webpan.model;

public class User {
	private int UserID;
	private String UserName;
	private String UserPass;
	private double UserUsage;
	private double UserStorage;
	private String UserKey;
	private String UserEmail;
	private String UserType;
	private boolean UserMessageStatus;
	
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
	public double getUserUsage() {
		return UserUsage;
	}
	public void setUserUsage(double userUsage) {
		UserUsage = userUsage;
	}
	public double getUserStorage() {
		return UserStorage;
	}
	public void setUserStorage(double userStorage) {
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
	public String getUserType() {
		return UserType;
	}
	public void setUserType(String userType) {
		UserType = userType;
	}
	public boolean getUserMessageStatus() {
		return UserMessageStatus;
	}
	public void setUserMessageStatus(boolean userMessageStatus) {
		UserMessageStatus = userMessageStatus;
	}
	
}
