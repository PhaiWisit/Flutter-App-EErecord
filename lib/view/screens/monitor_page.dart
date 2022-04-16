import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:village_visitor/model/apis/baseDataApi.dart';
import 'package:village_visitor/view/screens/register_page.dart';
import 'package:village_visitor/view/screens/detail_page.dart';
import '../../model/VisitorModel.dart';

import '../../custom_library/material/scaffold.dart' as Scaffold_Custom;

class MonitorPage extends StatefulWidget {
  const MonitorPage({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;
  @override
  State<MonitorPage> createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  VisitorModel visitorModel = VisitorModel(
      visitorId: 0,
      visitorStatus: "visitorStatus",
      visitorHouseNumber: 1,
      visitorContactMatter: "visitorContactMatter",
      visitorVehicleType: "visitorVehicleType",
      visitorDateEntry: "visitorDateEntry",
      visitorTimeEntry: "visitorTimeEntry",
      visitorDateExit: "visitorDateExit",
      visitorTimeExit: "visitorTimeExit",
      visitorImagePathIdCard: "visitorImagePathIdCard",
      visitorImagePathCarRegis: "visitorImagePathCarRegis");

  late List<VisitorModel> _dataActive;
  late List<VisitorModel> _dataInactive;

  //Color Value 1
  static const color1DeepBlue = Color(0xFF333d51);
  static const color1Yellow = Color(0xFFd3ac2b);
  static const color1Grey = Color(0xFFcbd0d8);
  static const color1DeepGrey = Color(0xFF797b7e);
  static const color1White = Color(0xFFf4f3ea);
  static const color1Black = Color.fromARGB(255, 24, 24, 24);

  BaseDataApi apiPro = BaseDataApi();

  @override
  void initState() {
    super.initState();
    getActive();
  }

  Future<List<VisitorModel>> getActive() async {
    var response = await apiPro.getActive();
    _dataActive = visitorModelFromJson(response.body);
    if (_dataActive[0] == []) {
      _dataActive.add(visitorModel);
      return _dataActive;
    } else {
      return _dataActive;
    }
  }

  Future<void> _pullRefreshActive() async {
    var response = await apiPro.getActive();
    setState(() {
      _dataActive = visitorModelFromJson(response.body);
    });
  }

  Future<List<VisitorModel>> getInactive() async {
    var response = await apiPro.getInactive();
    _dataInactive = visitorModelFromJson(response.body);
    if (_dataInactive[0] == []) {
      _dataInactive.add(visitorModel);
      return _dataInactive;
    } else {
      return _dataInactive;
    }
  }

  Future<void> _pullRefreshInactive() async {
    var response = await apiPro.getInactive();
    setState(() {
      _dataInactive = visitorModelFromJson(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold_Custom.Scaffold(
        backgroundColor: color1Grey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150.0),
          child: AppBar(
            backgroundColor: color1DeepBlue,
            bottom: TabBar(
              indicatorColor: color1Yellow,
              labelColor: color1Yellow,
              unselectedLabelColor: color1White,
              tabs: <Widget>[
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_available),
                      SizedBox(
                        width: 4,
                      ),
                      Text('ตอนนี้')
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history),
                      SizedBox(
                        width: 4,
                      ),
                      Text('ประวัติ')
                    ],
                  ),
                )
              ],
            ),
            flexibleSpace: SafeArea(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 80,
                              width: 80,
                              child:
                                  Image.asset('assets/images/icon_shield.png')),
                          SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'EE Record',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'ระบบบันทึกข้อมูลผู้เข้า-ออกหมู่บ้าน',
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: tabActive(),
            ),
            Center(
              child: tabInactive(),
            )
          ],
        ),
        persistentFooterButtons: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: color1DeepBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              RegisterPage(camera: widget.camera)));
                    },
                    child: Row(
                      children: [
                        Icon(Icons.add),
                        const Text(
                          'เพิ่มผู้มาติดต่อ',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Tab Active
  Widget tabActive() {
    return FutureBuilder(
      future: getActive(),
      builder: ((context, snapshot) {
        print(snapshot.connectionState);
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        } else {
          return Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: RefreshIndicator(
              onRefresh: _pullRefreshActive,
              child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: _dataActive.length,
                  itemBuilder: (BuildContext context, int index) {
                    return cardActive2(index);
                  }),
            ),
          );
        }
      }),
    );
  }

  // Widget cardActive(int index) {
  //   return Card(
  //     child: Container(
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10), color: color1White),
  //       child: Padding(
  //         padding: const EdgeInsets.all(10.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.max,
  //           children: [
  //             Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               // mainAxisSize: MainAxisSize.max,
  //               children: [cardActiveColumn1(index), cardActiveColumn2(index)],
  //             ),
  //             // ListTile(
  //             //   leading: _dataFromAPI[index].visitorVehicleType == 'รถจักรยานยนต์'
  //             //       ? Icon(
  //             //           Icons.motorcycle,
  //             //           size: 50,
  //             //         )
  //             //       : Icon(
  //             //           Icons.car_rental,
  //             //           size: 50,
  //             //         ),
  //             //   title: Text(_dataFromAPI[index].visitorVehicleType +
  //             //       '\n' +
  //             //       _dataFromAPI[index].visitorContactMatter +
  //             //       '\n' +
  //             //       'บ้านเลขที่ ' +
  //             //       _dataFromAPI[index].visitorHouseNumber.toString() +
  //             //       '\n' +
  //             //       'เข้า :' +
  //             //       _dataFromAPI[index].visitorDateEntry +
  //             //       ' ' +
  //             //       _dataFromAPI[index].visitorTimeEntry +
  //             //       '\n'),
  //             // ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 // Row(
  //                 //   mainAxisAlignment: MainAxisAlignment.start,
  //                 //   children: [
  //                 //     Container(
  //                 //       height: 35,
  //                 //       child: TextButton(
  //                 //         child: StreamBuilder(
  //                 //           stream: Stream.periodic(const Duration(seconds: 1)),
  //                 //           builder: (context, snapshot) {
  //                 //             return Text(
  //                 //               timeOnline(index)[0],
  //                 //               style: TextStyle(color: timeOnline(index)[1]),
  //                 //             );
  //                 //           },
  //                 //         ),
  //                 //         onPressed: null,
  //                 //       ),
  //                 //     ),
  //                 //   ],
  //                 // ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: <Widget>[
  //                     Container(
  //                       height: 40,
  //                       child: TextButton(
  //                         style: ButtonStyle(
  //                             backgroundColor:
  //                                 MaterialStateProperty.all(color1DeepGrey)),
  //                         child: const Text(
  //                           'ดูข้อมูล',
  //                           style: TextStyle(color: Colors.white),
  //                         ),
  //                         onPressed: () {
  //                           onClickToViewInfoActive(index);
  //                         },
  //                       ),
  //                     ),
  //                     const SizedBox(width: 8),
  //                     Container(
  //                       height: 40,
  //                       child: TextButton(
  //                         style: ButtonStyle(
  //                             backgroundColor:
  //                                 MaterialStateProperty.all(color1Yellow)),
  //                         child: const Text(
  //                           'สำเร็จ',
  //                           style: TextStyle(color: Colors.white),
  //                         ),
  //                         onPressed: () {
  //                           onClickSendStatus(index);
  //                         },
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget cardActiveColumn1(int index) {
  //   return Expanded(
  //     flex: 4,
  //     child: Container(
  //       // height: 100,
  //       // width: 100,
  //       // color: Colors.amber,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.max,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   _dataActive[index].visitorVehicleType == 'รถยนต์'
  //                       ? Image.asset('assets/images/icon_car.png')
  //                       : Image.asset('assets/images/icon_bike.png'),
  //                 ],
  //               ),
  //               Row(
  //                 children: [Text(_dataActive[index].visitorVehicleType + " ")],
  //               ),
  //               // SizedBox(
  //               //   height: 8,
  //               // ),
  //               Row(
  //                 children: [
  //                   StreamBuilder(
  //                     stream: Stream.periodic(const Duration(seconds: 1)),
  //                     builder: (context, snapshot) {
  //                       return Text(
  //                         timeOnline(index)[0] + " ",
  //                         style: TextStyle(color: timeOnline(index)[1]),
  //                       );
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget cardActiveColumn2(int index) {
  //   return Container(
  //     child: Flexible(
  //         flex: 6,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Text(
  //                   "บ้านเลขที่ " +
  //                       _dataActive[index].visitorHouseNumber.toString(),
  //                   style: TextStyle(fontSize: 20),
  //                 ),
  //               ],
  //             ),
  //             Wrap(
  //               // mainAxisAlignment: MainAxisAlignment.end,

  //               children: [
  //                 Container(
  //                   child: Text(
  //                     "" + _dataActive[index].visitorContactMatter,
  //                     style: TextStyle(fontSize: 20),
  //                     maxLines: 2,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Text(
  //               "" + _dataActive[index].visitorTimeEntry,
  //               style: TextStyle(fontSize: 16),
  //             ),
  //           ],
  //         )),
  //   );
  // }

  Widget cardActive2(int index) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
            color: color1White,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: InkWell(
          onTap: () {
            onClickToViewInfoActive(index);
          },
          splashColor: Color.fromARGB(255, 245, 245, 245),
          child: SizedBox(
            height: 150,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 20,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'บ้านเลขที่ ' +
                                      _dataActive[index]
                                          .visitorHouseNumber
                                          .toString(),
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: timeActive(index)[2],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: StreamBuilder(
                                    stream: Stream.periodic(
                                        const Duration(seconds: 1)),
                                    builder: (context, snapshot) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 0, 5, 0),
                                        child: Text(
                                          timeActive(index)[0] + " ",
                                          style: TextStyle(
                                              color: timeActive(index)[1]),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 50,
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: color1DeepBlue,
                                      border: Border.all(
                                          color: color1DeepGrey, width: 3),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child:
                                      _dataActive[index].visitorVehicleType ==
                                              'รถยนต์'
                                          ? Image.asset(
                                              'assets/images/icon_car.png')
                                          : Image.asset(
                                              'assets/images/icon_bike.png')),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 40,
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  _dataActive[index]
                                                      .visitorContactMatter,
                                                  softWrap: false,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 60,
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 70,
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        child: Row(
                                                          children: [
                                                            Text('วันที่ ' +
                                                                _dataActive[
                                                                        index]
                                                                    .visitorDateEntry)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: Row(
                                                          children: [
                                                            Text('เวลา ' +
                                                                _dataActive[
                                                                        index]
                                                                    .visitorTimeEntry)
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 40,
                                                child: Container(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: color1DeepBlue,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4)),
                                                        border: Border.all(
                                                            color:
                                                                color1DeepGrey,
                                                            width: 3)),
                                                    child: TextButton(
                                                      child: const Text(
                                                        'สำเร็จ',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16),
                                                      ),
                                                      onPressed: () {
                                                        onClickSendStatus(
                                                            index);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  //Tab Inactive
  Widget tabInactive() {
    return FutureBuilder(
      future: getInactive(),
      builder: ((context, snapshot) {
        print(snapshot.connectionState);
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        } else {
          return Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: RefreshIndicator(
              onRefresh: _pullRefreshInactive,
              child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: _dataInactive.length,
                  itemBuilder: (BuildContext context, int index) {
                    return cardInactive2(index);
                  }),
            ),
          );
        }
      }),
    );
  }

  // Widget cardInactive(int index) {
  //   return Card(
  //     child: Container(
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10), color: color1White),
  //       child: Padding(
  //         padding: const EdgeInsets.all(10.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.max,
  //           children: [
  //             Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               // mainAxisSize: MainAxisSize.max,
  //               children: [
  //                 cardInactiveColumn1(index),
  //                 cardInactiveColumn2(index)
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget cardInactiveColumn1(int index) {
  //   return Expanded(
  //     flex: 4,
  //     child: Container(
  //       // height: 100,
  //       // width: 100,
  //       // color: Colors.amber,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.max,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   _dataInactive[index].visitorVehicleType == 'รถยนต์'
  //                       ? Image.asset('assets/images/icon_car.png')
  //                       : Image.asset('assets/images/icon_bike.png'),
  //                 ],
  //               ),
  //               Row(
  //                 children: [
  //                   Text(_dataInactive[index].visitorVehicleType + " ")
  //                 ],
  //               ),
  //               Row(
  //                 children: [Text(_dataInactive[index].visitorTimeEntry + " ")],
  //               ),
  //               Row(
  //                 children: [Text(_dataInactive[index].visitorTimeExit + " ")],
  //               ),

  //               // Row(
  //               //   children: [
  //               //     StreamBuilder(
  //               //       stream: Stream.periodic(const Duration(seconds: 1)),
  //               //       builder: (context, snapshot) {
  //               //         return Text(
  //               //           timeOnline(index)[0] + " ",
  //               //           style: TextStyle(color: timeOnline(index)[1]),
  //               //         );
  //               //       },
  //               //     ),
  //               //   ],
  //               // ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget cardInactiveColumn2(int index) {
  //   return Expanded(
  //       flex: 6,
  //       child: Container(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Column(
  //                   children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         Text(
  //                           "บ้านเลขที่ " +
  //                               _dataInactive[index]
  //                                   .visitorHouseNumber
  //                                   .toString(),
  //                           style: TextStyle(fontSize: 20),
  //                         ),
  //                       ],
  //                     ),
  //                     Text(
  //                       "" + _dataInactive[index].visitorContactMatter,
  //                       style: TextStyle(fontSize: 20),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: 12,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: <Widget>[
  //                     Container(
  //                       height: 40,
  //                       child: TextButton(
  //                         style: ButtonStyle(
  //                             backgroundColor:
  //                                 MaterialStateProperty.all(color1DeepGrey)),
  //                         child: const Text(
  //                           'ดูข้อมูล',
  //                           style: TextStyle(color: Colors.white),
  //                         ),
  //                         onPressed: () {
  //                           onClickToViewInfoInactive(index);
  //                         },
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             )
  //           ],
  //         ),
  //       ));
  // }

  Widget cardInactive2(int index) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
            color: color1White,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: InkWell(
          onTap: () {
            onClickToViewInfoInactive(index);
          },
          splashColor: Color.fromARGB(255, 245, 245, 245),
          child: SizedBox(
            height: 150,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 20,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'บ้านเลขที่ ' +
                                      _dataInactive[index]
                                          .visitorHouseNumber
                                          .toString(),
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 200, 241, 200),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Text(
                                        'สำเร็จ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 24, 150, 28)),
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 50,
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: color1DeepBlue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child:
                                      _dataInactive[index].visitorVehicleType ==
                                              'รถยนต์'
                                          ? Image.asset(
                                              'assets/images/icon_car.png')
                                          : Image.asset(
                                              'assets/images/icon_bike.png')),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 40,
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  _dataInactive[index]
                                                      .visitorContactMatter,
                                                  softWrap: false,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 60,
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        child: Row(
                                                          children: [
                                                            Text(' วันที่ ' +
                                                                _dataInactive[
                                                                        index]
                                                                    .visitorDateEntry)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: Row(
                                                          children: [
                                                            Text(' เวลา ' +
                                                                _dataInactive[
                                                                        index]
                                                                    .visitorTimeEntry)
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4, right: 8),
                                                child: Container(
                                                  width: 2,
                                                  color: color1Yellow,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        child: Row(
                                                          children: [
                                                            Text('วันที่ ' +
                                                                _dataInactive[
                                                                        index]
                                                                    .visitorDateExit)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: Row(
                                                          children: [
                                                            Text('เวลา ' +
                                                                _dataInactive[
                                                                        index]
                                                                    .visitorTimeExit)
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  List timeActive(int index) {
    DateTime now = DateTime.now();

    var dateFormat =
        DateFormat.yMd().parse(_dataActive[index].visitorDateEntry);
    var timeFormat =
        DateFormat.Hms().parse(_dataActive[index].visitorTimeEntry);

    DateTime timeEntry = DateFormat("dd/MM/yyyy HH:mm:ss").parse(
        _dataActive[index].visitorDateEntry +
            ' ' +
            _dataActive[index].visitorTimeEntry);

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

  Future<void> onClickSendStatus(int index) async {
    DateTime now = DateTime.now();
    var dateFormat = DateFormat.yMd();
    var timeFormat = DateFormat.Hms();

    String _id = _dataActive[index].visitorId.toString();
    String _dateExit = '${dateFormat.format(now)}';
    String _timeExit = '${timeFormat.format(now)}';

    http.StreamedResponse response =
        await apiPro.updateStatus(_id, _dateExit, _timeExit);

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      _pullRefreshActive();
      _pullRefreshInactive();
    } else {
      print(response.reasonPhrase);
    }
  }

  void onClickToViewInfoActive(int index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: ((context) => DetailPage(
              id: _dataActive[index].visitorId,
            ))));
  }

  void onClickToViewInfoInactive(int index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: ((context) => DetailPage(
              id: _dataInactive[index].visitorId,
            ))));
  }
}
