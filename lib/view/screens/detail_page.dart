import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:village_visitor/model/VisitorDetailModel.dart';
import 'package:village_visitor/model/apis/baseDataApi.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.id}) : super(key: key);

  final int id;
  // final Image image2;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late VisitorDetailModel _dataDetail;
  BaseDataApi apiPro = BaseDataApi();

//Color Value 1
  static const color1DeepBlue = Color(0xFF333d51);
  static const color1Yellow = Color(0xFFd3ac2b);
  static const color1Grey = Color(0xFFcbd0d8);
  static const color1DeepGrey = Color(0xFF797b7e);
  static const color1White = Color(0xFFf4f3ea);
  static const color1Black = Color.fromARGB(255, 24, 24, 24);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVisitorDetail();
  }

  Future<VisitorDetailModel> getVisitorDetail() async {
    // var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    // var request = http.Request(
    //     'POST', Uri.parse('http://192.168.1.105:2811/getOneVisitor'));
    // request.bodyFields = {'id': widget.id.toString()};
    // request.headers.addAll(headers);

    // var response = await http.Response.fromStream(await request.send());

    var response = await apiPro.getVisitorDetail(widget.id);

    if (response.statusCode == 200) {
      _dataDetail = visitorDetailModelFromJson(response.body);
      print(_dataDetail.visitorContactMatter);
      return _dataDetail;
    } else {
      return Future.error(
          "This is the error", StackTrace.fromString("This is its trace"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลผู้มาติดต่อ'),
        backgroundColor: color1DeepBlue,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Container(
          decoration: BoxDecoration(
              color: color1DeepBlue,
              borderRadius: BorderRadius.all(Radius.circular(4))),
          child: ListView(
            children: [
              // Text('data')
              FutureBuilder(
                future: getVisitorDetail(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    print(snapshot.connectionState);
                    return LinearProgressIndicator();
                  } else {
                    print(snapshot.connectionState);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // container_header(),
                        container_houseNumber(),
                        container_contractMatter(),
                        container_datetime(),
                        container_idcard(),
                        container_plate()
                      ],
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget container_header() {
    return Container(
      color: Colors.yellow.shade100,
      height: 40,
    );
  }

  Widget container_houseNumber() {
    return Container(
      height: 100,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 4, 0),
              child: Container(
                decoration: BoxDecoration(
                    color: color1White,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                height: 100,
                child: Column(
                  children: [
                    _dataDetail.visitorVehicleType == 'รถยนต์'
                        ? Image.asset('assets/images/icon_car.png')
                        : Image.asset('assets/images/icon_bike.png'),
                    Text(_dataDetail.visitorVehicleType + ' ')
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
              child: Container(
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                      color: color1White,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  height: 100,
                  child: Column(
                    children: [
                      Icon(
                        Icons.house_outlined,
                        size: 30,
                      ),
                      Text(
                        'บ้านเลขที่ ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        _dataDetail.visitorHouseNumber.toString(),
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget container_contractMatter() {
    return Container(
      height: 80,
      // color: Colors.green.shade100,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      color: color1White,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                    children: [
                      Text(
                        'เรื่องที่ติดต่อ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        _dataDetail.visitorContactMatter + ' ',
                        style: TextStyle(fontSize: 20),
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget container_datetime() {
    return Container(
      height: 120,
      // color: Colors.green.shade100,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                      color: color1White,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              color: Colors.red.shade100,
                              height: 30,
                              width: 100,
                              child: Text(_dataDetail.visitorStatus),
                            ),
                            Container(
                              color: Colors.red.shade100,
                              height: 30,
                              child: Text(timeOnline(0)[0]),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("เข้า " +
                                _dataDetail.visitorDateEntry +
                                " " +
                                _dataDetail.visitorTimeEntry)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("ออก " +
                                _dataDetail.visitorDateExit +
                                " " +
                                _dataDetail.visitorTimeExit)
                          ],
                        ),
                      ),
                      // Expanded(
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [Text(timeOnline(0)[0])],
                      //   ),
                      // )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget container_idcard() {
    return Container(
      height: 180,
      // color: Colors.green.shade100,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                    color: color1White,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  children: [
                    Text(
                      'ภาพถ่ายบัตรประชาชน',
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                          color: color1White,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: CachedNetworkImage(
                        imageUrl: _dataDetail.visitorImagePathIdCard,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget container_plate() {
    return Container(
      height: 180,
      // color: Colors.green.shade100,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                    color: color1White,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  children: [
                    Text('ภาพถ่ายทะเบียนรถ', style: TextStyle(fontSize: 16)),
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                          color: color1White,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: CachedNetworkImage(
                        imageUrl: _dataDetail.visitorImagePathCarRegis,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List timeOnline(int index) {
    String timeOnline;
    DateTime now = DateTime.now();

    var dateFormat = DateFormat.yMd().parse(_dataDetail.visitorDateEntry);
    var timeFormat = DateFormat.Hms().parse(_dataDetail.visitorTimeEntry);

    DateTime timeEntry = DateFormat("dd/MM/yyyy HH:mm:ss").parse(
        _dataDetail.visitorDateEntry + ' ' + _dataDetail.visitorTimeEntry);

    Duration diff = now.difference(timeEntry);
    return _printDuration(diff);
  }

  List _printDuration(Duration duration) {
    Color colorGreen1 = Color(0xFF76BAA5);
    Color colorGreen2 = Color(0xFFE3F9F4);
    Color colorOrange1 = Colors.orange.shade300;
    Color colorOrange2 = Color.fromARGB(255, 253, 234, 206);
    Color colorRed1 = Colors.red.shade300;
    Color colorRed2 = Color.fromARGB(255, 255, 226, 229);

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = duration.inHours.remainder(24).toString();
    String minutes = duration.inMinutes.remainder(60).toString();
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    List onlineDay = [
      duration.inDays.toString() + ' วัน ' + hours + ' ชั่วโมง',
      colorRed1,
      colorRed2
    ];

    List onlineHours = [
      hours + ' ชั่วโมง ' + minutes + ' นาที',
      colorOrange1,
      colorOrange2
    ];

    List onlineMinutes = [
      minutes + ' นาที ' + twoDigitSeconds + ' วินาที',
      colorGreen1,
      colorGreen2
    ];

    if (duration.inDays >= 1) {
      return onlineDay;
    } else if (duration.inHours >= 1) {
      return onlineHours;
    } else {
      return onlineMinutes;
    }
  }
}
