package com.example.cache;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.res.Configuration;
import android.net.Uri;
import android.os.Environment;
import android.os.StatFs;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.WindowManager;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author :mohammad ali mirshahbazi
 * @classname: PhoneUtil
 * @describe: Mobile Information Tools
 */


public class PhoneUtil {
    private static PhoneUtil phoneUtil;
    /**
     * Mobile phone number judgment
     */
    private static Pattern PHONE_PATTERN = Pattern.compile("^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\\\d{8}$");

    public static PhoneUtil getInstance() {
        if (phoneUtil == null) {
            synchronized (PhoneUtil.class) {
                if (phoneUtil == null) {
                    phoneUtil = new PhoneUtil();
                }
            }
        }
        return phoneUtil;
    }

    public static boolean isMobileNO(String mobile) {
        Matcher m = PHONE_PATTERN.matcher(mobile);
        return m.matches();
    }

    /**
     * Get the version number of the mobile phone system API
     *
     * @return
     */
    public int getSDKVersionNumber() {
        int sdkVersion;
        try {
            sdkVersion = Integer.valueOf(android.os.Build.VERSION.SDK_INT);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            sdkVersion = 0;
        }
        return sdkVersion;
    }

    /**
     * Get the mobile phone system version number 6.0.1
     *
     * @return
     */
    public String getSDKVersion() {
        return android.os.Build.VERSION.RELEASE;
    }

    /**
     * Get the phone model
     */
    public String getPhoneModel() {
        return android.os.Build.MODEL;
    }

    /**
     * Get the phone model
     */
    public String getMobileBrand() {
        return android.os.Build.BRAND;
    }

    /**
     * Get the size of the remaining space of the sd card
     */
    @SuppressWarnings("deprecation")
    public long getSDFreeSize() {
        // Get SD card file path
        File path = Environment.getExternalStorageDirectory();
        StatFs sf = new StatFs(path.getPath());
        // Get the size of a single data block (Byte)
        long blockSize = sf.getBlockSize();
        // number of free data blocks
        long freeBlocks = sf.getAvailableBlocks();
        // Return the free size of the SD card in MB
        return (freeBlocks * blockSize) / 1024 / 1024;
    }

    /**
     * Get the total size of the sd card space
     */
    @SuppressWarnings("deprecation")
    public long getSDAllSize() {
        // Get SD card file path
        File path = Environment.getExternalStorageDirectory();
        StatFs sf = new StatFs(path.getPath());
        // Get the size of a single data block (Byte)
        long blockSize = sf.getBlockSize();
        // Get the number of all data blocks
        long allBlocks = sf.getBlockCount();
        // Return SD card size in MB
        return (allBlocks * blockSize) / 1024 / 1024;
    }


}