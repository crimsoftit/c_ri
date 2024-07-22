import 'package:cloud_firestore/cloud_firestore.dart';

class CUserModel {
  final String id;
  String fullName;
  final String email;
  String countryCode;
  String phoneNo;
  String profPic;

  CUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.countryCode,
    required this.phoneNo,
    required this.profPic,
  });

  // === static function to split fullName into 1st & last names ===
  static List<String> nameParts(fullName) => fullName.split(" ");

  // === static function to create an empty user model ===
  static CUserModel empty() => CUserModel(
        id: '',
        fullName: '',
        email: '',
        countryCode: '',
        phoneNo: '',
        profPic: '',
      );

  // to make it readable to firebase
  Map<String, dynamic> toJson() {
    return {
      "FullName": fullName,
      "Email": email,
      "CountryCode": countryCode,
      "PhoneNo": phoneNo,
      "ProfPic": profPic,
    };
  }

  // === factory method to create a UserModel from a Firebase document snapshot ===
  factory CUserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return CUserModel(
        id: document.id,
        fullName: data["FullName"] ?? '',
        email: data["Email"] ?? '',
        countryCode: data["CountryCode"] ?? '',
        phoneNo: data["PhoneNo"] ?? '',
        profPic: data["ProfPic"] ?? '',
      );
    } else {
      return CUserModel.empty();
    }
  }
}
