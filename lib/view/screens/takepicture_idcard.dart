import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as im;
import 'package:village_visitor/view/screens/register_page.dart';
import 'dart:io' as Io;

// A screen that allows users to take a picture using a given camera.
class TakePictureScreenIdCard extends StatefulWidget {
  const TakePictureScreenIdCard({Key? key, required this.camera})
      : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenIdCardState createState() => TakePictureScreenIdCardState();
}

class TakePictureScreenIdCardState extends State<TakePictureScreenIdCard> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool condition = false;
  bool flash_status = false;

  static const color1DeepBlue = Color(0xFF333d51);
  static const color1Yellow = Color(0xFFd3ac2b);
  static const color1Grey = Color(0xFFcbd0d8);
  static const color1DeepGrey = Color(0xFF797b7e);
  static const color1White = Color(0xFFf4f3ea);
  static const color1Black = Color.fromARGB(255, 24, 24, 24);

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    final deviceRatio = deviceSize.width / deviceSize.height;

    final size = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: color1DeepBlue,
      appBar: AppBar(
        title: Text("ถ่ายภาพบัตรประจำตัวประชาชน"),
        backgroundColor: color1DeepBlue,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Transform.scale(
                //   scale: 1,
                //   child: Center(
                //     child: AspectRatio(
                //       aspectRatio: 3 / 4,
                //       child: OverflowBox(
                //         alignment: Alignment.center,
                //         child: FittedBox(
                //           fit: BoxFit.fitWidth,
                //           child: Container(
                //             width: size / _controller.value.aspectRatio,
                //             height: size,
                // child:
                CameraPreview(_controller,
                    child: Transform.scale(
                        scale: 1,
                        child: Center(
                            child: AspectRatio(
                                aspectRatio: 3 / 4,
                                child: OverflowBox(
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Container(
                                        width: size /
                                            _controller.value.aspectRatio,
                                        height: size,
                                        child: Image.asset(
                                            'assets/images/camera_frame4.png'),
                                      ),
                                    )))))),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (!flash_status) {
                            _controller.setFlashMode(FlashMode.torch);
                            setState(() {
                              flash_status = true;
                            });
                          } else {
                            _controller.setFlashMode(FlashMode.off);
                            setState(() {
                              flash_status = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary:
                                !flash_status ? Colors.white : Colors.amber),
                        child: Text(
                          "Flash",
                          style: TextStyle(
                              color: Colors.black,
                              backgroundColor: Colors.transparent),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: color1White,
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final image = await _controller.takePicture();

            await Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                  camera: widget.camera,
                  imageName: image.name,
                ),
              ),
            )
                .then((value) {
              Navigator.of(context).pop(value);
            });
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(
          Icons.camera_alt,
          color: color1Black,
        ),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String imageName;

  const DisplayPictureScreen(
      {Key? key,
      required this.imagePath,
      required this.camera,
      required this.imageName})
      : super(key: key);

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    const color1DeepBlue = Color(0xFF333d51);
    const color1Yellow = Color(0xFFd3ac2b);
    const color1Grey = Color(0xFFcbd0d8);
    const color1DeepGrey = Color(0xFF797b7e);
    const color1White = Color(0xFFf4f3ea);
    const color1Black = Color.fromARGB(255, 24, 24, 24);

    final image = im.decodeImage(File(imagePath).readAsBytesSync())!;
    final thumbnail = im.copyCrop(image, 55, 240, 365, 245);
    File(imagePath).writeAsBytesSync(im.encodePng(thumbnail));

    final image2 = im.decodeImage(File(imagePath).readAsBytesSync())!;
    final thumbnail2 =
        im.fillRect(image2, 150, 20, 300, 40, Colors.black.value);
    File(imagePath).writeAsBytesSync(im.encodePng(thumbnail2));

    final image3 = im.decodeImage(File(imagePath).readAsBytesSync())!;
    final thumbnail3 = im.fillRect(image2, 5, 70, 30, 220, Colors.black.value);
    File(imagePath).writeAsBytesSync(im.encodePng(thumbnail3));

    return Scaffold(
      appBar: AppBar(
        title: const Text('ตรวจสอบรูปภาพ'),
        backgroundColor: color1DeepBlue,
      ),
      backgroundColor: color1DeepBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Image.file(File(imagePath))),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 140,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: color1Yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  // side: BorderSide(width: 5.0, color: color1Black),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(imagePath);
              },
              child: const Text(
                'ใช้ภาพนี้',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
