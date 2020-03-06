package com.xxin.drugstore.common.util;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Random;

public class EncryptUtil {
    public static String SHA1(String decript) {
        try {
            MessageDigest digest = MessageDigest
                    .getInstance("SHA-1");
            digest.update(decript.getBytes());
            byte messageDigest[] = digest.digest();
            // Create Hex String
            StringBuffer hexString = new StringBuffer();
            // 字节数组转换为 十六进制 数
            for (int i = 0; i < messageDigest.length; i++) {
                String shaHex = Integer.toHexString(messageDigest[i] & 0xFF);
                if (shaHex.length() < 2) {
                    hexString.append(0);
                }
                hexString.append(shaHex);
            }
            return hexString.toString();

        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return "";
    }

    /**
     * md5和sha-1混合加密
     *
     * @param inputText 要加密的内容
     *
     * @return String md5和sha-1混合加密之后的密码
     */
    public static String md5AndSha(String inputText) {
        return sha(md5(inputText));
    }


    /**
     * md5加密
     *
     * @param inputText 要加密的内容
     *
     * @return String  md5加密之后的密码
     */
    public static String md5(String inputText) {
        return encrypt(inputText, "md5");
    }


    /**
     * sha-1加密
     *
     * @param inputText  要加密的内容
     *
     * @return  sha-1加密之后的密码
     */
    public static String sha(String inputText) {
        return encrypt(inputText, "sha-1");
    }


    /**
     * md5或者sha-1加密
     *
     * @param inputText   要加密的内容
     *
     * @param algorithmName  加密算法名称：md5或者sha-1，不区分大小写
     *
     * @return String  md5或者sha-1加密之后的结果
     */
    private static String encrypt(String inputText, String algorithmName) {
        if (inputText == null || "".equals(inputText.trim())) {
            throw new IllegalArgumentException("请输入要加密的内容");
        }
        if (algorithmName == null || "".equals(algorithmName.trim())) {
            algorithmName = "md5";
        }
        String encryptText = null;
        try {
            MessageDigest m = MessageDigest.getInstance(algorithmName);
            m.update(inputText.getBytes("UTF8"));
            byte s[] = m.digest();
            return hex(s);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return encryptText;
    }



    /**
     * byte[]字节数组 转换成 十六进制字符串
     *
     * @param arr 要转换的byte[]字节数组
     *
     * @return  String 返回十六进制字符串
     */
    private static String hex(byte[] arr) {
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < arr.length; ++i) {
            sb.append(Integer.toHexString((arr[i] & 0xFF) | 0x100).substring(1, 3));
        }
        return sb.toString();
    }

    public static String getRandomSalt(){
        // 生成一个16位的随机数
        Random random = new Random();
        StringBuilder sBuilder = new StringBuilder(16);
        sBuilder.append(random.nextInt(99999999)).append(random.nextInt(99999999));
        int len = sBuilder.length();
        if (len < 16) {
            for (int i = 0; i < 16 - len; i++) {
                sBuilder.append("0");
            }
        }
        // 生成最终的加密盐
        String salt = sBuilder.toString();
        return salt;
    }

    /**
     * 生成含有随机盐的密码
     *
     * @param password 要加密的密码
     *
     * @return String 含有随机盐的密码
     */
    public static String getSaltMd5AndSha(String salt,String password) {
        password = md5AndSha(password + salt);
        char[] cs = new char[48];
        for (int i = 0; i < 48; i += 3) {
            cs[i] = password.charAt(i / 3 * 2);
            char c = salt.charAt(i / 3);
            cs[i + 1] = c;
            cs[i + 2] = password.charAt(i / 3 * 2 + 1);
        }
        return String.valueOf(cs);
    }



    /**
     * 验证加盐后是否和原密码一致
     *
     * @param password 原密码
     *
     * @param password 加密之后的密码
     *
     *@return boolean true表示和原密码一致   false表示和原密码不一致
     */
    public static boolean getSaltVerifyMd5AndSha(String password, String md5str,String salt) {
        char[] cs1 = new char[32];
        char[] cs2 = new char[16];
        try {
            for (int i = 0; i < 48; i += 3) {
                cs1[i / 3 * 2] = md5str.charAt(i);
                cs1[i / 3 * 2 + 1] = md5str.charAt(i + 2);
//                cs2[i / 3] = md5str.charAt(i + 1);
            }
//            String salt = new String(cs2);
            String encrypPassword = md5AndSha(password + salt);
            // 加密密码去掉最后8位数
            encrypPassword = encrypPassword.substring(0 , encrypPassword.length() - 8);
            return encrypPassword.equals(String.valueOf(cs1));
        }catch (Exception e){
            return false;
        }

    }



    public static void main(String[] args) {
        // 原密码
        String plaintext = "123";
//        String salt = getRandomSalt();
        String salt = "9554391059444155";

        System.out.println(salt);
        // 获取加盐后的MD5值
//        String ciphertext = EncryptUtil.getSaltMd5AndSha(salt,plaintext);
        String ciphertext = "b91c5455194573b793117904c5279b94b243e47510252956";

        System.out.println(md5AndSha("123"+salt));
        System.out.println("加盐后MD5：" + ciphertext);
        System.out.println("是否是同一字符串:" + EncryptUtil.getSaltVerifyMd5AndSha(plaintext, ciphertext,salt));
    }

}
