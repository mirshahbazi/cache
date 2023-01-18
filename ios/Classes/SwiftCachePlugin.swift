import Flutter
import UIKit

public class SwiftCachePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "cache", binaryMessenger: registrar.messenger())
    let instance = SwiftCachePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    if call.method == "getSystemCache" {
        WYAClearCache.wya_cacheFileSize(atPath: (call.arguments as! [String]).first!) { (msg) in
            result(msg)
        }
    } else if call.method == "clearCache" {
        WYAClearCache.wya_clearFile(atPath: (call.arguments as! [String]).first!) { (msg) in
            result(msg)
        }
    } else if call.method == "availableSpace" {
        WYAClearCache.wya_getDivceAvailableSizeBlock { (msg) in
            result(msg)
        }
    } else if call.method == "deviceCacheSpace" {
        result(WYAClearCache.wya_getDivceTotalSize())
    } else if call.method == "saveImage" {
        var map = call.arguments as! [String : Any]
        print(map)
        let image = UIImage(data: (map["data"] as! FlutterStandardTypedData).data)!
        if !(map["data"] is NSNull) {
            if !(map["path"] is NSNull)  {
                let manager = FileManager.default
                if !(manager.fileExists(atPath: map["path"] as! String)) {
                    let isSuccess = manager.createFile(atPath: map["path"] as! String, contents: (map["data"] as! FlutterStandardTypedData).data, attributes: nil)
                    var dic = NSDictionary(objects: [isSuccess], forKeys: ["isSuccess" as NSCopying,"reslut" as NSCopying,"imagePath" as NSCopying,"videoPath" as NSCopying])
                    result(dic)
                }

            } else {
                let tool = AssetCacheTool()
                if !(map["saveProjectNameAlbum"] is NSNull) {
                    tool.saveAblum = map["saveProjectNameAlbum"] as! Bool
                }
                if !(map["customAlbum"] is NSNull) {
                    tool.albumName = map["customAlbum"] as! String
                }
                tool.savePhtots(image, videoUrl: nil) { (isSuccess, res, path, videoPath) in
                    var dic = NSDictionary(objects: [isSuccess,res,path], forKeys: ["isSuccess" as NSCopying,"result" as NSCopying,"imagePath" as NSCopying])
                    result(dic)
                }
            }
        } else {
            result(NSDictionary(object: false, forKey: "isSuccess" as NSCopying))
        }

    } else if call.method == "saveVideo" {
        var map = call.arguments as! [String : Any]
        if !(map["path"] is NSNull) {
            let tool = AssetCacheTool()
            if !(map["saveProjectNameAlbum"] is NSNull) {
                tool.saveAblum = map["saveProjectNameAlbum"] as! Bool
            }
            if !(map["customAlbum"] is NSNull) {
                tool.albumName = map["customAlbum"] as! String
            }
            tool.savePhtots(nil, videoUrl: URL(fileURLWithPath: map["path"] as! String)) { (isSuccess, res, path, videoPath) in
                var dic = NSDictionary(objects: [isSuccess,res,videoPath], forKeys: ["isSuccess" as NSCopying,"result" as NSCopying,"videoPath" as NSCopying])
                result(dic)
            }
        } else {
            result(NSDictionary(object: false, forKey: "isSuccess" as NSCopying))
        }
    }
  }
}
