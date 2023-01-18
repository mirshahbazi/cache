import 'dart:async';

import 'package:flutter/services.dart';

typedef PermissionStatusCallback = void Function();

class Cache {
  static const MethodChannel _channel = const MethodChannel('cache');

  /// Get the memory size under a certain path of the system
  /// path: local path
  static Future<String> systemCache({required String path}) async {
    final String systemCache = await _channel.invokeMethod(
      'getSystemCache',
      [path],
    );
    return systemCache;
  }

  /// Clear the cache under a certain path
  /// path: local path
  static Future<bool> clearCache({required String path}) async {
    final bool cacheCache = await _channel.invokeMethod('clearCache', [path]);
    return cacheCache;
  }

  /// Get the remaining free space
  static Future<String> get availableSpace async {
    final String availableSpace = await _channel.invokeMethod(
      'availableSpace',
    );
    return availableSpace;
  }

  /// Get all the storage space of the device
  static Future<String> get deviceCacheSpace async {
    final String deviceCacheSpace = await _channel.invokeMethod(
      'deviceCacheSpace',
    );
    return deviceCacheSpace;
  }

  /// Save the picture to the album or local path
  /// data: data stream
  /// path: path
  /// saveProjectNameAlbum: Whether to save in a custom album. If customAlbum has no value, it will be automatically created with the project name as the album name
  /// customAlbum: custom album name
  ///
  /// The return value is a Map, including isSuccess, result, imagePath
  /// isSuccess: Indicates whether it is successful, bool value
  /// result: success or failure information, String
  /// imagePath: The path when saving in the album, String
  static Future<dynamic> saveImage(Uint8List data,
      {required String path,
      required bool saveProjectNameAlbum,
      required String customAlbum}) async {
    dynamic saveImage = await _channel.invokeMethod(
      'saveImage',
      {
        'path': path,
        'data': data,
        'saveProjectNameAlbum': saveProjectNameAlbum,
        'customAlbum': customAlbum,
      },
    );
    return saveImage;
  }

  /// Save the video to the camera roll
  /// path: path
  /// saveProjectNameAlbum: Whether to save in a custom album. If customAlbum has no value, it will be automatically created with the project name as the album name
  /// customAlbum: custom album name
  /// The return value is a Map, including isSuccess, result, videoPath
  /// isSuccess: Indicates whether it is successful, bool value
  /// result: success or failure information, String
  /// videoPath: the path when saving in the album, String
  static Future<dynamic> saveVideo(String videoPath,
      {required bool saveProjectNameAlbum, required String customAlbum}) async {
    dynamic saveVideo = await _channel.invokeMethod(
      'saveVideo',
      {
        'path': videoPath,
        'saveProjectNameAlbum': saveProjectNameAlbum,
        'customAlbum': customAlbum,
      },
    );
    return saveVideo;
  }
}
