
import 'package:cache/cache_until.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _sDFreeSize= '';
  String _sDeviceCacheSpace= '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      ByteData data = await rootBundle.load('images/1.jpeg');
      String path = '/storage/emulated/0/MAM/image';
      Uint8List listData = data.buffer.asUint8List();
      var aa = await Cache.saveImage(listData,
          path: path, saveProjectNameAlbum: true, customAlbum: 'MAM');
      print(aa);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
     // _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Running on: $_platformVersion\n'),
              Row(
                children: <Widget>[
                  TextButton(
                    child: Text("getSDFreeSize"),
                    onPressed: () async {
                      var aa = await Cache.availableSpace;
                      setState(() {
                        _sDFreeSize = aa;
                      });
                    },
                  ),
                  Text(': $_sDFreeSize'),
                ],
              ),

              Row(
                children: <Widget>[
                  TextButton(
                    child: Text("deviceCacheSpace"),
                    onPressed: () async {
                      var aa = await Cache.deviceCacheSpace;
                      setState(() {
                        _sDeviceCacheSpace = aa;
                      });
                    },
                  ),
                  Text(': $_sDeviceCacheSpace'),
                ],
              ),

              TextButton(onPressed: initPlatformState, child: Text("save Picture"))
            ],
          ),
        ),
      ),
    );
  }
}
