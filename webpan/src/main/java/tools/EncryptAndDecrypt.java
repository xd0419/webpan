package tools;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.security.Key;
import java.security.SecureRandom;

import javax.crypto.Cipher;
import javax.crypto.CipherInputStream;
import javax.crypto.CipherOutputStream;
import javax.crypto.KeyGenerator;
import javax.crypto.spec.IvParameterSpec;

import org.apache.commons.codec.binary.Hex;
import org.springframework.web.multipart.MultipartFile;

public class EncryptAndDecrypt {

    private final static String IV_PARAMETER = "12345678";
    private static final String CIPHER_ALGORITHM = "DES";
    private static final String CHARSET = "utf-8";

	public static void DESEncrypt(MultipartFile src_file,String dst_file,String key) throws Exception
	{
		Cipher cipher = Cipher.getInstance(CIPHER_ALGORITHM);
		Key des_key = GetKey(key);
		//String s = Hex.encodeHexString(des_key.getEncoded());
		cipher.init(Cipher.ENCRYPT_MODE, des_key);
		InputStream in = src_file.getInputStream();
		OutputStream out = new FileOutputStream(dst_file);
		CipherInputStream cis = new CipherInputStream(in, cipher);
		byte[] buffer = new byte[1024];
		int r;
        while ((r = cis.read(buffer)) > 0) {
            out.write(buffer, 0, r);
        }
        cis.close();
        in.close();
        out.close();
	}
	
	public static void DESDecrypt(File src_file, String dst_file, String key) throws Exception
	{
		
        Cipher cipher = Cipher.getInstance(CIPHER_ALGORITHM);
        Key des_key = GetKey(key);		
		cipher.init(Cipher.DECRYPT_MODE, des_key);		
		InputStream in = new FileInputStream(src_file);
        OutputStream out = new FileOutputStream(dst_file);
        CipherOutputStream cos = new CipherOutputStream(out, cipher);
        byte[] buffer = new byte[1024];
        int r;
        while ((r = in.read(buffer)) >= 0) {
            cos.write(buffer, 0, r);
        }
        cos.close();
        in.close();
        out.close();		
	}
	
	public static void DESEncrypt(String src_file,String dst_file,String key) throws Exception
	{
		Cipher cipher = Cipher.getInstance("DES");
		Key des_key = GetKey(key);
		cipher.init(Cipher.ENCRYPT_MODE, des_key);
		InputStream in = new FileInputStream(src_file);
		OutputStream out = new FileOutputStream(dst_file);
		CipherInputStream cis = new CipherInputStream(in, cipher);
		byte[] buffer = new byte[1024];
		int r;
        while ((r = cis.read(buffer)) > 0) {
            out.write(buffer, 0, r);
        }
        cis.close();
        in.close();
        out.close();
	}
	
	public static Key GetKey(String key) throws Exception
	{
		KeyGenerator kg = KeyGenerator.getInstance("DES");
		SecureRandom secureRandom = SecureRandom.getInstance("SHA1PRNG" );
		secureRandom.setSeed(key.getBytes());
		kg.init(secureRandom);
		Key des_key=kg.generateKey();
		return des_key;
	}
	
	public static String EncryptFileId(String src,String key)
	{
		char[] p = key.toCharArray(); // 字符串转字符数组
        int n = p.length; // 密码长度
        char[] c = src.toCharArray();
        int m = c.length; // 字符串长度
        for (int k = 0; k < m; k++) {
            int mima = c[k] + p[k / n]; // 加密
            c[k] = (char) mima;
        }
        return new String(c);

	}
	public static String DecryptFileId(String src,String key)
	{

        char[] p = key.toCharArray(); // 字符串转字符数组
        int n = p.length; // 密码长度
        char[] c = src.toCharArray();
        int m = c.length; // 字符串长度
        for (int k = 0; k < m; k++) {
            int mima = c[k] - p[k / n]; // 解密
            c[k] = (char) mima;
        }
        return new String(c);
	}

}

