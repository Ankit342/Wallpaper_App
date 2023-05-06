import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FullScreen extends StatefulWidget {
  final String? imageUrl;
  const FullScreen({
    Key? key,
    this.imageUrl,
  }) : super(key: key);

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  String _platformVersion = 'Unknown';
  String __heightWidth = "Unknown";
  var _imageFile;
  @override
  void initState() {
    super.initState();
    initAppState();
  }

  Future<void> initAppState() async {
    String platformVersion;
    String _heightWidth;

    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await WallpaperManager.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    try {
      int height = await WallpaperManager.getDesiredMinimumHeight();
      int width = await WallpaperManager.getDesiredMinimumWidth();
      _heightWidth =
          "Width = " + width.toString() + " Height = " + height.toString();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
      _heightWidth = "Failed to get Height and Width";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      __heightWidth = _heightWidth;
      _platformVersion = platformVersion;
    });
  }

  Future<void> setwallpaper(int query) async {
    try {
      int location = query;
      var file = await DefaultCacheManager().getSingleFile(widget.imageUrl!);

      final bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            'Set Wallpaper',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: InteractiveViewer(
                maxScale: 2.0,
                child: Image.network(
                  widget.imageUrl!,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Running on: $_platformVersion\t',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '$__heightWidth\n',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      border: Border.all(width: 2, color: Colors.white),
                    ),
                    child: InkWell(
                      onTap: () {
                        setwallpaper(WallpaperManager.HOME_SCREEN);
                        Fluttertoast.showToast(
                          msg: 'Wallpaper set for Home Screen',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.deepOrange,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      },
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Text(
                            'Home Screen',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      border: Border.all(width: 2, color: Colors.white),
                    ),
                    child: InkWell(
                      onTap: () {
                        setwallpaper(WallpaperManager.LOCK_SCREEN);
                        Fluttertoast.showToast(
                          msg: 'Wallpaper set for Lock Screen',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.deepOrange,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      },
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Text(
                            'Lock Screen',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
                border: Border.all(width: 2, color: Colors.white),
              ),
              child: InkWell(
                onTap: () {
                  WallpaperManager.clearWallpaper();
                  Fluttertoast.showToast(
                    msg: 'Wallpaper Cleared for Both Screen',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.deepOrange,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },
                child: Container(
                  height: 40,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Clear WallPaper',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
