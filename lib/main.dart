import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:village_visitor/view/screens/takepicture_idcard.dart';
import 'package:village_visitor/view/screens/register_page.dart';
import 'package:village_visitor/view/screens/monitor_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  Intl.defaultLocale = 'th';
  initializeDateFormatting();

  // ErrorWidget.builder = (FlutterErrorDetails details) {
  //   bool inDebug = false;
  //   assert(() {
  //     inDebug = true;
  //     return true;
  //   }());
  //   // In debug mode, use the normal error widget which shows
  //   // the error message:
  //   if (inDebug) return ErrorWidget(details.exception);
  //   // In release builds, show a yellow-on-blue message instead:
  //   return Container(
  //     alignment: Alignment.center,
  //     child: Text(
  //       'Error! ${details.exception}',
  //       style: TextStyle(color: Colors.yellow),
  //       // textDirection: TextDirection.LTR,
  //     ),
  //   );
  // };

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.camera}) : super(key: key);

  final CameraDescription camera;
  static const color1Yellow = Color(0xFFd3ac2b);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save Visitor',
      theme: ThemeData(),
      // primarySwatch: Colors.home,
      // ),

      home: MonitorPage(
        camera: camera,
      ),
      // home: HomePage(
      //   camera: camera,
      // ),
    );
  }
}
