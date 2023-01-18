package com.example.cache;

import android.graphics.Bitmap;
import android.os.Environment;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * @author :mohammad ali mirshahbazi
 * @classname: FileUtil
 * @describe: file tools
 */


public class FileUtil {
    private static final File PARENT_PATH = Environment.getExternalStorageDirectory();
    private static String storagePath = "";
    private static String DST_FOLDER_NAME = "mcj";

    /**
     * Initialize path, create file
     *
     * @return
     */
    private static String initPath(String dir) {
        File f = new File(dir);
        if (!f.exists()) {
            f.mkdir();
        }
        return dir;
    }

    /**
     * save Picture
     *
     * @param dir
     * @param b
     * @return
     */
    public static String saveBitmap(String dir, Bitmap b) {
        String path = initPath(dir);
        long dataTake = System.currentTimeMillis();
        String jpegName = path + File.separator + "picture_" + dataTake + ".jpg";
        try {
            FileOutputStream fout = new FileOutputStream(jpegName);
            BufferedOutputStream bos = new BufferedOutputStream(fout);
            b.compress(Bitmap.CompressFormat.JPEG, 100, bos);
            bos.flush();
            bos.close();
            return jpegName;
        } catch (IOException e) {
            e.printStackTrace();
            return "";
        }
    }

    /**
     * Delete Files
     *
     * @param path
     * @return
     */
    public static boolean deleteFile(String path) {
        boolean result = false;
        File file = new File(path);
        if (file.exists()) {
            result = file.delete();
        }
        return result;
    }

    /**
     * Determine whether there is an SD card
     *
     * @return
     */
    public static boolean isExternalStorageWritable() {
        String state = Environment.getExternalStorageState();
        if (Environment.MEDIA_MOUNTED.equals(state)) {
            return true;
        }
        return false;
    }

}
