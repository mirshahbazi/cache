package com.example.cache;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.os.Environment;
import android.os.StatFs;

import java.io.File;

/**
 * @author :mohammad ali mirshahbazi
 * @classname: StorageUtil
 * @describe: storage
 */

public class StorageUtil {
    /**
     * Determine whether the sd card is available
     */
    public static boolean isExternalStorageAvailable() {
        return Environment.getExternalStorageState().equals(
                Environment.MEDIA_MOUNTED);
    }

    /**
     * Get the phone's internal storage space
     *
     * @param context
     * @return capacity in B
     */
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
    public static long getInternalMemorySize(Context context) {
        File file = Environment.getDataDirectory();
        StatFs statFs = new StatFs(file.getPath());
        long blockSizeLong = statFs.getBlockSizeLong();
        long blockCountLong = statFs.getBlockCountLong();
        long size = blockCountLong * blockSizeLong;
        return size;
    }

    /**
     * Get the available internal storage space of the phone
     *
     * @param context
     * @return capacity in B
     */
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
    public static long getAvailableInternalMemorySize(Context context) {
        File file = Environment.getDataDirectory();
        StatFs statFs = new StatFs(file.getPath());
        long availableBlocksLong = statFs.getAvailableBlocksLong();
        long blockSizeLong = statFs.getBlockSizeLong();
        long size = availableBlocksLong * blockSizeLong;
        return size;
    }

    /**
     * Obtain mobile phone external storage space
     *
     * @param context
     * @return capacity in B
     */
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
    public static long getExternalMemorySize(Context context) {
        File file = Environment.getExternalStorageDirectory();
        StatFs statFs = new StatFs(file.getPath());
        long blockSizeLong = statFs.getBlockSizeLong();
        long blockCountLong = statFs.getBlockCountLong();
        long size = blockSizeLong * blockCountLong;
        return size;
    }

    /**
     * Get the external storage space available on the phone
     *
     * @return capacity in B units
     */
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
    public static long getAvailableExternalMemorySize() {
        File file = Environment.getExternalStorageDirectory();
        StatFs statFs = new StatFs(file.getPath());
        long availableBlocksLong = statFs.getAvailableBlocksLong();
        long blockSizeLong = statFs.getBlockSizeLong();
        long size = blockSizeLong * availableBlocksLong;
        return size;
    }

    /**
     * Get the storage space under the path
     *
     * @param path
     * @return capacity in B units
     */
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
    public static long getPathMemorySize(String path) {
        StatFs statFs = new StatFs(path);
        long availableBlocksLong = statFs.getAvailableBlocksLong();
        long blockSizeLong = statFs.getBlockSizeLong();
        long size = blockSizeLong * availableBlocksLong;
        return size;
    }


}
