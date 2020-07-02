package tools;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.security.Key;
import java.security.SecureRandom;

import javax.crypto.Cipher;
import javax.crypto.CipherInputStream;
import javax.crypto.KeyGenerator;

import org.apache.commons.codec.binary.Hex;
import org.springframework.web.multipart.MultipartFile;

public class EncryptAndDecrypt {
	public static void DESEncrypt(MultipartFile src_file,String dst_file,String key) throws Exception
	{
		Cipher cipher = Cipher.getInstance("DES");
		Key des_key = GetKey(key);
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

}

