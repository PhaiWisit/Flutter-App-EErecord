import 'dart:convert';

VisitorDetailModel visitorDetailModelFromJson(String str) =>
    VisitorDetailModel.fromJson(json.decode(str));

String visitorDetailModelToJson(VisitorDetailModel data) =>
    json.encode(data.toJson());

class VisitorDetailModel {
  VisitorDetailModel({
    required this.visitorId,
    required this.visitorStatus,
    required this.visitorHouseNumber,
    required this.visitorContactMatter,
    required this.visitorVehicleType,
    required this.visitorDateEntry,
    required this.visitorTimeEntry,
    required this.visitorDateExit,
    required this.visitorTimeExit,
    required this.visitorImagePathIdCard,
    required this.visitorImagePathCarRegis,
  });

  int visitorId;
  String visitorStatus;
  int visitorHouseNumber;
  String visitorContactMatter;
  String visitorVehicleType;
  String visitorDateEntry;
  String visitorTimeEntry;
  String visitorDateExit;
  String visitorTimeExit;
  String visitorImagePathIdCard;
  String visitorImagePathCarRegis;

  factory VisitorDetailModel.fromJson(Map<String, dynamic> json) =>
      VisitorDetailModel(
        visitorId: json["visitor_id"],
        visitorStatus: json["visitor_status"],
        visitorHouseNumber: json["visitor_houseNumber"],
        visitorContactMatter: json["visitor_contactMatter"],
        visitorVehicleType: json["visitor_vehicleType"],
        visitorDateEntry: json["visitor_dateEntry"],
        visitorTimeEntry: json["visitor_timeEntry"],
        visitorDateExit: json["visitor_dateExit"],
        visitorTimeExit: json["visitor_timeExit"],
        visitorImagePathIdCard: json["visitor_imagePathIdCard"],
        visitorImagePathCarRegis: json["visitor_imagePathCarRegis"],
      );

  Map<String, dynamic> toJson() => {
        "visitor_id": visitorId,
        "visitor_status": visitorStatus,
        "visitor_houseNumber": visitorHouseNumber,
        "visitor_contactMatter": visitorContactMatter,
        "visitor_vehicleType": visitorVehicleType,
        "visitor_dateEntry": visitorDateEntry,
        "visitor_timeEntry": visitorTimeEntry,
        "visitor_dateExit": visitorDateExit,
        "visitor_timeExit": visitorTimeExit,
        "visitor_imagePathIdCard": visitorImagePathIdCard,
        "visitor_imagePathCarRegis": visitorImagePathCarRegis,
      };
}
