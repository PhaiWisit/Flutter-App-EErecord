import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:village_visitor/model/apis/baseDataApi.dart';
import 'package:village_visitor/view/screens/monitor_page.dart';
import 'package:village_visitor/view/screens/takepicture_idcard.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:village_visitor/view/screens/takepicture_licenseplate.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

enum SingingCharacter { car, motocycle }

class _RegisterPageState extends State<RegisterPage> {
  var houseNumber_controller = TextEditingController();
  var about_controller = TextEditingController();

  late String image_path_idcard = '';
  late String image_path_carregis = '';

  //Color Value 1
  static const color1DeepBlue = Color(0xFF333d51);
  static const color1Yellow = Color(0xFFd3ac2b);
  static const color1Grey = Color(0xFFcbd0d8);
  static const color1DeepGrey = Color(0xFF797b7e);
  static const color1White = Color(0xFFf4f3ea);
  static const color1Black = Color.fromARGB(255, 24, 24, 24);

  static const textStyle_black_20 = TextStyle(color: color1Black, fontSize: 20);

  String selectedValue = "";
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text(
            "ส่งอาหาร",
            textAlign: TextAlign.center,
          ),
          value: "ส่งอาหาร"),
      const DropdownMenuItem(
          child: Text(
            "ส่งผู้โดยสาร",
            textAlign: TextAlign.center,
          ),
          value: "ส่งผู้โดยสาร"),
      const DropdownMenuItem(
          child: Text(
            "ติดต่อลูกบ้าน",
            textAlign: TextAlign.center,
          ),
          value: "ติดต่อลูกบ้าน"),
      const DropdownMenuItem(
          child: Text(
            "อื่นๆ",
            textAlign: TextAlign.center,
          ),
          value: "อื่นๆ"),
    ];
    return menuItems;
  }

  late SingingCharacter? _character = SingingCharacter.motocycle;
  String vehicleType = 'รถจักรยานยนต์';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ระบบบันทึกการเข้าออกหมู่บ้าน'),
        backgroundColor: color1DeepBlue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: color1Grey,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              containerHead(),
              space(5),
              Container(
                child: Image.asset('assets/images/icon_house.png'),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: color1DeepBlue),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          space(20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                containerHome(),
                              ],
                            ),
                          ),
                          space(20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                containerAbout(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                selectedValue == 'อื่นๆ'
                                    ? containerAboutOption()
                                    : space(0),
                              ],
                            ),
                          ),
                          space(20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                containerType(),
                              ],
                            ),
                          ),
                          space(20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [containerPictureIdCard()],
                            ),
                          ),
                          space(20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [containerPictureLicenesePlate()],
                            ),
                          ),
                          containerSubmit(),
                        ],
                      ),
                    ),
                    // Fix wrong onPressed when use transform position of button.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            onClickSendData(context);
                          },
                          child: Container(
                              width: 200, height: 30, child: space(30)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              space(30)
            ],
          ),
        ),
      ),
      backgroundColor: color1Grey,
    );
  }

  // บันทึกข้อมูลผู้มาติดต่อ
  Widget containerHead() {
    return Transform.translate(
      offset: Offset(0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: color1DeepBlue,
        ),
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: Image.asset(
                  'assets/resource/logo.png',
                  fit: BoxFit.fitHeight,
                  height: 70,
                  width: 70,
                ),
              ),
            ),
            Text(
              " บันทึกข้อมูลผู้มาติดต่อ",
              style: TextStyle(color: color1White, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }

  // บ้านเลขที่
  Widget containerHome() {
    return Expanded(
      flex: 7,
      child: Container(
        decoration: BoxDecoration(
          color: color1White,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: TextField(
          controller: houseNumber_controller,
          style: textStyle_black_20,
          decoration: InputDecoration(
            hintText: 'ใส่บ้านเลขที่',
            hintStyle: TextStyle(color: Color.fromARGB(255, 160, 160, 160)),
            labelStyle: textStyle_black_20,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            suffixIcon: IconButton(
              onPressed: houseNumber_controller.clear,
              icon: const Icon(Icons.clear),
            ),
          ),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }

  // เรื่องที่ติดต่อ
  Widget containerAbout() {
    return Expanded(
      flex: 7,
      child: Container(
        decoration: BoxDecoration(
          color: color1White,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: InputDecorator(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            hintText: "test",
          ),
          child: DropdownButtonHideUnderline(
            child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: color1White,
              ),
              child: Container(
                child: DropdownButton(
                  icon: const Icon(Icons.arrow_drop_down, color: color1Black),
                  value: selectedValue.isNotEmpty ? selectedValue : null,
                  items: dropdownItems.map((item) {
                    return DropdownMenuItem(
                      child: Container(child: item.child),
                      value: item.value,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value.toString();
                    });
                  },
                  hint: Container(
                    child: Text(
                      "เรื่องที่ติดต่อ",
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  style: TextStyle(color: color1Black, fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ประเภทรถ
  Widget containerType() {
    return Expanded(
      flex: 7,
      child: Container(
        decoration: BoxDecoration(
          color: color1White,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ประเภทรถ',
                    style: textStyle_black_20,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      title: Transform.translate(
                        offset: Offset(-16, 0),
                        child: Text(
                          'รถจักรยานยนต์',
                          style: TextStyle(color: color1Black, fontSize: 15),
                        ),
                      ),
                      leading: Radio<SingingCharacter>(
                        activeColor: color1DeepBlue,
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        value: SingingCharacter.motocycle,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                            vehicleType = 'รถจักรยานยนต์ ';
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      title: Transform.translate(
                        offset: Offset(-16, 0),
                        child: const Text(
                          'รถยนต์',
                          style: TextStyle(color: color1Black, fontSize: 15),
                        ),
                      ),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.car,
                        activeColor: color1DeepBlue,
                        groupValue: _character,
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                            vehicleType = 'รถยนต์';
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ภาพถ่าย
  Widget containerPicture() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 135,
            width: 155,
            decoration: BoxDecoration(
              border: Border.all(color: color1Black, width: 5),
              color: color1Grey,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'บัตรประชาชน',
                    style: TextStyle(color: color1White, fontSize: 14),
                  ),
                  space(10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        primary: color1White,
                        fixedSize: const Size(120, 80),
                      ),
                      onPressed: (onClickIdCard),
                      child: image_path_idcard == ''
                          ? Image.asset('assets/images/camera.png')
                          : Image.file(File(image_path_idcard)))
                ],
              ),
            ),
          ),
          Container(
            height: 135,
            width: 155,
            decoration: BoxDecoration(
              border: Border.all(color: color1Black, width: 5),
              color: color1Grey,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'ทะเบียนรถ',
                    style: TextStyle(color: color1White, fontSize: 14),
                  ),
                  space(10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: color1White,
                      padding: EdgeInsets.all(0),
                      fixedSize: const Size(120, 80),

                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(50))
                    ),
                    onPressed: (onClickCarRegis),
                    child: image_path_carregis == ''
                        ? Image.asset('assets/images/camera.png')
                        : Image.file(
                            File(image_path_carregis),
                            fit: BoxFit.fill,
                          ),
                  )
                  // IconButton(
                  //   icon: Image.asset(
                  //       'assets/images/Screenshot (19).png'),
                  //   iconSize: 120,
                  //   onPressed: () {},
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget containerPictureIdCard() {
    return Expanded(
      flex: 7,
      child: GestureDetector(
        onTap: () {
          onClickIdCard();
        },
        child: Container(
          decoration: BoxDecoration(
            color: color1White,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ภาพบัตรประชาชน',
                  style: TextStyle(color: color1Black, fontSize: 18),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  height: 50,
                  width: 50,
                  child: image_path_idcard == ""
                      ? Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: color1DeepGrey,
                        )
                      : Icon(
                          Icons.check_box,
                          size: 50,
                          color: Colors.green.shade800,
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget containerPictureLicenesePlate() {
    return Expanded(
      flex: 7,
      child: GestureDetector(
        onTap: () {
          onClickCarRegis();
        },
        child: Container(
          decoration: BoxDecoration(
            color: color1White,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ภาพป้ายทะเบียนรถ',
                  style: TextStyle(color: color1Black, fontSize: 18),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  height: 50,
                  width: 50,
                  child: image_path_carregis == ""
                      ? Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: color1DeepGrey,
                        )
                      : Icon(
                          Icons.check_box,
                          size: 50,
                          color: Colors.green.shade800,
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ปุ่มบันทึก
  Widget containerSubmit() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.translate(
            offset: Offset(0, 30),
            child: Container(
              width: 200,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: color1Yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  onClickSendData(context);
                },
                child: const Text(
                  'บันทึกข้อมูล',
                  style: textStyle_black_20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget containerAboutOption() {
    return Expanded(
      flex: 7,
      child: Container(
        decoration: BoxDecoration(
          color: color1White,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: about_controller,
                style: TextStyle(color: color1Black, fontSize: 16),
                inputFormatters: [LengthLimitingTextInputFormatter(30)],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  hintText: 'ระบุ',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  labelStyle: TextStyle(color: color1Black, fontSize: 16),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: about_controller.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            space(20)
          ],
        ),
      ),
    );
  }

  Widget space(double height) {
    return SizedBox(
      height: height,
    );
  }

  void onClickIdCard() {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => TakePictureScreenIdCard(
                  camera: widget.camera,
                )))
        .then((value) {
      setState(() {
        image_path_idcard = value;
      });

      print(value);
    });
  }

  void onClickCarRegis() {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => TakePictureScreenLicensePlate(
                  camera: widget.camera,
                )))
        .then((value) {
      setState(() {
        image_path_carregis = value;
      });

      print(value);
    });
  }

  Future<void> onClickSendData(BuildContext context) async {
    DateTime now = DateTime.now();
    var dateFormat = DateFormat.yMd();
    var timeFormat = DateFormat.Hms();

    String _houseNumber = houseNumber_controller.text;
    String _contactMatter = selectedValue;
    String _vehicleType = vehicleType;
    String _date = '${dateFormat.format(now)}';
    String _time = '${timeFormat.format(now)}';
    String _imagePathIdCard = image_path_idcard;
    String _imagePathCarRegis = image_path_carregis;

    if (selectedValue == 'อื่นๆ') {
      _contactMatter = 'ระบุ : ' + about_controller.text;
    }

    if (houseNumber_controller.text == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert(
              'แจ้งเตือน',
              'คุณไม่ได้กรอกข้อมูลบ้านเลขที่ กรุณากรอกบ้านเลขที่',
              'ตกลง',
              true,
              'ยกเลิก');
        },
      );
    } else if (image_path_idcard == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert(
              'แจ้งเตือน',
              'คุณไม่ได้ถ่ายภาพบัตรประชาชน กรุณาถ่ายภาพบัตรประชาชน',
              'ตกลง',
              true,
              'ยกเลิก');
        },
      );
    } else if (selectedValue == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert(
              'แจ้งเตือน',
              'คุณไม่ได้เลือกเรื่องที่ติดต่อ กรุณาเลือกเรื่องที่ติดต่อ',
              'ตกลง',
              true,
              'ยกเลิก');
        },
      );
    } else if (image_path_carregis == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert(
              'แจ้งเตือน',
              'คุณไม่ได้ถ่ายภาพทะเบียนรถ กรุณาถ่ายภาพทะเบียนรถ',
              'ตกลง',
              true,
              'ยกเลิก');
        },
      );
    } else {
      BaseDataApi apiPro = BaseDataApi();
      http.MultipartRequest request = await apiPro.uploadAll(
          _houseNumber,
          _contactMatter,
          _vehicleType,
          _date,
          _time,
          _imagePathIdCard,
          _imagePathCarRegis);
      request.send().then((res) => {
            if (res.statusCode == 200)
              {
                print('Save Success!'),
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'บันทึกข้อมูลสำเร็จ',
                      style: TextStyle(color: color1White, fontSize: 16),
                    ),
                    // action: SnackBarAction(
                    //   label: 'ดูข้อมูล',
                    //   onPressed: () {
                    //     // Code to execute.
                    //   },
                    // ),
                  ),
                ),
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) =>
                            MonitorPage(camera: widget.camera)),
                    (route) => false)
              }
          });
      // var postUri = Uri.parse("http://192.168.1.105:2811/uploadAll");
      // http.MultipartRequest request = http.MultipartRequest("POST", postUri);
      // http.MultipartFile multipartFile1 =
      //     await http.MultipartFile.fromPath('imageIdCard', _imagePathIdCard);
      // http.MultipartFile multipartFile2 = await http.MultipartFile.fromPath(
      //     'imageCarRegis', _imagePathCarRegis);
      // request.files.add(multipartFile1);
      // request.files.add(multipartFile2);
      // request.fields['status'] = 'active';
      // request.fields['houseNumber'] = _houseNumber;
      // request.fields['contactMatter'] = _contactMatter;
      // request.fields['vehicleType'] = _vehicleType;
      // request.fields['date'] = _date;
      // request.fields['time'] = _time;
      // request.fields['imagePathIdCard'] = _imagePathIdCard;
      // request.fields['imagePathCarRegis'] = _imagePathCarRegis;
      // request.send().then((res) => {
      //       if (res.statusCode == 200)
      //         {
      //           print('Save Success!'),
      //           ScaffoldMessenger.of(context).showSnackBar(
      //             SnackBar(
      //               content: const Text(
      //                 'บันทึกข้อมูลสำเร็จ',
      //                 style: TextStyle(color: color1White, fontSize: 16),
      //               ),
      //               // action: SnackBarAction(
      //               //   label: 'ดูข้อมูล',
      //               //   onPressed: () {
      //               //     // Code to execute.
      //               //   },
      //               // ),
      //             ),
      //           ),
      //           Navigator.of(context).pushAndRemoveUntil(
      //               MaterialPageRoute(
      //                   builder: (context) =>
      //                       MonitorPage(camera: widget.camera)),
      //               (route) => false)
      //         }
      //     });
    }

    print('${dateFormat.format(now)}');
    print('${timeFormat.format(now)}');
  }

  Widget alert(String title, String content, String okButton, bool ccBtnStatus,
      String ccButton) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        if (ccBtnStatus)
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(
              ccButton,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: Text(
            okButton,
            style: TextStyle(color: color1DeepBlue),
          ),
        ),
      ],
    );
  }
}
