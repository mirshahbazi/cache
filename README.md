
![Result](https://github.com/mirshahbazi/cache/tree/main/help/app_result.png)
## API

- *Cache*

##### iOS/Android

- iOS: Obtain the memory size under a certain path of the system, the path must be passed under iOS
- android: Get and format all cache sizes of the application, return String, with unit, path is not passed
```
systemCache({String path}) -> Future<String>
```

- iOS: Clear the cache under a certain path, must be uploaded under iOS
- android: Clear all caches of the application, the path is not passed
``` 
clearCache({String path}) -> Future<bool>
```

- Get remaining free space
```
availableSpace() -> Future<String>
```

- Get all storage space of the device
```
deviceCacheSpace() -> Future<String>
```

- Save pictures to album or local path
``` 
/// data: data stream
/// path: path
/// saveProjectNameAlbum: Whether to save in a custom album. If customAlbum has no value, it will be automatically created with the project name as the album name
/// customAlbum: custom album name
///
/// The return value is a Map, including isSuccess, result, imagePath
/// isSuccess: Indicates whether it is successful, bool value
/// result: success or failure information, String
/// imagePath: The path when saving in the album, String
saveImage(Uint8List data,
      {String path, bool saveProjectNameAlbum, String customAlbum}) -> Future<dynamic>
```

- save video to camera roll
```
/// path: path
/// saveProjectNameAlbum: Whether to save in a custom album. If customAlbum has no value, it will be automatically created with the project name as the album name
/// customAlbum: custom album name
///
/// isSuccess: Indicates whether it is successful, bool value
/// result: success or failure information, String
/// videoPath: the path when saving in the album, String
saveVideo(String videoPath,
      {bool saveProjectNameAlbum, String customAlbum}) -> Future<dynamic>
```
#### iOS

#### Android

---

- ShardPreferences

##### iOS/Android
> Local storage of key-value pairs. T class is [bool, int, double, String, List<String>]
```
localSave<T>(String key, T value) -> Void
```

> get value by key
```
localGet(String key) -> Future<dynamic>
```