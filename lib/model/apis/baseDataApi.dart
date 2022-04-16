import 'package:path/path.dart';
import 'package:village_visitor/view/screens/monitor_page.dart';

import '../VisitorModel.dart';
import 'package:http/http.dart' as http;

class BaseDataApi {
  final String _host = "Your Host Name";

  Future<http.Response> getActive() async {
    var getUri = Uri.parse(_host + "/getActive");
    return await http.get(getUri);
  }

  Future<http.Response> getInactive() async {
    var getUri = Uri.parse(_host + "/getInactive");
    return await http.get(getUri);
  }

  Future<http.MultipartRequest> uploadAll(
      String _houseNumber,
      String _contactMatter,
      String _vehicleType,
      String _date,
      String _time,
      String _imagePathIdCard,
      String _imagePathCarRegis) async {
    var postUri = Uri.parse(_host + "/uploadAll");
    http.MultipartRequest request = http.MultipartRequest("POST", postUri);
    http.MultipartFile multipartFile1 =
        await http.MultipartFile.fromPath('imageIdCard', _imagePathIdCard);
    http.MultipartFile multipartFile2 =
        await http.MultipartFile.fromPath('imageCarRegis', _imagePathCarRegis);
    request.files.add(multipartFile1);
    request.files.add(multipartFile2);
    request.fields['status'] = 'active';
    request.fields['houseNumber'] = _houseNumber;
    request.fields['contactMatter'] = _contactMatter;
    request.fields['vehicleType'] = _vehicleType;
    request.fields['date'] = _date;
    request.fields['time'] = _time;
    request.fields['imagePathIdCard'] = _imagePathIdCard;
    request.fields['imagePathCarRegis'] = _imagePathCarRegis;
    return request;
  }

  Future<http.Response> getVisitorDetail(int id) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var getUri = Uri.parse(_host + "/getOneVisitor");
    var request = http.Request('POST', getUri);
    request.bodyFields = {'id': id.toString()};
    request.headers.addAll(headers);

    return http.Response.fromStream(await request.send());
  }

  Future<http.StreamedResponse> updateStatus(
      String id, String dateExit, String timeExit) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST', Uri.parse(_host + '/updateStatus'));
    request.bodyFields = {'id': id, 'date': dateExit, 'time': timeExit};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response;
  }
}
